
library(tidyverse)
library(ggpubr)
# install.packages("svMisc")
library(svMisc)

EDOE_data <- read.csv("./EDOE/data/EDOE-cleaned-data.csv", stringsAsFactors = FALSE)

# looking at the plots that do "not" have exfoliated material
EDOE_data$acid_conc <- as.factor(EDOE_data$acid_conc)

temp <- transform(EDOE_data, base_name = factor(base_name, levels = c("Water", "NH4OH","TMAOH","TEAOH", "TBAOH")))

temp$ExCheck <- ifelse(temp$ExCheck == "Y", "Yes", "No")

temp$group_id <- as.numeric(temp$group_id)
EDOE_data$group_id <- as.numeric(EDOE_data$group_id)



## showing just one treatment and what 2D naonsheets absorption
EDOE_data %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(filename == "1-141-121-00-G04") %>%
  #  filter(ExCheck == "Y") %>%
  #  filter(base_name == "TBAOH") %>%
  # filter(days == "0") %>%
  ggplot() +
  geom_line(aes(x = wavelength, y = abs, group = filename, color = filename), 
            show.legend = F, size = 1) +
  ggtitle("UV-Vis Absorption of Cobalt Oxide Nanosheets") +
  theme_bw() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  ylim(0,NA) +
  ylab("Absorbance (A.U.)") +
  xlab("Wavelength (nm)") +
  ggsave("./EDOE/manuscript_figures/CONSspectra_1-141-121-00.png", width = 8, height = 6, units = "in", dpi = 300)


### exfoliation over time
data.names <- c("1-141-121-00-G04", "1-141-121-00-G12", "1-141-121-00-G13",
                "1-141-121-30-G04", "1-141-121-30-G12", "1-141-121-30-G13",
                "1-141-121-60-G04", "1-141-121-60-G12", "1-141-121-60-G13")


# accounting for these in the abs_DoEx for plotting
temp$abs_new <- temp$abs * temp$dilution


temp$group_id <- as.factor(temp$group_id)
temp$days <- as.factor(temp$days)

temp %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(filename %in% data.names) %>%
  #  filter(ExCheck == "Y") %>%
  #  filter(base_name == "TBAOH") %>%
  filter(days == "0") %>%
  ggplot() +
  geom_line(aes(x = wavelength, y = abs_new, group = filename, color = group_id), 
            show.legend = T, size = 1) +
  ggtitle("Exfoliation of Acid-Treated LCO Over Time") +
  theme_bw() +
  scale_color_discrete(name = "Days After Acid Treatment",
                       labels = c("1", "25", "150"),
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.position = c(0.85,0.85)) +
  ##theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  theme(plot.title = element_text(size = 20, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  ylim(0,NA) +
  ylab("Absorbance (A.U.)") +
  xlab("Wavelength (nm)") +
  ggsave("./EDOE/manuscript_figures/CONs_ExfOverTime.png", width = 8, height = 6, units = "in", dpi = 300)


temp$group_id <- as.numeric(temp$group_id)


