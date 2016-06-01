% This package defines the report/book class in the TU/e 2008 style.
% Besides new functionality, it also redefines some commands from
% the standard report/book document class, so it is designed to work with these
% classes only!
%
% Author: Alex Dings & Christiaan Dirkx, elaborated on the works of Marko Boon
% Date: May, 2015.

\NeedsTeXFormat{LaTeX2e}
\def\fileversion{v.2.0}
\def\filedate{2015/03/29}
\ProvidesClass{TUestyleReportBook}[\filedate\space\fileversion\space  TU/e style report & book 2008]



%%%
%   Used Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{xkeyval}
\RequirePackage[table]{xcolor}    % loads also »colortbl«

\RequirePackage{pgf}  % loads also »xcolor«
\RequirePackage[dutch, english]{babel}
\RequirePackage{graphicx}
\RequirePackage{anyfontsize}
%\RequirePackage{titletoc}
%\RequirePackage{titlesec}

%%%
%   Definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Switch between book / report
%%  (report by default)
\newif\ifbook
\bookfalse

%%% Switch between english / dutch
%%  (english by default)
\newif\ifenglish
\englishtrue

%%% Draft mode
%%  (false by default)
\newif\ifdraft
\draftfalse

%%% Draw draft mark
%%  (false by default)
\newif\ifdraftmark
\draftmarkfalse

%%% Draw draft line numbering
%%  (false by default)
\newif\iflinenum
\linenumfalse

%%% Use Meta OT fonts
%%  (false by default)
\newif\iftuefonts
\tuefontsfalse

%%% Show margins
%%  (false by default)
\newif\ifmargins
\marginsfalse

%%% Draw notes
%%  (false by default)
\newif\ifnotes
\notesfalse

%%% Switch between one-sided / two-sided mode
%%  (one-sided by default) %%% TODO describe per class
\newif\iftwosided

%%% Check if user overwrites default twoside or oneside
\newif\iftwosidedtouched
\twosidedtouchedfalse

%%% Switch between one-column / two-column mode
%%  (one-column by default)
\newif\iftwocolumn
\twocolumnfalse

%%% Switch between one-sided / two-sided header and footer
%%  (two-sided by default)
\newif\ifonesidehf
\onesidehffalse

%%% Draw chapter in footer
%%  (false by default)
\newif\ifsectioningf
\sectioningffalse

%%% Draw copyholder in footer
%%  (false by default)
\newif\ifcopyf
\copyffalse

%%% Draw last page number in footer
%%  (false by default)
\newif\ifendf
\endffalse

%%% Draw shorter header
%%  (false by default)
\newif\ifshorth
\shorthfalse

%%% Cover ratio
%%  (4/3 by default)
\def\@coverratio{4/3}

%%% Sectioning shift
%%  (0 by default)
\def\@sectioningshift{0}

%%% Align options
%%  (centered by default)
\def\autocentershort{c}
\def\autocenter{\centering}
\def\autocentercap{\centering}

%% header and footer color
\definecolor{hfcolor}{gray}{0}

%% graphics path
\def\definedpath{}

%% list of parskip
\newlength{\listofparskip}
\setlength{\listofparskip}{0cm}

