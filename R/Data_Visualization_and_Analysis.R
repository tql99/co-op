### The "easypackages" package allows for easier installation of packages & calling of libraries.
install.packages("easypackages")
library("easypackages")
my_packages <- c("ggplot2", "readr", "Hmisc", "RColorBrewer", "janitor", "here", "scales", "goeveg","ggpubr", "dplyr")
packages(my_packages)
libraries(my_packages)
##############################
### (TL): Below are the codes I use to generate the visualizations in "data_out/images".
##############################
# Import:
master_analyses <- read_csv(here("data_out", "master_analyses.csv"))
# Inspect the number of papers analyzed:
(paper_count <- length(unique(master_analyses$paper)))
### As of 191129: 43 papers.

# Inspect the number of papers, by species:
## E. coli:
Ecoli_entries_index <- grep("Ecoli", master_analyses$species)
Ecoli_entries <- master_analyses[Ecoli_entries_index,]
(Ecoli_paper_count <- length(unique(Ecoli_entries$paper)))
### As of 191129: 30 papers.

## S. cerevisiae:
Sac_entries_index <- grep("Sac", master_analyses$species)
Sac_entries <- master_analyses[Sac_entries_index,]
(Sac_paper_count <- length(unique(Sac_entries$paper)))
### As of 191129: 11 papers.

## P. aeruginosa:
aeruginosa_entries_index <- grep("aeruginosa", master_analyses$species)
aeruginosa_entries <- master_analyses[aeruginosa_entries_index,]
(aeruginosa_paper_count <- length(unique(aeruginosa_entries$paper)))
### As of 191129: 2 papers.

# Replace N/A values for "strain_info" with "0".
master_analyses$strain_info <- master_analyses$strain_info %>%
  replace(is.na(.), "0")


# If there are multiple strain backgrounds in 1 paper, include the value for "strain_info" in the "paper" column (for now).
for (i in 1:nrow(master_analyses)) {
  if (master_analyses[i, "strain_info"] != "0"){
    master_analyses[i, "dataset_name"] <- paste(master_analyses[i, "dataset_name"], " ", "(", master_analyses[i, "strain_info"], ")", sep = "")
    } else {
      if (master_analyses[i, "selective_pressure"] != "0") {
        master_analyses[i, "dataset_name"] <- paste(master_analyses[i, "dataset_name"], " ", "(", master_analyses[i, "selective_pressure"], ")", sep = "")
      }
    }
  }


### Inspect the number of datasets (some papers have > 1 dataset) (1 dataset: 1 ancestor, 1 environment/selective pressure)
(dataset_count <- length(unique(master_analyses$dataset_name)))
### As of 191129: 90 datasets.

# Inspect the number of datasets, by species:
## E. coli:
Ecoli_entries_strain_info_added <- master_analyses[Ecoli_entries_index,]
(Ecoli_dataset_count <- length(unique(Ecoli_entries_strain_info_added$dataset_name)))
### As of 191129: 52 datasets.

## S. cerevisiae:
Sac_entries_strain_info_added <- master_analyses[Sac_entries_index,]
(Sac_dataset_count <- length(unique(Sac_entries_strain_info_added$dataset_name)))
### As of 191129: 35 datasets.

## P. aeruginosa:
aeruginosa_entries_strain_info_added <- master_analyses[aeruginosa_entries_index,]
(aeruginosa_dataset_count <- length(unique(aeruginosa_entries_strain_info_added$dataset_name)))
### As of 191129: 3 datasets.

# c-hyper vs generation:
### Most datasets use generations to notate timepoints. However, there are still some that uses days or flasks. 
### Will need to clump all timepoints into more general ones (i.e. early/intermediate/late or convert everything to generations).
generation_analysis <- master_analyses %>%
  subset(generation != "NA")
## A dot & line chart, color coded by paper. Remove whatever elements you don't need:
ggplot(generation_analysis, aes(x = generation, y = c_hyper, color = dataset_name)) + geom_point() + labs(color = "Datasets") + geom_line(size = 0.75) + 
  scale_x_log10() + ggtitle("c-hyper vs generation") + theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"), legend.position = "bottom") 