# exfoliation yes/no
temp %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(base_name != "Water") %>%
  filter(group_id < 12) %>%
  #  filter(base_name == "TBAOH") %>%
  filter(days == "0") %>%
  ggplot() +
  geom_line(aes(x = wavelength, y = abs, group = filename, color = acid_conc), 
            show.legend = T, size = 1) +
  ylim(NA,1.5) +
  ggtitle("UV-Vis Absorption of Exfoliation Reactions") +
  ylab("Absorbance (A.U.)") +
  xlab("Wavelength (nm)") +
  theme_bw() +
  scale_color_discrete(name = "Acid Pre-Treated LCO (M HCl)",
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  facet_wrap(~ ExCheck, ncol = 2) +
  ggsave("./EDOE/manuscript_figures/CONs-YesNoSpectra-facet.png", width = 8, height = 6, units = "in", dpi = 300)


#supp.labs <- c("JJ", "TQAOH", "TEAOH", "TBAOH")

# exfoliation as a for each base
temp %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(base_name != "Water") %>%
  filter(ExCheck == "Yes") %>%
  filter(group_id < 12) %>%
  #  filter(base_name == "TBAOH") %>%
  filter(days == "0") %>%
  ggplot() +
  geom_line(aes(x = wavelength, y = abs, group = filename, color = acid_conc), 
            show.legend = T, size = 1) +
  geom_vline(xintercept = 400) +
  ylim(NA,1.5) +
  ylab("Absorbance (A.U.)") +
  xlab("Wavelength (nm)") +
  theme_bw() +
  scale_color_discrete(name = "Acid Pre-Treated LCO (M HCl)",
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("\nUV-Vis Absorption of Cobalt Oxide Nanosheets") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-BaseSpectra-facet.png", width = 12, height = 5, units = "in", dpi = 300)


# exfoliation as a for each base after 30 days in solution
temp %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(base_name != "Water") %>%
  filter(ExCheck == "Yes") %>%
  filter(days == "30") %>%
  filter(group_id < 12) %>%
  ggplot() +
  geom_line(aes(x = wavelength, y = abs, group = filename, color = acid_conc), 
            show.legend = T, size = 1) +
  geom_vline(xintercept = 400) +
  ylim(NA,1.5) +
  ylab("Absorbance (A.U.)") +
  xlab("Wavelength (nm)") +
  theme_bw() +
  scale_color_discrete(name = "Acid Pre-Treated LCO (M HCl)",
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("UV-Vis Absorption of Cobalt Oxide Nanosheets\n 30 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-BaseSpectra-facet-30days.png", width = 12, height = 5, units = "in", dpi = 300)



# exfoliation as a for each base after 60 days in solution
temp %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(base_name != "Water") %>%
  filter(ExCheck == "Yes") %>%
  filter(group_id < 12) %>%
  #  filter(base_name == "TBAOH") %>%
  filter(days == "60") %>%
  ggplot() +
  geom_line(aes(x = wavelength, y = abs, group = filename, color = acid_conc), 
            show.legend = T, size = 1) +
  labs(fill = "Acid Conc.") +
  geom_vline(xintercept = 400) +
  ylim(NA,1.5) +
  ylab("Absorbance (A.U.)") +
  xlab("Wavelength (nm)") +
  theme_bw() +
  scale_color_discrete(name = "Acid Pre-Treated LCO (M HCl)",
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("UV-Vis Absorption of Cobalt Oxide Nanosheets\n 60 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-BaseSpectra-facet-60days.png", width = 12, height = 5, units = "in", dpi = 300)


# Abs_DoEx for each base
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "0") %>%
  filter(group_id < 12) %>%
  filter(ExCheck == "Yes") %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = (ExCheckAbs * dilution))) + 
  geom_text(aes(label = round((ExCheckAbs * dilution), 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "firebrick3", 
                      limits = c(0,4.1),
                      na.value = 0, name = 'Abs at 400nm',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("\nCobalt Oxide Nanosheets - Degree of Exfoliation") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  # theme(legend.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) 
  ggsave("./EDOE/manuscript_figures/CONs-DegoExf-abs400nm-facet.png", width = 12, height = 5, units = "in", dpi = 300)


###### test subtracting abs at 1100 nm from abs at 400 nm

# # Abs_DoEx for each base
# temp %>%
#   filter(ExCheck == "Yes") %>%
#   filter(base_name != "Water") %>%
#   filter(days == "60") %>%
#   filter(group_id < 12) %>%
#   ggplot(aes(as.factor(acid_conc), base_conc)) +
#   geom_tile(aes(fill = (ExCheckAbs * dilution))) + 
#   geom_text(aes(label = round((ExCheckAbs * dilution), 2))) +
#   xlab("HCl Concentration (M)") +
#   ylab("Exfoliation Reagent \n Concentration (M)") +
#   theme_bw() +
#   scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
#                 limits = c(0.0024, 0.79)) +
#   scale_fill_gradient(low = "white", high = "firebrick3", 
#                       limits = c(0,4.1),
#                       na.value = 0, name = 'Abs at 400nm',
#                       guide = guide_colorbar(title.position = "top")) +
#   theme(legend.position = "bottom") +
#   theme(legend.direction = "horizontal") +
#   theme(legend.title.align = 0.5) +
#   theme(legend.justification = "center") +
#   theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
#   theme(panel.background = element_rect(colour = "black", size = 2)) +
#   facet_wrap(~ base_name, ncol = 4) +
#   ggtitle("\nCobalt Oxide Nanosheets - Degree of Exfoliation") +
#   theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
#   # theme(legend.title = element_text(hjust = 0.5)) +
#   theme(axis.text.x = element_text(size = 14)) +
#   theme(axis.text.y = element_text(size = 14)) +
#   theme(axis.title = element_text(size = 18, face = "bold")) +
#   theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
#         strip.text.x = element_text(size = 16, face = "bold"))
#   ggsave("./EDOE/manuscript_figures/CONs-DegoExf-abs400nm-facet.png", width = 12, height = 5, units = "in", dpi = 300)
# 


###########

# Abs_DoEx for each base after 30 days in solution
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "30") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = (ExCheckAbs * dilution))) + 
  geom_text(aes(label = round((ExCheckAbs * dilution), 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "firebrick3", 
                      limits = c(0,4.1),
                      na.value = 0, name = 'Abs at 400nm',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Cobalt Oxide Nanosheets - Degree of Exfoliation\n 30 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-DegoExf-abs400nm-30days-facet.png", width = 12, height = 5, units = "in", dpi = 300)

# Abs_DoEx for each base after 60 days in solution
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "60") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = (ExCheckAbs * dilution))) + 
  geom_text(aes(label = round((ExCheckAbs * dilution), 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "firebrick3", 
                      limits = c(0,4.1),
                      na.value = 0, name = 'Abs at 400nm',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Cobalt Oxide Nanosheets - Degree of Exfoliation\n 60 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-DegoExf-abs400nm-60days-facet.png", width = 12, height = 5, units = "in", dpi = 300)


# saving a plot of each spectra and the exfoliation criterion
i <- 5
for (i in 1:length(unique(EDOE_data$filename))) {
  EDOE_data %>%
    filter(energy < high_cut) %>%
    filter(energy > 1.12) %>%
    #filter(ExCheck == "Y") %>%
    filter(filename == unique(filename)[i]) %>%
    ggplot() +
    geom_point(aes(x = wavelength, y = abs)) +
    ggtitle(str_c("Cobatl Oxide Nanosheets Spectra\n",
                  unique(EDOE_data$filename)[i], "\n",
                  round(unique(EDOE_data$ExCheckAbs)[i], 2), " > 0.025 (@ 400nm)\n",
                  "Exfoliation Criterion Met: ",
                  (EDOE_data %>% filter(wavelength == 1100) %>% select(ExCheck))[i,1])) +
    ylab("Absorbance (A.U.)") +
    xlab("Wavelength (nm)") +
    theme_bw() +
    theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    theme(panel.background = element_rect(colour = "black", size = 2)) +
    theme(axis.text = element_text(size = 14)) +
    theme(axis.title = element_text(size = 16)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = (EDOE_data %>% filter(wavelength == 1100) %>% select(abs))[i,1]) +
    geom_vline(xintercept = 400) +
    ggsave(str_c("./EDOE/manuscript_figures/spectra/", unique(EDOE_data$filename)[i], "_spectra.png"),
           width = 8, height = 8, units = "in", dpi = 300)
  progress(i)
}

#### single plot #######
## tauc plot fits for each spectra
tauc_data <- EDOE_data %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(base_name != "Water") %>%
  #filter(group_id < 12) %>%
  filter(ExCheck == "Y")

tauc_names <- EDOE_data %>%
  filter(energy < high_cut) %>%
  filter(energy > low_cut) %>%
  filter(ExCheck == "Y") %>%
  filter(base_name != "Water") %>%
  #filter(group_id < 12) %>%
  filter(wavelength == 400)

tauc_names$acid_conc <- as.character(tauc_names$acid_conc)

i <- 1
# tauc fits for each spectra
for (i in 1:length(unique(tauc_data$filename))) {
  EDOE_data %>%
    filter(energy < high_cut) %>%
    filter(energy > low_cut) %>%
    filter(ExCheck == "Y") %>%
    filter(base_name != "Water") %>%
    #filter(group_id < 12) %>%
    filter(filename == unique(filename)[i]) %>%
    ggplot() +
    geom_point(aes(x = energy, y = tauc)) +
    ggtitle(str_c("Cobatl Oxide Nanosheets Tauc Plot\n",
                  tauc_names$acid_conc[i], " M ",
                  tauc_names$acid_name[i], " - ",
                  tauc_names$base_conc[i], " M ",
                  tauc_names$base_name[i], " - ",
                  tauc_names$days[i], " Days in Solution",
                  "\nCalculated (Direct) Band Gap: ", round(tauc_names$tauc_band_gap[i], 2))) +
    scale_x_continuous(breaks = seq(1.5, 4.5, 0.5)) +
    annotate("text", x = 4.1, y = 0, label = paste("Adj. R^2:",
                                                 round(tauc_names$tauc_adj_rsquared[i], 3))) +
    ylab(expression(paste("(", alpha, "h", nu, ")"^"1/2"))) +
    xlab("Energy (eV)") +
    theme_bw() +
    theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    theme(panel.background = element_rect(colour = "black", size = 2)) +
    theme(axis.text = element_text(size = 14)) +
    theme(axis.title = element_text(size = 16)) +
    geom_abline(intercept = tauc_names$tauc_int[i], slope = tauc_names$tauc_slope[i], color = "red",
                linetype = "solid", size = 1.5) +
    geom_vline(xintercept = tauc_names$low_tauc[i], linetype = "dashed", color = "red1") +
    geom_vline(xintercept = tauc_names$high_tauc[i], linetype = "dashed", color = "red1") +
    ggsave(str_c("./EDOE/manuscript_figures/tauc-fit/direct/single/", unique(tauc_data$filename)[i], "_taucfit.png"),
           width = 8, height = 8, units = "in", dpi = 300)
  progress(i)
}


###### double fitting tauc plot
### tauc plot fits for each spectra

tauc_names <- EDOE_data %>%
  #filter(energy < high_cut) %>%
  #filter(energy > low_cut) %>%
  filter(ExCheck == "Y") %>%
  filter(base_name != "Water") %>%
  #filter(group_id < 12) %>%
  filter(wavelength == 400)

tauc_names$acid_conc <- as.character(tauc_names$acid_conc)

i <- 10
# tauc fits for each spectra
for (i in 1:length(tauc_names$filename)) {
  EDOE_data %>%
    filter(energy < high_cut) %>%
    filter(energy > low_cut) %>%
    filter(ExCheck == "Y") %>%
    filter(base_name != "Water") %>%
    #filter(group_id < 12) %>%
    filter(filename == unique(filename)[i]) %>%
    ggplot() +
    geom_point(aes(x = energy, y = tauc)) +
    ggtitle(str_c("Cobatl Oxide Nanosheets Tauc Plot\n",
                  tauc_names$acid_conc[i], " M ",
                  tauc_names$acid_name[i], " - ",
                  tauc_names$base_conc[i], " M ",
                  tauc_names$base_name[i], " - ",
                  tauc_names$days[i], " Days in Solution",
                  "\nCalculated (Direct) Band Gap1 : ", round(tauc_names$tauc_band_gap[i], 2),
                  "\nCalculated (Direct) Band Gap2 : ", round(tauc_names$tauc_band_gap2[i], 2))) +
    scale_x_continuous(breaks = seq(1.5, 4.5, 0.5)) +
    annotate("text", x = 4.1, y = 0, label = paste("Adj. R^2:",
                                                 round(tauc_names$tauc_adj_rsquared[i], 3))) +
    ylab(expression(paste("(", alpha, "h", nu, ")"^"2"))) +
    xlab("Energy (eV)") +
    theme_bw() +
    theme(plot.title = element_text(size = 18, face = "bold", hjust = 0.5)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    theme(panel.background = element_rect(colour = "black", size = 2)) +
    theme(axis.text = element_text(size = 14)) +
    theme(axis.title = element_text(size = 16)) +
    geom_abline(intercept = tauc_names$tauc_int[i], slope = tauc_names$tauc_slope[i], color = "red",
                linetype = "solid", size = 1.5) +
    geom_vline(xintercept = tauc_names$low_tauc[i], linetype = "dashed", color = "red1") +
    geom_vline(xintercept = tauc_names$high_tauc[i], linetype = "dashed", color = "red1") +
    geom_abline(intercept = tauc_names$tauc_int2[i], slope = tauc_names$tauc_slope2[i], color = "blue",
              linetype = "solid", size = 1.5) +
    geom_vline(xintercept = tauc_names$low_tauc2[i], linetype = "dashed", color = "blue1") +
    geom_vline(xintercept = tauc_names$high_tauc2[i], linetype = "dashed", color = "blue1") +
    ggsave(str_c("./EDOE/manuscript_figures/tauc-fit/direct/double/", tauc_names$filename[i], "_taucfit.png"),
           width = 8, height = 8, units = "in", dpi = 300)
  progress(i)
}




# band gap1 for each base
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "0") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = tauc_band_gap)) + 
  geom_text(aes(label = round(tauc_band_gap, 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "royalblue1", 
                      limits = c(2.1, 2.901),
                      na.value = 0, name = 'Band Gap (eV)',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("\nCobalt Oxide Nanosheets - Calc. Band Gap (Direct)") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, 
                                        linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-Bandgap-facet.png", width = 12, 
         height = 5, units = "in", dpi = 300)

# band gap1 for each base after 30 days in solution
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "30") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = tauc_band_gap)) + 
  geom_text(aes(label = round(tauc_band_gap, 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "royalblue1", 
                      limits = c(2.1, 2.901),
                      na.value = 0, name = 'Band Gap (eV)',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Cobalt Oxide Nanosheets - Calc. Band Gap (Direct)\n30 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, 
                                        linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-Bandgap-30days-facet.png", width = 12, 
         height = 5, units = "in", dpi = 300)

# band gap1 for each base after 60 days in solution
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "60") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = tauc_band_gap)) + 
  geom_text(aes(label = round(tauc_band_gap, 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44), 
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "royalblue1", 
                      limits = c(2.1, 2.901),
                      na.value = 0, name = 'Band Gap (eV)',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Cobalt Oxide Nanosheets - Calc. Band Gap (Direct)\n60 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-Bandgap-60days-facet.png", width = 12, 
         height = 5, units = "in", dpi = 300)



# band gap2 for each base
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "0") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = tauc_band_gap2)) +
  geom_text(aes(label = round(tauc_band_gap2, 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44),
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "royalblue1",
                      #limits = c(2.1, 2.901),
                      na.value = 0, name = 'Band Gap (eV)',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("\nCobalt Oxide Nanosheets - Calc. Band Gap2 (Direct)") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5,
                                        linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-Bandgap2-facet.png", width = 12,
         height = 5, units = "in", dpi = 300)
  
# band gap2 for each base after 30 days
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "30") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = tauc_band_gap2)) +
  geom_text(aes(label = round(tauc_band_gap2, 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44),
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "royalblue1",
                      #limits = c(2.1, 2.901),
                      na.value = 0, name = 'Band Gap (eV)',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Cobalt Oxide Nanosheets - Calc. Band Gap2 (Direct)\n30 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5,
                                        linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-Bandgap2-30days-facet.png", width = 12,
         height = 5, units = "in", dpi = 300)


# band gap2 for each base after 60 days
temp %>%
  filter(base_name != "Water") %>%
  filter(days == "60") %>%
  filter(group_id < 12) %>%
  ggplot(aes(as.factor(acid_conc), base_conc)) +
  geom_tile(aes(fill = tauc_band_gap2)) +
  geom_text(aes(label = round(tauc_band_gap2, 2))) +
  xlab("HCl Concentration (M)") +
  ylab("Exfoliation Reagent \n Concentration (M)") +
  theme_bw() +
  scale_y_log10(breaks = c(0.0044, 0.0075, 0.014, 0.025, 0.044, 0.075, 0.14, 0.25, 0.44),
                limits = c(0.0024, 0.79)) +
  scale_fill_gradient(low = "white", high = "royalblue1",
                      #limits = c(2.1, 2.901),
                      na.value = 0, name = 'Band Gap (eV)',
                      guide = guide_colorbar(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.direction = "horizontal") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Cobalt Oxide Nanosheets - Calc. Band Gap2 (Direct)\n60 Days in Solution") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5,
                                        linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-Bandgap2-60days-facet.png", width = 12,
         height = 5, units = "in", dpi = 300)



### Ploting Abs_DoEx vs. Band gap

temp %>%
  filter(base_name != "Water") %>%
  filter(days == "0") %>%
  filter(group_id < 12) %>%
  filter(ExCheck == "Yes") %>%
  #filter(base_name == "TMAOH") %>%
  #filter(acid_conc == 3) %>%
  ggplot(aes(x = tauc_band_gap, y = (ExCheckAbs * dilution))) +
  geom_point(aes(color = base_name), show.legend = T, size = 2) +
  #geom_smooth() +
  #labs(fill = "Acid Conc.") +
  #geom_vline(xintercept = 400) +
  #ylim(NA,1.5) +
  ylab("Abs_DoEx (A.U.)") +
  xlab("Band Gap (eV)") +
  theme_bw() +
  scale_color_discrete(name = "Acid Pre-Treated LCO (M HCl)",
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  # facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Band Gap 1") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-AbsDoEx-vs-Bandgap.png", width = 8, height = 6, units = "in", dpi = 300)



##### band Gap 2

temp %>%
  filter(base_name != "Water") %>%
  filter(days == "0") %>%
  filter(group_id < 12) %>%
  filter(ExCheck == "Yes") %>%
  #filter(base_name == "TMAOH") %>%
  #filter(acid_conc == 3) %>%
  ggplot(aes(x = tauc_band_gap2, y = (ExCheckAbs * dilution))) +
  geom_point(aes(color = acid_conc), show.legend = T, size = 2) +
  #geom_smooth(method = "glm") +
  #labs(fill = "Acid Conc.") +
  #geom_vline(xintercept = 400) +
  #ylim(NA,1.5) +
  ylab("Abs_DoEx (A.U.)") +
  xlab("Band Gap (eV)") +
  theme_bw() +
  scale_color_discrete(name = "Acid Pre-Treated LCO (M HCl)",
                       guide = guide_legend(title.position = "top")) +
  theme(legend.position = "bottom") +
  theme(legend.title.align = 0.5) +
  theme(legend.justification = "center") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(panel.background = element_rect(colour = "black", size = 2)) +
  # facet_wrap(~ base_name, ncol = 4) +
  ggtitle("Band Gap 2") +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  theme(axis.text.x = element_text(size = 14)) +
  theme(axis.text.y = element_text(size = 14)) +
  theme(axis.title = element_text(size = 18, face = "bold")) +
  theme(strip.background = element_rect(color = "black", fill = "white", size = 5, linetype = "blank"),
        strip.text.x = element_text(size = 16, face = "bold")) +
  ggsave("./EDOE/manuscript_figures/CONs-AbsDoEx-vs-Bandgap2_acid.png", width = 8, height = 6, units = "in", dpi = 300)



# linear.model <-lm((ExCheckAbs * dilution) ~ tauc_band_gap2, temp)
# log.model <-lm(log((ExCheckAbs * dilution)) ~ tauc_band_gap2, temp)
# exp.model <-lm((ExCheckAbs * dilution) ~ exp(tauc_band_gap2), temp)
# 
# log.model.df <- data.frame(x = temp$tauc_band_gap2,
#                            y = exp(fitted(log.model)))
# 
# ggplot(temp, aes(x = temp$tauc_band_gap2, y = (temp$ExCheckAbs * temp$dilution))) + 
#   geom_point() +
#   geom_smooth(method = "lm", aes(color = "Exp Model"), formula = ((temp$ExCheckAbs * temp$dilution) ~ exp(temp$tauc_band_gap2)), 
#               se = FALSE, linetype = 1) +
#   #geom_line(data = log.model.df, aes(tauc_band_gap2, y, color = "Log Model"), size = 1, linetype = 2) + 
#   guides(color = guide_legend("Model Type"))



## calculating the abs_DoEx for 1-141-121 reactions
# data.names <- c("1-141-121-00-G04", "1-141-121-00-G12", "1-141-121-00-G13")
# 
# temp %>%
#   filter(energy < high_cut) %>%
#   filter(energy > low_cut) %>%
#   filter(filename %in% data.names) %>%
#   filter(wavelength == 400) %>%
#   select(abs_DoEx)

# # after 25 days
# 1 - (1.73 / 3.97)
# 
# # after 150 days
# 1- (1.02 / 3.97)