%%%
%   Commands used in class options 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% command \ifequal{<stringA>}}{<stringB>}{<on true>}{<on false>}
%%  compares two strings for equality
\newcommand{\@ifequal}[4]{%
  \def\string@a{#1}%
  \def\string@b{#2}%
  \ifx\string@a\string@b%
    #3%
  \else%
    #4%
  \fi%
}

\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}
  
\def\stringtonum#1{
  \edef\@tempa{#1}%
  \expandafter\expandfraction\@tempa\relax
} %%%TODO check if fraction

\newlength{\lengthc}
  \def\expandfraction#1/#2\relax{%  
  \setlength{\lengthc}{\dimexpr #1pt / #2 \relax}
}


%%%	command \ifrealnum{<number1>}{<number2>}{<on 1 > 2>}{<on 1 < 2>}{<on 1 = 2>}
%%	compares two (non) integer numbers (real numbers)
%%  Note: fractions can only contain integers
\newlength{\lengtha}
\newlength{\lengthb}
\def\ifrealnum #1#2#3#4#5 {%
  \if\instring{/}{#1}
    \stringtonum{#1}
    \setlength{\lengtha}{\the\lengthc} % allow for fractions (and calculations)  
  \else
    \setlength{\lengtha}{#1 pt}
  \fi
  \if\instring{/}{#2}
    \stringtonum{#2}
    \setlength{\lengthb}{\lengthc} % allow for fractions (and calculations) 
  \else
    \setlength{\lengthb}{#2 pt}
  \fi
  \ifdim\the\lengtha >\the\lengthb % on 1 > 2
    #3
  \else
    \ifdim\the\lengtha <\the\lengthb % on 1 < 2
      #4
    \else % on 1 = 2
      #5
    \fi
  \fi
}

%%% TODO add comments
\newcommand{\PassOptionsToBaseClass}[1]{
  \PassOptionsToClass{#1}{book}
  \PassOptionsToClass{#1}{report}
}





%%%
%   Class options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Report class option error
\def\ClassErrorNotSupported#1#2{\ClassError{TUestyle_ReportBook}{Sorry, only #1 is supported!}{Remove the #2 class option}}
\def\DeclareBooleanOptionX#1{\define@boolkey{TUestyle_Development.cls}[]{#1}{}}

% document options
\DeclareOptionX{report}{\bookfalse \iftwosidedtouched\relax\else\twosidedfalse\fi}
\DeclareOptionX{book}{\booktrue \iftwosidedtouched\relax\else\twosidedtrue\fi}

% throw error on not supported paper sizes
\DeclareOptionX{a5paper}{\ClassErrorNotSupported{a4paper}{a5paper}}
\DeclareOptionX{b5paper}{\ClassErrorNotSupported{a4paper}{b5paper}}
\DeclareOptionX{letterpaper}{\ClassErrorNotSupported{a4paper}{letterpaper}}
\DeclareOptionX{executivepaper}{\ClassErrorNotSupported{a4paper}{executivepaper}}
\DeclareOptionX{legalpaper}{\ClassErrorNotSupported{a4paper}{legalpaper}}
\DeclareOptionX{landscape}{\ClassErrorNotSupported{portrait}{landscape}}

% custom layout margins
\DeclareOptionX{left}{\newlength{\layoutleftmargin}\setlength{\layoutleftmargin}{#1}}
\DeclareOptionX{right}{\newlength{\layoutrightmargin}\setlength{\layoutrightmargin}{#1}}
\DeclareOptionX{top}{\newlength{\layouttopmargin}\setlength{\layouttopmargin}{#1}}
\DeclareOptionX{bottom}{\newlength{\layoutbottommargin}\setlength{\layoutbottommargin}{#1}}
\DeclareOptionX{marginparL}{\newlength{\marginparL}\setlength{\marginparL}{#1}}
\DeclareOptionX{marginparR}{\newlength{\marginparL}\setlength{\marginparL}{#1}}

% language options
\DeclareOptionX{english}{\englishtrue}
\DeclareOptionX{engels}{\englishtrue}
\DeclareOptionX{dutch}{\englishfalse}
\DeclareOptionX{nederlands}{\englishfalse}

% draft mode
\DeclareOptionX{draft}{\drafttrue}

% draw draft mark
\DeclareOptionX{draftmark}{\draftmarktrue}

% draw draft line numbering
\DeclareOptionX{linenum}{\linenumfalse}

%%% TU/e style options

% draw TU/e slogan
\DeclareBooleanOptionX{slogan}
\slogantrue

% draw the innovation mark
\DeclareBooleanOptionX{innovation}
\innovationtrue

% draw the TU/e logo mark
\DeclareBooleanOptionX{logo}
\logotrue

% draw TU/e address
\DeclareBooleanOptionX{address}
\addresstrue

% draw the author
\DeclareBooleanOptionX{author}
\authortrue

% draw the date
\DeclareBooleanOptionX{date}
\datetrue


%%% Sectioning options

% use sectioning style
\DeclareBooleanOptionX{sectioningstyling}
\sectioningstylingtrue

% draw "chapter XX" above chaptername
\DeclareBooleanOptionX{chaptername}
\chapternamefalse

% Shift all sectioning numbering to left margin,
% widen left margin
% Shift complete chapter heading in left margin
\DeclareBooleanOptionX{runinsec}
\runinsecfalse

% Keep subsectionmark
\DeclareBooleanOptionX{subsecmark}
\subsecmarkfalse

% Hidden watermark in sectioning
\DeclareBooleanOptionX{watermark}
\watermarkfalse

% use paragraph style
\DeclareBooleanOptionX{paragraphstyling}
\paragraphstylingtrue

% start sectioning counters at zero
\DeclareOptionX{zeroindexed}{\def\@sectioningshift{-1}}

% use auto labeling
\DeclareBooleanOptionX{autolabel}
\autolabeltrue

% show margins
\DeclareOptionX{margins}{\marginstrue}

% draw notes
\DeclareOptionX{notes}{\notestrue}

% draw one-sided / two-sided
\DeclareOptionX{oneside}{\twosidedfalse \twosidedtouchedtrue}
\DeclareOptionX{twoside}{\twosidedtrue  \twosidedtouchedtrue}

% draw one-column / two-column
\DeclareOptionX{onecolumn}{\twocolumnfalse}
\DeclareOptionX{twocolumn}{\twocolumntrue}

% cover ratio (min 4/3)
\DeclareOptionX{coverratio}{\def\@coverratio{\@nummin{4/3}{#1}}}

% graphics path
\DeclareOptionX{graphicspath}{%
	\def\definedpath{#1}
  \graphicspath{{\definedpath}}
}

%%	Option for cover ratio
%   Ratio has to be bigger than 4:3
\def\@coverratio{4/3}
\DeclareOptionX{coverratio}{
  \ifrealnum{#1}{4/3}{%
    \def\@coverratio{#1}
  }{
    \def\@coverratio{4/3}
  }{}


% fonts options
\DeclareOptionX{tuefonts}{\tuefontstrue}

% Alligning options
\DeclareOptionX{align}{
  \@ifequal{#1}{left}{%
    \def\autocenter{\raggedright}%
    \def\autocentercap{\raggedright}%
    \def\autocentershort{l}%
  }{
  \@ifequal{#1}{center}{%
    \def\autocenter{\centering}%
    \def\autocentercap{\centering}%
    \def\autocentershort{c}%
  }{
  \@ifequal{#1}{right}{%
    \def\autocenter{\raggedleft}%
    \def\autocentercap{\raggedleft}%
    \def\autocentershort{r}%
  }{
  \@ifequal{#1}{none}{%
    \def\autocenter{\raggedright}%
    \def\autocentercap{\centering}%
    \def\autocentershort{c}%
  }{}}}}
}


% header & footer options

% draw one-sided / two-sided header and footer
\DeclareOptionX{onesidehf}{\onesidehftrue}
\DeclareOptionX{twosidehf}{\onesidehffalse}

% draw faded header and footer
\DeclareOptionX{fadehf}{
  \definecolor{hfcolor}{gray}{.2}
}

% draw chapter in footer
\DeclareOptionX{sectioningf}{\sectioningftrue}

% draw chapter in footer
\DeclareOptionX{copyf}{\copyftrue}

% draw last page number in footer
\DeclareOptionX{endf}{\endftrue}

% draw shorter header
\DeclareOptionX{shorth}{\shorthtrue}
}

\DeclareBooleanOptionX{leadzero}
\leadzerotrue

%%%% TODO make option
\newif\ifcover
\coverfalse
\def\covername{cover}
\DeclareOptionX{cover}{%
  \@ifequal{#1}{}{}{
    \def\covername{#1}
  }
  \covertrue
}

%%% Miscelanious options

% use auto labeling
\DeclareBooleanOptionX{autolabel}
\autolabeltrue


% Print optimalization
\newif\ifprint
\printfalse
\DeclareOptionX{print}{\printtrue}

% hide upper sectioning
\DeclareBooleanOptionX{hideuppersectioning}
\hideuppersectioningfalse

% font options
\DeclareOptionX{9pt}  {\PassOptionsToBaseClass{10pt}            \def\classFontSize{9} }
\DeclareOptionX{10pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{10}}
\DeclareOptionX{11pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{11}}
\DeclareOptionX{12pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{12}}

\PassOptionsToBaseClass{10pt}
\def\classFontSize{9}

% pass options to underlying classes
\DeclareOptionX*{%
  \PassOptionsToClass{\CurrentOption}{book}%
  \PassOptionsToClass{\CurrentOption}{report}%
}

\ProcessOptionsX





%%%
%   Utility commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   User commands
%%%

%%   symbol reshaping commands
%%   used to rotate symbols to create new symbols

%%% command \reflectit
%%  reflects symbol horizontally
%%% command \turnover 
%%  reflects symbol vertically
%%% command \turnne   
%%  turns a symbol north east
%%% command \turnnw   
%%  turns a symbol north west
%%% command \turnsw   
%%  turns a symbol south west
%%% command \turnse   
%%  turns a symbol south east
\newcommand{\reflecth}[1]{\reflectbox{#1}}
\newcommand{\reflectv}[1]{\reflectbox{\rotatebox[origin=c]{180}{#1}}}
\newcommand{\turnover}[1]{\rotatebox[origin=c]{180}{#1}}
\newcommand{\turnne}[1]{\rotatebox[origin=c]{45}{#1}}
\newcommand{\turnnw}[1]{\rotatebox[origin=c]{135}{#1}}
\newcommand{\turnsw}[1]{\rotatebox[origin=c]{225}{#1}}
\newcommand{\turnse}[1]{\rotatebox[origin=c]{315}{#1}}

%%  symbol reshaping commands
%%  same as above, with math mode enabled
\newcommand{\mreflecth}[1]{\reflecth{\ensuremath#1}}
\newcommand{\mreflectv}[1]{\reflectv{\ensuremath#1}}
\newcommand{\mturnover}[1]{\turnover{\ensuremath#1}}
\newcommand{\mturnne}[1]{\turnne{\ensuremath#1}}
\newcommand{\mturnnw}[1]{\turnnw{\ensuremath#1}}
\newcommand{\mturnsw}[1]{\turnsw{\ensuremath#1}}
\newcommand{\mturnse}[1]{\turnse{\ensuremath#1}}

%%% command \enquote{<content>}
%%  correctly enquotes content, in the primary quotation style
\newcommand{\enquote}[1]{``#1’’}

%%% command \secenquote{<content>}
%%  correctly enquotes content, in the secondary quotation style
\newcommand{\secenquote}[1]{‘#1’}

%%% command \superscript{<content>}
%%  correctly writes content as superscript
\newcommand{\superscript}[1]{\ensuremath{^{\textrm{\small#1}}}}

%%% command \subscript{<content>}
%%  correctly writes content as subscript
\newcommand{\subscript}[1]{\ensuremath{_{\textrm{\small#1}}}}

%%%	Abbreviation commands
\def\ie/{{\emph{i.e.}},}
\def\viz/{{\emph{viz.}},}
\def\eg/{{\emph{e.g.}},}
\def\etc/{etc.}
\def\etal/{{\emph{et al.}}}
\def\tue/{{\emph{TU/e}}}

%%% Set change margin command
%% Usage: \beginchangemargin{<left>}{<right>} \endchangemargin
%%				Where "left" and "right" are units of length
\newenvironment{changemargin}[2]{%
  \begin{list}{}{%
  \setlength{\topsep}{0pt}%
  \setlength{\leftmargin}{#1}%
  \setlength{\rightmargin}{#2}%
  \setlength{\listparindent}{\parindent}%
  \setlength{\itemindent}{\parindent}%
  \setlength{\parsep}{\parskip}%
  }\item[]%
}{
  \end{list}
}

%%%	\crule[<color>]{<width>}{<height>}
\newcommand\crule[3][black]{%
\textcolor{#1}{\rule{#2}{#3}}%
}

%%%	\chrule[<color>]{<height>}
\newcommand\chrule[2][black]{%
  \begingroup
    \leavevmode\color{#1}\leaders\hrule height #2\hfill\kern\z@
  \endgroup
}

%%% command \urlstyle{allbreak}
%   breaks all urls
\def\url@allbreakstyle{%
  \def\UrlBreaks{\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;\do\>\do\]%
    \do\)\do\,\do\?\do\'\do+\do\=\do\#%
    \do A\do B\do C\do D\do E\do F\do G\do H\do I\do J\do K\do L\do M%
    \do N\do O\do P\do Q\do R\do S\do T\do U\do V\do W\do X\do Y\do Z%
    \do a\do b\do c\do d\do e\do f\do g\do h\do i\do j\do k\do l\do m%
    \do n\do o\do p\do q\do r\do s\do t\do u\do v\do w\do x\do y\do z%
    \do 0\do 1\do 2\do 3\do 4\do 5\do 6\do 7\do 8\do 9%
  }%
}


%%% command \urlstyle{restrictedbreak}
%   default LaTeX urls, no breaks all urls
\def\url@restrictedbreakstyle{%
  \def\UrlBreaks{\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;\do\>\do\]%
    \do\)\do\,\do\?\do\'\do+\do\=\do\#}%
}

%%%
%	Hide from ToC
%%% 

%%%	Command \stoplistentries
%	  Stops any entries from being added to the ToC and other lists
%%% Command \startlistentries
%	  Re-enables any entries being added to the ToC and other lists
\newcommand{\stoplistentries}{\storeoldrelax{\addcontentsline}\def\addcontentsline##1##2##3{}
}
\newcommand{\startlistentries}{\restoreold{\addcontentsline}}

%%%	Command \tocless
%	  Disables adding of the sectioning to the toc, creates label
%	  Example: \tocless\chapter{Title}
\newcommand{\tocless}[2]{\bgroup\stoplistentries #1{#2}
\labelselector{#1}{#2}\egroup}

%%% TODO needs comments
\newcommand{\labelless}[2]{\bgroup\storeoldrelax{\label}\def\label##1{}%
#1{#2}\egroup}
\newcommand{\stopautolabels}{\autolabelfalse}
\newcommand{\startautolabels}{\autolabeltrue}

%%% Justify command
  \newcommand{\justified}{%
    \rightskip\z@skip%
    \leftskip\z@skip}

%%%
%   Package commands
%%%

%%% command \getcondition{<if-name>}
%%  USE:    \if\getcondition{<name>}, where \if<name> is declared by \newif\if<name>
\newcommand*{\getcondition}[1]{%
  T\expandafter
  \ifx\csname if#1\endcsname\iftrue
    \expandafter T%
  \else
    \expandafter F%
  \fi
}

%%% command \newvariable{<variable>}{<value>}
%%  defines commands for getting and setting a variable
%%    SET : \<variable>{<value>}
%%    GET : \the<variable>
\newcommand{\newvariable}[2]{%
	\@namedef{#1}##1{\@namedef{the#1}{##1}}
	\@nameuse{#1}{#2}
}

%%% environment onecolarea
%%  a temporary one column area
\newenvironment{onecolarea}{%
	\if@twocolumn
	  \@restonecoltrue\onecolumn
	\else
	  \@restonecolfalse
	\fi
}{%
	\if@restonecol\twocolumn\fi
}

%%% command \writeto{<filename>}{<content>}
%%  writes the content to a file
\newwrite\@out
\newcommand{\@writeto}[2]{%
  \immediate\openout\@out=#1%
  \immediate\write\@out{#2}%
  \immediate\closeout\@out%
}

%%% command \writeto{<filename>}{<content>}
%%  writes the content to a file
\newread\@in
\newcommand{\@readfrom}[2]{%
  \immediate\openin\@in=#1%
	\read\@in to #2%
  #2
	\immediate\closein\@in%
}

%%% command \setfontsize{<fontsize>}}{<linespacing>}
%%  correctly sets the font size and spacing
\newcommand{\setfontsize}[2]{%
  \fontsize{#1}{#2}\selectfont%
  \setlength{\baselineskip}{#2}%
  \setlength{\parskip}{#2}%
}

%%% command \providelength{\<name>}
%%  define a new length if not already defined
%%  error if the command passed as argument hasn't been defined with \newlength
\newcommand{\providelength}[1]{%
  \@ifundefined{\expandafter\@gobble\string#1}
   {% if #1 is undefined, do \newlength
    \typeout{\string\providelength: making new length \string#1}%
    \newlength{#1}%
   }
   {% else check whether #1 is actually a length
    \lengthcheck@checkforlength{#1}%
   }%
}

    \newcommand{\lengthcheck@checkforlength}[1]{%
      % get the first five characters from \meaning#1
      \edef\lengthcheck@temp{\expandafter\lengthcheck@getfive\meaning#1TTTTT$}%
      % compare with the string "\skip"
      \ifx\lengthcheck@temp\lengthcheck@skipstring
        \typeout{\string\providelength: \string#1 already a length}%
      \else
        \@latex@error
          {\string#1 illegal in \string\providelength}
          {\string#1 is defined, but not with \string\newlength}%
      \fi
    }
    \def\lengthcheck@getfive#1#2#3#4#5#6${#1#2#3#4#5}
    \edef\lengthcheck@skipstring{\string\skip}

%%%	command \setnewlength{\<name>}{<value>}
%%	defines new length and sets it
\def\setnewlength #1#2 {
  \providelength{#1}
  \setlength{#1}{#2\relax}
}

%%% command \cs@to@str{\<command>}
%%  makes a string from a cs
%%  example: \cs@to@str\foo % => "foo"
%%  example: \expandafter\cs@to@str\csname\space foo\endcsname % => " foo"

\catcode`\@=11 %
\def\cs@to@str{%
  \romannumeral\if\string\ \cs@to@str@aux@i\fi
    \expandafter\cs@to@str@aux@ii\string
}
    \long\def\cs@to@str@aux@i#1\cs@to@str@aux@ii{%
      -\number\fi\expandafter\z@
    }
    \long\def\cs@to@str@aux@ii#1{\z@}

    
    

%%% \textlcsc{<string>}
%% Make all LowerCase Small Caps
\newcommand\textlcsc[1]{\textsc{\MakeLowercase{#1}}}

\newif\iflc

%%% \forcetextlcsc{<string>}
%% Make all LowerCase Small Caps, used if the font doesn't support it
\def\forcetextlcsc{\lctrue\bgroup\obeyspaces\forcetextscaux}

%%% \forcetextsc{<string>}
%% Make all LowerCase Small Caps
\def\forcetextsc{\lcfalse\bgroup\obeyspaces\forcetextscaux}

    \def\forcetextscaux#1{\expandafter\forcetextscauxii #1\relax\relax\egroup}
    \def\forcetextscauxii#1{%
    \ifx\relax#1\else \ifcat#1\@sptoken{} \expandafter\expandafter\expandafter\forcetextscauxii\else
    \forcemakesc#1\expandafter\expandafter\expandafter\forcetextscauxii\expandafter\fi\fi}

    \def\forcemakesc#1{%
      \iflc
        {\scalefont{.85}{\uppercase{#1}}}%
      \else
        \ifnum`#1=\uccode`#1 {#1}\else {\scalefont{.85}{\uppercase{#1}}}\fi%
      \fi
    }


%%% \scalefont{<scalefactor>}{<string>}
%% Scale fontsize in string by scalefactor, keep baselineskip
\newlength{\currentfontsize}
\def\scalefont#1{%
    \setlength{\currentfontsize}{\f@size pt}%
    \setfontsize{#1\currentfontsize}{\baselineskip}%
}

%%% command \ifcounter{<counter>}{<on true>}{<on false>}
%%  check if a counter exists
\newcommand*\ifcounter[1]{%
  \ifcsname c@#1\endcsname%
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi%
}

%%% command \ifnumber{<counter>}{<on true>}{<on false>}
%%  check if input is a number
\def\ifnumber#1{%
  \afterassignment\get@args\count@=0#1\hfuzz#1\hfuzz}
\def\get@args#1\hfuzz#2\hfuzz{%
  \if\relax\detokenize{#1}\relax
    \expandafter\@firstoftwo
  \else
    \expandafter\@secondoftwo
  \fi
}

\let\oldauthor\author
\let\author\relax
%%% \author\<name>{<value 1}...{<value n-1}{<value n}
%%  saves data in \data:<name>:<range>
\newcommand{\author}{% Use a declaration
  \edef\tempname{\string\author}
  \edef\tmp@sum{\string\author@sum}
  \initadddata
}

%%% TODO add comments
\newcommand{\authordelim}[2]{
\preprintdata\author{#1}{#2}
}


%%% \adddata\<name>{<value 1}...{<value n-1}{<value n}
%%  saves data in \data:<name>:<range>
\newcommand{\adddata}[1]{% Use a declaration
  \edef\tempname{\string#1}
  \edef\tmp@sum{\string#1@sum}
  \initadddata
}

\newcommand{\initadddata}{
  \@ifundefined{c@\expandafter\cs@to@str\tmp@sum}{%
    \expandafter\newcount\csname c@\expandafter\cs@to@str\tmp@sum\endcsname % define counter c@<name>@sum if it doesn't exist yet
    \advance\csname c@\expandafter\cs@to@str\tmp@sum\endcsname -1\relax
  }{}
  \csname decl@\endcsname\checknextarg
}

    \newcommand{\checknextarg}{
      \@ifnextchar\bgroup{
        \gobblenext % Check if another "argument" exists
      }{
        \@ifnextchar[{
          \gobblenext@key
        }{}
      }
    }

    \newcommand{\gobblenext}[1]{%
      \advance\csname c@\expandafter\cs@to@str\tmp@sum\endcsname 1\relax
      \let\tempname@sum\tempname
      %\protected@edef\tempvalue{#1}
     % \expandafter\let\csname data:\tempname:\the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname  \endcsname\tempvalue% Add value to numbered variable
      \expandafter\protected@edef\csname data:\tempname:\the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname  \expandafter\endcsname{\detokenize{#1}}
     %% \ClassWarning{TUestyle}{\the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname: #1}{}
      \checknextarg% Gobble next "argument"
    }
    
    \newcounter{currentnum}
    
    \def\gobblenext@key[#1]{
      \let\tempname@sum\tempname
      \ifnum \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname = -1
        \ClassError{TUeStyle}{Key comes after value}{}
      \else
        \ifnumber{#1}{
          \ClassError{TUeStyle}{Numbers not accepted as key}{}
        }{
          \ifcsname data:\tempname:#1\expandafter\endcsname
            \ClassWarning{TUestyle}{A value key is overwritten}{}
          \else
            \setcounter{currentnum}{\the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname}
            \expandafter\edef\csname data:\tempname:#1\endcsname{\noexpand\csname data:\tempname:\thecurrentnum\endcsname}
          % Add value to keyed variable
          \fi
        }
      \fi
      \checknextarg
    }


%%% \getdata[<index>]\<name>
%%  prints data contained in \data:<name>:<index>
\def\getdata[#1]#2{
  \ifcsname data:\string#2:#1\endcsname
    \csname data:\string#2:#1\endcsname
  \else
    \ClassError{Tuestyle}{data:\string#2:#1 undefined}{}
  \fi
}

%%% \cleardata[<index>]\<name>
%%  clears data contained in \data:<name>:<index>
\def\cleardata[#1]#2{
  \ifcsname data:\string#2:#1\endcsname
    \expandafter\def\csname data:\string#2:#1\endcsname{
      \ClassError{Tuestyle}{data:\string#2:#1 undefined}{}
    }
  \else
    \ClassError{Tuestyle}{data:\string#2:#1 undefined}{}
  \fi
}



%%% \printdata{\<name>}{<global delimiter optional>}{<last delimiter optional>}
%%  prints data contained in \data:<name>:<range>
\newif\ifdataprint
\newcommand{\printdata}[1]{%
  \dataprinttrue
  \def\tempname{\string#1}%
  \def\delimi{, }%
  \def\delimii{ \& }%
  \@ifnextchar\bgroup{\firstdelim}{\initiateprint{\tempname}}% If delimiter: set it, else, print
}

%%% \preprintdata{\<name>}{<global delimiter optional>}{<last delimiter optional>}
%%  prints data contained in \data:<name>:<range> to \all:<name>
\newcommand{\preprintdata}[1]{%
  \def\tempname{\string#1}%
  \dataprintfalse
  \def\delimi{, }%
  \def\delimii{ \& }%
  \@ifnextchar\bgroup{\firstdelim}{\initiateprint{\tempname}}% If delimiter: set it, else, print
}

    \def\seconddelim #1 {%
      \def\delimii{#1}%
      \initiateprint{\tempname}% Print
    }

    \def\firstdelim #1{%
      \def\delimi{#1}%
      \def\delimii{#1}%
      \@ifnextchar\bgroup{\seconddelim}{\initiateprint{\tempname}}% If second delimiter: set it, else, print
    }
    
    \newcounter{tempcount}%
    \newcommand{\initiateprint}[1]{%
      \edef\tmp@sum{#1@sum}%
      \edef\tmp{#1}%
      \setcounter{tempcount}{0}%
      \expandafter\def\csname all:\expandafter\cs@to@str\tmp\endcsname{} % define counter all:<name> if it doesn't exist yet, otherwise clear
      \printdatainternal#1%
    }

    \newcommand{\printdatainternal}[1]{%
      \ifnum \thetempcount < \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname \relax%
        \ifnum \thetempcount > 0% Use first delimiter in front of values, after the first value
          \printandwritedata[\delimi]\relax% Print current value
        \else%
          \printandwritedata\relax% Print first value
        \fi%
        \addtocounter{tempcount}{1}%
        \printdatainternal#1% Loop
      \else%
        \ifnum \thetempcount = \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname \relax% % Use second delimiter in front of the last value
          \printandwritedata[\delimii]% Print last value
        \fi
      \fi
    }
    
    \newcommand{\printandwritedata}[1][]{%
      \ifdataprint%
        #1\csname data:\tmp:\thetempcount\endcsname%
      \fi
      \expandafter\edef\csname all:\expandafter\cs@to@str\tmp\expandafter\endcsname{%
        \csname all:\expandafter\cs@to@str\tmp\expandafter\endcsname%
        #1\csname data:\tmp:\thetempcount\endcsname%
      }%
    }
    
%%% \printstring{\<name>}
%%  prints data contained in \all:<name> as a string, needed when commands can't be expanded
\newcommand{\printstring}[1]{%
  \def\tempdata{\csname all:\cs@to@str#1\endcsname}%%%%%% TODO implement better
  \edef\tempdata{\noexpand\scantokens{\tempdata}}%
  \tempdata%
}

%%%% TODO add descrp
\newcommand{\safeprintstring}[1]{%
  \csname all:\cs@to@str#1\endcsname
}

%%% TODO description
\newcommand{\ifprintstring}[1]{%
  \ifcsname all:\cs@to@str#1\endcsname
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi%
}


\ifwatermark
  %%% \watermark
  %%  Creates tiny watermark inside the following character, intended use: \watermark.
  \newcommand\watermark[1]{%
      #1%
      \sbox0{#1}%
      \llap{%
      \makebox[\wd0][c]{%  hor. centering
      \raisebox{.5\ht0}{%  approx. vert. centering
      \csname Gin@isotrue\endcsname% = "keepaspectratio"
      \resizebox*{.8\ht0}{.8\ht0}{% Scale down (the height is also used for the width to avoid the surrounding spaces)
      \parbox{10em}{% Allow line breaks
      \hbadness=100000 %
              \pgfsetfillopacity{0.1}\color{black}%
              %%%% TODO authorlist and actual copyholder
              This PDF % 
              \ifx\theversionnum\empty
              \else%
               (\theversionnum)\space%
              \fi%
              was created by \@author\ %
              \ifx\thecopyholder\empty\relax
              \else
                for \thecopyholder
              \fi.
          }%
      }}}}%
  }
\else
  \newcommand\watermark[1]{#1}
\fi

%%% \storeoldenv{\<name>}
%%  Stores the environment \begin{<name>}\end{<name>} to \begin{old<name>}\end{old<name>}
\newcommand{\storeoldenv}[1]{
  \expandafter\let\csname old\expandafter\cs@to@str\string#1\endcsname#1
  \expandafter\let\csname endold\expandafter\cs@to@str\string#1\expandafter\endcsname
    \csname end\expandafter\cs@to@str\string#1\endcsname
}

%%% \storeoldrelaxenv{\<name>}
%%  Stores the environment \begin{<name>}\end{<name>} to \begin{old<name>}\end{old<name>} and relaxes \begin{<name>}\end{<name>}
\newcommand{\storeoldrelaxenv}[1]{
    \storeoldenv{#1}
    \let#1\relax
    \expandafter\let\csname end\expandafter\cs@to@str\string#1\endcsname\relax
}

%%% \storeold{\<name>}
%%  Stores \<name> to \old<name>
\newcommand{\storeold}[1]{
  \expandafter\let\csname old\expandafter\cs@to@str\string#1\endcsname#1
}

%%% \restoreold{\<name>}
%%  Restores \old<name> to \<name>
\newcommand{\restoreold}[1]{
  \expandafter\let\expandafter#1\csname old\expandafter\cs@to@str\string#1\endcsname
}

%%% \storeoldrelax{\<name>}
%%  Stores \<name> to \old<name>, and relaxes \<name>
\newcommand{\storeoldrelax}[1]{
  \storeold{#1}
  \let#1\relax
}

%%% command \disablepageskip
%%	Store and disable clearpage, cleardoublepage & newpage commands
\newcommand{\disablepageskip}{
  \storeoldrelax{\clearpage}
	\storeoldrelax{\cleardoublepage}
	\storeoldrelax{\newpage}
}

%%% command \enablepageskip
%%  Re-enable clearpage, cleardoublepage & newpage commands
\newcommand{\enablepageskip}{
	\let\clearpage\oldclearpage
	\let\cleardoublepage\oldcleardoublepage
	\let\newpage\oldnewpage
}


%%% \labelselector{\<name of sectioning>}{<content>}
%%  Creates label for sectioning
\newcommand{\labelselector}[2]{%
  \@ifequal{#1}{\part}{%
    \label{part:#2}
  }{\@ifequal{#1}{\chapter}{%
		\label{ch:#2}%
  }{\@ifequal{#1}{\section}{%
		\label{sec:#2}
  }{\@ifequal{#1}{\subsection}{%
		\label{subsec:#2}%
  }{\@ifequal{#1}{\subsubsection}{%
		\label{sssec:#2}%
  }{\@ifequal{#1}{\paragraph}{%
		\label{par:#2}%
  }{\@ifequal{#1}{\subparagraph}{%
		\label{subpar:#2}%
  }{\@ifequal{#1}{\figure}{% Should be used
		\label{fig:#2}%
  }{\@ifequal{#1}{\table}{% Should be used
		\label{tab:#2}%
  }{\@ifequal{#1}{\lstlisting}{% Should be used
		\label{lst:#2}%
  }{\@ifequal{#1}{\equation}{% Should be used
		\label{eq:#2}%
  }{\@ifequal{#1}{\item}{% Not used, because adding 1 item to the list would shift manual references
		\label{itm:#2}%
  }{\@ifequal{#1}{\appendix}{% Not used
		\label{app:#2}%
  }{\@ifequal{#1}{\algorithm}{% Not used
		\label{alg:#2}%
  }}}}}}}}}}}}}}
}


%%% TODO Can be removed
\newcommand{\counterselector}[1]{%
  \@ifequal{#1}{\part}{%
	\thepart
  }{\@ifequal{#1}{\chapter}{%
	\thechapter
  }{\@ifequal{#1}{\section}{%
	\thesection
  }{\@ifequal{#1}{\subsection}{%
	\thesubsection
  }{\@ifequal{#1}{\subsubsection}{%
	\thesubsubsection
  }}}}}
}

%%% \levelselector{\<name of sectioning>}
%%  Returns sectioning level

%%  Levels:
%   Part         -1
%   Chapter       0
%   Section       1
%   Subsection    2
%   Subsubsection 3
%   Paragraph     4
%   Subparagraph  5

\newcommand{\levelselector}[1]{%%%% TODO use in createsectioning
  \@ifequal{#1}{\part}{%
   -1
  }{\@ifequal{#1}{\chapter}{%
		0
  }{\@ifequal{#1}{\section}{%
		1
  }{\@ifequal{#1}{\subsection}{%
		2
  }{\@ifequal{#1}{\subsubsection}{%
		3
  }{\@ifequal{#1}{\paragraph}{%
		4
  }{\@ifequal{#1}{\subparagraph}{%
		5
  }}}}}}}
}


%%% \DivideLengths{\<name>}{\<name>}
%%  Divides two given lengths
\newcommand*{\DivideLengths}[2]{%
  \strip@pt\dimexpr\number\numexpr\number\dimexpr#1\relax*65536/\number\dimexpr#2\relax\relax sp\relax
}

%%% command \slantedpar{<integer #lines>}{<paragraph width>}
%%  initiates parshape settings
\newcommand{\slantedpar}[3][left]{
  \setnewlength{\interval}{\@shiftratio\baselineskip}
  % Definition to hold the result calculations as strings
  \long\edef\temphold{}
  \setcounter{templine}{0}
  \slantedparvalues{#1}{#2}{#2}{#3}
  \parshape=#2
  \temphold 
}

    %%  Command to calculate current line width
    \newcommand{\axislinewidthleft}[3]{%
      0cm \dimexpr #3-#2\interval+#1\interval \relax%
    }
    
    \newcommand{\axislinewidthright}[3]{%
      \dimexpr-#2\interval+#1\interval\relax \dimexpr #3+#2\interval-#1\interval \relax%
    }

    \newcounter{templine}

    %%  loop command, also expanding \temphold with string result
    \newcommand{\slantedparvalues}[4]{
    \@ifequal{#1}{left}{
      \long\edef\temphold{%
        \temphold%
        \axislinewidthleft{#2}{#3}{#4}%
      }
    }{
      \long\edef\temphold{%
        \temphold%
        \axislinewidthright{#2}{#3}{#4}%
      }
    }
      \setcounter{templine}{#2}
      \addtocounter{templine}{-1}
      \ifnum #2 > 0 %loop if we are not out of lines
        \slantedparvalues{#1}{\thetempline}{#3}{#4}
      \else\fi
    }

    
%%% command \axispositionX{<y-position from bottom>}
%%  initiates parshape settings
\newlength{\axispositionY}
\newlength{\axispositionX}
\newcommand{\axisposition}[1]{%
  \setlength{\axispositionY}{\dimexpr #1 \relax}%
  \global\axispositionY=\axispositionY
  \setlength{\axispositionX}{\dimexpr \@Hspacing-\@Hshift + \@shiftratio\axispositionY -\@axiswidth \relax}%
  \global\axispositionX=\axispositionX
}

\newcounter{numberofsentences}
%%% command \getlongestsentence{<string>}
%%  Splits sentences on \break and outputs longest sentence to \longestsentence
\def\getlongestsentence#1{%
	\setnewlength{\longestsentence}{0pt}
    \setcounter{numberofsentences}{0}
	\def\holder{}
    \begingroup
    \edef\@tempa{\detokenize\expandafter{#1}\space}%
    \expandafter\endgroup
    \expandafter\readstring\@tempa\relax
}

    \long\def\readstring#1 #2\relax{%
          \partitionstringonbreaks{#1}%  #1 = substr, #2 = rest of string
          \begingroup%
          \ifx\relax#2\relax  % is #2 empty?
            \def\next{\endgroup\addtocounter{numberofsentences}{1}\endstringpartition}% end-macro
          \else%
             \def\next{\endgroup\readstring#2\relax}%
          \fi%
          \next%
    }
    
    \def\instring#1#2{TT\fi\begingroup
    \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}
    
    \def\sentencedelimi{\titlebreak}
    \def\sentencedelimii{\linebreak}
    
    \long\def\partitionstringonbreaks#1{%
      \expandafter\edef\expandafter\tempa{\detokenize{#1}}%
      \expandafter\edef\expandafter\tempb{\expandafter\string\sentencedelimi}%
      \expandafter\edef\expandafter\tempc{\expandafter\string\sentencedelimii}%
          \if\instring{\tempb}{\tempa}
            \g@addto@macro\holder{\scantokens{#1}}%
            \addtocounter{numberofsentences}{1}
            \endstringpartition%
          \else
              \if\instring{\tempc}{\tempa}
                \g@addto@macro\holder{\scantokens{#1}}%
                \addtocounter{numberofsentences}{1}
                \endstringpartition%
              \else
                \g@addto@macro\holder{\scantokens{#1}}%
              \fi
          \fi
    }

    \def\endstringpartition{%
      \settowidth{\@tempdima}{\holder}%
      \ifnum \@tempdima > \longestsentence%
      \setlength{\longestsentence}{\@tempdima}%
      \else\fi%
      \def\holder{}%
      
    }
    
%%  Command: get longest sentence if it is smaller than the maximum linewidth (#1)
\newcommand{\getlongestsentenceif}[2][0pt]{
\getlongestsentence{#2}
\ifdim \longestsentence > #1
	\setlength{\longestsentence}{#1}
\fi
}

%%% TODO add comments
\newcommand{\@setClassFontSize}[3]{
    \expandafter\def\csname selectedfont@#1\endcsname{#2bp}
    \expandafter\def\csname selectedbls@#1\endcsname{#3bp}
}

%%% TODO add comments
\ifnum \classFontSize = 9 
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSize{#1}{#2}{#3}
  }
\else \ifnum \classFontSize = 10
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSize{#1}{#4}{#5}
  }
\else \ifnum \classFontSize = 11
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSize{#1}{#6}{#7}
  }
\else \ifnum \classFontSize = 12
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSize{#1}{#8}{#9}
  }
\fi\fi\fi\fi



%%% TODO add comments
\newcommand{\copyclassFontSize}[2]{
  \expandafter\def\csname selectedfont@#1\endcsname{\csname selectedfont@#2\endcsname}
  \expandafter\def\csname selectedbls@#1\endcsname{\csname selectedbls@#2\endcsname}
}

%%% TODO add comments
\newcommand{\useclassFontSize}[1]{%
 \setfontsize{%
  \csname selectedfont@#1\endcsname%
 }{%
  \csname selectedbls@#1\endcsname%
 }%
}


%%%
%   Internal debug commands
%%%

\newcommand{\stripmacro}[1]{\expandafter\begingroup\escapechar=-1\edef\x{\endgroup\string#1}\x}

%%% Define showlength command
\def\convertto#1#2{\strip@pt\dimexpr #2*65536/\number\dimexpr 1#1}
\newcommand{\showlength}[2]{\textbf{\stripmacro{#2}}:\space\convertto{#1}{#2}\space#1}

%%%	command \printmacro{\<name>}
%%	prints macro definition to \<name>.txt
\def\printmacro #1{%
    \newwrite\printmacroname
    \begingroup\escapechar=-1
    % better as .txt file
    \immediate\openout\printmacroname=\jobname-meaning-\string#1.txt
    \endgroup
    \immediate\write\printmacroname{\meaning#1}%
    \immediate\closeout\printmacroname
}



	
%%%
%   Document settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   Document
%%%

% load underlying class
\ifbook
  \LoadClass{book}
\else
  \LoadClass{report}
\fi

% depending packages
\iftuefonts\relax\else
  \RequirePackage{arial}
\fi
\RequirePackage{hyperref}
\RequirePackage[a4paper]{geometry}
\RequirePackage{fancyhdr}


%%%
%	Set last page label
%%%

%% Has to be the above any writeout AtEndDocument as the "labels have changed warning" will be triggered otherwise.

\AtEndDocument{
	\label{lastdocpage}
}



%%% TODO move
\newcommand{\ifexists}[1]{
  \ifcsname #1\endcsname
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi%
}


\ifruninsec
  \def\gridleftcolumns{2}
  \def\@seccntformat#1{\llap{\protect\makebox[2\tabsize][l]{\csname the#1\endcsname}}}
\fi



%%%
%   Grid
%%%
\AtBeginDocument{
  \begingroup
    \def\sentencedelimi{ }
    \newcounter{footerlines}
    \expandafter\getlongestsentence{\@title}
    \addtocounter{footerlines}{\thenumberofsentences}
    \ifsectioningf
      \addtocounter{footerlines}{1}
    \fi
    \ifx\theextraf\empty\relax\else
      \getlongestsentence{\theextraf}
      \addtocounter{footerlines}{\thenumberofsentences}
    \fi
  \endgroup  
  \ifexists{footskipvalue}{}{
    \setnewlength{\footskipvalue}{\dimexpr \thefooterlines\baselineskip + \headfootsep}
  }
  \ifexists{layoutbottommargin}{}{
    \setnewlength{\layoutbottommargin}{\dimexpr 15.75mm+\footskipvalue\relax} % 15.75mm
  }
}

\setnewlength{\headfootsep}{3\baselineskip}

\ifexists{headsepvalue}{}{
  \setnewlength{\headsepvalue}{\headfootsep}
}

\ifexists{layoutleftmargin}{}{
  \setnewlength{\layoutleftmargin}{15mm}
}
\ifexists{layoutrightmargin}{}{
  \setnewlength{\layoutrightmargin}{15mm}
}
\ifexists{layouttopmargin}{}{
  \setnewlength{\layouttopmargin}{\dimexpr 20.25mm+\headheight+\headsepvalue\relax} % 20.25mm
}
\ifexists{marginparL}{}{
  \setnewlength{\marginparL}{\columnsep}
}
\ifexists{marginparR}{}{
  \setnewlength{\marginparR}{\layoutrightmargin}
}
\ifexists{gridcolumns}{}{
  \def\gridcolumns{12}
}
\ifexists{gridleftcolumns}{}{
  \def\gridleftcolumns{1}
}
\ifexists{gridrightcolumns}{}{
  \def\gridrightcolumns{2}
}



\def\gridbodycolumns{\numexpr\gridcolumns-\gridleftcolumns-\gridrightcolumns\relax}

\setnewlength{\gridgutterwidth}{3.853mm}
\setlength{\columnsep}{\gridgutterwidth}

\setnewlength{\gridcolumnwidth}{\dimexpr (\paperwidth - \layoutleftmargin - \layoutrightmargin + \gridgutterwidth) / \gridcolumns \relax}
\addtolength{\gridcolumnwidth}{-\gridgutterwidth}

\setnewlength{\frameleft}{\dimexpr \layoutleftmargin + \gridleftcolumns\gridcolumnwidth +\gridleftcolumns\gridgutterwidth \relax}
\setnewlength{\frameright}{\dimexpr \layoutrightmargin + \gridrightcolumns\gridcolumnwidth + \gridrightcolumns\gridgutterwidth \relax}

\setnewlength{\headeroffset}{5.25mm}
\setnewlength{\footeroffset}{6.75mm}
\setnewlength{\gridheight}{12.75bp}

%%% command \drawgrid
%%  draws document grid
\newcommand{\drawgrid}{%
  % TODO implement drawing grid
}

%%% Tab size
\newlength{\tabsize}
\setlength{\tabsize}{\dimexpr \gridcolumnwidth + \gridgutterwidth}



\ifruninsec
  \setnewlength{\chaptershift}{2\tabsize}
\else
  \setnewlength{\chaptershift}{0pt}
\fi


%%%
%   Layout
%%%
\newcommand{\resetHeadWidth}{\fancy@setoffs} %\resetHeadWidth which calls the fancyhdr macro for defining the header and footer widths.



%%%
% Set original margins
%%%
\newcommand{\resetlayout}{
  \setnewlength{\marginparsepvalue}{\marginparL}
  \setnewlength{\marginparwidthvalue}{\dimexpr \frameright - \marginparL - \marginparR \relax}
  \setnewlength{\rightmargincalculated}{\dimexpr \layoutrightmargin + \marginparL + \marginparwidth \relax}
  \disablepageskip  
	%	If the document uses the "twoside" option
	\iftwosided
		\newgeometry{footskip=\footskipvalue,marginparsep=\marginparsepvalue,marginparwidth=\marginparwidthvalue,headsep=\headsepvalue,bindingoffset=0cm,top=\layouttopmargin,left=\frameleft,right=\frameright,bottom=\layoutbottommargin,headheight=16pt,twoside=true}
	%	If the document uses the "oneside" option
	\else
		\newgeometry{footskip=\footskipvalue,marginparsep=\marginparsepvalue,marginparwidth=\marginparwidthvalue,headsep=\headsepvalue,bindingoffset=0cm,top=\layouttopmargin,left=\frameleft,right=\frameright,bottom=\layoutbottommargin,headheight=16pt,twoside=false}
	\fi
  \resetHeadWidth
  \sethf
  \enablepageskip
}

\AtBeginDocument{
\ifprintstring{\author}{% If custom delimiters defined by user (using \preprintdata\author)
  \def\@author{\printstring\author}
}{% Else
  \preprintdata\author{,\hfill\break}{ \&\hfill\break}
  \def\@author{\printstring\author}
}

\begingroup %begingroup not to overwrite earlier \preprintdata\author
  \preprintdata\author{, }{ \& }
  \def\pdf@author{\safeprintstring\author}
  \def\titlebreak{ }
  \def\linebreak{ }
  \hypersetup{pdftitle = {\@title},pdfauthor = {\pdf@author},pdfsubject={\thesubtitle},pdfkeywords={Version \theversionnum} {Eindhoven University of Technology},pdfcreator={aLeX TU/e template}}
\endgroup



\resetlayout
}



%%%
%   Draft
%%%





%%%
%   Localization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   Language
%%%

\ifenglish
  \selectlanguage{english}
\else
  \selectlanguage{dutch}
\fi


%%%
%   TU/e
%%%

\newvariable{tuesite}{www.tue.nl}
\newvariable{phonenumber}{+31 (0)40 247 9111}
\newvariable{phonenumberlabel}{Tel.}
\newvariable{fullname}{Technische Universiteit \textbf{Eindhoven} University of Technology}

\ifenglish
  \newvariable{shortname}{Eindhoven University of Technology}
\else
  \newvariable{shortname}{Technische Universiteit Eindhoven}
\fi

%%%
%   Labels
%%%

%%% General labels
\ifenglish
	\newvariable{copyholderlabel}{Copyholder}
	\newvariable{authorlabel}{Author}
	\newvariable{orderissuerlabel}{Order issuer}
	\newvariable{referencelabel}{Reference}
	\newvariable{datelabel}{Date}
	\newvariable{versionlabel}{Version}
	\newvariable{Netherlands}{The Netherlands\\} %Todo remove break here
	\newvariable{PObox}{P.O. Box}
  \newvariable{visitingaddresslabel}{Visiting adress}
  \newvariable{postaladdresslabel}{Postal adress}
  \newvariable{titlelabel}{Title}
  \newvariable{subtitlelabel}{Subtitle}
\else
	\newvariable{copyholderlabel}{Kopiehouder}
	\newvariable{authorlabel}{Auteur}
	\newvariable{orderissuerlabel}{Opdrachtgever}
	\newvariable{referencelabel}{Referentie}
	\newvariable{datelabel}{Datum}
	\newvariable{versionlabel}{Versie}
	\newvariable{Netherlands}{}
	\newvariable{PObox}{Postbus}
  \newvariable{visitingaddresslabel}{Bezoekadres}
  \newvariable{postaladdresslabel}{Postadres}
  \newvariable{titlelabel}{Titel}
  \newvariable{subtitlelabel}{Ondertitel}
\fi


%%% Note labels
\ifenglish
	\newvariable{notesname}{Note}
	\newvariable{listofnotesname}{List of Notes}
\else
	\newvariable{notesname}{Notitie}
	\newvariable{listofnotesname}{Lijst van Notities}
\fi

%%% Figures and tables labels
\ifenglish
	\newvariable{listoffiguresname}{List of Figures}
	\newvariable{listoftablesname}{List of Tables}
\else
	\newvariable{listoffiguresname}{Lijst van Illustraties}
	\newvariable{listoftablesname}{Lijst van Tabellen}
\fi

%%% Equation labels
\ifenglish
	\newvariable{equationsname}{Equation}
	\newvariable{listofequationsname}{List of Equations}
\else
	\newvariable{equationsname}{Vergelijking}
	\newvariable{listofequationsname}{Lijst van Vergelijkingen}
\fi


%%%
%   Drafting options
%%%

\ifmargins
  \Gm@showframetrue
\fi



%%%
%   Header/footer options
%%%

%%% command \extraf{<string>} & \extrah{<string>}
%%  Adds custom footer and header  data
\newvariable{extraf}{}
\newvariable{extrah}{}


\def\captionwidth{.8}

%%% Redefine caption to enable alignment options
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\makebox{\style{caption}#1: #2}}%
  \ifdim \wd\@tempboxa >\captionwidth\hsize
    \autocentercap\parbox{\captionwidth\linewidth}{\style{caption}\autocentercap#1: #2}\par
  \else
    \global\@minipagefalse%
	\autocentercap\makebox[\captionwidth\linewidth][\autocentershort]{\style{caption}#1: #2}
  \fi
  \vskip\belowcaptionskip}

%%%
%   Tabs
%%%

%%% command \tab[<integer>]
%%  goes to specified tab
\newcommand{\tab}[1][1]{%
	\noindent\leavevmode\\*[-\baselineskip]\hspace*{#1\tabsize}%
}


%%%
% Clean up the tables, figures, defintions and sources lists
%%%

%%%	Remove dots between text and pagenumbers
\renewcommand{\@dotsep}{10000}

%%%	Declare the \listoftables command for the list of tables
\storeold{\listoftables}
\renewcommand{\listoftables}[1][\thelistoftablesname]{
	\renewcommand{\listtablename}{#1}
	\renewcommand*\l@table{\@dottedtocline{1}{0em}{\listindent}}% Default: 1.5em/2.3em
  \begingroup
    \oldlistoftables
	\endgroup
}

%%%	Declare the \listoffigures command for the list of figures
\storeold{\listoffigures}
\renewcommand{\listoffigures}[1][\thelistoffiguresname]{
	\renewcommand{\listfigurename}{#1}
	\renewcommand*\l@figure{\@dottedtocline{1}{0em}{\listindent}}% Default: 1.5em/2.3em
  \begingroup
    \oldlistoffigures
	\endgroup
}





%%%
%   TU/e style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%   Fonts
%%%

% Arial
\renewcommand{\sfdefault}{ua1}
\renewcommand{\rmdefault}{ua1}
\renewcommand{\ttdefault}{pcr}
\renewcommand\familydefault{\sfdefault}

% Meta OT

\newcommand{\fontdefault}{%
  \normalfont\selectfont%
}

\newcommand{\fontnormal}{%
  \iftuefonts%
    \usefont{T1}{meta}{m}{n}%
  \else%
    \normalfont\fontseries{m}\selectfont%
  \fi
}

\sbox0{\sffamily X}
\DeclareFontShape{T1}{ua1}{sb}{n}{ <-> ua1r8t}{} %map semi bold to regular

\newcommand{\fontmedium}{%
  \iftuefonts%
    \usefont{T1}{zmb}{m}{n}%
  \else%
    \normalfont\fontseries{sb}\selectfont%
  \fi
}

\newcommand{\fontbold}{%
  \iftuefonts%
    \usefont{T1}{zmw}{m}{n}%
  \else%
    \normalfont\fontseries{b}\selectfont%
  \fi
}




%%%
%   Colors
%%%

%%% Main colors

% scarlet
\definecolor{PMSwarmred}{rgb}{0.969,0.192,0.192}
\colorlet{tuescarlet}{PMSwarmred}

% red
\definecolor{PMS206}{rgb}{0.839,0.000,0.290}
\colorlet{tuered}{PMS206}

% cyan
\definecolor{PMSprocesscyan}{rgb}{0.000,0.635,0.871}
\colorlet{tuecyan}{PMSprocesscyan}

% blue
\definecolor{PMS300}{rgb}{0.000,0.400,0.800}
\colorlet{tueblue}{PMS300}

% dark blue
\definecolor{PMS2748}{rgb}{0.063,0.063,0.451}
\colorlet{tuedarkblue}{PMS2748}

% pink
\definecolor{PMS226}{rgb}{0.839,0.000,0.482}
\colorlet{tuepink}{PMS226}

% purple
\definecolor{PMS253}{rgb}{0.678,0.125,0.678}
\colorlet{tuepurple}{PMS253}

%%% Support colors

% orange
\definecolor{PMS137}{rgb}{1.000,0.604,0.000}
\colorlet{tueorange}{PMS137}

% yellow
\definecolor{PMSyellow012}{rgb}{1.000,0.867,0.000}
\colorlet{tueyellow}{PMSyellow012}

% lime
\definecolor{PMS396}{rgb}{0.808,0.875,0.000}
\colorlet{tuelime}{PMS396}

% green
\definecolor{PMS375}{rgb}{0.518,0.824,0.000}
\colorlet{tuegreen}{PMS375}

% teal
\definecolor{PMSgreen}{rgb}{0.000,0.675,0.510}
\colorlet{tueteal}{PMSgreen}

% azure
\definecolor{PMS3135}{rgb}{0.000,0.573,0.710}
\colorlet{tueazure}{PMS3135}



%%%
%   Text colors
%%%

%%% body colors
\colorlet{colorbody}{black}
\colorlet{colorpromotional}{colorbody}
\colorlet{colorcaption}{colorbody}
\colorlet{colornote}{colorbody}

%%% heading colors
\colorlet{colorheading}{tuered}
\colorlet{colorsubheading}{colorheading}

%%% heading colors
\colorlet{coloraccent}{tuecyan}
\colorlet{colorintro}{coloraccent}
\colorlet{colorquote}{coloraccent}
\colorlet{colorinfo}{coloraccent}
\colorlet{colorlabel}{coloraccent}

%%% extra colors
\colorlet{colorextra}{tuedarkblue}
\colorlet{colorpayoff}{colorextra}
\colorlet{colorlink}{tuered!20!white}


%%%
%   Font size commands
%%%

%%                % Name              % 9pt         % 10pt        % 11pt        % 12pt
\setclassFontSize {tiny}              {5}{6.5}      {5}{6.5}      {6}{7.75}     {6}{7.75}
\setclassFontSize {scriptsize}        {6.75}{9}     {6.75}{9}     {7.75}{11.25} {7.75}{11.25}
\setclassFontSize {caption}           {7.75}{11.25} {8.5}{11.5}   {9.25}{12.75} {10}{12.75}
\copyclassFontSize{footnote}          {caption}
\copyclassFontSize{tableHead}         {caption}
\copyclassFontSize{tableText}         {caption}
\setclassFontSize {small}             {8.5}{11.5}   {9.25}{12.75} {10}{12.75}   {10.75}{14.35}
\setclassFontSize {body}              {9.25}{12.75} {10}{12.75}   {10.75}{14.35}{12}{15.75}
\copyclassFontSize{subHeadii}         {body}
\copyclassFontSize{accentText}        {body}
\copyclassFontSize{subInfo}           {body}
\setclassFontSize {subHeadi}          {10}{12.75}   {10.75}{14.35}{11.5}{15.75} {12.75}{16.5}
\setclassFontSize {payOffii}          {10}{12.75}   {10}{12.75}   {10}{12.75}   {10}{12.75}
\setclassFontSize {recruitingText}    {10.75}{14.35}{11}{14.35}   {11.75}{15.75}{13}{17.25}
\copyclassFontSize{introii}           {recruitingText}
\setclassFontSize {recruitingHead}    {11}{14.35}   {11.25}{14.5} {12}{15.75}   {13.25}{17.5}
\copyclassFontSize{quoteiv}           {recruitingHead}
\setclassFontSize {articleHeadviii}   {12.25}{16}   {12.25}{16}   {12.75}{16.5} {14}{18.5}
\copyclassFontSize{introi}            {articleHeadviii}
\copyclassFontSize{quoteiii}          {articleHeadviii}
\setclassFontSize {articleHeadviihalf}{14}{18.5}    {14}{18.5}    {14}{18.5}    {15}{20}
\setclassFontSize {quoteii}           {15}{20}      {15}{20}      {15}{20}      {16}{21.25}
\setclassFontSize {payOffi}           {15}{20}      {15}{20}      {15}{20}      {15}{20}
\setclassFontSize {articleHeadvii}    {16}{21.25}   {16}{21.25}   {16}{21.25}   {18}{24}
\setclassFontSize {quotei}            {18}{24}      {18}{24}      {18}{24}      {20}{26,75}
\setclassFontSize {articleHeadvi}     {20}{26,75}   {20}{26,75}   {20}{26,75}   {24}{32}
\setclassFontSize {articleHeadv}      {24}{32}      {24}{32}      {24}{32}      {30}{40}
\setclassFontSize {articleHeadiv}     {30}{40}      {30}{40}      {30}{40}      {30}{40}
\setclassFontSize {articleHeadii}     {36}{48}      {36}{48}      {36}{48}      {36}{48}
\setclassFontSize {articleHeadii}     {42}{54}      {42}{54}      {42}{54}      {42}{54}
\setclassFontSize {articleHeadi}      {48}{58}      {48}{58}      {48}{58}      {48}{58}

\renewcommand\tiny{\useclassFontSize{tiny}}
\renewcommand\scriptsize{\useclassFontSize{scriptsize}}
\renewcommand\large{\useclassFontSize{articleHeadviii}}
\renewcommand\Large{\useclassFontSize{articleHeadviihalf}}
\renewcommand\LARGE{\useclassFontSize{articleHeadvii}}
\renewcommand\huge{\useclassFontSize{articleHeadvi}}
\renewcommand\Huge{\useclassFontSize{articleHeadv}}





%%%
%   Text styles
%%%

% heading subparagraph
\def\styling@headingsubparagraph{%
  \useclassFontSize{subHeadii}%
	\fontmedium%
  \leavevmode\color{colorsubheading}\it%
}

% heading paragraph
\def\styling@headingparagraph{%
  \useclassFontSize{subHeadi}%
	\fontbold%
  \leavevmode\color{colorsubheading}%
}

% heading subsubsection
\def\styling@headingsubsubsection{%
  \useclassFontSize{articleHeadviii}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading subsection
\def\styling@headingsubsection{%
  \useclassFontSize{articleHeadvii}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading section
\def\styling@headingsection{%
  \useclassFontSize{articleHeadvi}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading chapter
\def\styling@headingchapter{%
  \useclassFontSize{articleHeadv}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading part
\def\styling@headingpart{%
  \useclassFontSize{articleHeadiv}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

%%%%%%%

% heading Large
\def\styling@headingLarge{%
  \useclassFontSize{articleHeadiii}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading LARGE
\def\styling@headingLARGE{%
  \useclassFontSize{articleHeadii}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading huge
\def\styling@headinghuge{%
  \useclassFontSize{articleHeadi}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% intro normal
\def\styling@intronormal{%
  \useclassFontSize{introii}%
	\fontmedium%
  \leavevmode\color{colorintro}%
}

% intro large
\def\styling@introlarge{%
  \useclassFontSize{introi}%
	\fontmedium%
  \leavevmode\color{colorintro}%
}

% body text
\def\styling@body{%
  \useclassFontSize{body}%
	\fontdefault%
  \leavevmode\color{colorbody}%
}

%%% TODO rename: promotional or recruiting

% promotional text
\def\styling@promotional{%
  \useclassFontSize{recruitingText}%
	\fontnormal%
  \leavevmode\color{colorpromotional}%
}

% promotional heading
\def\styling@promotionalheading{%
  \useclassFontSize{recruitingHead}%
	\fontbold%
  \leavevmode\color{colorsubheading}%
}

%%% TODO add qoute 3&4, also in switch

% quote large
\def\styling@quotesmall{%
  \useclassFontSize{quoteiv}%
	\fontmedium%
  \leavevmode\color{colorquote}%
}

% quote large
\def\styling@quotenormal{%
  \useclassFontSize{quoteiii}%
	\fontmedium%
  \leavevmode\color{colorquote}%
}

% quote large
\def\styling@quotelarge{%
  \useclassFontSize{quoteii}%
	\fontmedium%
  \leavevmode\color{colorquote}%
}

% quote Large
\def\styling@quoteLarge{%
  \useclassFontSize{quotei}%
	\fontmedium%
  \leavevmode\color{colorquote}%
}

% accent text
\def\styling@accent{%
  \useclassFontSize{accentText}%
	\fontmedium%
  \leavevmode\color{coloraccent}%
}

% info text
\def\styling@info{%
  \useclassFontSize{subInfo}%
	\fontnormal%
  \leavevmode\color{colorinfo}%
}

% caption
\def\styling@caption{%
  \useclassFontSize{caption}%
	\fontbold%
  \leavevmode\color{colorcaption}%
}

% note
\def\styling@note{%
  \useclassFontSize{footnote}%
	\fontnormal%
  \leavevmode\color{colornote}%
}

% payoff normal
\def\styling@payoffnormal{%
  \useclassFontSize{payOffii}%
	\fontmedium%
  \leavevmode\color{colorpayoff}%
}

% payoff large
\def\styling@payofflarge{%
  \useclassFontSize{payOffi}%
	\fontmedium%
  \leavevmode\color{colorpayoff}%
}

% tiny (self-defined)
\def\styling@tiny{%
  \useclassFontSize{tiny}%
	\fontmedium%
  \leavevmode\color{colorbody}%
}

%%% command \style[<size>]{<type>}
%%  sets the font style
\newcommand{\style}[2][1]{%
  \@ifequal{#2}{heading}{%
    \@ifequal{#1}{-4}{\styling@headinghuge}%
    {\@ifequal{#1}{-3}{\styling@headingLARGE}%
    {\@ifequal{#1}{-2}{\styling@headingLarge}%
    {\@ifequal{#1}{-1}{\styling@headingpart}%
    {\@ifequal{#1}{0}{\styling@headingchapter}%
    {\@ifequal{#1}{1}{\styling@headingsection}%
    {\@ifequal{#1}{2}{\styling@headingsubsection}%
    {\@ifequal{#1}{3}{\styling@headingsubsubsection}%
    {\@ifequal{#1}{4}{\styling@headingparagraph}%
    {\@ifequal{#1}{5}{\styling@headingsubparagraph}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}}}}}}}}}%
  }{\@ifequal{#2}{intro}{%
    \@ifequal{#1}{1}{\styling@introlarge}%
    {\@ifequal{#1}{2}{\styling@intronormal}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\@ifequal{#2}{body}{%
    \@ifequal{#1}{1}{\styling@body}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{promotional}{%
    \@ifequal{#1}{1}{\styling@promotional}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{promotional-heading}{%
    \@ifequal{#1}{1}{\styling@promotionalheading}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{quote}{%
    \@ifequal{#1}{1}{\styling@quoteLarge}%
    {\@ifequal{#1}{2}{\styling@quotelarge}%
    {\@ifequal{#1}{3}{\styling@quotenormal}%
    {\@ifequal{#1}{4}{\styling@quotesmall}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}}}%
  }{\@ifequal{#2}{accent}{%
    \@ifequal{#1}{1}{\styling@accent}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{info}{%
    \@ifequal{#1}{1}{\styling@info}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{caption}{%
    \@ifequal{#1}{1}{\styling@caption}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{note}{%
    \@ifequal{#1}{1}{\styling@note}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{payoff}{%
    \@ifequal{#1}{1}{\styling@payofflarge}%
    {\@ifequal{#1}{2}{\styling@payoffnormal}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\@ifequal{#2}{tiny}{%
    \@ifequal{#1}{1}{\styling@tiny}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }%
  }}}}}}}}}}}%
}

%%% meta shortcuts
\def\metasmall{\style{tiny}}
\def\meta{\style{note}}
\def\metanormal{\style{body}}

%%% titlepage styling
\def\frontpagehead#1{
  \iffirsthead%
    \firstheadfalse%
  \else%
    \hfill\linebreak% Leave a blank space
  \fi%
  \leavevmode\style{tiny}\textbf{#1}\hfill\break %
} %leavevmode because \style breaks 

\newcommand{\frontpagebody}[1]{
\style{note}#1\hfill\break}



%%%
%   Enumeration styles
%%%

\renewcommand{\labelitemi}{\color{colorlabel}$\bullet$}

\newcommand{\labelstyle}[1]{\color{colorlabel}\textbf{#1}}

%%% TODO enable with option
\renewcommand{\labelitemi}{\scriptsize{\labelstyle{\raisebox{.175\baselineskip}{\rule{.65\baselineskip}{.65\baselineskip}}}}}
\renewcommand{\labelitemii}{\labelstyle{--}}
\renewcommand{\labelitemiii}{\labelstyle{-}}
\renewcommand{\labelitemiv}{\labelstyle{-}}

\setnewlength{\labelindent}{7pt}
\setlength{\labelsep}{.5\tabsize}
\addtolength{\labelsep}{-.5\labelindent}

\settowidth{\leftmargini}{\labelitemi}
\addtolength{\leftmargini}{\labelsep}

\settowidth{\leftmarginii}{\labelitemii}
\addtolength{\leftmarginii}{\labelsep}

\settowidth{\leftmarginiii}{\labelitemiii}
\addtolength{\leftmarginiii}{\labelsep}

\settowidth{\leftmarginiv}{\labelitemiv}
\addtolength{\leftmarginiv}{\labelsep}


\renewcommand{\labelenumi}{%
  \color{colorlabel}\arabic{enumi}.%
  \hspace{-\labelindent}
}
\renewcommand{\labelenumii}{%
  \color{colorlabel}\Alph{enumii}.%
  \hspace{-\labelindent}
}
\renewcommand{\labelenumiii}{%
  \color{colorlabel}\alph{enumiii}.%
  \hspace{-\labelindent}
}
\renewcommand{\labelenumiv}{%
  \color{colorlabel}\alph{enumiv}.%
  \hspace{-\labelindent}
}



%%%
%   Table styles
%%%

\def\zapcolorreset{\let\reset@color\relax\ignorespaces}
\def\colorrows#1{\noalign{\aftergroup\zapcolorreset#1}\ignorespaces}

\edef\endtabular{\unexpanded\expandafter{\endtabular}\noexpand\reset@color}

\renewcommand{\arraystretch}{1.75}

\storeoldenv{\table}
\renewenvironment{table}[1][ht!]{%
  \oldtable[#1]\autocenter}%
  {\endoldtable}

\storeoldenv{\tabular}
\renewenvironment{tabular}{%
\setlength{\arrayrulewidth}{1.5pt}%
	\oldtabular%
	}{%
  \\\arrayrulecolor{tuered}\hline
	\endoldtabular}

\newcommand{\headbegin}{
	\rowcolor{tuered}
	\colorrows{\color{white}}
}

\newcommand{\headend}{
	\colorrows{\color{black}}
}

\newcommand{\subheadbegin}{
	\colorrows{\color{tuered}}
}

\newcommand{\subheadend}{
	\colorrows{\color{black}}
}

%%% COMMAND:  \parcell[<alignment>]{<content>}
%%  USAGE:    Used to create a breakable cell within a table
%%  EXAMPLE:  Vertical center middle: \specialcell   {Foo\\bar} & Foo\\
%%  EXAMPLE:  Vertical center top:    \specialcell[t]{Foo\\bar} & Foo\\
%%  EXAMPLE:  Vertical center bottom: \specialcell[b]{Foo\\bar} & Foo\\
\def\parcell{%
   \@ifnextchar[%
     {\parcell@i}
     {\parcell@i[c]}%
}
\def\parcell@i[#1]{%
   \@ifnextchar[%
     {\parcell@ii{#1}}
     {\parcell@ii{#1}[c]}%
}
\def\parcell@ii#1[#2]#3{%
  \begin{oldtabular}[#1]{@{}#2@{}}#3\end{oldtabular}}

%%%
%   Figure styles
%%%

\storeoldenv{\figure}
\renewenvironment{figure}[1][ht]{%
  \oldfigure[#1]\autocenter}%
  {\endoldfigure}


%%%
%   Titlepage lengths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Vertical spacing
\setnewlength{\@Vspacing}{8.5cm}

%%% Horizontal spacing
\setnewlength{\@Hspacing}{0.5\paperwidth}
\addtolength\@Hspacing{-1.12cm}

%%% Axis width
\setnewlength{\@axiswidth}{.2mm}

%%% Axis height
\setnewlength{\@axisheight}{\paperheight}
\addtolength\@axisheight{-\@Vspacing}

%%% Axis shift ratio
\def\@shiftratio{0.287} % 74 degree axis

%%% Axis horizontal shift
\setnewlength{\@Hshift}{\@shiftratio\paperheight}

%%% Table of Contents spacing
\setnewlength{\@tocleftpadding}{\layoutleftmargin}

\setnewlength{\@tocleftspace}{\@Hspacing}
\addtolength{\@tocleftspace}{-1.88cm}

\setnewlength{\@toctopspace}{\@Vspacing}
\addtolength{\@toctopspace}{\@axiswidth}
\addtolength{\@toctopspace}{0.48cm}

%%% Cover image lengths
\newlength{\@coverheight}
\newlength{\@coverwidth}

%%% Calculate cover image dimension and position based on the image ratio and the axes lengths
\pgfmathsetlength{\@coverheight}{(\paperwidth - \@Hspacing + \@shiftratio * \@Vspacing)/(\@coverratio - \@shiftratio)}
\pgfmathsetlength{\@coverwidth}{\paperwidth - \@Hspacing + \@shiftratio * \@Vspacing + \@shiftratio * \@coverheight}
\setnewlength\@covertop{\dimexpr \@axisheight-0.5\@axiswidth}
\setnewlength\@coverbottom{\dimexpr \@axisheight - \@coverheight}


%%%
%   Lengths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Redefine skip amounts
\smallskipamount=.5\baselineskip plus .15\baselineskip minus .15\baselineskip
\medskipamount=1\baselineskip plus .3\baselineskip minus .3\baselineskip
\bigskipamount=3\baselineskip plus 1\baselineskip minus 1\baselineskip

%%% List indent
\setnewlength{\listindent}{\tabsize}

%%% List environment indent (includes quote)
\setlength{\leftmargini}{.5\tabsize}

%%% Paragraph indent
\setlength{\parindent}{0pt}

%%%
%   Fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Write out to log which labels have changed
\def\@testdef #1#2#3{%
  \def\reserved@a{#3}\expandafter%
  \ifx \csname #1@#2\endcsname
    \reserved@a  \else
      \typeout{%
        ^^Jlabel #2 changed:^^J%
        \meaning\reserved@a^^J%
        \expandafter\meaning\csname #1@#2\endcsname^^J%
      }%
    \@tempswatrue 
  \fi
}


% define \shapedraggedright as redefined \raggedright to not create with \shapepar:
% i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
\def\shapedraggedright{%
\let\\\@centercr\@rightskip \z@ plus\linewidth \rightskip\@rightskip
\leftskip\z@skip
\parindent\z@}


%%%	Set cleardoublepage to also work with the "oneside" option
\def\cleardoublepage{\clearpage\ifodd\c@page\else
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi}

%%%
% 	Redefine titlepage so it does not reset page counter
%%%

\if@compatibility
\renewenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      %\setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\renewenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      %\setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
       % \setcounter{page}\@ne
     \fi
    }
\fi

%%%
% 	Redefine part style, no empty page behind it
%%%

\renewcommand\@endpart
{
	\vfil
	\if@twoside
		\null
		\thispagestyle{empty}%
		\newpage
	\fi
		\if@tempswa
		\twocolumn
	\fi
}



%%%
%   Document data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% 	Declare data commands, commands used by the user to enter data
%%%

%%% Defining the commands to specify name, department, etc.
\newvariable{name}{}
\newvariable{date}{\today}
\newvariable{administrativeunit}{}
\newvariable{department}{}
\newvariable{website}{\thetuesite}
\newvariable{subtitle}{}
\newvariable{subsubtitle}{}
\newvariable{orderissuer}{}
\newvariable{reference}{}
\newvariable{address}{}
\newvariable{versionnum}{}
\newvariable{copyholder}{}
\newvariable{addfrontpage}{}

\newif\ifprofilingtouched
\profilingtouchedfalse

\newif\ifprofilingfilled
\profilingfilledfalse

\def\profiling{%
   \@ifnextchar[%
     {\profiling@i}
     {\profiling@i[\@empty]}%
}
\def\profiling@i[#1]{%
   \@ifnextchar[%
     {\profiling@ii{#1}}
     {\profiling@ii{#1}[\@empty]}%
}
\def\profiling@ii#1[#2]#3{%
  \profilingtouchedtrue
  \ifx#1\@empty
    \newvariable{profilingvalue}{#3}
    \newvariable{profilingcolor}{tuered}
    \colorlet{profilingcolor}{tuered}
  \else
    \newvariable{profilingvalue}{#3}
    \newvariable{profilingcolor}{#1}
    \colorlet{profilingcolor}{#1}
  \fi
  \@ifequal{#2}{fill}{
    \profilingfilledtrue
  }{}
}




%%%	Package for linkstyling
%	Enable PDF bookmarks
%	Make index page numbers clickable

%%%	Set link colors, bookmarks etc.
\hypersetup{
  backref=true,
  linktocpage=true,
  breaklinks=true,
  linktocpage=true,
  bookmarksnumbered=true,
  breaklinks=true,
	colorlinks=true,
	linkcolor={tuered},
	citecolor={tuedarkblue},
	urlcolor={tuescarlet},
  linkbordercolor={tuered},
  citebordercolor={tuedarkblue},
	urlbordercolor={tuescarlet}
}

\urlstyle{same}
\urlstyle{allbreak} % set as default

\ifprint
  \AtBeginDocument{
    \storeold{\href}
    \renewcommand{\href}[2]{\oldhref{##1}{##2}\footnote{\url{##1}}}
  }
\fi




%%%
%   Build number
%%%

\def\buildfile{\jobname.build}
\newcounter{build}

\AtBeginDocument{%
	\IfFileExists{\buildfile}{
		\def\@transfer{}
    \@readfrom{\buildfile}{\@transfer}
    \@transfer
	}{
		\refstepcounter{build}
    \@writeto{\buildfile}{\string\setcounter{build}{\number\value{build}}}
	}
}

\AtEndDocument{%
		\refstepcounter{build}
    \@writeto{\buildfile}{\string\setcounter{build}{\number\value{build}}}
}





%%%
% Reset sectioning counters
%%%
\newcommand{\resetcounters}[1]{
	\ifnum #1 < 0
		\setcounter{chapter}      {0}% Level 0
	\fi
	\ifnum #1 < 1
		\setcounter{section}      {0}% Level 1
		\setcounter{figure}       {0}% Reset at chapter
		\setcounter{table}        {0}% Reset at chapter
    \setcounter{footnote}     {0} %%%% TODO make option
    \setcounter{equation}     {0} %%%% TODO make option 
	\fi
	\ifnum #1 < 2	
		\setcounter{subsection}   {0}% Level 2
	\fi
	\ifnum #1 < 3
    \setcounter{subsubsection}{0}% Level 3
  \fi
	\ifnum #1 < 4
    \setcounter{paragraph}    {1}% Level 4, counter not used
  \fi
	\ifnum #1 < 5
    \setcounter{subparagraph} {1}% Level 5, counter not used
  \fi
}

\def\thepart{\ifnum\value{part} < 1%
  \addtocounter{part}{1}%
\fi%
\the\numexpr\value{part}+\@sectioningshift\relax%
}

\def\thechapter{%
\ifnum\value{chapter} < 1%
	\addtocounter{chapter}{1}%
\fi
\ifnum\the\numexpr\value{chapter}+\@sectioningshift\relax < 10
	\ifleadzero%
    0%
  \fi
  \the\numexpr\value{chapter}+\@sectioningshift\relax
\else
	\the\numexpr\value{chapter}+\@sectioningshift\relax
\fi
}

\def\thesection{%
\ifnum 1 < \numexpr \value{sectioningcountertouched}+1\relax %
  \relax%
\else
  \ifnum 1 > \numexpr \value{sectioningcounterstarred}+1\relax
    \ifnum 1 > \numexpr \value{reversesecnumdepth}\relax
      \thechapter\relax%
      \texorpdfstring{\protect\watermark{.}}{.}%
    \fi
  \fi
\fi
\ifnum\value{section} < 1%
  \addtocounter{section}{1}%
\fi%
\the\numexpr\value{section}+\@sectioningshift\relax%
}

\def\thesubsection{%
\ifnum 2 < \numexpr \value{sectioningcountertouched}+1\relax %
  \relax%
\else
  \ifnum 2 > \numexpr \value{sectioningcounterstarred}+1\relax
    \ifnum 2 > \numexpr \value{reversesecnumdepth}\relax
      \thesection\relax%
      \texorpdfstring{\protect\watermark{.}}{.}%
    \fi
  \fi
\fi
\ifnum\value{subsection} < 1%
	\addtocounter{subsection}{1}%
\fi%
\the\numexpr\value{subsection}+\@sectioningshift\relax}

\def\thesubsubsection{%
\ifnum 3 < \numexpr \value{sectioningcountertouched}+1\relax %
  \relax%
\else
  \ifnum 3 > \numexpr \value{sectioningcounterstarred}+1\relax
    \ifnum 3 > \numexpr \value{reversesecnumdepth}\relax
      \thesubsection\relax%
      \texorpdfstring{\protect\watermark{.}}{.}%
    \fi
  \fi
\fi
\ifnum\value{subsubsection} < 1%
	\addtocounter{subsubsection}{1}%
\fi%
\the\numexpr\value{subsubsection}+\@sectioningshift\relax}




%%%
% Declare commands for parts, chapters and sections without number
% Also autolabel them
%%%

\newcommand{\autolabeling}[2]{
	\ifautolabel
    \labelselector{#1}{#2}
  \else\relax\fi
}

%%% command \createsectioningstyling[<level>]{\<name>}{<style>}{<space before>}{<space after>}
\newcommand{\createsectioningstyling}[7][\secingLevelLowest]{
  \renewcommand#2{
    \@startsection{\cs@to@str#2}{#1}{\z@}%
    {#3 \@plus #4 \@minus #5}% %%% TODO make plus and minus relative
    {#6 \@plus #7}%
    {\style[#1]{heading}}
  }
}

\ifsectioningstyling
  \createsectioningstyling[1]{\section}       {-3.5ex}  {-1ex}{-.2ex}{2.3ex}{.2ex}
  \createsectioningstyling[2]{\subsection}    {-3.25ex} {-1ex}{-.2ex}{1.5ex}{.2ex}
  \createsectioningstyling[3]{\subsubsection} {-3.25ex} {-1ex}{-.2ex}{1.5ex}{.2ex}
  
  \setnewlength{\vaftersection}{2.3ex \@plus .2ex}
  
  \AtBeginDocument{
    \def\@makechapterhead#1{%
      \vspace*{50\p@}%
      \hspace{-\chaptershift}\parbox{\dimexpr\linewidth+\chaptershift}{\parindent \z@ \raggedright \style[0]{heading}%\normalfont
        \ifnum \c@secnumdepth >\m@ne
          \ifchaptername % check for chaptername option
            \@chapapp\space\thechapter\linebreak
          \fi
           %\vskip 20\p@
        \fi
        \interlinepenalty\@M
        \Huge \bfseries #1\par\nobreak
        \vskip 40\p@
      }
    }
  }
\fi

\ifsectioningstyling
  \ifparagraphstyling
    \createsectioningstyling[4]{\paragraph}{-3.25ex}{-1ex}{-.2ex}{.2ex}{.2ex} %Negative values to create linebreak
    \createsectioningstyling[5]{\subparagraph}{-3.25ex}{-1ex}{-.2ex}{.2ex}{.2ex}%Negative values to create linebreak
  \fi
\fi




\def\secingLevelLowest{6}% Subparagraph level +1
\def\secingLevelHighest{-2}% Part level -1
\newcounter{sectioningcounterdisplay}
\setcounter{sectioningcounterdisplay}{\secingLevelLowest}
\newcounter{sectioningcountertouched}
\setcounter{sectioningcountertouched}{\secingLevelLowest}

\newcounter{sectioningcounterstarred}
\setcounter{sectioningcounterstarred}{\secingLevelHighest}

%%% Set counter depth to only exclude subsubsection and (sub)paragraph
\setcounter{secnumdepth}{3} %%% TODO change to 2
\setcounter{tocdepth}{2}

%% custom counter for reverse senumdepth
\newcounter{reversesecnumdepth}
\setcounter{reversesecnumdepth}{\secingLevelHighest}

\newcommand{\createsectioning}[2][\secingLevelLowest]{
	\storeold{#2}
	\def#2{
		\@ifstar
		{\csname @\expandafter\cs@to@str\string#2New\endcsname}
		{\csname @@\expandafter\cs@to@str\string#2New\endcsname}
	}
  
  \expandafter\newcommand\csname @\expandafter\cs@to@str\string#2New\endcsname[2][\@empty]{
    \csname @@@\expandafter\cs@to@str\string#2Internal\endcsname{##1}{##2}{*}
    \ifnum #1 > \value{sectioningcounterdisplay}%
      \relax
    \else
      \setcounter{sectioningcounterdisplay}{#1}
    \fi
    \setcounter{sectioningcounterstarred}{#1}
  }
  
  \expandafter\newcommand\csname @@\expandafter\cs@to@str\string#2New\endcsname[2][\@empty]{
    \ifnum #1 > \value{sectioningcounterdisplay}%
      %%% TODO add partial numbering branch
      \ifhideuppersectioning
        \ifnum #1 = \value{sectioningcounterstarred}
          \addtocounter{sectioningcounterstarred}{-1}
        \else
          \ClassWarning{TUestyle}{PARTIAL Numbering removed from '\string#2 because it is nested inside unnumbered sectioning}
        \fi
        \csname @@@\expandafter\cs@to@str\string#2Internal\endcsname{##1}{##2}{}
      \else
        \csname @@@\expandafter\cs@to@str\string#2Internal\endcsname{##1}{##2}{*}
        \ClassWarning{TUestyle}{Numbering removed from '\string#2 because it is nested inside unnumbered sectioning}
      \fi
    \else
      \setcounter{sectioningcounterstarred}{\secingLevelHighest}
      \setcounter{sectioningcounterdisplay}{\secingLevelLowest}
      \csname @@@\expandafter\cs@to@str\string#2Internal\endcsname{##1}{##2}{}
    \fi
  }
  
  \expandafter\newcommand\csname @@@\expandafter\cs@to@str\string#2Internal\endcsname[3]{
    \resetcounters{#1}
    \csname old\expandafter\cs@to@str\string#2\endcsname##3{##2}
    \ifx\@empty##1%
      \autolabeling{#2}{##2}%
    \else%
      \autolabeling{#2}{##1}%
    \fi
    \ifnum #1 < \value{sectioningcountertouched}
      \ifnum \value{sectioningcountertouched} < \secingLevelLowest
        \ClassError{TUestyle}{\string#2\space was called after a sectioning command lower in the hierarchy was called first, @line \thefirstsectioningline: \firstsectioningline}{Make sure the hierarchy is correct to prevent duplicate numbering. Either remove \firstsectioningline\space @line \thefirstsectioningline\space or replace \string#2\space with sectioning equal or higher in hierarchy than \firstsectioningline.}
      \else
        \setcounter{sectioningcountertouched}{#1}
        \newcounter{firstsectioningline}
        \setcounter{firstsectioningline}{\the\inputlineno}
        \def\firstsectioningline{\string#2}
      \fi
    \fi
    \thispagestyle{fancy}
    \@ifequal{##3}{}{
      \relax
    }{
      \phantomsection
      \addcontentsline{toc}{\expandafter\cs@to@str\string#2}{##2}
    }
  }
}


\AtBeginDocument{
  %%%	Part no number command
  \createsectioning[0]{\part}

  %%%	Chapter no number command
  \createsectioning[0]{\chapter}
  
  \def\chaptermark#1{
   \markboth{\MakeUppercase{\ifnum \c@secnumdepth >\m@ne \chaptername\space\thechapter\fi\space#1}}{\rightmark}
  }
  
  \renewcommand\sectionmark[1]{%
    \markright{\ifnum \c@secnumdepth >\z@ \thesection . \ \fi #1}
  }
  
  \ifsubsecmark\relax\else
    \renewcommand{\subsectionmark}[1]{}
  \fi


  %%%	Section no number command
  \createsectioning[1]{\section}

  %%%	Subsection no number command
  \createsectioning[2]{\subsection}

  %%%
  % Auto labeling of sectioning
  %%%
  \createsectioning[3]{\subsubsection}

  \createsectioning[4]{\paragraph}

  \createsectioning[5]{\subparagraph}
}

%%%
% Customize appendix
%%%

\AtBeginDocument{
  \storeold{\appendix}
  \def\appendix{\part*{Appendix}\oldappendix}
}



\newif\iffirsthead
%
\newcommand{\infobox}[2][bottom]{%
  \begingroup
  \firstheadtrue
  \setlength{\fboxsep}{0pt}
    \@ifequal{#1}{top}{%
      %%% Left top column
      \axisposition{\@axisheight+\@axispadding}%
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\@axiswidth+\axispositionY},left,bottom]{%
        \begin{minipage}[b][\dimexpr \paperheight-\axispositionY \relax]{\dimexpr \axispositionX - \@tocleftpadding -\@axispadding \relax}%
      
          \shapedraggedright%
          \style{note}#2\vspace{-\baselineskip}\end{minipage}}
    }{%
      %%% Left bottom column
      \axisposition{\@axisheight-\@axiswidth-\@axispadding}%
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\axispositionY},left,top]{%
        \begin{minipage}[t][\dimexpr \@axisheight-\@axispadding \relax]{\dimexpr \axispositionX - \@tocleftpadding -\@axispadding \relax}%
          \slantedpar{80}{\linewidth}%
          \shapedraggedright%
          #2\end{minipage}}
    }
  \endgroup
}








%%%
%   Titlepage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\setnewlength{\@axispadding}{10bp}

%%%
% Defining command for the TU/e logo, innovation and axes
%%%

%%% Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtuelogoandaxes}{
	%%%	If drawtuelogo is not set to false, by the "notuelogo" option
	\iflogo
		 % TU/e logo and red lines
		 \pgftext[at=\pgfpoint{\@Hspacing-2.475cm}{\the\paperheight-5.25mm},left,top]{\includegraphics[height=1.5cm]{tuelogo}}%
		
		\newvariable{logoname}{}
		\if\theadministrativeunit\empty
      \relax
    \else	
			\logoname{\theadministrativeunit}
		\if\thedepartment\empty
      \relax
    \else
			\logoname{\thedepartment}
		\ifprofilingtouched
			\logoname{\theprofilingvalue}
		\fi\fi\fi

    \begingroup
      \enablefrontbreak
      \setlength{\tempboxaheight}{0pt}
      \ifprofilingtouched
          \ifprofilingfilled
            \titlepagecontent[right][pink]{\theprofilingvalue}{purple}{\style[1]{heading}}{\dimexpr\paperwidth-\axispositionX-\frameright\relax}{\paperheight-5.25mm-1.5cm}{}{}
           %%% TODO make normal
            \titlepagecontent[left][pink]{\theprofilingvalue}{purple}{\style[1]{heading}}{}{\paperheight-5.25mm-1.5cm}{}{}
          \else
            \titlepagecontent[right]{\theprofilingvalue}{\theprofilingcolor}{\style[1]{heading}}{}{\paperheight-5.25mm-1.5cm}{}
          \fi
      \else
        \titlepagecontent[right]{\thelogoname}{tuedarkblue}{\style[4]{heading}}{}{\paperheight-2.3cm}{}{}
      \fi
    \endgroup
	\else
		\relax
	\fi

  \drawtueaxes

	%%%	If innovation is not set to false, by the "noinnovation" option
	\ifinnovation
  %%%%%%%%%%%%%%%  \ClassError{Tuestyle}{oke dan}{}
		\pgfsetcolor{tuedarkblue}
    \axisposition{6.75mm}
		\pgftext[at=\pgfpoint{\axispositionX+\@axispadding}{\axispositionY},left,bottom]{\style[4]{heading}\color{tuedarkblue} Where innovation starts}%
	\fi

	%%%	Reset colour to black
	\pgfsetcolor{black}
}


%%% Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtueaxes}[1][true]{
  \pgfsetcolor{tuered}
  \@ifequal{#1}{true}{
    %%%	Draw horizontal axis
    \pgfpathmoveto{\pgfpoint{0mm}			{\@axisheight}}
    \pgfpathlineto{\pgfpoint{\paperwidth}	{\@axisheight}}
    \pgfpathlineto{\pgfpoint{\paperwidth}	{\@axisheight-\@axiswidth}}
    \pgfpathlineto{\pgfpoint{0cm}			{\@axisheight-\@axiswidth}}
    \pgfusepath{fill}
  }{}
	%%%	Draw diagonal axis
	\pgfpathmoveto{\pgfpoint{\@Hspacing}						{\paperheight}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@Hshift}				{0cm}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@axiswidth-\@Hshift}	{0cm}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@axiswidth}			{\paperheight}}
	\pgfusepath{fill}
}


            %% TODO move
            \newcommand{\settocompleteheight}[2]{
            \settoheight{#1}{#2}
            \settodepth{\@tempdima}{#2}
            \addtolength{#1}{\@tempdima}
            \global#1=#1
            }

   %% to use you need to set \axispostionX and \axispositionY lengths first, preferably by using \axisposition
   % also set tempboxaheight 0 if it is the first
   \newlength{\tempboxaheight}
   \newlength{\tempboxawidth}
   
   \newlength{\titlepagecontentX}
   \newlength{\titlepagecontentY}
   
   \setnewlength{\fillhorizontalpadding}{\@axispadding}
   \newlength{\fillverticalpadding}
   
\def\titlepagecontent{%
   \@ifnextchar[%
     {\titlepagecontent@i}
     {\titlepagecontent@i[right]}%
}
\def\titlepagecontent@i[#1]{%
   \@ifnextchar[%
     {\titlepagecontent@ii{#1}}
     {\titlepagecontent@ii{#1}[\@empty]}%
}
\def\titlepagecontent@ii#1[#2]#3#4#5#6#7#8#9{%
  \setlength{\tempboxawidth}{0pt}% Reset item-width
  
  \axisposition{#7-2\tempboxaheight}% Get axisposition X and Y
  \setlength{\titlepagecontentX}{\axispositionX}% Store axisposition X
  \setlength{\titlepagecontentY}{\axispositionY}% Store axisposition Y
  \global\titlepagecontentY=\titlepagecontentY% Set axisposition Y to be global
  
  \@ifequal{#1}{left}{}
  {% If right go to the right side of the axis
    \addtolength{\axispositionX}{\@axiswidth}
  }
  
  {%
    #5% Activate disired styling (inside group to contain it)
    \setlength{\currentfontsize}{\f@size pt}% Store the current fontsize
    \global\currentfontsize=\currentfontsize% Set the current fontsize to be global
  }
  
  \@ifequal{#9}{}{% If the vertical padding is not specified
    \setlength{\fillverticalpadding}{\@axispadding}% Set vertical padding to equal to horizontal padding
  }{% If the vertical padding is specified
    \setlength{\fillverticalpadding}{#9}% Set vertical padding to value specified
  }
  
  \@ifequal{#1}{left}{% If left set baselength:
    \setnewlength{\@tempbaselength}{\dimexpr\titlepagecontentX-\@axispadding-\@axiswidth-\layoutleftmargin\relax}
    \ifx#2\@empty\else
      \addtolength{\@tempbaselength}{-\fillhorizontalpadding}% Substract padding from baselength
    \fi
  }{% If right set baselength:
    \setnewlength{\@tempbaselength}{\dimexpr\paperwidth-\titlepagecontentX-.3\currentfontsize-\layoutrightmargin-\@axispadding\relax}
    \ifx#2\@empty\else
      \addtolength{\@tempbaselength}{-\fillhorizontalpadding}% Substract padding from baselength
    \fi
  }
  
  \@ifequal{#6}{}{% If no minimum width is specified
    \setnewlength{\minimumfillwidth}{0pt}
    % Set the minimum to 0
  }{% If a minimum width is specified
    \setnewlength{\minimumfillwidth}{#6}
    % Set the minimum to value specified
  }
  
  \pgftext[at=\pgfpoint{0pt}{0pt},left,top]{
      \def\@tempcontentinside{
          #5%
          \leavevmode\color{#4}%
          #3
      }
      \def\@tempcontent{% 
        #5%
        \leavevmode\color{#4}%      
        \vbox{%
          \@ifequal{#1}{left}{%
            \slantedpar[left]{80}{\linewidth}\raggedleft%
          }{%
            \slantedpar[right]{80}{\linewidth}\shapedraggedright%
          }%
           \@tempcontentinside}%
      }%
      \global\sbox{\@tempboxa}{%
        \begin{minipage}[t]{\@tempbaselength}%
        \parbox{\linewidth}{%
          \@tempcontent%
        }
        \end{minipage}%
      }%
      \settocompleteheight{\tempboxaheight}{\usebox{\@tempboxa}}
      \addtolength{\tempboxaheight}{\fillverticalpadding}
      \global\tempboxaheight=\tempboxaheight
      \ifx#2\@empty\else
        #5
        \getlongestsentence{#3}
        \ifdim \longestsentence < \@tempbaselength
          \ifdim \longestsentence < \minimumfillwidth
            \setlength{\tempboxawidth}{\dimexpr\minimumfillwidth\relax}
          \else
            \setlength{\tempboxawidth}{\longestsentence}
          \fi
        \else
          \setlength{\tempboxawidth}{\@tempbaselength}
        \fi
      \fi
      \global\tempboxawidth=\tempboxawidth
  }
  \ifx#2\@empty\else
    \pgfsetcolor{#2}
    \@ifequal{#1}{left}{
      \pgfpathmoveto{\pgfpoint{\titlepagecontentX}                                                  {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  - \tempboxawidth - \fillhorizontalpadding-\@axispadding -\@axiswidth}                {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX   - \tempboxawidth - \fillhorizontalpadding-\@axispadding -\@axiswidth}                {\titlepagecontentY - 2\tempboxaheight}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  - \@shiftratio\tempboxaheight*2}                  {\titlepagecontentY - 2\tempboxaheight}}
      \pgfusepath{fill}
    }{
      \pgfpathmoveto{\pgfpoint{\titlepagecontentX}                                                  {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  + \tempboxawidth + \fillhorizontalpadding}                {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX   + \tempboxawidth + \fillhorizontalpadding}                {\titlepagecontentY - 2\tempboxaheight}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  - \@shiftratio\tempboxaheight*2}                  {\titlepagecontentY - 2\tempboxaheight}}
      \pgfusepath{fill}
    }
  \fi
  \@ifequal{#1}{left}{
    \pgftext[at=\pgfpoint{\layoutleftmargin}{\titlepagecontentY-.25\baselineskip-\fillverticalpadding},left,top]{%
     \usebox{\@tempboxa}
    }
  }{
    \pgftext[at=\pgfpoint{\titlepagecontentX+\@axispadding}{\titlepagecontentY-.25\baselineskip-\fillverticalpadding},left,top]{%
      \usebox{\@tempboxa}
    }
  }
  \@ifequal{#8}{nospace}{
    \setlength{\tempboxaheight}{0pt}
    \global\tempboxaheight=\tempboxaheight
  }{}
}
  


%%%
% 	Create the TU/e style titlepage
%%%

\ifcover
  %%% Get actual cover image dimensions
  \newlength{\actual@coverheight}
  \settoheight\actual@coverheight{\includegraphics[width={\@coverwidth}]{\definedpath \covername}}
      % Calculate actual cover image ratio
      \def\actual@coverratio{\DivideLengths{\@coverwidth}{\actual@coverheight}}
     
\fi
      
\newcommand\enablefrontbreak{
  \def\titlebreak{\linebreak}
}

\newcommand\disablefrontbreak{
  \def\titlebreak{\unskip\space}
}

%%% TODO use only on frontpage, then reset
\def\@fnsymbol#1{\ifcase\value{footnote}\or*\or
†\or‡\or§\or¶\or||\or**\or††\or‡‡\or|||\or***\or†††\or‡‡‡\or \ClassError{TUeStyle}{Frontpage counter too large. Are you sure you need that many authors?}\fi}

\renewcommand\maketitle{
  \setcounter{footnote}{-1}
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}
  \def\and{} %%% TODO add warning
  \begin{titlepage}
    %%%% TODO footnotesize and settings
    \let\footnotesize\small%
    \let\footnoterule\relax%
    \let\footnote\thanks%
    %%%\hfuzz=1000pt
    \enablefrontbreak

    \newgeometry{left=0cm,top=0cm,bottom=0cm, right=0cm, ignoreall}
    \begin{pgfpicture}{0cm}{0cm}{\paperwidth}{\paperheight}
    
      %%%	If the cover option is set, then draw cover and white overlays
      \ifcover
        %%% Display area to be filled by the cover image
        \pgfsetcolor{black!20!white}
        \pgfpathmoveto{\pgfpoint{0mm}{\@axisheight}}
        \pgfpathlineto{\pgfpoint{\the\paperwidth}{\@axisheight}}
        \pgfpathlineto{\pgfpoint{\the\paperwidth}{0cm}}
        \pgfpathlineto{\pgfpoint{0mm}{0mm}}
        \pgfusepath{fill}
        
        %%% Draw the cover 
        \pgftext[at=\pgfpoint{\paperwidth-\@coverwidth}{\@covertop},left,top]{\includegraphics[width={\@coverwidth}]{\definedpath \covername}}%
         
        %%% Compare the cover ratio to the actual ratio and draw if wrong
        \pgfsetcolor{red}
        \pgftext[at=\pgfpoint{\paperwidth-.5\@coverwidth}{\@coverbottom},center,bottom]{
        \ifrealnum{\@coverratio}{\actual@coverratio}{}{
          \parbox[b]{\@coverwidth}{
            \huge \centering WARNING: Cover-image doesn't fill set coverratio.
          }
        }{}
        }%
        
        %%% Draw bottom white overlay for the cover
        \pgfsetcolor{white}
        \pgfpathmoveto{\pgfpoint{0mm}{\@coverbottom}}
        \pgfpathlineto{\pgfpoint{\the\paperwidth}{\@coverbottom}}
        \pgfpathlineto{\pgfpoint{\the\paperwidth}{0cm}}
        \pgfpathlineto{\pgfpoint{0mm}{0mm}}
        \pgfusepath{fill}
         
        %%% Draw left white overlay for the cover
        \pgfsetcolor{white}
        \pgfpathmoveto{\pgfpoint{0mm}{\@axisheight}}
        \pgfpathlineto{\pgfpoint{\@Hspacing-\@shiftratio*85mm}{\@axisheight}}
        \pgfpathlineto{\pgfpoint{\@Hspacing-\@shiftratio*\paperheight}{0cm}}
        \pgfpathlineto{\pgfpoint{0mm}{0mm}}
        \pgfusepath{fill}
      \fi

      %%% From name and address
      \pgfsetcolor{black}
        \infobox[top]{%
          \frontpagebody{\textbf{\theadministrativeunit}\vspace{\baselineskip}}
          \ifx\thedepartment\empty
          \else
            \frontpagebody{\textit{\textbf{\thedepartment}}}
          \fi
          \ifx\theaddress\empty
          \else
            \frontpagebody{\theaddress ,}%
          \fi
          \ifaddress
            \frontpagebody{5612 AZ Eindhoven}
            \frontpagebody{\thePObox\space513, 5600 MB Eindhoven}
            \ifx\theNetherlands\empty
            \else
              \frontpagebody{\theNetherlands}
            \fi
          \fi
          \ifx\thewebsite\empty
          \else
            \hypersetup{urlcolor={black}}
            \frontpagebody{\urlstyle{same}\url{\thewebsite}}
            \hypersetup{urlcolor={tuescarlet}}
          \fi
        }%
      %%% Left column with info
        \infobox[bottom]{%
          \ifauthor%
            \frontpagehead{\theauthorlabel}%
            \frontpagebody{\@author}%
          \fi%
          \ifx\theorderissuer\empty
          \else%
            \frontpagehead{\theorderissuerlabel}%
            \frontpagebody{\theorderissuer}%
          \fi%
          \ifx\thereference\empty
          \else%
            \frontpagehead{\thereferencelabel}%
            \frontpagebody{\thereference}%
          \fi%
          \theaddfrontpage%
          \ifx\thedate\empty
          \else%
            \frontpagehead{\thedatelabel}%
            \frontpagebody{\thedate}%
          \fi%
          \ifx\theversionnum\empty
          \else%
            \frontpagehead{\theversionlabel}%
            \frontpagebody{\theversionnum}%
          \fi%
      }%
      \ifcover
      
      
   

      
      
      %%% Title and subtitle positioned underneath cover
        \setlength{\tempboxaheight}{0pt}
        \axisposition{\@coverbottom}

      \else
      %%% Title and subtitle at normal position
        \setlength{\tempboxaheight}{0pt}
        \axisposition{\@axisheight}
      \fi
      \titlepagecontent[right][green]{\@title}{black}{\style[0]{heading}}{}{\axispositionY}{}{}
      \titlepagecontent[right][pink]{\thesubtitle}{black}{\style[3]{heading}}{}{\titlepagecontentY}{}{}
      \titlepagecontent[right]{\thesubsubtitle}{black}{\style{body}\justified}{}{\titlepagecontentY}{}{}
      
      %%%	Drawing of the TU/e axes and logo
      %   Drawn last so it overlays everything else
      \drawtuelogoandaxes
    \end{pgfpicture}%
  \end{titlepage}

  %%%% \hfuzz=0pt

  %%%	Reset the original values of all margins
  \renewcommand{\thefootnote}{\arabic{footnote}}
  \resetcounters{0}  %%% TODO use resetcounters
  \resetlayout
}
\def\and{\ClassWarning{TUestyle}{\string\and command is disabled, use \string\author{<name1>}{<name2>}{<name3>} for proper styling}{}}



%%%
% 	Redefine table of contents
%%%

\newlength{\oldheadrulewidth}
% Completely redefine the \tableofcontents command.
% It shows the TU/e logo and draws the axes.
% It also needs to redefine the margins temporarily,
% for which the geometry package is used.

\let\oldtableofcontents\tableofcontents
\renewcommand\tableofcontents{%
	\if@openright
		\cleardoublepage
	\else\relax\fi

	% The table of contents needs different margins. The package geometry is used to
	% change the margins of certain pages within a document.
	% After the table of contents, they will be reset.
	\newgeometry{bottom=\layoutbottommargin, twoside=false, right=\rightmargincalculated, left=\@tocleftspace, top=\@toctopspace, headheight=0cm, headsep=0cm,footskip=0cm,marginpar=0cm,marginparsep=0cm}

	\fancyhf{}
	\setlength{\oldheadrulewidth}{\headrulewidth}
	\renewcommand{\headrulewidth}{0.0pt}

	\fancyfoot[L]{%
	\vspace{\dimexpr-\@toctopspace-\textheight}%
	\makebox[\textwidth][l]{%
		\hspace{-\@tocleftspace}%
			\begin{pgfpicture}{0mm}{0mm}{\paperwidth}{\paperheight}
				\drawtuetableofcontents
			\end{pgfpicture}
		}
	}
	
	\pagestyle{fancy}
		%%%	Draw TOC (Table of Contents)
		{
		\@starttoc{toc} 
	 }%
	
	%%%	Begin new page to start layout-change
	\newpage

	%%%	Reset the original values of all margins
	\resetlayout
	
	\renewcommand{\headrulewidth}{\oldheadrulewidth}
	
	\ifx\drawtwocolumn\undefined
		\relax
	\else
		\twocolumn
	\fi
}


%%%
% Defining command for the TU/e logo, innovation, axes, text and title
% for the table of contents
%%%

%%%	Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtuetableofcontents}{

	%%%	Draw TU/e logo, innovation and axes
	\drawtuelogoandaxes
	\color{black}
	
	%%% Draw "Table of contents" or "Inhoudsopgave" title
  \infobox[top]{%
      \Large\contentsname\hfill\break%
  }

	%%% Draw title and subtitle
  \infobox[bottom]{%
    \ifx\@title\empty\relax\else
      \frontpagehead{\thetitlelabel}%
      \frontpagebody{\@title}%
    \fi
    \ifx\thesubtitle\empty\relax\else
      \frontpagehead{\thesubtitlelabel}%
      \frontpagebody{\thesubtitle}%
    \fi
  }
}








%%%
% Declare TU/e header and footers
%%%

%%%	Using the fancyhdr package to set the TU/e headings.
%%%	Define left side header
\newcommand{\leftsidehead}{
	\style{body}\color{hfcolor} 
	\ifshorth 
		\thefullname
	\else
		\theshortname
	\fi
	\ifx\theextrah\empty\relax\else
    -\space\theextrah
  \fi
}

%%%	Define right side header
\newcommand{\rightsidehead}{
	\style{body}\color{hfcolor} 
	\ifx\theextrah\empty\relax\else
    \theextrah\space-
  \fi
	\ifshorth
		\thefullname
	\else
		\theshortname
	\fi
}

%%%	Define left side footer
\newcommand{\leftsidefoot}{
  \parbox[b]{\linewidth}{\raggedright
    \style{body}\color{black}\footnumber\color{hfcolor}\space-\space
    \@title
      \ifx\theversionnum\empty
        \linebreak
      \else
        { / \theversionlabel\space\theversionnum }\linebreak%
      \fi%
    \ifsectioningf
      \itshape\nouppercase{\leftmark}\linebreak%
    \fi
    \ifx\theextraf\empty\relax\else
      \theextraf
    \fi
  }
}

%%%	Define right side footer
\newcommand{\rightsidefoot}{
  \parbox[b]{\linewidth}{\raggedleft
    \style{body}\color{hfcolor}%
    \storeold{\linebreak}%
    \def\linebreak{\space-\space\color{black}\footnumber\oldlinebreak\restoreold{\linebreak}\color{hfcolor}}%
    \@title%
    \ifx\theversionnum\empty%
      \linebreak%
    \else%
      \space/\space\theversionlabel\space\theversionnum\linebreak%
    \fi%
    \ifsectioningf%
      \itshape\nouppercase{\rightmark}\linebreak%
    \fi%
    \ifx\theextraf\empty\relax\else%
      \theextraf%
    \fi%
  }
}

%%%	Define copyholder footer
\newcommand{\copyfoot}{
	\ifcopyf
		\frontpagehead{\hfill\thecopyholderlabel}
    \frontpagebody{\hfill\thecopyholder}\vspace{-.5\baselineskip}
	\fi
}

%%%	Define draft overlay
\newcommand{\draftmarking}{
	\ifdraftmark
		\draftmark%
		\settoheight{\@tempdima}{\draftmark}%
		\vspace{-\@tempdima}%
		\vspace{\dimexpr -.5\paperheight+\layouttopmargin \relax}%
	\fi
}

%%%	Define footer number
\newcommand{\footnumber}{
	\textbf{%
		\thepage%
		\ifendf
			/\pageref*{lastdocpage}
		\fi
	}
}

%%%	Define headers and footers for twoside design
\newcommand{\setheadersTwo}{
	\pagestyle{fancy}
	\fancyhf{}
	%	Header for the even pages, header on the left
	\fancyhead[LE]{
		\leftsidehead
	}
	%	Header for the odd pages, header on the right
	\fancyhead[RO]{
		\rightsidehead
	}
	%	Header for the even pages, footer on the right
	\fancyfoot[RE]{
		\rightsidefoot
	}
	%	Header for the odd pages, footer on the left
	\fancyfoot[LO]{
		\leftsidefoot
	}
  %	Copyholder in the middle
	\fancyfoot[C]{%
    \makebox[\textwidth]{%
      \raisebox{\dimexpr-15.75mm+\fboxrule}{
      \setlength{\fboxsep}{0pt}%
      \fbox{\parbox[b]{5cm}{\copyfoot}}%
      }%
    }%
    \raisebox{\dimexpr.5\paperheight-15.75mm}[0pt][0pt]{\hspace{-\textwidth}\makebox[\textwidth]{%
      \draftmarking%
    }}%
	}%
}

%%%	Define header and footers for oneside design
\newcommand{\setheadersOne}{
	\pagestyle{fancy}
	\fancyhf{}
	%	Header only on the right side
	\fancyhead[R]{
		\rightsidehead
	}
	%	Footer only on the left side
	\fancyfoot[L]{
		\leftsidefoot
	}
  %	Copyholder in the middle
	\fancyfoot[C]{%
    \makebox[\textwidth]{%
      \raisebox{\dimexpr-15.75mm+\fboxrule}{
      \setlength{\fboxsep}{0pt}%
      \fbox{\parbox[b]{5cm}{\copyfoot}}%
      }%
    }%
    \raisebox{\dimexpr.5\paperheight-15.75mm}[0pt][0pt]{\hspace{-\textwidth}\makebox[\textwidth]{%
      \draftmarking%
    }}%
	}%
}

%%%	Set defined header/footers, custom, twoside or oneside
\newcommand{\sethf}{
  \ifonesidehf
    \fancyheadoffset[LO]{\dimexpr\marginparsep+\marginparwidth\relax}
    \fancyfootoffset[RO]{\dimexpr\marginparsep+\marginparwidth\relax} 
  \else
    \fancyheadoffset[LO,RE]{\dimexpr\marginparsep+\marginparwidth\relax}
    \fancyfootoffset[RO,LE]{0pt}
  \fi
	\ifdefined\setheaders
		\setheaders
	\else
		\iftwosided
      \ifonesidehf
				%%%	Set oneside headers
				\setheadersOne
			\else
        %%%	Set twoside headers
				\setheadersTwo
			\fi
		\else
    	%%%	Set oneside headers
			\setheadersOne
		\fi
	\fi
 \renewcommand{\headrulewidth}{0mm}
}
\sethf

\fancypagestyle{plain}{%
  \fancyhead{}
  \fancyfoot{}
  \fancyfoot[C]{
    \parbox[b]{\linewidth}{\centering
      \color{hfcolor}-\space\color{black}\footnumber\color{hfcolor}\space-
    }
  }
}


%%%
% Define draftmark
%%%

\newsavebox{\draftBox}
\savebox{\draftBox}{%
	\color{tuered}
  \pgfsetfillopacity{0.1}
	\rotatebox[origin=c]{-45}{\fontsize{150bp}{0bp} \selectfont \textbf{\textsc{draft}}}%
  \pgfsetfillopacity{1}
}%

%%%	Declare the \draftmark command and scale it to the text
\newcommand{\draftmark}{%
	\usebox{\draftBox}%
}


%%%
% \aLeX command
%%%

\DeclareRobustCommand{\oldaLeX}{%
%L\kern-.36em%
{\sbox\z@ T%
\vbox to\ht\z@{\hbox{%
\check@mathfonts
\fontsize\sf@size\z@
\math@fontsfalse\selectfont A}%
\vss}%
}%
\kern-.15em%
\oldLeX}

\DeclareRobustCommand{\aLeX}{%
\begingroup\fontfamily{cmr}\selectfont\oldaLeX\endgroup%
}

\DeclareRobustCommand{\org@LeX}{%
L\kern -.1667em\lower .5ex\hbox {E}\kern -.125emX\@
}

\DeclareRobustCommand{\oldLeX}{%
\org@LeX%
}

\DeclareRobustCommand{\LeX}{%
\begingroup\fontfamily{cmr}\selectfont\oldLeX\endgroup%
}





%%%
% \LaTeX command (ensures fontfamily)
%%%

\DeclareRobustCommand{\oldLaTeX}{%
L\kern-.36em%
{\sbox\z@ T%
\vbox to\ht\z@{\hbox{%
\check@mathfonts
\fontsize\sf@size\z@
\math@fontsfalse\selectfont A}%
\vss}%
}%
\kern-.15em%
\oldTeX}

\DeclareRobustCommand{\LaTeX}{%
\begingroup\fontfamily{cmr}\selectfont\oldLaTeX\endgroup%
}

\DeclareRobustCommand{\oldTeX}{%
\org@TeX%
}

\DeclareRobustCommand{\TeX}{%
\begingroup\fontfamily{cmr}\selectfont\oldTeX\endgroup%
}





%%%
% Listing styling
%%%
\newcommand{\definelist}[3][1]{
  \expandafter\def\csname listof#2s\endcsname{%
    \begin{onecolarea}
      \chapter*{\csname thelistof#2sname\endcsname}%
      \setlength{\parskip}{\listofparskip}
      \@starttoc{#3}%
    \end{onecolarea}% defines the list of notes' formatting	
  }
  \stylelist[#1]{note}
}

\newcommand{\stylelist}[2][1]{  
  \expandafter\def\csname l@#2\endcsname##1##2{%
    \@dottedtocline{1}
     {0em} % Indent
     {#1\listindent} % Listing number width
     {##1} % Entry text
     {##2}% % Page number
  }
}

%%%
%	Notes
%%%

%%
%	Command \note
%	Declares a new note
%%
\ifnotes
  \newcounter{note} % note counter
  \newcommand{\note}[2][\@empty]{%
    \@ifundefined{if#1}{%
      \expandafter\newif\csname if#1\endcsname%
      \csname #1true\endcsname%
    }{}%
    \if\getcondition{#1}%
      \refstepcounter{note}%
      \notestyle[#1]{\thenote}{#2}%
      \addcontentsline{lon}{note}{\numberline {\thenote} #2}%
    \fi%
  }
\else
  \newcommand{\note}[2][\@empty]{}
\fi


%% defines the note styling
\newcommand{\notestyle}[3][\@empty]{%
  \textcolor{tuescarlet}{%
    {\raisebox{0pt}[0pt]{\scalefont{1.2}\textbf{|}}}%
    \settoheight{\@tempdima}{N}%
    \textbf{\forcetextsc{N}\raisebox{\depth}{\rotatebox[origin=c]{90}{\resizebox{\@tempdima}{!}{\forcetextsc{OTE}}}}\hspace{1pt}#2%
    \ifx#1\@empty\relax\else\space\forcetextsc{#1}\fi%
    }%
    {\raisebox{0pt}[0pt]{\scalefont{1.2}\textbf{|\guillemotright}}}\space%
    #3%
    \space{\raisebox{0pt}[0pt]{\scalefont{1.2}\textbf{\guillemotleft|}}}%
  }%
}

%%% command \hidenotes
\newcommand{\hidenotes}[1]{
    \@ifundefined{if#1}{
      \expandafter\newif\csname if#1\endcsname
      \csname #1false\endcsname
    }{
      \csname #1false\endcsname
    }
}

%%% command \shownotes
\newcommand{\shownotes}[1]{
    \@ifundefined{if#1}{
      \ClassError{TUeStyle}{Note type #1 doesn't exist}{}
    }{
      \csname #1true\endcsname
    }
}



%%
%	Command \listofnotes
%	Produces a list of all notes
%% 
\definelist[1]{note}{lon}



%%%% TODO check if it produces errors
%%%% TODO make option
%%%% TODO disable in final (option) mode
\iflinenum
  \def\parlineval{{\it\color{black!50}l.\space\the\inputlineno.\space}}%
  \storeold{\everypar}
  \newtoks\everypar
  \oldeverypar{\the\everypar%
  \settowidth{\parlinewidth}{\parlineval}%
  \hspace{-\parlinewidth}\parlineval} 
\fi


%%%
%	Footnote styling
%	Marginpar styling
%	Footnote* command creation
%%%

\renewcommand\@makefnmark{\hbox{\@textsuperscript{\color{tuered}\@thefnmark}}}

\let\oldfootnote\footnote
\def\footnote{\@ifstar\@footnoteS\@@footnoteS}
\def\@footnoteS{%
	\xdef\@thefnmark{--}\@footnotetext%
}
\def\@@footnoteS#1{
	\oldfootnote{#1}
}

\let\@oldmakefntext\@makefntext
\long\def\@makefntext#1{%
  \parindent 1em\noindent \hb@xt@ 1.8em{\hss \@makefnmark\space}\style{note}#1}%
  
\let\oldmarginpar\marginpar
\def\marginpar#1{
\oldmarginpar[\raggedleft\style{note}#1]{\raggedright\style{note}#1}
}


%%%
%	Indentation commands
%%%

%%% command \indent
%%  used for inline indents
\storeold{\indent}
\newcommand{\forceindent}{\parindent=.5\tabsize\indent\parindent=0pt\relax} %parindent is temporarily redefined

%%% command \indentpar
%%  used for a single complete indented paragraph
\def\indentpar{
  \parshape 1 .5\tabsize \dimexpr\linewidth-.5\tabsize\relax
}
 	
%%% command \beginindentpar
%%  used to start complete indented paragraphs
\def\beginindentpar{%
   \advance\leftskip .5\tabsize
}

%%% command \endindentpar
%%  used to end complete indented paragraphs
\def\endindentpar{%
    \advance\leftskip -.5\tabsize
  }

%%% command \narrower
%%  used to start complete narrow paragraphs
\def\narrower{% redefine narrower command to the correct size
	\advance\leftskip .5\tabsize
    \advance\rightskip .5\tabsize
  }   

%%% command \narrower
%%  used to end complete narrow paragraphs
\def\wider{% define opposite of \narrower
	\advance\leftskip -.5\tabsize
    \advance\rightskip -.5\tabsize
  }   

%%%
%	Formatting marks
%%%

%%% NOTE requires explicit linebreaking
\newenvironment{showspaces}
  {\par\obeyspaces\obeylines%
  \begingroup\lccode`\~=`\ \lowercase{\endgroup\let~}\AND%
  \begingroup\lccode`\~=`\^^M\lowercase{\endgroup\let~}\AND}%
  {\par}
\newcommand{\AND}{%
  \leaders\hrule height 1.5ex
  \hskip\fontdimen2\font plus \fontdimen3\font minus \fontdimen4\font
}




\renewenvironment{quotation}
           {\list{}{\listparindent \leftmargin%
                    \itemindent    0pt
                    \rightmargin \leftmargin
                    \parsep        \z@ \@plus\p@}%
            \item\relax\style[4]{quote}}
           {\endlist}

\storeoldenv{\quote}
\renewenvironment{quote}{\style[4]{quote}\oldquote}{\endoldquote}


\newenvironment{intro}{\style[2]{intro}}{}



\newif\ifallowaxistile
\allowaxistiletrue


\newcommand{\makeaxis}{
	\if@openright
		\cleardoublepage
	\else\relax\fi

	% The table of contents needs different margins. The package geometry is used to
	% change the margins of certain pages within a document.
	% After the table of contents, they will be reset.
	
  %%%%%%%%\newgeometry{bottom=\layoutbottommargin, twoside=false, right=\rightmargincalculated, left=\@tocleftspace, top=\@toctopspace, headheight=0cm, headsep=0cm,footskip=0cm,marginpar=0cm,marginparsep=0cm}
	\newgeometry{marginparsep=\marginparsepvalue,marginparwidth=\marginparwidthvalue,bindingoffset=0cm,top=\layouttopmargin,left=\layoutleftmargin,right=\frameright,bottom=\layoutbottommargin,twoside=false, headheight=0cm, headsep=0cm,footskip=0cm}

	\fancyhf{}
  \newtoks\mylinetoks%use token register to allow \linebreak etc., this doesn't work in edef
  \mylinetoks={}
	\fancyfoot[L]{%
	\vspace{\dimexpr-\layouttopmargin-\textheight}%
	\makebox[\textwidth][l]{%
		\hspace{-\layoutleftmargin}%
			\begin{pgfpicture}{0mm}{0mm}{\paperwidth}{\paperheight}
        \setlength{\tempboxaheight}{0pt}
        \axisposition{\paperheight-\layouttopmargin+\@axispadding}
        \setlength{\titlepagecontentY}{\axispositionY}
				\drawtueaxes[false]
        \the\mylinetoks
			\end{pgfpicture}
		}
	}
	\newpage\null\thispagestyle{fancy}

\checknextargb}

\newcommand{\checknextargb}{%
  \@ifnextchar\bgroup{%
    \gobblenextb % Check if another "argument" exists
  }{%
    \@ifnextchar[{%
      \gobblenextb@key%
    }{% Ending
      %%%	Begin new page to start layout-change
      \newpage

      %%%	Reset the original values of all margins
      \resetlayout
    }
  }
}


  \newcommand{\gobblenextb}[1]{%
      \mylinetoks=\expandafter{\the\mylinetoks
      \titlepagecontent[right]{#1}{black}{}{}{\titlepagecontentY}{}{.5\baselineskip}
    }
    \allowaxistiletrue
    \checknextargb% Gobble next "argument"
  }
  
  \newlength{\tempaxispos}
  \def\gobblenextb@key[#1]{%
    \ifallowaxistile
      \mylinetoks=\expandafter{\the\mylinetoks
      \titlepagecontent[left]{#1}{tuered}{}{}{\titlepagecontentY}{nospace}{.5\baselineskip}
    }
    \else\ClassError{TUeStyle}{Can't write two titles after each other, use a \string\linebreak (followed by another \string\linebreak for a paragraph ending)}\fi\allowaxistilefalse
    \checknextargb% Gobble next "argument"
  }









\AtBeginDocument{
  %%  Removes extreme spacing between paragraphs
  %   Boxes on every page are of a different height
\raggedbottom
\disablefrontbreak
}

\def\titlebreak{\unskip\space} %unskip to remove space in front 

\setcounter{errorcontextlines}{20}



\newenvironment{minitextpage}{
	\@ifnextchar[{
		\begin{minipage}
	}{
		\begin{minipage}[t]
	}
}{	
	\setlength{\currentfontsize}{\f@size pt}%
 	\vspace{\dimexpr \baselineskip-\currentfontsize \relax}%
 	
 	\xdef\tpd{\the\prevdepth}% requires empty line before
	\end{minipage}
}