### A version optimized for the poster competition i.e. graph legend & title removed:
ggplot(generation_analysis, aes(x = generation, y = c_hyper, color = dataset_name)) + geom_point() + geom_line(size = 0.75) + 
  scale_x_log10() + theme(legend.position = "none")


## Split the chart by species:
### E. coli:
generation_analysis_Ecoli_index <- grep("Ecoli", generation_analysis$species)
generation_analysis_Ecoli <- generation_analysis[generation_analysis_Ecoli_index,]
ggplot(generation_analysis_Ecoli, aes(x = generation, y = c_hyper, color = dataset_name)) + geom_point() + geom_line(size = 0.75) + 
  scale_x_log10() + ggtitle("c-hyper vs generation, E. coli") + theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"), legend.position = "bottom")

### S. cerevisiae:
generation_analysis_Sac_index <- grep("Sac", generation_analysis$species)
generation_analysis_Sac <- generation_analysis[generation_analysis_Sac_index,]
ggplot(generation_analysis_Sac, aes(x = generation, y = c_hyper, color = dataset_name)) + geom_point() + geom_line(size = 0.75) + 
  scale_x_log10() + ggtitle("c-hyper vs generation, S. cerevisiae") + theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"), legend.position = "none")

### P. aeruginosa:
generation_analysis_P_aeruginosa_index <- grep("aeruginosa", generation_analysis$species)
generation_analysis_P_aeruginosa <- generation_analysis[generation_analysis_P_aeruginosa_index,]
ggplot(generation_analysis_P_aeruginosa, aes(x = generation, y = c_hyper, color = dataset_name)) + geom_point() + geom_line(size = 0.75) + 
  scale_x_log10() + ggtitle("c-hyper vs generation, P. aeruginosa") + theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold"), legend.position = "none")


# ## If you just need to color-code by species:
# ### First, we need to remove the strain names and just keep the general species name. 
# ### Also, use a neater-looking form of species names for the graph legend.
# #### E. coli:
# generation_analysis$species <- generation_analysis$species %>%
#   replace(grep("coli", generation_analysis$species), "E. coli")
# #### S. cerevisiae:
# generation_analysis$species <- generation_analysis$species %>%
#   replace(grep("Sac", generation_analysis$species), "S. cerevisiae")
# #### P. aeruginosa:
# generation_analysis$species <- generation_analysis$species %>%
#   replace(grep("aeruginosa", generation_analysis$species), "P. aeruginosa")
# ### Designate colors to each species:
# #### Since we designate color by species, why not set the stage for color-coding with the species?
# generation_analysis$graph_color <- generation_analysis$species
# #### Then, replace each species' name with the color you want:
# generation_analysis$graph_color <- generation_analysis$graph_color %>%
#   replace(grep("E. coli", generation_analysis$graph_color), "green")
# generation_analysis$graph_color <- generation_analysis$graph_color %>%
#   replace(grep("S. cerevisiae", generation_analysis$graph_color), "red")
# generation_analysis$graph_color <- generation_analysis$graph_color %>%
#   replace(grep("P. aeruginosa", generation_analysis$graph_color), "blue")
# ### Finally, the plot:
# ggplot(generation_analysis, aes(x = generation, y = c_hyper, color = graph_color)) + geom_point() + geom_line(size = 0.75) + 
#   labs(color = "Species") + scale_x_log10() + ggtitle("c-hyper vs generation") + theme(plot.title = element_text(hjust = 0.5, size = 11), legend.position = "bottom")


# c-hyper vs generation (multiple generations):
multiple_wide_generation_analysis <- generation_analysis %>%
  subset(func == "multiple_wide")
multiple_wide_generation_analysis <- multiple_wide_generation_analysis[order(multiple_wide_generation_analysis$paper, multiple_wide_generation_analysis$generation),]

