# ADS Final Project: 

Term: Fall 2016

+ Team Name: MelodySoup
+ Project title: Music Writing App Based on Chord & Key Mining 
+ Team members
	+ team member 1 Kanghui Jiang (kj2381)
	+ team member 2 Zhehao Liu    (zl2480)
	+ team member 3 Yixin Sun     (ys2879)
	+ team member 4 Cen Zeng      (cz2379)
	+ team member 5 Wanyi Zhang   (wz2323)
+ Project summary:
    + Objective: Songbase writing app MelodySoup
    + Chord progression
        + Sequence analysis: 
            + n-gram: bigram, 4-gram
        + Objective: generate sequence with 4-grams
    + Visualization
        + use bigram to make circular plots
            + for one song, while playing the music
            + for diff genres* (able to add songs to the diagram one by one?)
        + use 4-gram to plot sankey diagram (diff genres* in diff colors) (start with genres* or verse-chorus form) 
    + Cooccurrence analysis:
        + topic modeling: 4-gram as a word
        + read literature: 中文切词
    + EDA: 
        + Genre popularity over time 
        + Most frequent chords/keys/4-grams by genres
        + Pick specific genres/artists/albums for detailed demo (with sound)
    + Results:
        + predict the genre of a new song
        + Generate music with chords and keys based on a particular genre you want
            + Do demo with audio (add layers)
        
        
+ Dataset:
    1. McGill Billboard Project http://ddmal.music.mcgill.ca/billboard
        + Unzip tar.xz http://askubuntu.com/questions/25347/what-command-do-i-need-to-unzip-extract-a-tar-gz-file
        + Billboard parser documentation http://www.cs.uu.nl/research/techreps/repo/CS-2012/2012-018.pdf
    2. The Beatles http://isophonics.net/content/reference-annotations-beatles
    3. API: one for "next chord probabilities" and one for "songs containing a chord progression” 
        + https://www.hooktheory.com/api/trends/docs
    + （Audio Dataset List: http://www.audiocontentanalysis.org/data-sets/）
    + （MARL (Music and Audio Research Lab) at NYU Music Technology program https://github.com/tmc323/Chord-Annotations
        + 195 USpop songs chord transcription https://github.com/tmc323/Chord-Annotations/tree/master/uspopLabels
        + 100 RWC pop chord annotation https://github.com/tmc323/Chord-Annotations/tree/master/RWC_Pop_Chords）
   
    
+ Music theory support 乐理知识:
    + NiceChord（好和弦）Youtube（必看！！）: 
        + 和弦有什么功能 https://www.youtube.com/watch?v=kMlJSwFAiTU
        + 和弦还有什么功能（续集） https://www.youtube.com/watch?v=1USZt8fx82U
        + 什么是大调和小调 https://www.youtube.com/watch?v=T70L-t60j5c
        + 十分钟之内，一次搞懂所有的现代和弦代号 https://www.youtube.com/watch?v=I0y2LY4sPZA
        + 流行歌曲的verse-chorus form（五月天《后来的我们》分析） https://www.youtube.com/watch?v=46z8HPCAKCs
        + 为什么流行歌听起来都这么像？（港台风法宝） https://www.youtube.com/watch?v=wxJImbUCyJw
    + 吉他各调常用和弦 http://www.ijita.com/tool/usedchord/
    + 教你用C调1645和弦写出不一样的歌 https://www.douban.com/note/380048632/

        
+ Existing examples:
    + https://www.hooktheory.com/trends#node=4.1.5.6&key=rel
    + https://github.com/mexindian/Musical-chord-progressions
    + http://amitkohli.com/chord-progressions-of-5-000-songs/
    
    
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file
