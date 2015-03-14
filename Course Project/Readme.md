# Readme

## Objective
The objective of this file is to provide brief instructions on the use of the scripts or markdown files to generate the merged tidy data file (as per project requirements)

## Instruction to use the R script.
1.  Download the 'R' script: run_analysis.R
2.  Set the working directory to be the same folder as the downloaded R script
3.  Source the R script.  Upon completion, it should have 
    - Created a sub-directory: data
    - Downloaded the data: UCI HAR Dataset.zip
    - Unzip the dataset zip file into the data sub-folder
    - Generate the merged tidy data file in the working director: merge_tidy.txt
4.  Please read the run_analysis.html for the analysis done on the raw dataset to generate the tidy data file.

## Instruction to use the R markdown file
1.  The R markdown file is the actual source file used to create the R script above and the html file.
2.  Download the 'R' markdown file: run_analysis.Rmd
3.  Set the working directory to be the same folder as the downloaded 'R' markdown file.
4.  Load the 'R' markdown file into editor
5.  At the editor toolbar, select "knit HTML".  This would generate the run_analysis.html file, generate the merge_tidy.txt file into the Working Directory.  This also "source" the embeded 'R' script within the markdown file.  Alternatively, you can also use the R console command, knit2html("run_analysis.Rmd").  You would need to load the knitr library to do this.
6.  To create the 'R' script, at the R console, load the knitr library, and type purl("run_analysis.Rmd")

## Metadata Analysis and Assumptions (or Codebook)
1.  For the analysis of the metadata of the downloaded dataset and the assumptions made, please read the run_analysis.html file.  
2.  If you are familar with 'R' markdown files, the knitr will generate the run_analysis.html and display it when the Rmd is knitr.