ggplot(multiple_wide_generation_analysis, aes(x = generation, y = c_hyper, color = dataset_name)) + geom_point() + labs(color = "Datasets") + geom_line(size = 0.75) + 
  scale_x_log10() + ggtitle("c-hyper vs generation, experiments with multiple generations") + theme(plot.title = element_text(hjust = 0.5, size = 11), legend.position = "bottom")
## Get the correlation between generation and c-hyper:
cor(multiple_wide_generation_analysis$c_hyper, multiple_wide_generation_analysis$generation)


# c-hyper vs generation (generation-notated end points only):
end_point_generation_analysis <- c()
end_point_generation_analysis <- generation_analysis %>%
  subset(func != "multiple_wide")
### Get only the end points of experiments with data for multiple generations (from multiple_wide_generation_analysis):
### [The selection of rows in this step is still manual & should be made automatic - for loop?].
end_point_entries_multiple_wide <- c(6, 8, 12, 17, 28, 36, 46, 57, 59)
end_point_generation_analysis <- rbind(end_point_generation_analysis, multiple_wide_generation_analysis[end_point_entries_multiple_wide,])
### The plot is currently optimized for the poster competition (bigger axis.text, bigger legend.title, etc.)
ggplot(end_point_generation_analysis, aes(x = generation, y = c_hyper, color = species)) + xlab("Generations") + ylab("c-hyper") + 
  geom_jitter(size = 4, width = 0.2) + labs(color = "Species") + scale_x_log10() + scale_y_continuous(breaks = seq(0,80,5)) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 18, face = "bold"), 
        legend.title = element_text(size = 18, face = "bold"), legend.position = "right", legend.text = element_text(size = 14, face = "italic")) 
end_point_generation_analysis_small_c_hyper <- subset(end_point_generation_analysis, c_hyper == 0)
end_point_generation_analysis_small_c_hyper <- end_point_generation_analysis_small_c_hyper[order(end_point_generation_analysis_small_c_hyper$c_hyper),]
# Include this if need a title: "+ ggtitle("c-hyper vs generation, generation-notating end points only") + theme(plot.title = element_text(hjust = 0.5, size = 11))" 
# Include this if need a linear regression line: "+ geom_smooth(method=lm, se = FALSE)"
# Include this if need a log curve: "+ geom_smooth(method = lm, formula = y ~ log(x), se = FALSE)"


## c-hyper vs generation (generation-notated end points only), by species:
### E. coli (also omitting Tenaillon2016 for the same reason as mentioned above):
end_point_generation_Ecoli_entries <- grep("E.", end_point_generation_analysis$species)
end_point_generation_Ecoli_analysis <- end_point_generation_analysis[end_point_generation_Ecoli_entries,]
ggplot(end_point_generation_Ecoli_analysis, aes(x = generation, y = c_hyper)) + geom_point() +  geom_smooth(method=lm, se=FALSE) + labs(color = "Datasets") + 
  ggtitle("c-hyper vs generation, generation-notating end points only, E. coli") + theme(plot.title = element_text(hjust = 0.5, size = 11), legend.position = "bottom") 

### Sac:
end_point_generation_Sac_entries <- grep("Sac", end_point_generation_analysis$species)
end_point_generation_Sac_analysis <- end_point_generation_analysis[end_point_generation_Sac_entries,]
ggplot(end_point_generation_Sac_analysis, aes(x = generation, y = c_hyper)) + geom_point() +  geom_smooth(method=lm, se=FALSE) + labs(color = "Datasets") + 
  ggtitle("c-hyper vs generation, generation-notating end points only, S. cerevisiae") + theme(plot.title = element_text(hjust = 0.5, size = 11), legend.position = "bottom") 

### P. aeruginosa:
end_point_generation_aeruginosa_entries <- grep("aeruginosa", end_point_generation_analysis$species)
end_point_generation_aeruginosa_analysis <- end_point_generation_analysis[end_point_generation_aeruginosa_entries,]
ggplot(end_point_generation_aeruginosa_analysis, aes(x = generation, y = c_hyper)) + geom_point() +  geom_smooth(method=lm, se=FALSE) + labs(color = "Datasets") + 
  ggtitle("c-hyper vs generation, generation-notating end points only, P. aeruginosa") + theme(plot.title = element_text(hjust = 0.5, size = 11), legend.position = "bottom") 


