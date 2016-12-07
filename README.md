# ADS Final Project: 

Term: Fall 2016

+ Team Name: MelodySoup
+ Project title: Music Writing App Based on Chord Mining 
+ Team members
	+ team member 1 Kanghui Jiang (kj2381)
	+ team member 2 Zhehao Liu    (zl2480)
	+ team member 3 Yixin Sun     (ys2879)
	+ team member 4 Cen Zeng      (cz2379)
	+ team member 5 Wanyi Zhang   (wz2323)
+ Project summary:
    + Dataset: [McGill Billboard Project](http://ddmal.music.mcgill.ca/billboard) 
        + 990 songs of Billboard chart from 1958 to 1991
        + Containing txt files of chord annotations, and csv file of song information
        + Genres of songs obtained by API
        + Transpose chords to the key of C (normalization)
    + Objective: Generate characteristic chord progressions given a particular genre using sequence analysis
    + EDA
        + Genre popularity over time 
        + Major chords across genres
    + Naive Bayes: 
        + Predict genres using chord frequencies
        + Baseline model: simulation of genres using stratified probability
        + Prediction accuracy: 52% (enhanced baseline accuracy 25% by 107%)
    + Sequence analysis on chord progression
        + n-gram: bigram, 4-gram
        + use tf-idf to remove common pattern across all genres
        + Objective: generate chord progression with 4-grams
    + Visualizations
        + Use bigrams to make chord diagrams of <Beat It> and for each genre
        + Use 4-grams to make sankey diagrams
    + Shiny app: [MelodySoup](https://wanyizhang.shinyapps.io/melodysoup/)
        + Recommend next chord given a particular genre based on 4-gram tf-idf
        + Generate a chord progression and play audio
        
    
          
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
├── meetings/
└── output/
```

Please see each subfolder for a README file
