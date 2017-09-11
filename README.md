# toyexam
auto multiple choice example exam

This shared stuff is an example of how to maintain your exam questions as
a set of files in file system and some conventions that make it easy to reuse
these questions or variants thereof without having to go into copy and paste mode.

a video will be on [Youtube](https://youtu.be/AhdNW2gGHuE)

The conventions are as follows:

The exam questions and the exam instances are sibling directories with  course
specific directory as the common parent. For the toy exam that would be:

```bash
../../trunk/40_exam/
├── builds
│   ├── 20140401
│   ├── 20140402
│   ├── 20160329
│   ├── blindexam
│   ├── exam1
│   ├── exam2
│   ├── exam3
│   ├── luaexam
│   └── matrixquestion
└── questions
    ├── code
    │   └── ExamCode
    │       └── src
    │           └── racingsequence
    │               ├── r1
    │               ├── r2
    │               ├── r3
    │               └── r4
    ├── figures
    ├── geography
    ├── history
    ├── java
    ├── math
    └── multiset
```

Our local convention is to have the exam stuff under 40_exam.

Every exam instance lives in a directory of its own, convention is to use the exam date in iso 8601 date format.
Example 20160329 for 29th of march 2016.

The exam itself (the files we version) consist of three files:
questions.tex  source.tex     students.csv   

The name of the `students.csv` file should give enough clue to its purpose.
The `source.tex` file is the one that is to be processed by AMC. The most important thing it does is define where all the stuff is. This is in the line starting with `\def\CourseDir`.
The remainder should be clear from the names of the defined variables.

The secret ingredient is the processor file, which in this case is `exampreamble`.
`exampreamble` is one of a set of latex files used in our installation. For convenience and as convention we put them in a directory under ~/texmf/tex/latex which is the texlive location to
lookup files that are not in the local directory. `eampreamble` itself inputs some other stuff, based on the defined names.


```latex
%% Example source file AMC exam
%% with fontys Venlo Specific Includes.
%% $Id$

%% CourseDir is the absolute path to the parent dir of
%% questions/... and builds/.
%% The \ProcessExam at the end assumes the following substructure
%% <CourseDir>
%% ├── builds
%% │   ├── <ExamInstance>, e.g. 20120628 or exam1 (as in this example)
%% │   │   ├── questions.tex The mc question in this exam, shuffled
%% │   │   ├── openquestions.tex the open question, not shuffled and
%% │   │   ├                     put ate end
%% │   │   ├── students.csv   The list of students for this exam,
%% │   │   ├                  peerweb generated
%% │   │   └── source.tex     This file
%% │   ├── defaults.tex       Defaults for this course
%% │   ├── [macros.tex]       optional macros for this course
%% │   └── packages.tex       optional packages used in the exams for
%% │                          this course
%% └── questions              Question base dir
%%     ├── [figures]          Figures to include in exams
%%     ├── [tables]           Tables
%%     ├── [code]             source code (e.g. java)
%%     ├── [subject1]         questions on subject (dir name is up to
%%                            author. avoid spaces though ;-))
%%     ├── [subject2]          ,,
%%     └── [subject3]          ,,

%% absolute path to the parent dir of exams and questions
\providecommand\ProcessorFile{exampreamble}
\def\CourseDir{\string~/sebi/toyexam/trunk/40_exam}
\def\ExamInstance{20160329}
\input{\ProcessorFile}

%% if some defs are same for all your exams for this source, put them in
%% ../defaults.tex which is also known as \CourseDir/builds/defaults.tex

%% Set the seed for this exam, Preferably different for each instance.
\def\RandomSeed{293613415}
%% If you need a different date then the one defined in the defaults.tex
\def\examdate{\NL{29 januari 2016}\DE{29. Januar 2016}\EN{January 29$^{th}$ 2016}}
\def\examtime{14:00-15:00}

%% provided are one a two colum forms. uncomment one of the next two lines.
\def\FormType{onecolumnform}
%\def\FormType{twocolumnform}

%% AMC settings for 2 points per questions
%% for other options or score dependent on question see AMC doc.
\scoringDefaultM{haut=2}
\scoringDefaultS{mz=2}
%%  set the machinery to work.
\ProcessExam

```

To make this all work, make sure you have a copy or a symlink to the fontexam directory as child of your personal ~/texmf/tex/latex directory.
Also make sure that the teambin directory is mentioned in your PATH environment variable. Easiest is to add a statement to that effect to
your ~/.bashrc script like so: `export PATH=${HOME}/bin:${HOME}/teambin:$PATH`

To test if things work, go to one of the question directories, like `...40_exam/questions/math` and try the command `onequestion-en graph`. This should render the graph.tex question.
This is the way we test question when authoring them.

As a next test, go to `...40_exam/builds/20160329` and try `pdflatex source` there. This should produce a pdf of an exam, with as many pages as needed for your students.

To produce the exam with AMC, a few extra steps are needed.
. start AMC
. create a new empty exam
. go to the directory where the exam is created and link the `source.tex` file to `...40_exam/builds/20160329/source.tex`
with the command `ln -sf ...40_exam/builds/20160329/source.tex source.tex`. while you are at it, do the same for the students.csv file.
`ln -sf  ...40_exam/builds/20160329/students.csv students.csv`

Then in the AMC GUI you can create the exam.