# Statistical analysis, by species:
## [Could create a function to get all the basic statistical values]
## End-point analyses:
### E. coli:
#### # of datasets:
endpoint_generation_paper_count_Ecoli <- length(end_point_generation_Ecoli_analysis)
#### Mean:
c_hyper_mean_Ecoli <- mean(end_point_generation_Ecoli_analysis$c_hyper)
#### Standard deviation:
c_hyper_sd_Ecoli <- sd(end_point_generation_Ecoli_analysis$c_hyper)

### Sac:
#### # of datasets:
endpoint_generation_paper_count_Sac <- length(end_point_generation_Sac_analysis)
#### Mean:
c_hyper_mean_Sac <- mean(end_point_generation_Sac_analysis$c_hyper)
#### Standard deviation:
c_hyper_sd_Sac <- sd(end_point_generation_Sac_analysis$c_hyper)
#### Coefficient of variation:
c_hyper_coevar_Sac <- cv(end_point_generation_Sac_analysis$c_hyper)
#### Variance:
c_hyper_var_Sac <- var(end_point_generation_Sac_analysis$c_hyper)

### P. aeruginosa:
#### # of datasets:
endpoint_generation_paper_count_aeruginosa <- length(end_point_generation_aeruginosa_analysis$paper)
#### Mean:
c_hyper_mean_aeruginosa <- mean(end_point_generation_aeruginosa_analysis$c_hyper)
#### Standard deviation:
c_hyper_sd_aeruginosa <- sd(end_point_generation_aeruginosa_analysis$c_hyper)

### Bacteria (E. coli & P. aeruginosa):
end_point_generation_bacteria_analysis <- rbind(end_point_generation_Ecoli_analysis, end_point_generation_aeruginosa_analysis)
#### # of datasets:
endpoint_generation_paper_count_bacteria <- length(unique(end_point_generation_bacteria_analysis$paper))
#### Mean:
c_hyper_mean_bacteria <- mean(end_point_generation_bacteria_analysis$c_hyper)
#### Standard deviation:
c_hyper_sd_bacteria <- sd(end_point_generation_bacteria_analysis$c_hyper)
#### Coefficient of variation:
c_hyper_coevar_bacteria <- cv(end_point_generation_bacteria_analysis$c_hyper)
#### Variance:
c_hyper_var_bacteria <- var(end_point_generation_bacteria_analysis$c_hyper)


# MH's Wilcox Test (E. coli vs Sac):
## Testing if the median in E.coli is different then the median in Sac for their c_yper value.
### SOOOO our data can not use anova since it doesnt meet the assumptions of normality or equal variances. so we can use the wilcox test. 
end_point_generation_analysis_grouped_species <- end_point_generation_analysis %>% select(species, c_hyper)
end_point_generation_analysis_grouped_species$species <- gsub("Ecoli_K12", "bacteria", end_point_generation_analysis_grouped_species$species)
end_point_generation_analysis_grouped_species$species <- gsub("P_aeruginosa_PA14", "bacteria", end_point_generation_analysis_grouped_species$species)


summary = end_point_generation_analysis_grouped_species %>% group_by(species) %>%
  summarise(
    count = n(),
    median = median(c_hyper, na.rm = TRUE),
    IQR = IQR(c_hyper, na.rm = TRUE)
  )
summary

ggboxplot(end_point_generation_analysis_grouped_species, x = "species", y = "c_hyper", 
          color = "species", palette = c("#00AFBB", "#E7B800"),
          ylab = "C_hyper", xlab = "Species")

test <- wilcox.test(c_hyper ~ species, end_point_generation_analysis_grouped_species = end_point_generation_analysis_grouped_species,
                    exact = FALSE)
test
### Reject Ho big time
### We can conclude that E.coli's median c_hyper is significantly different from Sac's median c_hyper with a p-value = 1.325e-06, which correcsponds with the graph above.

