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
\ProvidesClass{TUestyleReportBook}[\filedate\space\fileversion\space TU/e style report & book 2008]
\newcommand{\docname}{TUestyle_Development.cls}





%%%
%   General Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{errorcontextlines}{20}% Show more context of the LaTeX erros

%%%
%   Used Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}% loaded after [T1]{fontenc}
\RequirePackage{xkeyval}
\RequirePackage[table]{xcolor}% loads also »colortbl«
\RequirePackage{pgf}% loads also »xcolor« so loaded after »xcolor«
\RequirePackage[dutch, english]{babel}
\RequirePackage{graphicx}
\RequirePackage{anyfontsize}% allow the usage of any arbitrary font size, stop fallback
\RequirePackage{lmodern}% better i18n Postscript version of Knuth's cm fonts
\RequirePackage{fancyhdr}
\RequirePackage{ulem}

\RequirePackage{accsupp}

\newcommand*{\copyable}[1]{%
  \BeginAccSupp{%
    ActualText=\detokenize{#1},%
    method=escape,
  }%
  #1%
  \EndAccSupp{}%
}

\newcommand*{\unselectable}[1]{%
  \BeginAccSupp{%
    ActualText={},%
    method=escape,
  }%
  #1%
  \EndAccSupp{}%
}

\AtBeginDocument{
  \RequirePackage{refcheck}
  %%% package microtype
  %% activate={true,nocompatibility} - activate protrusion and expansion
  %% final - enable microtype; use "draft" to disable
  %% tracking=true, kerning=true, spacing=true - activate these techniques
  %% factor=1100 - add 10% to the protrusion amount (default is 1000)
  %% stretch=10, shrink=10 - reduce stretchability/shrinkability (default is 20/20)
  \RequirePackage[activate={true,nocompatibility},final,
  tracking=true,
  kerning=true,
  spacing=true,
  factor=1100,stretch=10,shrink=10
  ]{microtype}
  \microtypecontext{spacing=nonfrench}
}

%%%
%   Definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Switch between book / report
%%  (report by default)
\newif\ifbook
\bookfalse

%%% Switch between english / dutch
%%  (english by default)
\newif\ifdutch
\dutchfalse

%%% Use Meta OT fonts
%%  (false by default)
\newif\iftuefonts
\tuefontsfalse

%%% Switch between one-sided / two-sided mode
%%  (one-sided by default for report)
%%  (one-sided by default for book)
\newif\iftwosided

%%% Check to see if user overwrites default twoside or oneside
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

%%% Cover ratio
%%  (4/3 by default)
\def\@coverratio{4/3}

%%% Sectioning shift
%%  (0 by default)
\def\@sectioningshift{0}

%%% "List of" parskip
\newlength{\listofparskip}
\setlength{\listofparskip}{0cm}

%%% Default image paths
\graphicspath{{Images/}{Imgs/}{Img/}{images/}{imgs/}{img/}}


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

%%% command \ifequalii{<defA>}}{<stringB>}{<on true>}{<on false>}
%%  compares a definition with a string for equality
\newcommand{\@ifequalii}[4]{%
  \def\string@a{#2}%
  \ifx\string@a#1%
    #3%
  \else%
    #4%
  \fi%
}

%%% command \if\instring{<item>}{<string>}\fi
%%  checks if <string> contains <item>
\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}
    
%%% command \stringtonum{<stringfraction>}
%%  converts a fraction written as a string: "5/3" to a number
%%  result is stored in a length variable "stringtonumResult"
%%  Note: fractions can only contain integers
\def\stringtonum#1{
  \if\instring{/}{#1}
    \edef\@tempa{#1}%
    \expandafter\expandfraction\@tempa\relax
  \fi
}

  \newlength{\stringtonumResult}
  \def\expandfraction#1/#2\relax{%  
    \setlength{\stringtonumResult}{\dimexpr #1pt / #2 \relax}
  }

%%%	command \ifrealnum{<number1>}{<number2>}{<on 1 > 2>}{<on 1 < 2>}{<on 1 = 2>}
%%	compares two (non) integer numbers (real numbers)
%%  Note: fractions can only contain integers
\newlength{\ifrealnumTempA}
\newlength{\ifrealnumTempB}
\def\ifrealnum #1#2#3#4#5 {%
  \if\instring{/}{#1}
    \stringtonum{#1}
    \setlength{\ifrealnumTempA}{\the\stringtonumResult} % allow for fractions (and calculations)  
  \else
    \setlength{\ifrealnumTempA}{#1 pt}
  \fi
  \if\instring{/}{#2}
    \stringtonum{#2}
    \setlength{\ifrealnumTempB}{\stringtonumResult} % allow for fractions (and calculations) 
  \else
    \setlength{\ifrealnumTempB}{#2 pt}
  \fi
  \ifdim\the\ifrealnumTempA >\the\ifrealnumTempB % on 1 > 2
    #3
  \else
    \ifdim\the\ifrealnumTempA <\the\ifrealnumTempB % on 1 < 2
      #4
    \else % on 1 = 2
      #5
    \fi
  \fi
}

%%% command \PassOptionsToBaseClass is used to pass options to the baseclass
\newcommand{\PassOptionsToBaseClass}[1]{
  \PassOptionsToClass{#1}{book}
  \PassOptionsToClass{#1}{report}
}

%%% Report class option error
\def\ClassErrorNotSupported#1#2{\ClassError{\docname}{Sorry, only #1 is supported!}{Remove the #2 class option}}

%%% 
\newcommand{\DeclareBooleanOptionX}[2][true]{\define@boolkey{\docname}[]{#2}{}\csname#2#1\endcsname}


%%%
%   Class options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
\DeclareOptionX{english}    {\dutchfalse}
\DeclareOptionX{engels}     {\dutchfalse}
\DeclareOptionX{dutch}      {\dutchtrue}
\DeclareOptionX{nederlands} {\dutchtrue}

% load BibLaTeX, and use the BibLaTeX presets
\DeclareBooleanOptionX[false]{biblatex}

% draft mode
\DeclareBooleanOptionX[false]{draft}

% draw draft mark
\DeclareBooleanOptionX[false]{draftmark}

% draw draft line numbering
\DeclareBooleanOptionX[false]{linenum}

%%% TU/e style options

% draw TU/e slogan
\DeclareBooleanOptionX[true]{slogan}

% draw the innovation mark
\DeclareBooleanOptionX[true]{innovation}

% draw the TU/e logo mark
\DeclareBooleanOptionX[true]{logo}

% draw the title in ToC
\DeclareBooleanOptionX[true]{title}

% draw the subtitle in ToC
\DeclareBooleanOptionX[true]{subtitle}

% draw TU/e address
\DeclareBooleanOptionX[true]{address}

% draw the author
\DeclareBooleanOptionX[true]{author}

% draw the date
\DeclareBooleanOptionX[true]{date}

%%% Sectioning options

% use sectioning style
\DeclareBooleanOptionX[true]{sectioningstyling}

% draw "chapter XX" above chaptername
\DeclareBooleanOptionX[false]{chaptername}

% disable pagebreak before sectioning
\DeclareBooleanOptionX[false]{inlinesec}

% left align chapter head
\DeclareBooleanOptionX[false]{leftch}

% Shift all sectioning numbering to left margin,
% widen left margin
% Shift complete chapter heading in left margin
\DeclareBooleanOptionX[false]{runinsec}

% Keep subsectionmark
\DeclareBooleanOptionX[false]{subsecmark}

% Hidden watermark in sectioning
\DeclareBooleanOptionX[false]{watermark}

% use paragraph style
\DeclareBooleanOptionX[true]{paragraphstyling}

% start sectioning counters at zero
\DeclareOptionX{zeroindexed}{\def\@sectioningshift{-1}}

% use auto labeling
\DeclareBooleanOptionX[true]{autolabel}

% show frame
\DeclareBooleanOptionX[false]{showframe}

% draw one-sided / two-sided
\DeclareOptionX{oneside}{\twosidedfalse \twosidedtouchedtrue}
\DeclareOptionX{twoside}{\twosidedtrue  \twosidedtouchedtrue}

% draw one-column / two-column
\DeclareOptionX{onecolumn}{\twocolumnfalse}
\DeclareOptionX{twocolumn}{\twocolumntrue}

%%	Option for cover ratio
%   Ratio has to be bigger than 4:3
\def\@coverratio{4/3}
\DeclareOptionX{coverratio}[4/3]{%
  \ifrealnum{#1}{4/3}{% If the ratio is bigger than 4/3
    \def\@coverratio{#1}
  }{%
    \def\@coverratio{4/3}
  }{}
}

%%  Option for cover alignment
\def\@coveralign{width}
\DeclareOptionX{coveralign}[width]{
    \def\@coveralign{#1}
}

% don't float images
\DeclareBooleanOptionX[false]{nofloat}

% fonts options
\DeclareOptionX{tuefonts}{\tuefontstrue}

%notes options
\newif\ifmarginnotes
\newif\ifnotes
\newif\iftextnotes
\marginnotestrue
\notestrue
\textnotestrue

\define@choicekey*{\docname}{notes}[\val\nr]{textmargin,text,margin,false}[textmargin]{%
  \ifcase\nr\relax
    \marginnotestrue
    \textnotestrue
    \notestrue
  \or
    \marginnotesfalse
    \textnotestrue
    \notestrue
  \or
    \marginnotestrue
    \textnotesfalse
    \notestrue
  \or
    \notesfalse
  \fi
}

%%% Align options
%%  (centered by default)
\def\autocentershort{c}
\def\autocenter{\centering}
\def\autocentercap{\centering}

\define@choicekey*{\docname}{align}[\val\nr]{left,center,right,none}[center]{%
  \ifcase\nr\relax
    \def\autocenter{\raggedright}%
    \def\autocentercap{\raggedright}%
    \def\autocentershort{l}%
  \or
    \def\autocenter{\centering}%
    \def\autocentercap{\centering}%
    \def\autocentershort{c}%
  \or
    \def\autocenter{\raggedleft}%
    \def\autocentercap{\raggedleft}%
    \def\autocentershort{r}%
  \or
    \def\autocenter{\raggedright}%
    \def\autocentercap{\centering}%
    \def\autocentershort{c}%
  \fi
}

% header & footer options

% draw one-sided / two-sided header and footer
\DeclareOptionX{onesidehf}{\onesidehftrue}
\DeclareOptionX{twosidehf}{\onesidehffalse}

%%% Draw faded header and footer
%%  (false by default)
\DeclareBooleanOptionX[false]{fadehf}

% draw chapter in footer
\DeclareBooleanOptionX[false]{sectioningf}

% draw chapter in footer
\DeclareBooleanOptionX[false]{copyf}

% draw last page number in footer
\DeclareBooleanOptionX[false]{endf}

% draw shorter header
\DeclareBooleanOptionX[false]{shorth}

\DeclareBooleanOptionX[true]{leadzero}

%%%% TODO make option per cover
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
\DeclareBooleanOptionX[false]{autolabel}

% Print optimalization
\DeclareBooleanOptionX[false]{print}

% Force indent
\DeclareBooleanOptionX[false]{parindent}

% Force zero parskip
\DeclareBooleanOptionX[true]{parskip}

% Colored sectioning
\DeclareBooleanOptionX[true]{coloredsectioning}

% Colored text
\DeclareBooleanOptionX[true]{coloredtext}

% Mark blank pages
\DeclareBooleanOptionX[false]{markblank}

% Indent after sectioning
\DeclareBooleanOptionX[false]{indentafter}

% Global list of spacing
\DeclareBooleanOptionX[true]{globallistspacing}

% Include TeX sourcecode in the pdf
\DeclareBooleanOptionX[false]{includesource}

% Hyperstyle option
\DeclareOptionX{hyperstyle}{
  \def\hyperstyle{#1}
}
\def\hyperstyle{}

% hide upper sectioning
\DeclareBooleanOptionX[false]{hideuppersectioning}

% font options
\DeclareOptionX{9pt}  {\PassOptionsToBaseClass{10pt}            \def\classFontSize{9} }
\DeclareOptionX{10pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{10}}
\DeclareOptionX{11pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{11}}
\DeclareOptionX{12pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{12}}

  % dafault 9pt
  \PassOptionsToBaseClass{10pt}
  \def\classFontSize{9}

% Show build number
\DeclareBooleanOptionX[false]{buildnumber}

%%% Option processing

% Pass options to underlying classes
\DeclareOptionX*{%
  \PassOptionsToBaseClass{\CurrentOption}
}

% Process all options
\ProcessOptionsX




%%%
%   Utility commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   User commands
%%%

%%% command \rotatepdfpage
%%  Rotates the page in the pdf view, possible values are: 0, 90, 180, 270 etc.
\newcommand{\rotatepdfpage}[1]{\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate #1}}

%%% command \vcenterinclude
%%  Includes something vertically centered
\newcommand{\vcenteredinclude}[1]{\begingroup
\setbox0=\hbox{#1}%
\parbox{\wd0}{\box0}\endgroup}

%%% command \NewPage
%%  Creates an empty - blank - page
\newcommand*\NewPage{\newpage\null\thispagestyle{empty}\newpage}

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

%%% command \superscript{<content>}
%%  correctly writes content as superscript
\newcommand{\superscript}[1]{\@textsuperscript{#1}}
\let\up\superscript

%%% command \subscript{<content>}
%%  correctly writes content as subscript
\newcommand{\subscript}[1]{\@textsubscript{#1}}
\let\down\subscript

%%%	Abbreviation commands
\def\ie/{{\emph{i.e.}},}
\def\viz/{{\emph{viz.}},}
\def\eg/{{\emph{e.g.}},}
\def\etc/{etc.}
\def\etal/{{\emph{et al.}}}
\def\tue/{{\emph{TU/e}}}

%%% Partial derivative command
\newcommand{\pd}[2]{\frac{\partial #1}{\partial #2}}

%%% Set change margin command
%% Usage: \begin{shiftmargin}{<left>}{<right>} \end{shiftmargin}
%%				Where "left" and "right" are units of length
\newenvironment{shiftmargin}[2]{%
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


%%% Command: \shiftcolumns
\newenvironment{shiftcolumn}[2]{%
  \begin{shiftmargin}{\dimexpr -#1\columntabsize}{\dimexpr -#2\columntabsize}
}{%
  \end{shiftmargin}
}

%%%	\crule[<color>]{<width>}{<height>}
\newcommand\crule[3][colorrule]{%
\textcolor{#1}{\rule{#2}{#3}}%
}

%%%	\chrulefill[<color>][<height>]
\def\chrulefill{%
   \@ifnextchar[%
     {\chrulefill@i}
     {\chrulefill@i[colorrule]}%
}
\def\chrulefill@i[#1]{%
   \@ifnextchar[%
     {\chrulefill@ii{#1}}
     {\chrulefill@ii{#1}[0.4pt]}% According to p. 221 of the TeXbook, the height of \hrule is 0.4pt.
}
\def\chrulefill@ii#1[#2]{%
  \begingroup
    \leavevmode\color{#1}\leaders\hrule height #2\hfill\kern\z@
  \endgroup
}

%%%	\chrule[<color>][<height>]
\def\chrule{%
   \@ifnextchar[%
     {\chrule@i}
     {\chrule@i[colorrule]}%
}
\def\chrule@i[#1]{%
   \@ifnextchar[%
     {\chrule@ii{#1}}
     {\chrule@ii{#1}[0.4pt]}% According to p. 221 of the TeXbook, the height of \hrule is 0.4pt.
}
\def\chrule@ii#1[#2]{%
  \begingroup
    \leavevmode\color{#1}\hrule height #2
  \endgroup
}

%\urlstyle{restrictedbreak}
%\urlstyle{allbreak}

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
\newcommand{\stoplistentries}{\storeoldrelax{\addcontentsline}\def\addcontentsline##1##2##3{}}

%%% Command \startlistentries
%	  Re-enables any entries being added to the ToC and other lists
\newcommand{\startlistentries}{\restoreold{\addcontentsline}}

%%%	Command \tocless
%	  Disables adding of the sectioning to the toc, creates label
%	  Example: \tocless\chapter{Title}
\newcommand{\tocless}[2]{\bgroup\stoplistentries #1{#2}\egroup}

%%% TODO needs comments
\newcommand{\labelless}[2]{\bgroup\storeoldrelax{\label}\def\label##1{}%
#1{#2}\egroup}
\newcommand{\stopautolabels}{\autolabelfalse}
\newcommand{\startautolabels}{\autolabeltrue}

%%% Justify command
  \newcommand{\justified}{%
    \rightskip\z@skip%
    \leftskip\z@skip}
    
%%% Roman numerals, starting with 0
\newcommand{\ZeroRoman}[1]{% 0 + \Roman
  \ifcase\value{#1}\relax 0\else% Chapter 0
  \Roman{#1}\fi}% All other chapters

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

%%% command \ifexists{<commandname>}{<on true>}{<on false>}
%%  checks if \<commandname> exists
\newcommand{\ifexists}[1]{
  \ifcsname #1\endcsname
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi%
}

%%% TODO add comments
\def\ifnumber#1{
  \if\relax\detokenize\expandafter{\romannumeral-0#1}\relax		
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi
}

%%% TODO add comments
\def\printisbn#1#2#3#4#5#6#7#8#9{%
    \def\@printisbn##1##2##3##4{%

		\ifnumber{#1}{\printisbnAddToString#1}{}% 01
		\ifnumber{#2}{\printisbnAddToString#2}{}% 02
		\ifnumber{#3}{\printisbnAddToString#3}{}% 03
		\ifnumber{#4}{\printisbnAddToString#4}{}% 04
		\ifnumber{#5}{\printisbnAddToString#5}{}% 05
		\ifnumber{#6}{\printisbnAddToString#6}{}% 06
		\ifnumber{#7}{\printisbnAddToString#7}{}% 07
		\ifnumber{#8}{\printisbnAddToString#8}{}% 08
		\ifnumber{#9}{\printisbnAddToString#9}{}% 09
		\ifnumber{##1}{\printisbnAddToString##1}{}% 10
		\ifnumber{##2}{\printisbnAddToString##2}{}% 11
		\ifnumber{##3}{\printisbnAddToString##3}{}% 12
		\ifnumber{##4}{\printisbnAddToString##4}{}% 13
		
		\def\@@printisbn####1####2####3####4{%
		  \ifnumber{####1}{\printisbnAddToString####1}{}% 14
		  \ifnumber{####2}{\printisbnAddToString####2}{}% 15
		  \ifnumber{####3}{\printisbnAddToString####3}{}% 16
		  \ifnumber{####4}{\printisbnAddToString####4}{}% 17
      \@@@@printisbn{#1#2#3#4#5#6#7#8#9##1##2##3##4####1####2####3####4}
    	}
    \def\@@@printisbn{%
      \@@@@printisbn{#1#2#3#4#5#6#7#8#9##1##2##3##4}
    }
		\@ifnextchar\par{\@@@printisbn}{\@@printisbn}%
    }%
    \@printisbn%
}

\def\@@@@printisbn#1{
    \fbox{\parbox{4cm}{\begin{center}%
    \makebox[\linewidth][c]{\small ISBN\,#1}\\[.1cm]
    \expandafter\barcode\isbnTempNumberSum%
    \end{center}}}
}

    \def\printisbnAddToString#1{
      \edef\isbnTempNumberSum{\isbnTempNumberSum#1}
      \edef\isbnTempNumberSum{\isbnTempNumberSum}
    }

    \def\isbnTempNumberSum{}

    \def\barcode#1#2#3#4#5#6#7{\begingroup%
      \dimen0=0.1em
      \def\stack##1##2{\oalign{##1\cr\hidewidth##2\hidewidth}}%
      \def\0##1{\kern##1\dimen0}%
      \def\1##1{\vrule height.8cm width##1\dimen0}%
      \def\L##1{\ifcase##1\bc3211##1\or\bc2221##1\or\bc2122##1\or\bc1411##1%
        \or\bc1132##1\or\bc1231##1\or\bc1114##1\or\bc1312##1\or\bc1213##1%
        \or\bc3112##1\fi}%
      \def\R##1{\bgroup\let\next\1\let\1\0\let\0\next\L##1\egroup}%
      \def\G##1{\bgroup\let\bc\bcg\L##1\egroup}% reverse
      \def\bc##1##2##3##4##5{\stack{\0##1\1##2\0##3\1##4}##5}%
      \def\bcg##1##2##3##4##5{\stack{\0##4\1##3\0##2\1##1}##5}%
      %% Barcode reverse
      \def\bcR##1##2##3##4##5##6{\R##1\R##2\R##3\R##4\R##5\R##6\11\01\11\09\stack{}{\textgreater}%
      \endgroup}%
      \stack{\09}#1\11\01\11\L#2%
      \ifcase#1\L#3\L#4\L#5\L#6\L#7\or\L#3\G#4\L#5\G#6\G#7%
        \or\L#3\G#4\G#5\L#6\G#7\or\L#3\G#4\G#5\G#6\L#7%
        \or\G#3\L#4\L#5\G#6\G#7\or\G#3\G#4\L#5\L#6\G#7%
        \or\G#3\G#4\G#5\L#6\L#7\or\G#3\L#4\G#5\L#6\G#7%
        \or\G#3\L#4\G#5\G#6\L#7\or\G#3\G#4\L#5\G#6\L#7%
      \fi\01\11\01\11\01\bcR}

%%% environment onecolarea
%%  a temporary one column area
\newenvironment{onecolarea}[2]{%
	\if@twocolumn
	  \@restonecoltrue\onecolumn
	\else
	  \@restonecolfalse#1
	\fi
  \def\onecolareaTemp{#2}
}{%
	\if@restonecol\twocolumn\else\onecolareaTemp\fi
}

%%% command \writeto{<filename>}{<content>}
%%  writes the content to a file
%%  obeys linebreaks
\newwrite\@out
\def\@writeto{\begingroup\obeylines\@writetoaux}
\begingroup\obeylines
\gdef\@writetoaux#1#2{%
  \obeylines%
  \def^^M{^^J}%
  \immediate\openout\@out=#1%
  \immediate\write\@out{%
    #2% <- no new line at the end
  }%
  \immediate\closeout\@out%
  \endgroup%
}
\endgroup


%%% command \readfrom{<filename>}
%%  reads the content from a file named <filename>
\newread\@in
\newcommand{\@readfrom}[1]{%
\openin\@in=#1
\loop\unless\ifeof\@in
    \read\@in to\fileline % Reads a line of the file into \fileline
    \fileline% Do something with \fileline
\repeat
}


%%% command \setfontsize{<fontsize>}}{<linespacing>}
%%  correctly sets the font size and spacing
\newcommand{\setfontsize}[2]{%
  \fontsize{#1}{#2}\selectfont%
  \setlength{\baselineskip}{#2}%
  \ifparskip%
    \setlength{\parskip}{#2}%
  \else%
    \setlength{\parskip}{0pt}%
  \fi%
}

%%% command \providelength{\<name>}
%%  define a new length if not already defined
%%  error if the command passed as argument hasn't been defined with \newlength
\newcommand{\providelength}[1]{%
  \@ifundefined{\expandafter\@gobble\string#1}%
   {% if #1 is undefined, do \newlength
    \typeout{\string\providelength: making new length \string#1}%
    \newlength{#1}%
   }
   {% else check whether #1 is actually a length
    \stringtonumResultheck@checkforlength{#1}%
   }%
}

    \newcommand{\stringtonumResultheck@checkforlength}[1]{%
      % get the first five characters from \meaning#1
      \edef\stringtonumResultheck@temp{\expandafter\stringtonumResultheck@getfive\meaning#1TTTTT$}%
      % compare with the string "\skip"
      \ifx\stringtonumResultheck@temp\stringtonumResultheck@skipstring
        \typeout{\string\providelength: \string#1 already a length}%
      \else
        \@latex@error
          {\string#1 illegal in \string\providelength}
          {\string#1 is defined, but not with \string\newlength}%
      \fi
    }
    \def\stringtonumResultheck@getfive#1#2#3#4#5#6${#1#2#3#4#5}
    \edef\stringtonumResultheck@skipstring{\string\skip}

%%%	command \setnewlength{\<name>}{<value>}
%%	defines new length if the length \<name> doesn't exist yet
%%  sets length to <value>
\def\setnewlength #1#2{
  \providelength{#1}
  \setlength{#1}{\dimexpr#2\relax}
}

%%% TODO add commments
\newcommand\setnewcounter[2]{
  \newcounter{#1}
  \setcounter{#1}{#2}
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

%%%	command \letnewcolor{<name>}{<value>}
%%	defines new color-variable if the color-variable <name> doesn't exist yet
%%  sets color-variable to color: <value>
\newcommand{\letnewcolor}[2]{%
  \@ifundefinedcolor{#1}{\colorlet{#1}{#2}}{}}

%   TODO add comments
\newcommand{\colorbrightness}[1]{%
  \colorlet{mycolor}{.}\color{mycolor!#1!white}
}

%%% \textlcsc{<string>}
%%  Make <string> LowerCase Small Caps
\newcommand\textlcsc[1]{\textsc{\MakeLowercase{#1}}}

\newif\iflc

%%% \forcetextlcsc{<string>}
%%  Make <string> LowerCase Small Caps , used if the font doesn't support it
\def\forcetextlcsc{\lctrue\bgroup\obeyspaces\forcetextscaux}

%%% \forcetextsc  {<string>}
%%  Make <string>           Small Caps , used if the font doesn't support it
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
%%  Scale fontsize in string by scalefactor, keep baselineskip
\newlength{\scalefontTempCurrentFontsize}
\def\scalefont#1{%
    \setlength{\scalefontTempCurrentFontsize}{\f@size pt}%
    \setfontsize{#1\scalefontTempCurrentFontsize}{\baselineskip}%
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
%%  true on <counter>=""
\def\ifnumber#1{%
  \afterassignment\get@args\count@=0#1\hfuzz#1\hfuzz}
\def\get@args#1\hfuzz#2\hfuzz{%
  \if\relax\detokenize{#1}\relax
    \expandafter\@firstoftwo
  \else
    \expandafter\@secondoftwo
  \fi
}


\def\@authordelimFirst{,\titlebreak}
\def\@@authordelimSecond{ \&\titlebreak}
\def\@author{\printdata\author{\@authordelimFirst}{\@@authordelimSecond}}

\newcommand{\authordelim}[1]{%
  \@ifnextchar\bgroup{
    \@authordelim{#1}
  }{
    \def\@authordelimFirst{#1}
    \def\@@authordelimSecond{#1}
  }
}
        \newcommand{\@authordelim}[2]{
            \def\@authordelimFirst{#1}
            \def\@@authordelimSecond{#2}
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


%%% \getstring[<index>]\<name>
%%  prints data contained in \data:<name>:<index>
\def\getdata[#1]#2{
  \ifcsname data:\string#2:#1\endcsname
    \csname data:\string#2:#1\endcsname%
  \else
    \ClassError{Tuestyle}{data:\string#2:#1 undefined}{}
  \fi
}

\def\getdata[#1]#2{
  \ifcsname data:\string#2:#1\endcsname
    \def\tempdata{\csname data:\string#2:#1\endcsname}%
      \edef\tempdata{\noexpand\scantokens{\tempdata}}%
    \unskip\tempdata% Unskip to prevent unwanted spaces
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
  \dataprinttrue%
  \def\tempname{\string#1}%
  \@ifnextchar\bgroup{\firstdelim}{\initiateprint{\tempname}}% If delimiter: set it, else, print
}

%%% \printstring{\<name>}
%%  prints data contained in \all:<name> as an active string,
%%  has be called after \preprintstring
\newcommand{\printstring}[1]{%
  \def\tempdata{\csname all:\cs@to@str#1\endcsname}%
  \edef\tempdata{\noexpand\scantokens{\tempdata}}%
  \tempdata%
}

%%%% TODO add descrp
%%  prints data contained in \all:<name> as a string, needed when commands can't be expanded,
%%  has be called after \preprintstring
\newcommand{\safeprintstring}[1]{%
  \csname all:\cs@to@str#1\endcsname
}

%%% \preprintstring{\<name>}{<global delimiter optional>}{<last delimiter optional>}
%%  prints data contained in \data:<name>:<range> to \all:<name>
\newcommand{\preprintstring}[1]{%
  \def\tempname{\string#1}%
  \dataprintfalse%
  \def\delimi{, }%
  \def\delimii{ \& }%
  \@ifnextchar\bgroup{\firstdelim}{\initiateprint{\tempname}}% If delimiter: set it, else, print
}

    \def\seconddelim#1{%
      \def\delimii{#1}%
      \initiateprint{\tempname}% Print
    }

    \def\firstdelim#1{%
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
      \ifnum \thetempcount < \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname\relax%
        \ifnum \thetempcount > 0% Use first delimiter in front of values, after the first value
          \printandwritedata[\delimi]\relax% Print current value
        \else%
          \printandwritedata\relax% Print first value
        \fi%
        \addtocounter{tempcount}{1}%
        \printdatainternal#1% Loop
      \else%
        \ifnum \thetempcount = \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname\relax% % Use second delimiter in front of the last value
          \ifnum \thetempcount > 0% Check if this value is not the first AND last
            \printandwritedata[\delimii]% Print last value
          \else%
            \printandwritedata\relax%
          \fi
        \fi
      \fi
    }
    
    \newcommand{\printandwritedata}[1][]{%
      \ifdataprint%
          \def\tempdata{\csname data:\tmp:\thetempcount\endcsname}%
          \edef\tempdata{\noexpand\scantokens{\tempdata}}%
          \unskip#1\tempdata% Unskip to prevent unwanted spaces
      \fi%
      \expandafter\edef\csname all:\expandafter\cs@to@str\tmp\expandafter\endcsname{%
        \csname all:\expandafter\cs@to@str\tmp\expandafter\endcsname%
        #1\csname data:\tmp:\thetempcount\endcsname%
      }%
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
              \pgfsetfillopacity{0.1}\color{colorbody}%
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
%   Don't use it to copy environments: no garanties, doesn't work with optional arguments
\newcommand{\storeoldenv}[1]{%
  \expandafter\let\csname old\expandafter\cs@to@str\string#1\endcsname#1%
  \expandafter\let\csname endold\expandafter\cs@to@str\string#1\expandafter\endcsname%
    \csname end\expandafter\cs@to@str\string#1\endcsname%
}

%%% \storeoldrelaxenv{\<name>}
%%  Stores the environment \begin{<name>}\end{<name>} to \begin{old<name>}\end{old<name>} and relaxes \begin{<name>}\end{<name>}
%   Don't use it to copy environments: no garanties, doesn't work with optional arguments
\newcommand{\storeoldrelaxenv}[1]{%
    \storeoldenv{#1}%
    \let#1\relax%
    \expandafter\let\csname end\expandafter\cs@to@str\string#1\endcsname\relax%
}

%%% \storeold{\<name>}
%%  Stores \<name> to \old<name>
%   Don't use it to copy environments: no garanties, doesn't work with optional arguments
\newcommand{\storeold}[1]{%
  \expandafter\let\csname old\expandafter\cs@to@str\string#1\endcsname#1%
}

%%% \restoreold{\<name>}
%%  Restores \old<name> to \<name>
%   Don't use it to copy environments: no garanties, doesn't work with optional arguments
\newcommand{\restoreold}[1]{%
  \expandafter\let\expandafter#1\csname old\expandafter\cs@to@str\string#1\endcsname%
}

%%% \storeoldrelax{\<name>}
%%  Stores \<name> to \old<name>, and relaxes \<name>
%   Don't use it to copy environments: no garanties, doesn't work with optional arguments
\newcommand{\storeoldrelax}[1]{%
  \storeold{#1}%
  \let#1\relax%
}

%%% command \disablepageskip
%%	Store and disable clearpage, cleardoublepage & newpage commands
\newcommand{\disablepageskip}{%
  \storeoldrelax{\clearpage}%
	\storeoldrelax{\cleardoublepage}%
	\storeoldrelax{\newpage}%
}

%%% command \enablepageskip
%%  Re-enable         clearpage, cleardoublepage & newpage commands
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
  }{\ClassError{Tuestyle}{Label type #1 doesn't exist}{}}}}}}}}}}}}}}}
}


%%% \levelselector{\<name of sectioning>}
%%  Returns sectioning level

% Command                              Level   Comment
% ------------------------------------------------------------------------
% \part{part}                         -1       not in letters
% \chapter{chapter}                    0       only books and reports
% \section{section}                    1       not in letters
% \subsection{subsection}              2       not in letters
% \subsubsection{subsubsection}        3       not in letters
% \paragraph{paragraph}                4       not in letters
% \subparagraph{subparagraph}          5       not in letters

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
  }{\ClassError{Tuestyle}{Sectioning #1 doesn't exist}{}}}}}}}}
}


%%% \DivideLengths{\<name>}{\<name>}
%%  Divides two given lengths
\newcommand*{\DivideLengths}[2]{%
  \strip@pt\dimexpr\number\numexpr\number\dimexpr#1\relax*65536/\number\dimexpr#2\relax\relax sp\relax
}

%%% command \slantedpar{<integer #lines>}{<paragraph width>}
%%  initiates parshape settings
\newcounter{slantedparTempLineNum}

\newcommand{\slantedpar}[3][left]{
  \setnewlength{\interval}{\@shiftratio\baselineskip}
  % Definition to hold the result calculations as strings
  \long\edef\slantedparTempHold{}
  \setcounter{slantedparTempLineNum}{0}
  \slantedparvalues{#1}{#2}{#2}{#3}
  \parshape=#2
  \slantedparTempHold 
}

    %%  Command to calculate current line width for 
    %%  text on the left
    \newcommand{\axislinewidthleft}[3]{%
      0cm \dimexpr #3-#2\interval+#1\interval \relax%
    }
    
    %%  Command to calculate current line width for 
    %%  text on the right
    \newcommand{\axislinewidthright}[3]{%
      \dimexpr-#2\interval+#1\interval\relax \dimexpr #3+#2\interval-#1\interval \relax%
    }

    %%  loop command, also expanding \slantedparTempHold with string result
    \newcommand{\slantedparvalues}[4]{%
    \@ifequal{#1}{left}{
      \long\edef\slantedparTempHold{%
        \slantedparTempHold%
        \axislinewidthleft{#2}{#3}{#4}%
      }
    }{
      \long\edef\slantedparTempHold{%
        \slantedparTempHold%
        \axislinewidthright{#2}{#3}{#4}%
      }
    }
      \setcounter{slantedparTempLineNum}{#2}
      \addtocounter{slantedparTempLineNum}{-1}
      \ifnum #2 > 0 %loop if we are not out of lines
        \slantedparvalues{#1}{\theslantedparTempLineNum}{#3}{#4}
      \else\fi
    }

%%% command \resetaxisposition
\newcommand{\resetaxisposition}{
  \setlength{\tempboxaheight}{0pt}
}
    
%%% command \axispositionX{<y-position from bottom>}
%%  initiates parshape settings
\newlength{\axispositionY}
\newlength{\axispositionX}
\newcommand{\setaxisposition}[1]{%
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
    
    \def\sentencedelimi{\titlebreak}
    \def\sentencedelimii{\linebreak}
    
    \long\def\partitionstringonbreaks#1{%
      \expandafter\edef\expandafter\tempa{\detokenize{#1}}%
      \expandafter\edef\expandafter\tempb{\expandafter\string\sentencedelimi}%
      \expandafter\edef\expandafter\tempc{\expandafter\string\sentencedelimii}%
          \ifdim \@tempdima > 14000pt % 16383.99999pt; the largest legal dimension.
            \def\holder{}
            \setlength{\longestsentence}{\linewidth}%
          \fi
          \settowidth{\@tempdima}{\holder}%
          %\ClassWarning{TUeStyle}{\the\@tempdima}{}
          %\ClassWarning{TUeStyle}{#1}{}
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
      \ifdim \@tempdima > \longestsentence%
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

%%% command \Repeat{<iterations>}{<content>}
%%  iterates <content> <iterations> times
\newcommand{\Repeat}[1]{%
    \expandafter\@Repeat\expandafter{\the\numexpr #1\relax}%
}

    \def\@Repeat#1{%
        \ifnum#1>0
            \expandafter\@@Repeat\expandafter{\the\numexpr #1-1\expandafter\relax\expandafter}%
        \else%
            \expandafter\@gobble
        \fi
    }
    \def\@@Repeat#1#2{%
        \@Repeat{#1}{#2}#2%
    }


%%%
%   Internal debug commands
%%%

\newcommand{\stripmacro}[1]{\expandafter\begingroup\escapechar=-1\edef\x{\endgroup\string#1}\x}

%%% Define showlength command
\newcommand{\showlength}[2]{\textbf{\stripmacro{#2}}:\space\convertto{#1}{#2}\space#1}
        \def\convertto#1#2{\strip@pt\dimexpr #2*65536/\number\dimexpr 1#1}

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

%%%
%	Set last page label
%%%

%% Has to be the above any writeout AtEndDocument as the "labels have changed warning" will be triggered otherwise.
\AtEndDocument{
	\label{lastdocpage}
}

%%%
%   Depending packages
%%%

\ifshowframe
  \RequirePackage[absolute,showboxes]{textpos}% also loads »atbegshi«
\else
  \RequirePackage[absolute          ]{textpos}% also loads »atbegshi«
\fi
\textblockorigin{0pt}{0pt}

\RequirePackage{caption}% loaded after document class

\RequirePackage{csquotes}% loaded after document class
\setquotestyle{american}

\iftuefonts\relax\else
  \RequirePackage{arial}
\fi

\RequirePackage[hypertexnames=false]{hyperref}% Option hypertexnames=false prevents table of contents link collision with two sectioning items with same number and name
\DeclareUrlCommand\Code{\urlstyle{same}}
\urlstyle{allbreak}%%% TODO option

\ifshowframe
  \RequirePackage[a4paper,showframe,showcrop]{geometry}
\else
  \RequirePackage[a4paper                   ]{geometry}
\fi
  
\ifbiblatex
  \RequirePackage[backref=true]{biblatex}
  \@ifpackagelater{babel}{2016/04/23}{}{%
      \PackageError{TUeStyle}{Your babel package is too old for BibTeX}{}%
  }
\fi

\ifnofloat
  \RequirePackage{float}
\fi

\ifinlinesec
  \RequirePackage{placeins}
\fi

\ifparskip
  \RequirePackage{parskip}% Making adjustments to the spacing of lists and other structures which use paragraph spacing, so they don't get too far apart
\fi

\ifincludesource
  \RequirePackage{embedfile}
  \embedfile[desc={Source code (plain-TeX)}]{\jobname.tex}
\fi

\ifindentafter% done after loading of packages, so it isn't overwritten
 \let\@afterindentfalse\@afterindenttrue
 \@afterindenttrue
\fi

\ifruninsec
  \def\gridleftcolumns{2}
  \def\@seccntformat#1{\llap{\protect\makebox[2\columntabsize][l]{\@ifundefinedcolor{colornumsec}{}{\color{colornumsec}}\csname the#1\endcsname}}}
\fi

%%% TODO use
%    \def\@seccntformat#1{\@ifundefined{#1@cntformat}%
%   {\csname the#1\endcsname\quad}%    default
%   {\csname #1@cntformat\endcsname}}% enable indiv. control
%\newcommand\section@cntformat{\thesection\quad} 

\ifleftch
  \def\gridleftcolumns{2}
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
    \ifx\theextrafo\empty\relax\else
      \getlongestsentence{\theextrafo}
      \ifnum \thenumberofsentences > \thefooterlines
        \setcounter{footerlines}{\thenumberofsentences}
      \fi
    \fi
  \endgroup  
  \ifexists{footskipvalue}{}{
    \setnewlength{\footskipvalue}{\thefooterlines\baselineskip + \headfootsep}
  }
  \ifexists{layoutbottommargin}{}{
    \setnewlength{\layoutbottommargin}{15.75mm+\footskipvalue} % 15.75mm
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
  \setnewlength{\layouttopmargin}{20.25mm+\headheight+\headsepvalue} % 20.25mm
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

%%% Columntab size
\newlength{\columntabsize}
\setlength{\columntabsize}{\dimexpr \gridcolumnwidth + \gridgutterwidth}

%%% Tab size
\newlength{\tabsize}
\setlength{\tabsize}{\dimexpr .5\columntabsize}

%%% Textpos grid intervals
\setlength{\TPHorizModule}{\columntabsize}
\setlength{\TPVertModule}{\columntabsize}

\newcommand{\showtab}[1][1]{%
  \Repeat{#1}{%
    \crule[tuered]{\dimexpr \tabsize-\gridgutterwidth}{5pt}%
    \crule[tueblue]{\gridgutterwidth}{5pt}%
  }
}

\newcommand{\showcolumntab}[1][1]{%
  \Repeat{#1}{%
    \crule[tuered]{\gridcolumnwidth}{5pt}%
    \crule[tueblue]{\gridgutterwidth}{5pt}%
  }%
}

\ifruninsec
  \setnewlength{\chaptershift}{2\columntabsize}
\else
  \ifleftch
    \setnewlength{\chaptershift}{2\columntabsize}
  \else
    \setnewlength{\chaptershift}{0pt}
  \fi
\fi


%%%
%   Layout
%%%
\newcommand{\resethfwidth}{\fancy@setoffs}%\resethfwidth which calls the fancyhdr macro for defining the header and footer widths.


\ifruninsec
  \def\asymmetricvalue{asymmetric}
\else
  \def\asymmetricvalue{}
\fi



%%% TODO move
\RequirePackage{refcount}
\newcounter{oddevencount}

\newcommand{\ifoddpagelabel}{%
  \label{pageOddEven:\theoddevencount}%
}

\def\ifoddpage{\stepcounter{oddevencount}\@ifstar\@ifoddpage\@@ifoddpage}
\newcommand{\@@ifoddpage}{%
  \label{pageOddEven:\theoddevencount}%
  \@ifoddpage%
}
\newcommand{\@ifoddpage}[2]{%
  \ifodd\getpagerefnumber{pageOddEven:\theoddevencount}%
  	#1%
  \else%
    #2%
  \fi%
}



%%% TODO move
\storeold{\@outputpage}
\gdef\@oddevengeometry{}% Initialize \@oddevengeometry
\def\oddevengeometry#1#2{%
  \def\@outputpage{\expandafter\@oddevengeometry\old@outputpage}% Execute our @thisgeometry routine before the original @outputpage
  \gdef\@oddevengeometry{% Create @thisgeometry to store if statement and geometry options
  \ifodd\thepage\relax% Doesn't use \ifoddpage because it takes place just before the outputpage routine, this would place the label on the previous page
      \expandafter\newgeometry\expandafter{#1}\relax%
  \else
      \expandafter\newgeometry\expandafter{#2}\relax%
  \fi}
}
\def\normalgeometry{%
\ifexists{old@outputpage}{\restoreold{\@outputpage}}{}
}


\AtBeginDocument{
\resetlayout
}


%%%
% Set original margins
%%%
\newcommand{\calculatelayout}{
  \setnewlength{\marginparsepvalue}{\marginparL}
  \setnewlength{\marginparwidthvalue}{\dimexpr \frameright - \marginparL - \marginparR \relax}
  \setnewlength{\rightmargincalculated}{\dimexpr \layoutrightmargin + \marginparL + \marginparwidth \relax}
  
  \ifshowframe
    \def\showframevalue{showframe}
    \def\showcropvalue{showcrop}
  \else
    \def\showframevalue{}
    \def\showcropvalue{}
  \fi
  
      \edef\TUE@GeometryOptionsRightSideGENERAL{%
        right           = \frameright,%           Next to margin
        marginparsep    = \marginparsepvalue,%
        marginparwidth  = \marginparwidthvalue,%
      }
      
      \edef\TUE@GeometryOptionsLeftSideGENERAL{%
        left            = \frameleft,%
      }

      \edef\TUE@GeometryOptionsTopSideGENERAL{%
        top             = \layouttopmargin,%
      }
      
  \edef\TUE@GeometryOptionsBASIC{% Basic values which stay the same for all pages except the titlepage
    bottom          = \layoutbottommargin,%
    footskip        = \footskipvalue,%
    headsep         = \headsepvalue,%
    bindingoffset   = 0cm,%
    headheight      = 16pt,%
    \showframevalue,%
    \showcropvalue,%
    \asymmetricvalue,%
  }
  
      \edef\TUE@GeometryOptionsGENERAL{%
        \TUE@GeometryOptionsBASIC,%
        \TUE@GeometryOptionsTopSideGENERAL,%
        \TUE@GeometryOptionsRightSideGENERAL,%
        \TUE@GeometryOptionsLeftSideGENERAL,%
      }
      
  %%% General geometry twoside
  \edef\TUE@GeometryOptionsTwosideGENERAL{%
    \TUE@GeometryOptionsGENERAL,%
    twoside=true,%    
  }
  
  %%% General geometry oneside
  \edef\TUE@GeometryOptionsOnesideGENERAL{%
    \TUE@GeometryOptionsGENERAL,%
    twoside=false,%    
  }
  
      \edef\TUE@GeometryOptionsLefSideCONTENT{%
        left=\@tocleftspace,%
      }
      
      \edef\TUE@GeometryOptionsTopSideCONTENT{%
        top=\@toctopspace,%
      }
      
      \edef\TUE@GeometryOptionsCONTENT{%
        \TUE@GeometryOptionsBASIC,%
        \TUE@GeometryOptionsTopSideCONTENT,%
        \TUE@GeometryOptionsLefSideCONTENT,%
        marginparsep    = 0pt,%
        marginparwidth  = 0pt,%
        twoside=false,%
      }
  
  %%% Odd content geometry
  \edef\TUE@GeometryOptionsOddCONTENT{%
    \TUE@GeometryOptionsCONTENT,%
    right           = \frameleft,%
  }
  
  %%% Even content geometry
  \edef\TUE@GeometryOptionsEvenCONTENT{%
    \TUE@GeometryOptionsCONTENT,%
    right           = \frameright,%
  }
  
      \edef\TUE@GeometryOptionsLefSideFULL{%
        left=\layoutleftmargin,%
      }
      
      \edef\TUE@GeometryOptionsFULL{%
        \TUE@GeometryOptionsBASIC,%
        \TUE@GeometryOptionsTopSideGENERAL,%
        \TUE@GeometryOptionsLefSideFULL,%
        marginparsep    = 0pt,%
        marginparwidth  = 0pt,%
        twoside=false,%
      }
  
  %%% Odd content geometry
  \edef\TUE@GeometryOptionsOddFULL{%
    \TUE@GeometryOptionsFULL,%
    right           = \frameleft,%
  }
  
  %%% Even content geometry
  \edef\TUE@GeometryOptionsEvenFULL{%
    \TUE@GeometryOptionsFULL,%
    right           = \frameright,%
  }
  
  %%% Titlepage geometry
  \edef\TUE@GeometryOptionsTITLEPAGE{%
    \TUE@GeometryOptionsTopSideCONTENT,%
    \TUE@GeometryOptionsLefSideCONTENT,%
    bottom=\footeroffset,%
    right=\layoutrightmargin,%
    \showframevalue,%
    \showcropvalue,%
    headheight=0pt,%
    headsep=0pt,%
    marginparsep    = 0pt,%
    marginparwidth  = 0pt,%
    twoside=false,%
  }
}

\newcommand{\initializelayout}{
  \normalgeometry
  \disablepageskip
  \calculatelayout
}

\newcommand{\finalizelayout}{
  \enablepageskip
  \resethfwidth
}

\newcommand{\resetlayout}{
  \initializelayout
  %	If the document uses the "twoside" option
	\iftwosided
		\expandafter\newgeometry\expandafter{\TUE@GeometryOptionsTwosideGENERAL}
	%	If the document uses the "oneside" option
	\else
		\expandafter\newgeometry\expandafter{\TUE@GeometryOptionsOnesideGENERAL}
	\fi
  \finalizelayout
  \sethfbasic
}

\newcommand{\setoddcontentlayout}{
  \initializelayout
  \ifodd\thepage
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsOddCONTENT}
  \else
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsEvenCONTENT}
  \fi
  \finalizelayout
  \resethf
  \oddevengeometry{\TUE@GeometryOptionsEvenCONTENT}{\TUE@GeometryOptionsOddCONTENT}\clearpage
}

\newcommand{\setfulloddlayout}{
  \initializelayout
  \ifodd\thepage
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsOddFULL}
  \else
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsEvenFULL}
  \fi
  \finalizelayout
  \resethf
  \oddevengeometry{\TUE@GeometryOptionsEvenFULL}{\TUE@GeometryOptionsOddFULL}\clearpage
  \ifodd\thepage%%% TODO repeat every page to check oddeven
    \setnewlength{\titlepagecontentright}{\frameright}
  \else
    \setnewlength{\titlepagecontentright}{\frameleft}
  \fi
}

\newcommand{\settitlelayout}{
  \initializelayout
  \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsTITLEPAGE}
  \finalizelayout
  \resethf
  \setnewlength{\titlepagecontentright}{\layoutrightmargin}
}




\AtBeginDocument{
\begingroup %begingroup not to overwrite earlier \preprintstring\author
  \preprintstring\author{,}{ \& }
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

\ifdutch
  \AtBeginDocument{
    \selectlanguage{dutch}
  }
\else
  \AtBeginDocument{
    \selectlanguage{english}
  }
\fi


%%%
%   TU/e
%%%

\newvariable{tuesite}{www.tue.nl}
\newvariable{phonenumber}{+31 (0)40 247 9111}
\newvariable{phonenumberlabel}{Tel.}
\newvariable{fullname}{Technische Universiteit \textbf{Eindhoven} University of Technology}
\newvariable{abbrname}{TU/e}% Not used, yet

\ifdutch
  \newvariable{shortname}{Technische Universiteit \textbf{Eindhoven}}
\else
  \newvariable{shortname}{\textbf{Eindhoven} University of Technology}
\fi

%%%
%   Labels
%%%

%%% General labels
\ifdutch
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
\else
	\newvariable{copyholderlabel}{Copyholder}
	\newvariable{authorlabel}{Author}
	\newvariable{orderissuerlabel}{Order issuer}
	\newvariable{referencelabel}{Reference}
	\newvariable{datelabel}{Date}
	\newvariable{versionlabel}{Version}
	\newvariable{Netherlands}{The Netherlands}
	\newvariable{PObox}{P.O. Box}
  \newvariable{visitingaddresslabel}{Visiting adress}
  \newvariable{postaladdresslabel}{Postal adress}
  \newvariable{titlelabel}{Title}
  \newvariable{subtitlelabel}{Subtitle}
\fi


%%% Note labels
\ifdutch
	\newvariable{notesname}{Notitie}
	\newvariable{listofnotesname}{Lijst van Notities}
\else
	\newvariable{notesname}{Note}
	\newvariable{listofnotesname}{List of Notes}
\fi

%%% Figures and tables labels
\ifdutch
	\newvariable{listoffiguresname}{Lijst van Illustraties}
	\newvariable{listoftablesname}{Lijst van Tabellen}
\else
	\newvariable{listoffiguresname}{List of Figures}
	\newvariable{listoftablesname}{List of Tables}
\fi

%%% Equation labels
\ifdutch
	\newvariable{equationsname}{Vergelijking}
	\newvariable{listofequationsname}{Lijst van Vergelijkingen}
\else
	\newvariable{equationsname}{Equation}
	\newvariable{listofequationsname}{List of Equations}
\fi


%%%
%   Drafting options
%%%





%%%
%   Header/footer options
%%%

%%% command \extraf{<string>} & \extrah{<string>}
%%  Adds custom footer and header data
\newvariable{extraf}{}
\newvariable{extrah}{}

%%% command \extrafo{<string>} & \extraho{<string>}
%%  Adds custom footer and header data
\newvariable{extrafo}{}
\newvariable{extraho}{}

%%% TODO move
%%% Redefine caption to enable alignment options
\DeclareCaptionFormat{caption}{\autocentercap\style{caption}#1#2#3}
\captionsetup{format=caption,singlelinecheck=off,margin=0pt,labelsep=endash}

%%%
%   Tabs
%%%

%%% command \tab[<integer>]
%%  goes to specified tab
\newcommand{\tab}[1][1]{%
	\noindent\leavevmode\\*[-\baselineskip]\hspace*{#1\tabsize}%
}



%%%
%   TU/e style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%   Fonts
%%%

% Arial
\iftuefonts%
  \renewcommand{\sfdefault}{ua1}% load TUE font family
\else
  \renewcommand{\sfdefault}{ua1}
\fi
\renewcommand{\rmdefault}{lmr}
\renewcommand{\ttdefault}{pcr}
\renewcommand\familydefault{\sfdefault}

\newcommand{\titlefamilydefault}{\sffamily}
\newcommand{\bodyfamilydefault}{\sffamily}

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
\DeclareFontShape{T1}{ua1}{sb}{n}{ <-> ua1b8t}{} %map semi bold to bold

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
\colorlet{tuewarmred}{PMSwarmred}% Old color name, not used by style

% red
\definecolor{PMS206}{rgb}{0.839,0.000,0.290}
\colorlet{tuered}{PMS206}

% cyan
\definecolor{PMSprocesscyan}{rgb}{0.000,0.635,0.871}
\colorlet{tuecyan}{PMSprocesscyan}
\colorlet{tueprocesscyan}{PMSprocesscyan}% Old color name, not used by style

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
\colorlet{tuelightgreen}{PMS396}% Old color name, not used by style

% green
\definecolor{PMS375}{rgb}{0.518,0.824,0.000}
\colorlet{tuegreen}{PMS375}

% teal
\definecolor{PMSgreen}{rgb}{0.000,0.675,0.510}
\colorlet{tueteal}{PMSgreen}

% azure
\definecolor{PMS3135}{rgb}{0.000,0.573,0.710}
\colorlet{tueazure}{PMS3135}



%%%% TODO for all colors: If undefined, define at begin document

%%%
%   Document colors
%%%
  \AtBeginDocument{
  \letnewcolor{colorbody}{black}
  \letnewcolor{colormain}{tuered}
  \letnewcolor{coloraccent}{tuedarkblue}
  \letnewcolor{colorextra}{tuecyan}
  \letnewcolor{colorhighlight}{colormain!20!white}
  \letnewcolor{colorwhite}{white}
  \letnewcolor{colorgray}{colorbody!50}
  \letnewcolor{colorlightgray}{colorgray!12.5}
  \letnewcolor{colorpayoff}{tuedarkblue}
  \letnewcolor{coloraxis}{tuered}
  \letnewcolor{colorbackground}{white}

  %%% body colors
  \iffadehf
    \letnewcolor{hfcolor}{colorgray}
  \else
    \letnewcolor{hfcolor}{colorbody}
  \fi
  \letnewcolor{colorpromotional}{colorbody}
  \letnewcolor{colorcaption}{colorbody}
  \letnewcolor{colornote}{colorbody}

  \ifcoloredsectioning
    %%% heading colors
    \letnewcolor{colorheading}{colormain}
    \letnewcolor{colorsubheading}{colorheading}
    % colornumsec, if not defined -> heading color
  \else
    %%% heading colors
    \letnewcolor{colorheading}{colorbody}
    \letnewcolor{colorsubheading}{colorbody}
  \fi

  \ifcoloredtext
    %%% text colors
    \letnewcolor{colorintro}{coloraccent}
    \letnewcolor{colorquote}{coloraccent}
    \letnewcolor{colorinfo}{coloraccent}
    \letnewcolor{colorlabel}{colormain}
    \letnewcolor{colorlink}{colorhighlight}
  \else
    %%% text colors
    \letnewcolor{colorintro}{colorbody}
    \letnewcolor{colorquote}{colorbody}
    \letnewcolor{colorinfo}{colorbody}
    \letnewcolor{colorlabel}{colormain}
    \letnewcolor{colorlink}{colorgray}
  \fi
  
  \letnewcolor{colorquoteaccent}{colorquote!40!white}

  %%% element colors
  \letnewcolor{tablehighlight}{colormain}
  \letnewcolor{tablerule}{tablehighlight}
  \letnewcolor{tablewhite}{colorwhite}
  \letnewcolor{tableblack}{colorbody}
  \letnewcolor{tableodd}{colorlightgray}
  \letnewcolor{tableeven}{colorwhite}
  %
  \letnewcolor{linkcolor}{colormain}
  \letnewcolor{citecolor}{colorextra}
  \letnewcolor{urlcolor}{coloraccent}
  %
  \letnewcolor{colorrule}{colormain}
  %
  \letnewcolor{notescolor}{colormain}
  %
  \letnewcolor{colorfootrule}{colormain}
}

%%%
%   Font size utility commands
%%%

\def\setNormalsize#1#2#3#4#5#6#7#8#9{
  \renewcommand\normalsize{%
     \@setfontsize\normalsize{#1}{#2}%
     \abovedisplayskip #3\p@ \@plus#4\p@ \@minus#5\p@
     \abovedisplayshortskip \z@ \@plus#6\p@
     \belowdisplayshortskip #7\p@ \@plus#8\p@ \@minus#9\p@
     \belowdisplayskip \abovedisplayskip
     \let\@listi\@listI}
  \normalsize
}

\def\setOthersize#1#2#3#4#5#6#7#8#9{%
    \def\@setOthersize##1##2##3##4##5##6##7{%
  \expandafter\renewcommand\csname#1\endcsname{%
     \expandafter\@setfontsize\csname#1\endcsname{#2}{#3}%
     \abovedisplayskip #4\p@ \@plus#5\p@ \@minus#6\p@
     \abovedisplayshortskip \z@ \@plus#7\p@
     \belowdisplayshortskip #8\p@ \@plus#9\p@ \@minus##1\p@
     \def\@listi{\leftmargin\leftmargini
                 \topsep ##2\p@ \@plus##3\p@ \@minus##4\p@
                 \parsep ##5\p@ \@plus##6\p@ \@minus##7\p@
                 \itemsep \parsep}%
     \belowdisplayskip \abovedisplayskip
  }
}\@setOthersize
}

%%% TODO add comments
\ifnum \classFontSize = 9 
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSizeName{#1}{#2}{#3}
  }
\else \ifnum \classFontSize = 10
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSizeName{#1}{#4}{#5}
  }
\else \ifnum \classFontSize = 11
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSizeName{#1}{#6}{#7}
  }
\else \ifnum \classFontSize = 12
  \newcommand{\setclassFontSize}[9]{
    \@setClassFontSizeName{#1}{#8}{#9}
  }
\fi\fi\fi\fi

    %%% TODO add comments
    \newcommand{\@setClassFontSizeName}[3]{
        \expandafter\def\csname selectedfont@#1\endcsname{#2bp}
        \expandafter\def\csname selectedbls@#1\endcsname{#3bp}
    }


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
%   Font size commands
%%%

%                                     Fontdim.        \abovedisplayskip   \abovedisplayshortskip  \belowdisplayshortskip  \topsep           \parsep
%                                     Size    BL      Base  +     -       Plus                    Base  +     -           Base  +     -     Base  +     -
\ifnum\classFontSize = 9
  \setNormalsize                      {9.25}  {12.75} {10}  {2}   {5}     {3}                     {6}   {3}   {3}
  \setOthersize   {small}             {8.5}   {11.5}  {8.5} {3}   {4}     {2}                     {4}   {2}   {2}         {4}   {2}   {2}   {2}   {1}   {1}
  \setOthersize   {footnotesize}      {7.75}  {11.25} {6}   {2}   {4}     {1}                     {3}   {1}   {2}         {3}   {1}   {1}   {2}   {1}   {1}
\else \ifnum \classFontSize = 10
  \setNormalsize                      {10}    {12.75} {11}  {2}   {6}     {4}                     {7}   {3}   {4}
  \setOthersize   {small}             {9.25}  {12.75} {10}  {3}   {5.5}   {3.5}                   {5.5} {2}   {3.5}       {5.5} {2}   {3}   {3.5} {1}   {1}
  \setOthersize   {footnotesize}      {8.5}   {11.5}  {7}   {2}   {5}     {2}                     {4}   {1}   {3}         {4}   {1}   {2}   {3}   {1}   {1}
\else \ifnum \classFontSize = 11
  \setNormalsize                      {10.75} {14.35} {12}  {3}   {7}     {4}                     {7.5} {3.5} {4}
  \setOthersize   {small}             {10}    {12.75} {11}  {2}   {6}     {4}                     {7}   {3}   {4}         {7}   {2}   {3}   {4}   {2}   {1}
  \setOthersize   {footnotesize}      {9.25}  {12.75} {9}   {2}   {5}     {2}                     {5}   {2}   {3}         {5}   {2}   {3}   {3}   {1}   {1}
\else \ifnum \classFontSize = 12
  \setNormalsize                      {12}    {15.75} {13}  {3}   {8}     {4}                     {7.5} {3.5} {4}
  \setOthersize   {small}             {10.75} {14.35} {12}  {3}   {7}     {4}                     {7.5} {3.5} {4}         {10}  {3}   {6}   {5.5} {2}   {1}
  \setOthersize   {footnotesize}      {10}  {12.75}   {11}  {2}   {6}     {4}                     {7}   {3}   {4}         {7}   {2}   {3}   {4}   {2}   {1}
\fi\fi\fi\fi

%                 Name                9pt           10pt          11pt          12pt
\setclassFontSize {tiny}              {5}{6.5}      {5}{6.5}      {6}{7.75}     {6}{7.75}
\setclassFontSize {scriptsize}        {6.75}{9}     {6.75}{9}     {7.75}{11.25} {7.75}{11.25}
\setclassFontSize {caption}           {7.75}{11.25} {8.5}{11.5}   {9.25}{12.75} {10}{12.75}
\copyclassFontSize{tableHead}         {caption}
\copyclassFontSize{tableText}         {caption}
\setclassFontSize {subHeadii}         {9.25}{12.75} {10}{12.75}   {10.75}{14.35}{12}{15.75}% \normalsize size
\copyclassFontSize{accentText}        {subHeadii}
\copyclassFontSize{subInfo}           {subHeadii}
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
\setclassFontSize {quotei}            {18}{24}      {18}{24}      {18}{24}      {20}{26.75}
\setclassFontSize {articleHeadvi}     {20}{26.75}   {20}{26.75}   {20}{26.75}   {24}{32}
\setclassFontSize {articleHeadv}      {24}{32}      {24}{32}      {24}{32}      {30}{40}
\setclassFontSize {articleHeadiv}     {30}{40}      {30}{40}      {30}{40}      {30}{40}
\setclassFontSize {articleHeadiii}    {36}{48}      {36}{48}      {36}{48}      {36}{48}
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
	\fontmedium\titlefamilydefault%
  \leavevmode\color{colorsubheading}\itshape%
}

% heading paragraph
\def\styling@headingparagraph{%
  \useclassFontSize{subHeadi}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorsubheading}%
}

% heading subsubsection
\def\styling@headingsubsubsection{%
  \useclassFontSize{articleHeadviii}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% heading subsection
\def\styling@headingsubsection{%
  \useclassFontSize{articleHeadvii}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% heading section
\def\styling@headingsection{%
  \useclassFontSize{articleHeadvi}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% heading chapter
\def\styling@headingchapter{%
  \useclassFontSize{articleHeadv}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% heading part
\def\styling@headingpart{%
  \useclassFontSize{articleHeadiv}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

%% Unused heading sizes

% heading Large
\def\styling@headingLarge{%
  \useclassFontSize{articleHeadiii}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% heading LARGE
\def\styling@headingLARGE{%
  \useclassFontSize{articleHeadii}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% heading huge
\def\styling@headinghuge{%
  \useclassFontSize{articleHeadi}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorheading}%
}

% intro normal
\def\styling@intronormal{%
  \useclassFontSize{introii}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{colorintro}%
}

% intro large
\def\styling@introlarge{%
  \useclassFontSize{introi}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{colorintro}%
}

% body text
\def\styling@body{%
  \normalsize%
	\fontdefault\bodyfamilydefault%
  \leavevmode\color{colorbody}%
}

%%% TODO rename: promotional or recruiting

% promotional text
\def\styling@promotional{%
  \useclassFontSize{recruitingText}%
	\fontnormal\bodyfamilydefault%
  \leavevmode\color{colorpromotional}%
}

% promotional heading
\def\styling@promotionalheading{%
  \useclassFontSize{recruitingHead}%
	\fontbold\titlefamilydefault%
  \leavevmode\color{colorsubheading}%
}

% quote large
\def\styling@quotesmall{%
  \useclassFontSize{quoteiv}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{colorquote}%
}

% quote large
\def\styling@quotenormal{%
  \useclassFontSize{quoteiii}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{colorquote}%
}

% quote large
\def\styling@quotelarge{%
  \useclassFontSize{quoteii}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{colorquote}%
}

% quote Large
\def\styling@quoteLarge{%
  \useclassFontSize{quotei}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{colorquote}%
}

% accent text
\def\styling@accent{%
  \useclassFontSize{accentText}%
	\fontmedium\bodyfamilydefault%
  \leavevmode\color{coloraccent}%
}

% info text
\def\styling@info{%
  \useclassFontSize{subInfo}%
	\fontnormal\bodyfamilydefault%
  \leavevmode\color{colorinfo}%
}

% caption
\def\styling@caption{%
  \useclassFontSize{caption}%
	\fontbold\bodyfamilydefault%
  \leavevmode\color{colorcaption}%
}

% note
\def\styling@note{%
  \footnotesize%
	\fontnormal\bodyfamilydefault%
  \leavevmode\color{colornote}%
}

% payoff normal
\def\styling@payoffnormal{%
  \useclassFontSize{payOffii}%
	\fontmedium\sffamily%
  \leavevmode\color{colorpayoff}%
}

% payoff large
\def\styling@payofflarge{%
  \useclassFontSize{payOffi}%
	\fontmedium\sffamily%
  \leavevmode\color{colorpayoff}%
}

% tiny (self-defined)
\def\styling@tiny{%
  \useclassFontSize{tiny}%
	\fontmedium\bodyfamilydefault%
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

%%% titlepage styling

%%% command \frontpagehead{<content>}
%%  styles <content> as a frontepage heading
\def\frontpagehead#1{
  \iffirsthead%
    \firstheadfalse%
  \else%
    \hfill\linebreak% Leave a blank space
  \fi%
  \leavevmode\style{tiny}\textbf{#1}\hfill\break %
} %leavevmode because \style breaks 

%%% command \frontpagebody{<content>}
%%  styles <content> as frontepage body content
\newcommand{\frontpagebody}[1]{\raggedright
\style{note}#1\hfill\break}



%%%
%   Enumeration styles
%%%

\newcommand{\labelstyle}[1]{\color{colorlabel}\textbf{#1}}

%%\renewcommand{\labelitemi}{\color{colorlabel}$\bullet$}

%%% TODO enable with option
\renewcommand{\labelitemi}{\scriptsize\labelstyle{\raisebox{.175\baselineskip}{\rule{.65\baselineskip}{.65\baselineskip}}}}%%% TODO add actual $bullet$ behind there
\renewcommand{\labelitemii}{\labelstyle{--}}
\renewcommand{\labelitemiii}{\labelstyle{-}}
\renewcommand{\labelitemiv}{\labelstyle{$\cdot$}}

\setlength{\labelsep}{\gridgutterwidth}
\setlength{\labelwidth}{\tabsize}

\renewcommand{\labelenumi}{%
  \color{colorlabel}\arabic{enumi}.%
}
\renewcommand{\labelenumii}{%
  \color{colorlabel}\alph{enumii}.%
}
\renewcommand{\labelenumiii}{%
  \color{colorlabel}\roman{enumiii}.%
}
\renewcommand{\labelenumiv}{%
  \color{colorlabel}\Alph{enumiv}.%
}

%%%
%   Highlight style
%%%

%%% TODO create color
\newcommand\thl[1][yellow]{\bgroup\markoverwith
  {\textcolor{#1}{\smash{\rule[-.75ex]{.1pt}{\baselineskip}}}}\ULon}
  
\newcommand\thlarrowright[1][yellow]{%
  \thlarrow[#1]{1}{0}%
}

\newcommand\thlarrowleft[1][yellow]{%
  \thlarrow[#1]{0}{1}%
}

        \newcommand\thlarrow[3][yellow]{\begingroup%
          \color{#1}%
          \pgfpathmoveto{\pgfpoint{#3ex}			{-.75ex}}%
          \pgfpathlineto{\pgfpoint{#2ex}			{-.75ex+.5\baselineskip}}%
          \pgfpathlineto{\pgfpoint{#3ex}			{-.75ex+\baselineskip}}%
          \pgfusepath{fill}\hspace{1ex}%
        \endgroup}
   
\newcommand\thlduo[3][yellow]{%
  \thl[#1]{%
    #2%
  }%
  \thl[#1!20!white]{%
    #3%
  }%
}

\newcommand\thlSideways[1]{%
  \raisebox{\dimexpr\depth-.375ex\relax}{%
    \rotatebox[origin=c]{90}{%
      \resizebox{\dimexpr\baselineskip-.75ex}{!}{%
        \textbf{\color{white}#1}%
      }%
    }%
  }%
}

\newcommand\thlStraight[1]{%
  \raisebox{\dimexpr\depth-.375ex\relax}{%
    \resizebox{!}{\dimexpr\baselineskip-.75ex}{%
      \textbf{\color{white}#1}%
    }%
  }%
}


%%%
%   Long word handling
%%%

\newcommand\lword[1]{\leavevmode\nobreak\hskip0pt plus\linewidth\penalty50\hskip0pt plus-\linewidth\nobreak#1}
 
%%%\emergencystretch=1em TODO use microtype

%%%
%   Blank page style
%%%

\ifmarkblank
  \newcommand*{\blankpage}{%
    \begingroup
      \setlength{\topskip}{0pt}%
      \vspace*{\fill}%
      \nointerlineskip % suppresses partial \baselineskip above text
      \hbox to \linewidth{%
        \hbox to \textwidth{%
          \hfill
          This page would be intentionally left blank if we would not wish
          to inform about that.%
          \hfill
        }%
        \hss
      }%
      \vspace{\fill}%
    \endgroup
    % \showlists
  }

  \renewcommand*{\cleardoublepage}{\clearpage\if@twoside \ifodd\c@page\else
  \blankpage
  \thispagestyle{empty}
  \newpage
  \if@twocolumn\hbox{}\newpage\fi\fi\fi}
\fi


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
  \rowcolors{0}{tableodd}{tableeven}% Alternating row colors, placed inside the env so it doesn't affect oldtabular
	\oldtabular%
	}{%
  \\\arrayrulecolor{tablerule}\hline
	\endoldtabular}

\newcommand{\headbegin}{
	\rowcolor{tablehighlight}
	\colorrows{\color{tablewhite}}
}

\newcommand{\headend}{
	\colorrows{\color{tableblack}}
}

\newcommand{\subheadbegin}{
	\colorrows{\color{tablehighlight}}
}

\newcommand{\subheadend}{
	\colorrows{\color{tableblack}}
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
      
%%% COMMAND:  \fakebox[<width>]{<height>}
%%  USAGE:    Used to create a placeholder for for example graphics
\newcommand{\fakebox}[2]{%
  \fboxsep=-\fboxrule%
  \fbox{%
    \makebox[0pt][l]{\kern2\fboxrule\tiny Dummy}%
    \rule{0pt}{#2}%
    \rule{#1}{0pt}%
  }
}

%%%
%   Figure styles
%%%

\storeoldenv{\figure}

\ifnofloat
  \renewenvironment{figure}[1][H]{%
    \oldfigure[#1]\autocenter}%
    {\endoldfigure}
\else
  \renewenvironment{figure}[1][!ht]{%
    \oldfigure[#1]\autocenter}%
    {\endoldfigure}
\fi

  
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
\def\@shiftratio{0.287}% 74 degree axis

%%% Axis horizontal shift
\setnewlength{\@Hshift}{\@shiftratio\paperheight}

%%% Table of Contents spacing
\setnewlength{\@tocleftpadding}{\layoutleftmargin}

\newlength{\@tocleftspace}
\pgfmathsetlength{\@tocleftspace}{\@Hspacing-\@shiftratio*(\@Vspacing+0.48cm)+0.48cm}

\setnewlength{\@toctopspace}{\@Vspacing}
\addtolength{\@toctopspace}{\@axiswidth}
\addtolength{\@toctopspace}{0.48cm}

%%% Cover image lengths
\newlength{\@coverheight}
\newlength{\@coverwidth}

%%% Calculate cover image dimension and position based on the image ratio and the axes lengths
\pgfmathsetlength{\@coverheight}{(\paperwidth - \@Hspacing + \@shiftratio * \@Vspacing)/(\@coverratio - \@shiftratio)}
\pgfmathsetlength{\@coverwidth}{\paperwidth - \@Hspacing + \@shiftratio * \@Vspacing + \@shiftratio * \@coverheight}
\setnewlength\@covertop{ \@axisheight-0.5\@axiswidth}
\setnewlength\@coverbottom{ \@axisheight - \@coverheight}


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
\setlength{\leftmargini}{\tabsize}

%%% Paragraph indent
\setnewlength{\originalparindent}{\tabsize}%
\ifparindent%
  \setlength{\parindent}{\originalparindent}%
\else%
  \setlength{\parindent}{0pt}%
\fi

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


% Define \shapedraggedright as redefined \raggedright.
% \raggedright behavior with \shapepar:
% i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i i i i i i i i i i i i i i i i i i ...
% \shapedraggedright behavior with \shapepar:
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i i i i i i i i i i i i i i i i i i ...
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i

\def\shapedraggedright{%
\let\\\@centercr\@rightskip \z@ plus\linewidth \rightskip\@rightskip
\leftskip\z@skip
\parindent\z@}


%%%	Redefine cleardoublepage to also work with the "oneside" option
\def\cleardoublepage{\clearpage\ifodd\c@page\else
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi}

%%%
% 	Redefine titlepage so it does not reset page counter
%%%

\if@compatibility
\renewenvironment{titlepage}
    {%
      \begin{onecolarea}{}{\newpage}
      \thispagestyle{empty}%
      %\setcounter{page}\z@
    }%
    {\end{onecolarea}
    }
\else
\renewenvironment{titlepage}
    {%
      \cleardoublepage
      \begin{onecolarea}{\newpage}{\newpage}
      \thispagestyle{empty}%
      %\setcounter{page}\@ne
    }%
    {\end{onecolarea}
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
%   User helping defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\maxwidth{% %%%% TODO move
  \ifdim\Gin@nat@width>\linewidth
    \linewidth
  \else
    \Gin@nat@width
  \fi
}

\storeoldrelax{\includegraphics}
\newcommand{\includegraphics}[2][\@empty]{
	\ifx\@empty#1
		\oldincludegraphics[width=\maxwidth]{#2}
	\else
		\oldincludegraphics[#1]{#2}
	\fi
}

%%% Change GraphicsExtensions to ignore casemixing in determining loading order.
% Regular load order:       .png .pdf .jpg .mps .jpeg .jbig2 .jb2 .PNG .PDF .JPG .JPEG .JBIG2 .JB2
\DeclareGraphicsExtensions{ .png,.PNG,.pdf,.PDF,.jpg,.mps,.jpeg,.jbig2,.jb2,.JPG,.JPEG,.JBIG2,.JB2}


%%%
%   Document data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% 	Declare data commands, commands used by the user to enter data
%%%

%%% Defining the commands to specify subtitle, department, etc.
\newvariable{date}{\today}
\newvariable{department}{}
\newvariable{website}{\thetuesite}
\newvariable{subtitle}{}
\newvariable{subsubtitle}{}
\newvariable{orderissuer}{}
\newvariable{reference}{}
\newvariable{customaddress}{}
\newvariable{address}{}
\newvariable{versionnum}{}
\newvariable{copyholder}{}
\newvariable{addfrontpagebottom}{}
\newvariable{addfrontpagetop}{}

\newcommand{\administrativeunit}[1]{\administrativeunitswitch{#1}} 
\def\theadministrativeunit{}

\def\@date{\thedate}
\def\@subtitle{\thesubtitle}
\def\@subsubtitle{\thesubsubtitle}

\ifdutch
	\newvariable{bmt} {Biomedische Technologie}
  \newvariable{bwk} {Bouwkunde}
  \newvariable{ele} {Electrical Engineering}
  \newvariable{id}  {Industrial Design}
  \newvariable{tm}  {Industrial Engineering \& Innovation Sciences}
  \newvariable{chem}{Scheikundige Technologie}
  \newvariable{phys}{Technische Natuurkunde}
  \newvariable{wtb} {Werktuigbouwkunde}
  \newvariable{win} {Wiskunde \& Informatica}
\else
	\newvariable{bmt}{Biomedical Engineering}
  \newvariable{bwk}{Built Environment}
  \newvariable{ele}{Electrical Engineering}
  \newvariable{id}{Industrial Design}
  \newvariable{tm}{Industrial Engineering \& Innovation Sciences}
  \newvariable{chem}{Chemical Engineering and Chemistry}
  \newvariable{phys}{Applied Physics}
  \newvariable{wtb}{Mechanical Engineering}
  \newvariable{win}{Mathematics and Computer Science}
\fi

\newcommand{\administrativeunitswitch}[1]{
  \@ifequal{#1}{}{
    \def\theadministrativeunit{}
  }{
  \ifcsname the#1\endcsname
    \def\theadministrativeunit{\csname the#1\endcsname}
  \else
    \def\theadministrativeunit{#1}
  \fi
  }
}

\newif\ifprofilingtouched
\profilingtouchedfalse

\newif\ifprofilingfilled
\profilingfilledfalse


\def\profiling{%
   \@ifstar
     {\profilingfilledtrue\profiling@ii}
     {\profilingfilledfalse\profiling@ii}%
}
\newcommand\profiling@ii[2][colormain]{%
  \profilingtouchedtrue
  \newvariable{profilingvalue}{#2}
  \newvariable{profilingcolor}{#1}
    \AtBeginDocument{\colorlet{profilingcolor}{#1}}
}

%%%	Package for linkstyling
%	Enable PDF bookmarks
%	Make index page numbers clickable

%%%	Set link colors, bookmarks etc.
\hypersetup{
  linktocpage=true,
  breaklinks=true,
  linktocpage=true,
  bookmarksnumbered=true,
  breaklinks=true,
}

%%% colored links
\hypersetup{
  colorlinks=true,
  linkcolor={linkcolor},
  citecolor={citecolor},
  urlcolor={urlcolor}
}

\ifprint\else
  \@ifequalii{\hyperstyle}{border}{
    %%% links with colored border
    \hypersetup{
      colorlinks=false,
      linkbordercolor={linkcolor},
      citebordercolor={citecolor},
      urlbordercolor={urlcolor}
    }
  }{
    \@ifequalii{\hyperstyle}{underline}{
      %%% links with colored underline
      \hypersetup{
        colorlinks=false,
        linkbordercolor={linkcolor},
        citebordercolor={citecolor},
        urlbordercolor={urlcolor},
        pdfborderstyle={/S/U/W 1}% Border style will be underline of width 1pt
      }
    }{}
  }
\fi

\urlstyle{same}
\urlstyle{allbreak} % set as default

\ifprint
  \DeclareRobustCommand\hrefsymbol{%
    \raisebox{\depth}{%
      $\nearrow$%
    }%
  }%
  \newcounter{printhrefcounter}
  \AtBeginDocument{%
    \storeold{\href}%
    \renewcommand{\href}[2]{%
      \stepcounter{printhrefcounter}%
      \oldhref{#1}{#2}%
      \begingroup\footnote[\hrefsymbol\theprinthrefcounter]{\hypersetup{urlcolor={colorbody}}\url{#1}}\endgroup%\qrcode[nolink,height=1cm]{#1}
    }
  }
\fi


%%%
%   Timestamp
%%%

% EXPORTED FUNCTIONS:
%   \today: Outputs today's date as ``yyyy-mm-dd''
%   \now: Outputs the current time as ``hh:dd''
%   \timestamp: \today, plus one space, plus \now
%--

\def\@timeresult{\zeroPadTwo{\the\hour}:\zeroPadTwo{\the\minute}}
\def\@dateresult{\the\year-\zeroPadTwo{\the\month}-\zeroPadTwo{\the\day}}


\newcount\minute	% Current minute within the hour
\newcount\hour		% Current hour (24-hour type)
\newcount\hourMins  % Temporary for taking hour modulo 60
%
% - - -   \ n o w   - - -
%
\def\now%
{% Displays today's time as ``hh:mm''
%  The \time macro gives the minutes since midnight.  Compute
%  the whole hours by dividing this by 60, then find the
%  minute by effectively taking the minutes modulo 60.
%
  \@now
%
  \@timeresult%
}% --- \now ---

\def\@now{%
  \minute=\time    % Number of minutes since midnight
  \hour=\time \divide \hour by 60 % Get hours
  \hourMins=\hour \multiply\hourMins by 60
  \advance\minute by -\hourMins % Hours modulo 60
}

%
% - - -   \ t i m e s t a m p   - - -
%
\def\timestamp%
{% Displays ``yyyy-mm-dd hh:mm''
  \today\ \now
}% --- \timestamp ---
%
% - - -   \ t o d a y   - - -
%
\def\today%
{% Displays today's date and time as ``yyyy-mm-dd hh:mm''
  \@dateresult%
}% --- \today ---
%
% - - -   z e r o P a d T w o   - - -
%
\def\zeroPadTwo#1%
{% Left zero pad of the argument to 2 digits.  The argument
%  should be a number between 1 and 99.  This macro outputs
%  a `0' if the argument is less than ten, then it outputs
%  the argument.
%
  \ifnum #1<10 0\fi    % Conditionally output a zero
  #1%    Then output the argument
}% --- \zeroPadTwo ---



%%%
%   Build number
%%%

\def\buildfile{\jobname.build}


%builddate/time, buildtitle, buildauthor, buildjobname, buildversion

\newcounter{build}
\newvariable{buildtimestamp}{}
\newvariable{builddate}{}
\newvariable{buildtime}{}
\newvariable{buildauthor}{}
\newvariable{buildname}{}
\newvariable{buildtitle}{}
\newvariable{buildsubtitle}{}

\AtBeginDocument{%
	\IfFileExists{\buildfile}{
		\def\@transfer{}
    \@readfrom{\buildfile}
	}{}
}

\long\def\fullyexpand#1{%
  \csname donothing\fullyexpandauxi{#1}{}%
}
        \long\def\fullyexpandauxi#1{%
          \expandafter\fullyexpandauxii\romannumeral -`0#1\fullyexpandend
        }
        \long\def\fullyexpandauxii#1#2\fullyexpandend#3{%
          \ifx\donothing#2\donothing
            \expandafter\fullyexpandend
          \else
            \expandafter\fullyexpandloop
          \fi
          {#1}{#2}{#3}%
        }
        \long\def\fullyexpandend#1#2#3{\endcsname#3#1}
        \long\def\fullyexpandloop#1#2#3{%
          \fullyexpandauxi{#2}{#3#1}%
        }

\ifbuildnumber
  \AtBeginDocument{
    \edef\theversionnum{\theversionnum\space b.\space\thebuild}
  }
\fi

\AtEndDocument{%
		\refstepcounter{build}
    \preprintstring\author{, }{ \& }
    \@now
    \@writeto{\buildfile}{%
        \string\setcounter{build}{\number\value{build}}^^J%
        \string\buildtimestamp{\@dateresult,\space\@timeresult}^^J%
        \string\builddate{\@dateresult}^^J%
        \string\buildtime{\@timeresult}^^J%
        \string\buildauthor{\csname all:author\endcsname}^^J%
        \string\buildname{\jobname}^^J%
        \string\buildtitle{\unexpanded\expandafter{\@title}}^^J%
        \string\buildsubtitle{\unexpanded\expandafter{\thesubtitle}}^^J%
      }%
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
      \setaxisposition{\@axisheight+\@axispadding}%
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\@axiswidth+\axispositionY},left,bottom]{%
        \begin{minipage}[b][\dimexpr \paperheight-\axispositionY \relax]{\dimexpr \axispositionX - \@tocleftpadding -\@axispadding \relax}%
      
          \shapedraggedright%
          \style{note}#2\vspace{-\baselineskip}\end{minipage}}
    }{%
      %%% Left bottom column
      \setaxisposition{\@axisheight-\@axiswidth-\@axispadding}%
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
      \resetaxisposition
      \ifprofilingtouched            
        \resetaxisposition
        \setaxisposition{\paperheight-5.25mm-1.5cm}
        \ifprofilingfilled
          \titlepagecontent[right][profilingcolor]{\theprofilingvalue}{white}{\style[1]{heading}}{}{\axispositionY}{\dimexpr\paperwidth-.5\axispositionX-.5\layoutrightmargin\relax}{}
        \else
          \titlepagecontent[right]{\theprofilingvalue}{\theprofilingcolor}{\style[1]{heading}}{}{\axispositionY}{}{}
        \fi
      \else
        \resetaxisposition
        \setaxisposition{\paperheight-2.3cm}
        \titlepagecontent[right]{\thelogoname}{colorpayoff}{\style[4]{heading}}{}{\axispositionY}{}{}
      \fi
    \endgroup
	\else
		\relax
	\fi

  \drawtueaxes

	%%%	If innovation is not set to false, by the "noinnovation" option
	\ifinnovation
  %%%%%%%%%%%%%%%  \ClassError{Tuestyle}{oke dan}{}
    \setaxisposition{6.75mm}
		\pgftext[at=\pgfpoint{\axispositionX+\@axispadding}{\axispositionY},left,bottom]{\style[4]{heading}\color{colorpayoff} Where innovation starts}%
	\fi

	%%%	Reset colour to black
	\pgfsetcolor{colorbody}
}


%%% Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtueaxes}[1][true]{
  \pgfsetcolor{coloraxis}
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
   
   \newlength{{\@tempbaselength}}
   
   \newlength{\titlepagecontentX}
   \newlength{\titlepagecontentY}
   
   \setnewlength{\fillhorizontalpadding}{\@axispadding}
   \newlength{\fillverticalpadding}
   
   \newlength{\minimumfillwidth}
   
   \setnewlength{\titlepagecontentright}{\layoutrightmargin}
   \setnewlength{\titlepagecontentleft}{\layoutleftmargin}
   
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
  
  \setaxisposition{#7-2\tempboxaheight}% Get axisposition X and Y
  \setlength{\titlepagecontentX}{\axispositionX}% Store axisposition X
  \setlength{\titlepagecontentY}{\axispositionY}% Store axisposition Y
  \global\titlepagecontentY=\titlepagecontentY% Set axisposition Y to be global
  
  \@ifequal{#1}{left}{}
  {% If right go to the right side of the axis
    \addtolength{\axispositionX}{\@axiswidth}
  }
  
  \@ifequal{#9}{}{% If the vertical padding is not specified
    \setlength{\fillverticalpadding}{\@axispadding}% Set vertical padding to equal to horizontal padding
  }{% If the vertical padding is specified
    \setlength{\fillverticalpadding}{#9}% Set vertical padding to value specified
  }
  
  \@ifequal{#1}{left}{% If left set baselength:
    \setlength{\@tempbaselength}{\dimexpr\titlepagecontentX-\@axispadding-\titlepagecontentleft-.5em\relax}
    \ifx#2\@empty\else
      \addtolength{\@tempbaselength}{\dimexpr-\fillhorizontalpadding-.5em\relax}% Substract padding from baselength
    \fi
  }{% If right set baselength:
    \setlength{\@tempbaselength}{\dimexpr\paperwidth-\titlepagecontentX-.3em-\titlepagecontentright-\@axispadding\relax}
    \ifx#2\@empty\else
      \addtolength{\@tempbaselength}{-\fillhorizontalpadding}% Substract padding from baselength
    \fi
  }
  
  \@ifequal{#6}{}{% If no minimum width is specified
    \setlength{\minimumfillwidth}{0pt}
    % Set the minimum to 0
  }{% If a minimum width is specified
    \setlength{\minimumfillwidth}{#6}
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
      \ifdim \longestsentence < \minimumfillwidth
        \addtolength{\tempboxawidth}{\@axiswidth}
      \else
        \@ifequal{#1}{left}{
          \addtolength{\tempboxawidth}{\dimexpr 3\fillhorizontalpadding\relax}
        }{
          \addtolength{\tempboxawidth}{\dimexpr\fillhorizontalpadding+\@axispadding+.3em\relax}
        }
      \fi
      \global\tempboxawidth=\tempboxawidth
  }
  \ifx#2\@empty\else
    \pgfsetcolor{#2}
    \@ifequal{#1}{left}{
      \pgfpathmoveto{\pgfpoint{\titlepagecontentX- \tempboxawidth}{\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX}                {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX - \@shiftratio\tempboxaheight*2}         {\titlepagecontentY - 2\tempboxaheight}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX- \tempboxawidth}{\titlepagecontentY - 2\tempboxaheight}}
      \pgfusepath{fill}
    }{
      \pgfpathmoveto{\pgfpoint{\titlepagecontentX}                                                                                      {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  + \tempboxawidth}                                           {\titlepagecontentY}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  + \tempboxawidth}                                          {\titlepagecontentY - 2\tempboxaheight}}
      \pgfpathlineto{\pgfpoint{\titlepagecontentX  - \@shiftratio\tempboxaheight*2}                                                     {\titlepagecontentY - 2\tempboxaheight}}
      \pgfusepath{fill}
    }
  \fi
  \@ifequal{#1}{left}{
    \pgftext[at=\pgfpoint{\dimexpr\titlepagecontentX-\@axispadding-\@axiswidth}{\titlepagecontentY-.25\baselineskip-\fillverticalpadding},right,top]{%
     \usebox{\@tempboxa}
    }
  }{
    \pgftext[at=\pgfpoint{\titlepagecontentX+\@axispadding}{\titlepagecontentY-.25\baselineskip-\fillverticalpadding},left,top]{%
      \usebox{\@tempboxa}
    }
  }
  \@ifequal{#8}{nospace}{
    \resetaxisposition
    \global\tempboxaheight=\tempboxaheight
  }{}
}
  


%%%
% 	Create the TU/e style titlepage
%%%

%%%%% TODO check
\ifcover
  %%% Get actual cover image dimensions
  \newlength{\actual@coverheight}
  \settoheight\actual@coverheight{\includegraphics[width={\@coverwidth}]{\covername}}
      % Calculate actual cover image ratio
      \def\actual@coverratio{\DivideLengths{\@coverwidth}{\actual@coverheight}}
     
\fi
      
\newcommand\enablefrontbreak{
  \def\titlebreak{\hfill\break}
}

\newcommand\disablefrontbreak{
  \def\titlebreak{\unskip\ }
}

%%% TODO use only on frontpage, then reset
\def\@fnsymbol#1{\ifcase\value{footnote}\or*\or
†\or‡\or§\or¶\or||\or**\or††\or‡‡\or|||\or***\or†††\or‡‡‡\or \ClassError{TUeStyle}{Frontpage counter too large. Are you sure you need that many author footnotes?}\fi}

\storeold{\thanks}

\renewcommand\maketitle{
  \begingroup
    \begin{titlepage}
      \setcounter{footnote}{0}
      \renewcommand{\thefootnote}{\@fnsymbol{footnote}}
      \setlength{\fnmarkbox}{0em}
      \inlinefntext
   
      \restoreold{\thanks}%     Enable the \thanks command
      \let\footnoterule\relax%  No footnote rule
      \let\footnote\thanks%     In order to collect footnotes just as done with \thanks
      
      %%%\hfuzz=1000pt
      \enablefrontbreak
      
      \settitlelayout

      \hbox{}% Geometry requires an item on the page, textblock doesn't get detected
      
      \begin{textblock*}{\paperwidth}(0pt,0pt)
        \noindent\begin{pgfpicture}{0cm}{0cm}{\paperwidth}{\paperheight}
        
          %%%	If the cover option is set, then draw cover and white overlays
          \ifcover
            %%% Display area to be filled by the cover image
            \@axisfill[right]{colorgray}{\@coverbottom}{\@covertop}
            
            %%% Draw the cover 
            \pgftext[at=\pgfpoint{\paperwidth-.5\@coverwidth}{\@covertop-.5\@coverheight},center,center]{%
              \@ifequalii{\@coveralign}{width}{%
                \includegraphics[width={\@coverwidth}]{\covername}%
              }{\@ifequalii{\@coveralign}{height}{%
                \includegraphics[height={\@coverheight}]{\covername}%
              }{}}%
            }%
            
            %%% Draw bottom white overlay for the cover
            \@axisfill[right]{colorbackground}{\@coverbottom}{0mm}
            
            %%% Draw top white overlay for the cover
            \@axisfill[right]{colorbackground}{\@covertop}{\paperheight}
             
            %%% Draw left white overlay for the cover
            \@axisfill[left]{colorbackground}{0mm}{\paperheight}
          \fi

          %%% From name and address
          \pgfsetcolor{colorbody}
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
              \ifx\thecustomaddress\empty
                \frontpagebody{5612 AZ Eindhoven}
                \frontpagebody{\thePObox\space513, 5600 MB Eindhoven}
                \ifx\theNetherlands\empty
                \else
                  \frontpagebody{\theNetherlands}
                \fi
              \else
                \frontpagebody{\thecustomaddress}
              \fi
            \fi
            \ifx\theaddfrontpagetop\empty
            \else
              \frontpagebody{\theaddfrontpagetop}
            \fi
            \ifx\thewebsite\empty
            \else
              \hypersetup{urlcolor={colorbody}}
              \frontpagebody{\urlstyle{same}\url{\thewebsite}}
              \hypersetup{urlcolor={coloraccent}}
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
            \ifx\theaddfrontpagebottom\empty
            \else
              \frontpagebody{\theaddfrontpagebottom}
            \fi
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
            \resetaxisposition
            \setaxisposition{\@coverbottom}
          \else
            %%% Title and subtitle at normal position
            \resetaxisposition
            \setaxisposition{\@axisheight}
          \fi
          
          \titlepagecontent[right]{\@title}{colorbody}{\style[0]{heading}}{}{\axispositionY}{}{}
          \titlepagecontent[right]{\thesubtitle}{colorbody}{\style[3]{heading}}{}{\titlepagecontentY}{}{}
          \titlepagecontent[right]{\thesubsubtitle}{colorbody}{\style{body}\justified}{}{\titlepagecontentY}{}{}
         
                     \resetaxisposition
            \setaxisposition{\paperheight-3cm}
         %%%TODO remove:
          \titlepagecontent[left][red]{\@title}{colorbody}{\style[0]{heading}\raggedright}{}{\axispositionY}{}{}
          \titlepagecontent[left]{\thesubsubtitle}{colorbody}{\style{body}\justified}{}{\titlepagecontentY}{}{}
         
         
          %%%	Drawing of the TU/e axes and logo
          %   Drawn last so it overlays everything else
          \drawtuelogoandaxes
          
        \end{pgfpicture}%
      \end{textblock*}
      \@thanks    
    \end{titlepage}

    %%%% \hfuzz=0pt

    %%%	Reset the original values of all margins
    \resetcounters{0}  %%% TODO use resetcounters  
  \endgroup
  \gdef\thanks##1{}% Disarm \thanks
  \let\@thanks\@empty% Clear \@thanks, which holds the footnotes for this titlepage
  \resetlayout
  \clearpage
}

%%% disable \and command 
\def\and{\ClassWarning{TUestyle}{\string\and\space command is disabled, use \string\author{<name1>}{<name2>}{<name3>}[<key3>] for proper styling}{}}




\newcommand{\axisfill}[2][blbrtlbl]{
\in@{bl}{#1}\ifin@
  %%% Draw left bottom overlay for the cover
  \@axisfill[left]{#2}{\@axisheight-\@axiswidth}{0mm}
\fi%
\in@{br}{#1}\ifin@
  %%% Draw right bottom overlay for the cover
  \@axisfill[right]{#2}{\@axisheight-\@axiswidth}{0mm}
\fi%
\in@{tl}{#1}\ifin@
  %%% Draw left top overlay for the cover
  \@axisfill[left]{#2}{\@axisheight}{\paperheight}
\fi% 
\in@{tr}{#1}\ifin@
  %%% Draw right top overlay for the cover
  \@axisfill[right]{#2}{\@axisheight}{\paperheight}
\fi%
}

\newcommand{\@axisfill}[4][left]{
  \pgfsetcolor{#2}
  \@ifequal{#1}{left}{%
    \pgfpathmoveto{\pgfpoint{0mm}{#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing-\@shiftratio*(\paperheight-(#4))-\@axiswidth}{#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing-\@shiftratio*(\paperheight-(#3))-\@axiswidth}{#3}}
    \pgfpathlineto{\pgfpoint{0mm}{#3}}
  }{
    \pgfpathmoveto{\pgfpoint{\paperwidth}{#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing-\@shiftratio*(\paperheight-(#4))}{#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing-\@shiftratio*(\paperheight-(#3))}{#3}}
    \pgfpathlineto{\pgfpoint{\paperwidth}{#3}}
  }
  \pgfusepath{fill}
}






%%%
% 	Redefine table of contents
%%%

% Completely redefine the \tableofcontents command.
% It shows the TU/e logo and draws the axes.
% It also needs to redefine the margins temporarily,
% for which the geometry package is used.

\storeold{\tableofcontents}
\renewcommand\tableofcontents{%
  \microtypesetup{protrusion=false}
  \begin{onecolarea}{}{\newpage}
    
    \storeold{\contentsline}
    \def\contentsline##1##2##3##4{%
    \ifoddpage*{%
        \parshape 1 0cm \dimexpr\paperwidth-\@tocleftspace-\frameright\relax
        \oldcontentsline{##1}{\ifoddpagelabel##2}{##3}{##4}%
    }{%
        \parshape 1 0cm \dimexpr\paperwidth-\@tocleftspace-\frameleft\relax
        \oldcontentsline{##1}{\ifoddpagelabel##2}{##3}{##4}%
    }%
    }

    \if@openright
      \cleardoublepage
    \else
      \clearpage
    \relax\fi
    
    \setoddcontentlayout\clearpage


    % The table of contents needs different margins. The package geometry is used to
    % change the margins of certain pages within a document.
    % After the table of contents, they will be reset.


    \fancyfoot[L]{%
      \begin{textblock*}{\paperwidth}(0pt,0pt)
      \makebox[\textwidth][l]{%
          \noindent\begin{pgfpicture}{0mm}{0mm}{\paperwidth}{\paperheight}
            \drawtuetableofcontents
          \end{pgfpicture}
        }
      \end{textblock*}
    }
    
    \fancyfoot[C]{%
      \datafoot
    }%

    \pagestyle{fancy}
      %%%	Draw TOC (Table of Contents)
      {
      \@starttoc{toc} 
     }%
    
	%%%	Begin \newpage to start layout-change
	\end{onecolarea}

	%%%	Reset the original values of all margins
  %%% TODO move and use in makeaxis, toc
	\resetlayout
	


  
  \microtypesetup{protrusion=true}
}


%%%
% Defining command for the TU/e logo, innovation, axes, text and title
% for the table of contents
%%%

%%%	Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtuetableofcontents}{

	%%%	Draw TU/e logo, innovation and axes
	\drawtuelogoandaxes
	\color{colorbody}
	
	%%% Draw "Table of contents" or "Inhoudsopgave" title
  \infobox[top]{%
      \Large\contentsname\hfill\break%
  }

	%%% Draw title and subtitle
  \infobox[bottom]{%
    \iftitle
      \ifx\@title\empty\relax\else
        \frontpagehead{\thetitlelabel}%
        \frontpagebody{\@title}%
      \fi
    \fi
    \ifsubtitle
      \ifx\thesubtitle\empty\relax\else
        \frontpagehead{\thesubtitlelabel}%
        \frontpagebody{\thesubtitle}%
      \fi
    \fi
  }
}








%%%
% Declare TU/e header and footers
%%%

%%%	Using the fancyhdr package to set the TU/e headings.
%%%	Define left side header
\newcommand{\leftsidehead}{
	\small\color{hfcolor} 
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
	\small\color{hfcolor} 
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
    \small\color{colorbody}\footnumber\color{hfcolor}\space-\space
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
    \small\color{hfcolor}%
    \storeold{\linebreak}%
    \def\linebreak{\space-\space\color{colorbody}\footnumber\oldlinebreak\restoreold{\linebreak}\color{hfcolor}}%
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

%%%	Define odd right side footer
\newcommand{\oddrightsidefoot}{%
  \parbox[b]{\linewidth}{\raggedleft
    \small\color{hfcolor}%
    \ifx\theextrafo\empty\relax\else%
      \theextrafo%
    \fi%
  }%
}

%%%	Define odd left side footer
\newcommand{\oddleftsidefoot}{%
  \parbox[b]{\linewidth}{\raggedright
    \small\color{hfcolor}%
    \ifx\theextrafo\empty\relax\else%
      \theextrafo%
    \fi%
  }%
}

%%% Define data footer
\newcommand{\datafoot}{
    \begin{textblock*}{5cm}[0.5,1](.5\paperwidth,\paperheight)
      \parbox[b]{5cm}{\copyfootcontent}%
    \end{textblock*}
    \draftmarking
}

%%%	Define copyholder footer content
\newcommand{\copyfootcontent}{
	\ifcopyf
		\frontpagehead{\hfill\thecopyholderlabel}
    \frontpagebody{\hfill\thecopyholder}\vspace{-.5\baselineskip}
	\fi
}

%%%	Define draft overlay
\newcommand{\draftmarking}{
    \raisebox{\dimexpr.5\paperheight-15.75mm}[0pt][0pt]{\makebox[\textwidth]{
      \@draftmarking%
    }}%
}
        \newcommand{\@draftmarking}{
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
	%	Header for the even pages, header on the left
	\fancyhead[LE]{
		\leftsidehead
	}
	%	Header for the odd pages, header on the right
	\fancyhead[RO]{
		\rightsidehead
	}
	%	Footer for the even pages, footer on the right
	\fancyfoot[RE]{
		\rightsidefoot
	}
  % Extra footer for the even pages, on opposite side
  \fancyfoot[LE]{
    \oddleftsidefoot
  }
	%	Footer for the odd pages, footer on the left
	\fancyfoot[LO]{
		\leftsidefoot
	}
  % Extra footer for the odd pages, on opposite side
  \fancyfoot[RO]{
    \oddrightsidefoot
  }
  %	Data in the middle
	\fancyfoot[C]{%
    \datafoot
  }%
}

%%%	Define header and footers for oneside design
\newcommand{\setheadersOne}{

	%	Header only on the right side
	\fancyhead[R]{
		\rightsidehead
	}
	%	Footer only on the left side
	\fancyfoot[L]{
		\leftsidefoot
	}
  % Extra footer for the odd pages, on opposite side
  \fancyfoot[R]{
    \oddrightsidefoot
  }
  %	Data in the middle
	\fancyfoot[C]{%
    \datafoot
	}%
}

\newcommand{\resethf}{
  \ifonesidehf
    \fancyheadoffset[LO]{\dimexpr\marginparsep+\marginparwidth\relax}
    \fancyfootoffset[RO]{\dimexpr\marginparsep+\marginparwidth\relax} 
  \else
    \fancyheadoffset[LO,RE]{\dimexpr\marginparsep+\marginparwidth\relax}
    \fancyfootoffset[RO,LE]{0pt}
  \fi 
  \renewcommand{\headrulewidth}{0mm}
	\fancyhf{}
}

%%%	Set defined header/footers, custom, twoside or oneside
\newcommand{\sethfbasic}{
  \resethf
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
  \pagestyle{fancy}
}
\AtBeginDocument{
  \sethfbasic
}

\fancypagestyle{plain}{%
  \fancyhead{}
  \fancyfoot{}
  \fancyfoot[C]{
    \parbox[b]{\linewidth}{\centering
      \color{hfcolor}-\space\color{colorbody}\footnumber\color{hfcolor}\space-
      \datafoot
    }
  }
}

\fancypagestyle{empty}{%
  \fancyhead{}
  \fancyfoot{}
  \fancyfoot[C]{
    \datafoot
  }
}





%%%
% Define draftmark
%%%

\newsavebox{\draftBox}
\AtBeginDocument{
  \savebox{\draftBox}{%
    \color{colormain}%
    \pgfsetfillopacity{0.1}%
    \resizebox{\textwidth}{!}{\rotatebox[origin=c]{-45}{%
    \begin{oldtabular}{r}\fontsize{150bp}{0bp}\fontfamily{lmr}\selectfont\textbf{\forcetextsc{draft}}\\%
    \@ifequalii{\theversionnum}{}{}{\theversionlabel\space\theversionnum\space/}\space\today,\space\now\end{oldtabular}%
    }%
    }%
    \pgfsetfillopacity{1}%
  }%
}
%%%	Declare the \draftmark command and scale it to the text
\newcommand{\draftmark}{%
	\unselectable{\usebox{\draftBox}}%
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
\begingroup\fontfamily{lmr}\selectfont\oldaLeX\endgroup%
}

\DeclareRobustCommand{\org@LeX}{%
L\kern -.1667em\lower .5ex\hbox {E}\kern -.125emX\@
}

\DeclareRobustCommand{\oldLeX}{%
\org@LeX%
}

\DeclareRobustCommand{\LeX}{%
\begingroup\fontfamily{lmr}\selectfont\oldLeX\endgroup%
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
\begingroup\fontfamily{lmr}\selectfont\oldLaTeX\endgroup%
}

\DeclareRobustCommand{\oldTeX}{%
\org@TeX%
}

\DeclareRobustCommand{\TeX}{%
\begingroup\fontfamily{lmr}\selectfont\oldTeX\endgroup%
}




%%% TODO move
%   use with extreme caution
\newcommand{\declarecommand}[1]{\providecommand{#1}{}\renewcommand{#1}}

%%% TODO move
\newcommand{\truncate}[1]{%
	\@truncate#1.0\@endtruncate%
}
    \def\@truncate#1.#2\@endtruncate{#1}
    \def\@endtruncate{}

%%% TODO move
\newcommand\modulo[2]{%
  \@tempcnta=#1 
  \divide\@tempcnta by #2 
  \multiply\@tempcnta by #2 
  \multiply\@tempcnta by -1 
  \advance\@tempcnta by #1\relax 
  \the\@tempcnta
} 

%%%
% Listing styling
%%%
\newcommand{\definelist}[3][1]{
  \expandafter\newcommand\csname listof#2s\endcsname[1][\csname thelistof#2sname\endcsname]{%
    \listofcontent{#2}{#3}{##1}%
  }%
    \stylelist{#2}{}% Processed in preamble so it can be overwritten the usual way
}

\newcommand{\redefinelist}[3][1]{
  \expandafter\renewcommand\csname listof#2s\endcsname[1][\csname thelistof#2sname\endcsname]{%
    \listofcontent{#2}{#3}{##1}%
  }%
    \stylelist{#2}{}% Processed in preamble so it can be overwritten the usual way
}

        \newcommand{\listofcontent}[3]{%
            \begin{onecolarea}{}{}\begingroup
              \ifgloballistspacing 
                \def\@currentlist{globalitem}
              \else
                \def\@currentlist{#1}
              \fi
              \microtypesetup{protrusion=false}
              \ifinlinesec\disablepageskip\fi
              \expandafter\chapter*{#3}%
              \setlength{\parskip}{\listofparskip}
              \@starttoc{#2}%
            \endgroup\end{onecolarea}
        }

\newcommand{\stylelist}[3][2]{
  \ifgloballistspacing 
    \expandafter\providecommand\csname l@tabs@globalitem\endcsname{#1}
    \expandafter\stylelistSingle[\csname l@tabs@globalitem\endcsname]{#2}{#3}
  \else
    \expandafter\providecommand\csname l@tabs@#2\endcsname{#1}
    \expandafter\stylelistSingle[\csname l@tabs@#2\endcsname]{#2}{#3}
  \fi
}

\newcommand{\stylelistTabdefault}[2]{
  \expandafter\def\csname l@tabs@#1\endcsname{\numexpr\truncate{#2}+1\relax}
}

\newcommand{\stylelistSingle}[3][2]{
  \expandafter\def\csname l@#2\endcsname##1##2{%
    \@dottedtocline{1}
     {0em} % Indent
     {#1\listindent} % Listing number width
     {#3##1} % Entry text
     {##2}% % Page number
  }
}

%%%
% Clean up the tables, figures, defintions and sources lists
%%%

%%%	Remove dots between text and pagenumbers
\renewcommand{\@dotsep}{10000}

%%%	Redeclare the \listoftables command for the list of tables
\storeold{\listoftables}
\redefinelist{table}{lot}

%%%	Redeclare the \listoffigures command for the list of figures
\storeold{\listoffigures}
\redefinelist{figure}{lof}

%%%	Declare the \listoffigures command for the list of notes
\definelist{note}{lon}

%%%
%	Notes
%%%

%%
%	Command \note
%	Declares a new note
%%
\AtBeginDocument{
  \ifnotes%
    \newcounter{note} % note counter
    \newcommand{\note}[2][\@empty]{%
      \@ifundefined{if@note@#1}{%
        \expandafter\newif\csname if@note@#1\endcsname%
        \csname @note@#1true\endcsname%
      }{}%
      \letnewcolor{notes@#1}{notescolor}%
      \addtocontents{lon}{\string\letnewcolor{notes@#1}{notescolor}}
      \refstepcounter{note}%
      \ifnotes%
        \ifx\@empty#1%
          \notestyle[#1]{\thenote}{#2}%
        \else%
          \if\getcondition{@note@#1}%
            \notestyle[#1]{\thenote}{#2}%
          \fi%
        \fi%
      \fi%
    }%
  \else%
    \newcommand{\note}[2][\@empty]{}%
  \fi%
}

%% defines the note coloring
\newcommand{\colornotes}[2][\@empty]{%
	\colorlet{notes@#1}{#2}%
  \addtocontents{lon}{\string\letnewcolor{notes@#1}{#2}}
}

%% defines the note styling
\newcommand{\notestyle}[3][\@empty]{%
    \def\@notename{%
      \ifx\@empty#1\relax\else\,\protect\forcetextsc{#1}\,\fi%
    }%
    \def\notename{%
      \thlduo[notes@#1]{\,\thlStraight{\forcetextsc{N}}\thlSideways{\forcetextsc{OTE}}\thlStraight{#2}\,}{\@notename}%
    }%
    \def\notecontent{%
      {\ifx\@empty#1\relax\else\thl[notes@#1]{\space}\fi%
      \thlarrowright[notes@#1]%
      \space\itshape#3\space%
      \ifmarginnotes\ifx\@empty#1\relax\else\hfill\fi\fi\thlarrowleft[notes@#1]\thl[notes@#1]{\space}}%
    }%
    \begingroup%
    \ifmarginnotes\iftextnotes\notename\fi\marginpar{\notename\notecontent}\else\notename\notecontent\fi%
    \endgroup%
    \addcontentsline{lon}{note}{\string\numberline{\thenote}{\thl[notes@#1]{\space}\thl[notes@#1!20!white]{\@notename}\space#3}}%
}

%%% command \hidenotes
\newcommand{\hidenotes}[1]{
    \@ifundefined{if@note@#1}{
      \expandafter\newif\csname if@note@#1\endcsname
      \csname @note@#1false\endcsname
    }{
      \csname @note@#1false\endcsname
    }
}

%%% command \shownotes
\newcommand{\shownotes}[1]{
    \@ifundefined{if@note@#1}{
      \ClassError{TUeStyle}{Note type #1 doesn't exist}{}
    }{
      \csname @note@#1true\endcsname
    }
}







%%%
%	Footnote styling
%	Marginpar styling
%	Footnote* command creation
%%%

\newcommand\nextToken\relax

\newcommand\isFootnote{%
    \ifx\footnote\nextToken\textsuperscript{,}\fi}
    
\newcommand\checkIsFootnote{\futurelet\nextToken\isFootnote}


%%  Command \footnote is redefined to include new variants 
\storeold{\footnote}

\newvariable{currentFootnoteLabel}{}

\def\footnote{\@ifstar\@footnoteS\@footnote}

\def\@footnoteS{%
  \@ifnextchar({
    \@gobblefootnotelabelS%
  }
  {
    \@footnoteswitchS%
  }%
}

\def\@gobblefootnotelabelS(#1){%
  \currentFootnoteLabel{foot:#1}%
  \@footnoteswitchS%
}

\def\@footnoteswitchS{
  \@ifnextchar[{%
    \@@footnoteSS%
  }{%
    \@@@footnoteS%
  }%
}

%%% Command:  \footnote*(<label>)[<icon>]{<text>}
%%% Command:  \footnote*         [<icon>]{<text>}
%%  Result:   Outputs a footnote with:
%%  - a custom footnote mark,
%%  - footnote label "foot:<label>",
%%  - no footnote mark in tekst
\long\def\@@footnoteSS[#1]#2{%
\begingroup%
  \storeoldrelax{\@makefnmark}% Hide fnmark in text
  \renewcommand\thefootnote{#1}%
  \makebox[0pt]{% Hide \footnotemark remains
    \footnotemark% Needed for correct hyperref
  }%
  \restoreold{\@makefnmark}% Restore fnmark so it is used in the footmark
  \@ifequalii{\thecurrentFootnoteLabel}{}{%
    \footnotetext{#2}%
  }{%
    \footnotetext{\label{\thecurrentFootnoteLabel}#2}%
  }%
  \currentFootnoteLabel{}%
  \endgroup%
}

%%% Command:  \footnote*(<label>){<text>}
%%% Command:  \footnote*         {<text>}
%%  Result:   Outputs a footnote with:
%%  - a custom footnote mark "--",
%%  - no footnote mark in tekst
%%  Info:     This command doesn't allow labels to reference since this is not useful if the marks are all "--"
\long\def\@@@footnoteS#1{%
  \def\@thefnmark{--}\@footnotetext{#1}%
}

\def\@footnote{%
  \@ifnextchar(\@gobblefootnotelabel%
  {%
    \@footnoteswitch%
  }%
}

\def\@gobblefootnotelabel(#1){%
  \currentFootnoteLabel{foot:#1}%
  \@footnoteswitch%
}

\def\@footnoteswitch{%
  \@ifnextchar[{%
    \@@footnote%
  }{%
    \@@@footnote%
   }
}

%%% Command \footnote(<label>){<text>}
%%% Command \footnote         {<text>}
%%  Result: Outputs a regular footnote
%%  Followed by a seperating comma if next command is \footnote
\long\def\@@@footnote#1{%
  \@ifequalii{\thecurrentFootnoteLabel}{}{%
    \oldfootnote{#1}%
  }{%
    \oldfootnote{\label{\thecurrentFootnoteLabel}#1}%
  }%
  \currentFootnoteLabel{}%
  \checkIsFootnote%
}

%%% Command \footnote*(<label>)[<label>]{<text>}
%%% Command \footnote*         [<label>]{<text>}
%%  Result: Outputs a footnote with:
%%  - a custom footnote mark,
%%  - footnote label "foot:<label>"
%%  Followed by a seperating comma if next command is \footnote
\long\def\@@footnote[#1]#2{%
  \begingroup%
  \@ifequalii{\thecurrentFootnoteLabel}{}{%
    \renewcommand\thefootnote{#1}\footnote{#2}%
  }{%
    \renewcommand\thefootnote{#1}\footnote{\label{\thecurrentFootnoteLabel}#2}%
  }%
  \currentFootnoteLabel{}%
  \addtocounter{footnote}{-1}%
  \endgroup%
  \checkIsFootnote%
}


\newcommand{\footref}[1]{%
    \@textsuperscript{\ref{foot:#1}}%
}


%%% Command \@makefnmark
%%  Is restyled to have the TU/e main theme color
\renewcommand\@makefnmark{\hbox{\@textsuperscript{\begingroup\color{colormain}\@thefnmark\endgroup}}}

\setnewlength{\fnmarkbox}{\tabsize}

\newcommand\inlinefntext{
  \renewcommand\@makefntext[1]{%
    \parindent \originalparindent%
    \noindent\hb@xt@ \fnmarkbox% hbox with "\fnmarkbox" width
    {\hss\@makefnmark\space}%
    \style{note}%
    ##1}
}
 
\newcommand\hangfntext{
  \renewcommand\@makefntext[1]{%
    \@setpar{% At every paragraph ending:
      \@@par% Start new paragraph
      \parshape \@ne \fnmarkbox \dimexpr \textwidth-\fnmarkbox\relax% Start new parshape
    }%
    \par \parindent=\originalparindent% Parindent when there are multiple paragraphs
    \noindent% No indent on the fnmark
    \hb@xt@ \z@{\hss \hb@xt@ \fnmarkbox{\hss\@makefnmark\space}}% Horizontal box with "\tabsize" width
    \leavevmode\style{note}% 
    ##1%
    
    %\vspace*{-\baselineskip}% Remove starting of last paragraph
  }
}
\hangfntext%% TODO make option
  
\storeold{\marginpar}
\def\marginpar#1{%
\oldmarginpar[\raggedleft\style{note}#1]{\raggedright\style{note}#1}%
}


%%%
%	Indentation commands
%%%

%%% command \forceindent
%%  used for forced inline indents at the original parindent size
\newlength{\oldparindent}
\newcommand{\forceindent}{%
\setlength{\oldparindent}{\parindent}%
\parindent=\originalparindent\indent\parindent=\oldparindent\relax}

%%% command \indentpar
%%  used for a single complete indented paragraph
\def\indentpar{
  \parshape 1 \originalparindent \dimexpr\linewidth-\originalparindent\relax
}
 	
%%% command \beginindentpar
%%  used to start complete indented paragraphs
\def\beginindentpar{%
   \advance\leftskip \originalparindent
}

%%% command \endindentpar
%%  used to end complete indented paragraphs
\def\endindentpar{%
    \advance\leftskip -\originalparindent
  }

%%% command \narrower
%%  used to start complete narrow paragraphs
\def\narrower{% redefine narrower command to the correct size
	\advance\leftskip \originalparindent
    \advance\rightskip \originalparindent
  }   

%%% command \wider
%%  used to end complete narrow paragraphs
\def\wider{% define opposite of \narrower
	\advance\leftskip -\originalparindent
    \advance\rightskip -\originalparindent
  }   

%%%
%	Formatting marks
%%%

%%% NOTE requires explicit linebreaking
\newenvironment{showspaces}[1][dot]{\par\obeyspaces%\obeylines%
  \@ifequal{#1}{dot}{%
  \begingroup\lccode`\~=`\ \lowercase{\endgroup\let~}\spacedot%
  \begingroup\lccode`\~=`\^^M\lowercase{\endgroup\let~}\spacedot%
  }{%
  \@ifequal{#1}{bar}{%
  \begingroup\lccode`\~=`\ \lowercase{\endgroup\let~}\spacebar%
  \begingroup\lccode`\~=`\^^M\lowercase{\endgroup\let~}\spacebar%
  }{%
    \@ifequal{#1}{sbar}{%
    \begingroup\lccode`\~=`\ \lowercase{\endgroup\let~}\highspacebar%
    \begingroup\lccode`\~=`\^^M\lowercase{\endgroup\let~}\highspacebar%
    }{}%
  }%
  }%
  }
  {\par}
  
\newcommand{\spacebar}{%
  \leaders\hrule height 1.5ex
  \hskip\fontdimen2\font plus \fontdimen3\font minus \fontdimen4\font
}

\newcommand{\highspacebar}{%
  \leaders\hrule height \dimexpr\baselineskip-3.0657pt\relax depth 3.0657pt%%% TODO set depth to actual value
  \hskip\fontdimen2\font plus \fontdimen3\font minus \fontdimen4\font
}

\newcommand{\spacedot}{%
  \cleaders\hbox{$\cdot$}
  \hskip\fontdimen2\font plus \fontdimen3\font minus \fontdimen4\font
}


\newsavebox{\hugequoteleftBox}
\newcommand{\hugequoteleft}{%
  \begingroup%
  \savebox{\hugequoteleftBox}{\raisebox{-1em}{\style[-3]{heading}\color{colorquoteaccent}
  \raggedleft\textbf{``}}}%
  \leavevmode\smash{\makebox[0pt]{\hspace{\dimexpr-\tabsize-5pt\relax}\usebox{\hugequoteleftBox}}}%TODO change tabsize to left margin (current)
  \endgroup%
}

\newcommand{\@quotesource}[1]{\par\smallskip\hfill{\color{colorquoteaccent}\normalsize---\space\space\color{colorquote}#1}}

\newcommand{\quotesource}[1]{\@ifequalii{#1}{}{}{\@quotesource{#1}}}

\storeoldenv{\quotation}
\renewenvironment{quotation}[1][]
           {\list{}{\listparindent \leftmargin%
                    \itemindent    0pt%
                    \rightmargin \leftmargin%
                    \parsep        \z@ \@plus\p@}%
            \medskip\item\relax\style[4]{quote}\raggedright\def\tempaaaa{#1}}
           {\quotesource{\tempaaaa}\endlist\smallskip}

\storeoldenv{\quote}

\renewenvironment{quote}[1][]
               {\list{}{\rightmargin\leftmargin}%
            \medskip\item\relax\style[4]{quote}\raggedright\def\tempaaaa{#1}}
           {\quotesource{\tempaaaa}\endlist\smallskip}

\newenvironment{quote*}[1][]{\begin{quote}[#1]\hugequoteleft}{\end{quote}}
\newenvironment{quotation*}[1][]{\begin{quotation}[#1]\hugequoteleft}{\end{quotation}}

\newenvironment{intro}{\style[2]{intro}}{\smallskip}

\newif\ifallowaxistile
\allowaxistiletrue






\newcommand{\makeaxis}{

	\if@openright% NOTE (TODO) Use if no body text on page
		\cleardoublepage
	\else
    \clearpage
  \fi

  \setfulloddlayout
  
  \fancyfoot[C]{
    \datafoot
  }
  \thispagestyle{fancy}
  
	% The table of contents needs different margins. The package geometry is used to
	% change the margins of certain pages within a document.
	% After the table of contents, they will be reset.

  \newtoks\mylinetoks%use token register to allow \linebreak etc., this doesn't work in edef
  \mylinetoks={}
  
  \hbox{}
  
\checknextargb%
}

\newcommand{\checknextargb}{%
  \@ifnextchar\bgroup{%
    \gobblenextb % Check if another "argument" exists
  }{%
    \@ifnextchar[{%
      \gobblenextb@key%
    }{% Ending
      \begin{textblock*}{\paperwidth}(0pt,0pt)
        \noindent\begin{pgfpicture}{0mm}{0mm}{\paperwidth}{\paperheight}
          \resetaxisposition
          \setaxisposition{\paperheight-\layouttopmargin+.5\baselineskip}% Shift the amount of "\titlepagecontent padding" up to make it align with normal text
          \setlength{\titlepagecontentY}{\axispositionY}
          \drawtueaxes[false]
          \the\mylinetoks
        \end{pgfpicture}
      \end{textblock*}
      %%%	Begin new page to start layout-change
      \clearpage

      %%%	Reset the original values of all margins
      \resetlayout
    }
  }
}


  \newcommand{\gobblenextb}[1]{%
      \mylinetoks=\expandafter{\the\mylinetoks
      \titlepagecontent[right]{#1}{colorbody}{}{}{\titlepagecontentY}{}{.5\baselineskip}
    }
    \allowaxistiletrue
    \checknextargb% Gobble next "argument"
  }
  
  \newlength{\tempaxispos}
  \def\gobblenextb@key[#1]{%
    \ifallowaxistile
      \mylinetoks=\expandafter{\the\mylinetoks
      \titlepagecontent[left]{#1}{colormain}{}{}{\titlepagecontentY}{nospace}{.5\baselineskip}
    }
    \else\ClassError{TUeStyle}{Can't write two titles after each other, use a \string\linebreak (followed by another \string\linebreak for a paragraph ending)}\fi\allowaxistilefalse
    \checknextargb% Gobble next "argument"
  }



\def\titlebreak{\unskip\space} %unskip to remove space in front




%%% environment "minitextpage"
%%  \begin{minitextpage}[<position>]{<width>}
%%  optional:   c (for center), 
%%  <position>  t (for top) &
%%              b (for bottom)
\newenvironment{minitextpage}{%
	\@ifnextchar[{%
		\begin{minipage}%
	}{%
		\begin{minipage}[t]%
	}%
}{%
 	\vspace{\dimexpr \baselineskip-\f@size pt \relax}%
  % empty line is required for the next definition
 	
 	\xdef\tpd{\the\prevdepth}
	\end{minipage}%
}




%%% environment "exercisealph"
\setnewlength{\exercisepadding}{\gridgutterwidth}
\setnewlength{\exercisemargin}{\dimexpr \leftmargini - \exercisepadding}
\setnewlength{\exercisespacing}{0pt}

\newcounter{exercisealphTempCounter}

\newenvironment{exercisealph}{%
  \begin{list}{%
    \protect\makebox[\exercisemargin][r]{\color{colormain}(\alph{exercisealphTempCounter})}%
  }{%
    \usecounter{exercisealphTempCounter}%
    \setlength\labelwidth     {\exercisemargin}%
    \setlength\labelsep       {\exercisepadding}%
    \setlength\leftmargin     {\exercisespacing}%
    \setlength\listparindent  {0pt}%
    \setlength\itemindent     {0pt}%
  }
}{%
  \end{list}
}




\newcounter{exercise}
\@addtoreset{exercise}{chapter}

\newcommand{\exercisename}{Exercise}

\newcommand{\exercisetitle}[1]{\subsection*{\exercisename\space\thechapter.\theexercise\space#1}}

\newsavebox{\exercisebox}
\newenvironment{exercise}[1]
{

\def\exercisetitleTemp{#1}
\begin{lrbox}{\exercisebox}}
{\end{lrbox}
\vspace{5ex}%% TODO rewrite to actual subsection padding
\begin{markleft}
\begin{minipage}[b]{\linewidth}
\refstepcounter{exercise}\exercisetitle{\exercisetitleTemp}
\usebox{\exercisebox}\end{minipage}
\end{markleft}

}


\newsavebox{\markleftbox}
\newenvironment{markleft}
{%
\setlength{\fboxsep}{\gridgutterwidth}%
\setlength{\fboxrule}{1mm}%
\begin{lrbox}{\markleftbox}\begin{minitextpage}[b]{\linewidth}}
{\end{minitextpage}\end{lrbox}
\noindent\hspace{\dimexpr-\fboxsep-.5\fboxrule}%
\cfbox[lTBR]{colormain}{\usebox{\markleftbox}}%
}



%%% command \cfbox[<lbrt>]{<color>}{<content>}
%%  creates a colored \fbox around <content> with the color <color>
%%  optional: 't' for top   border, 
%%  <lbrt>    'r' for right border,
%%            'b' for bottom border,
%%            'l' for left  border,
%%            'T' for leaving out top     padding,
%%            'R' for leaving out right   padding,
%%            'B' for leaving out bottom  padding &
%%            'L' for leaving out left    padding
%%            can be entered in any order
\newcommand\cfbox[3][lbrt]{%
  \begingroup
  \leavevmode
  \setbox\@tempboxa\hbox{%
    \color@begingroup
      \in@{L}{#1}\ifin@\else\kern\fboxsep\fi%
      {#3}%
      \in@{R}{#1}\ifin@\else\kern\fboxsep\fi%
    \color@endgroup
  }%
  \@tempdima\fboxrule
  \advance\@tempdima\fboxsep
  \advance\@tempdima\dp\@tempboxa
  \hbox{%
    \hskip-.5\fboxrule
    \lower\@tempdima% 
    \hbox{%
      \vbox{%
        %\in@{T}{#1}\ifin@\else\vskip\fboxsep\fi
        \in@{t}{#1}%
        \ifin@
            {\color{#2}%
            \hrule\@height\fboxrule
            }%
        \fi
        \hbox{%
          \in@{l}{#1}%
          \ifin@
            {\color{#2}%
            \vrule\@width\fboxrule
            }%
          \fi
          \vbox{%
            \in@{T}{#1}\ifin@\else\vskip\fboxsep\fi
            \box\@tempboxa
            \in@{B}{#1}\ifin@\else\vskip\fboxsep\fi}%
          \in@{r}{#1}%
          \ifin@
            {\color{#2}%
            \vrule\@width\fboxrule
            }%
          \fi
        }%
        \in@{b}{#1}%
        \ifin@
          {\color{#2}%
          \hrule\@height\fboxrule
          }%
        \fi
        %\in@{B}{#1}\ifin@\else\vskip\fboxsep\fi
      }%
    }%
    \hskip-.5\fboxrule
  }%
  \endgroup
}


%%% renewing command \footnoterule
%%  coloring the footnote rule and setting its width to 3\columntabsize
%%  keeping the height and spacing the same
\AtBeginDocument{
  \renewcommand{\footnoterule}{\begingroup\color{colorfootrule}%
    \kern -3pt
    \hrule width 3\columntabsize height .4pt
    \kern 2.6pt
  \endgroup}
}




%%% multi column image command
\newcounter{mulimagescurrent}
\newcounter{mulimagesmax}

\newcommand{\mulimages}[2][2]{%
  \setcounter{mulimagescurrent}{0}%
  \setcounter{mulimagesmax}{#1}%
  \def\multype{#2}
 % \setcounter{mulimagesgutters}{#1}%
  \begin{\multype}% No placement parameters so it takes document defaults
  %%% TODO allow placement parameters
  \hspace{-\gridgutterwidth}%
  \@twoimagesi%
}

    \newcommand\@twoimagesi{\stepcounter{mulimagescurrent}\@ifnextchar\stopimages{\@twoimagesend}{\@twoimagesii}}

    \newcommand{\@twoimagesii}[4][\@empty]{%
        \ifx\@empty#1%
          \let\multypecurrent\multype%
        \else%
          \def\multypecurrent{#1}%
        \fi
        \ifx\@empty#4%
          \def\mulwidthcurrent{1}%
        \else%
          \def\mulwidthcurrent{#4}%
        \fi
            \autocenter\hspace{\gridgutterwidth}%
                  \begin{minipage}[t][][t]{\dimexpr\linewidth/\themulimagesmax-\gridgutterwidth*\numexpr \themulimagesmax -1 \relax/\themulimagesmax}%% TODO calculate highest box and scale every other box in line
        \autocenter%
        \parbox[b][][t]{\dimexpr\mulwidthcurrent\linewidth}{#2}%\linebreak%
        \@ifequal{#3}{}{}{%
          \iffalse%
            \captionof{\multypecurrent}{#3}%
          \else%
            \subcaption{#3}%\label{img:#1}%
          \fi}%
        \end{minipage}%
      \ifnum \themulimagescurrent = \themulimagesmax%
        \setcounter{mulimagescurrent}{0}%
        \\[\bigskipamount]\hspace{-\gridgutterwidth}%
      \fi%
      \@twoimagesi% restart the recursion
    }

      
    \newcommand\@twoimagesend[1]{% The argument is \stopimages
      \ifnum \themulimagescurrent = 1%
        \vspace*{-\bigskipamount}%
      \fi%
        \@ifnextchar\bgroup{%
          \@twoimagescap%
        }{%
          \end{\multype}%
        }
      }
    
\def\@twoimagescap#1{\caption{#1}\end{\multype}}
  
  
  
\newcounter{customsubcaption}
\@addtoreset{customsubcaption}{figure}
  
\AtBeginDocument{
  \providecommand{\subcaption}[1]{
    \stepcounter{customsubcaption}
    \caption*{(\alph{customsubcaption})\space#1}
  }
}

%%% Command \dashfill
%%  Creates a stylised line like \dotfill
\def\dashfill{\hbox to \hsize{\@dashfill\hfil}}
\def\@dashfill{\cleaders\hbox{\hskip1pt-\hskip1pt}\hfill}

%%% Command \showfont
%%  shows some current font specifications 
\newcommand{\showfont}{%
  \ifmmode
    \ClassWarning{TUeStyle}{\string\showfont\space doesn't have any effect in mathmode}{}
  \else
    \expandafter\string\the\font,\\
    encoding: \f@encoding{},\\
    family: \f@family{},\\
    series: \f@series{},\\
    shape: \f@shape{},\\
    size: \f@size{},\\
    full name: \fontname\font%
    \raggedright\par%
  \fi
}

%%% Command \switchfont{"font"}
%%  Example usage: \switchfont{cmss10}, call \switchback to switch the font back
\newcommand{\switchfont}[1]{
\expandafter \let \expandafter \switchback \the\font
\font\1=#1\1
}

\AtBeginDocument{
  %%  Removes extreme spacing between paragraphs
  %   \raggedbottom %%%% TODO make option
  %   Boxes on every page are of a different height
\disablefrontbreak%% TODO test if needed
\style{body}
}







\def\DividedListChapterTitle{}

\newcommand{\DeclareDividedList}[1]%
  {\setnewcounter{#1@chapter}{0}}
  
\def\DividedListChapterCheck#1#2{
\ifcounter{#1@chapter}{%
     \ifnum \thechapter > \value{#1@chapter}%
       \setcounter{#1@chapter}{\thechapter}%
       \addtocontents{#1}{\protect\addvspace{10\p@}}%
       \addtocontents{#1}{\protect\contentsline{#2}%
         {\bfseries\protect\numberline{\thechapter}{\DividedListChapterTitle}}{}{}}%%% TODO add chapter styling
     \fi%
   }{}%
}

\storeoldrelax{\addcontentsline}
\def\addcontentsline#1#2#3{\DividedListChapterCheck{#1}{#2}\oldaddcontentsline{#1}{#2}{#3}}

\DeclareDividedList{lof}
\DeclareDividedList{lot}
\DeclareDividedList{lon}




%%%% TODO move
\newcommand{\settobiggest}[2]{%
\ifdim #2 > #1%
	\setlength{#1}{#2}%
\fi%
}





\AtBeginDocument{
	\def\preauxfile{\jobname.preaux}

	\IfFileExists{\preauxfile}{%
		\def\@preauxtransfer{}
    \@readfrom{\preauxfile}
	}{}

  \newwrite\preaux
  \immediate\openout\preaux=\preauxfile
}

\storeold{\numberline}
\newlength{\numberlineTemp}%
\renewcommand{\numberline}[1]{%
  \expandafter\providelength\csname\@currentlist Widest\endcsname%
  \settowidth{\numberlineTemp}{#1}%
  \expandafter\settobiggest\csname\@currentlist Widest\endcsname{\numberlineTemp}%
  \expandafter\global\csname\@currentlist Widest\endcsname=\csname\@currentlist Widest\endcsname
  \immediate\write\preaux{\expandafter\string\expandafter\stylelistTabdefault{\@currentlist}{\DivideLengths{\the\csname\@currentlist Widest\endcsname+\gridgutterwidth}{\tabsize}}}%
  \oldnumberline{#1}%
}
\def\@currentlist{none}








\normalem% Disable ulem package \em overwrite
\DeclareRobustCommand{\em}{%
  \@nomath\em \if b\expandafter\@car\f@series\@nil
  \normalfont \itshape \else \bfseries\itshape \fi}
  




  
\newcommand{\verbatimfont}[1]{\renewcommand{\verbatim@font}{\ttfamily#1}}








\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne%
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@%
    \setlength\@tempdima{\tabsize}%\setlength\@tempdima{1.5em}%
    \begingroup%
      \parindent \z@ \rightskip \@pnumwidth%
      \parfillskip -\@pnumwidth%
      \leavevmode \bfseries%
      \advance\leftskip\@tempdima%
      \hskip -\leftskip%
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par%
      \penalty\@highpenalty%
    \endgroup
  \fi}

\renewcommand*\l@section{\@dottedtocline{1}{\tabsize}{\tabsize}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2\tabsize}{\tabsize}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3\tabsize}{2\tabsize}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4\tabsize}{\tabsize}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5\tabsize}{\tabsize}}
















\ifsectioningstyling
  \setnewlength{\vbeforechapter}{50\p@}% Original
  \setnewlength{\vbeforechapter}{25\p@}% Half
  
  \setnewlength{\vafterchapter}{40\p@}% Original
  \setnewlength{\vafterchapter}{20\p@}% Half
\fi

\ifsectioningstyling
  \AtBeginDocument{
    \def\@makechapterhead#1{%
      \gdef\DividedListChapterTitle{#1}% Store chapter title for devided list ofs
      \vspace*{\vbeforechapter}%
        {\raggedright\style[0]{heading}%\noindent to prevent sectioning from getting indented, because \style allows for it
          \ifnum \c@secnumdepth >\m@ne%
            \leftskip -\chaptershift
            \ifchaptername% check for chaptername option
              \@chapapp\space\thechapter\par\nobreak
              %\vskip 20\p@
            \else
              \@seccntformat{chapter}%
            \fi
          \fi
          \interlinepenalty\@M
          \style[0]{heading}%\Huge \bfseries 
          \noindent#1\hfill\par\nobreak
          \vskip \vafterchapter%
        }%
      }

    \def\@part[#1]#2{%
      \ifnum \c@secnumdepth >-2\relax
        \refstepcounter{part}%
        \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
      \else
        \addcontentsline{toc}{part}{#1}%
      \fi
      \markboth{}{}%
      {\centering
       \interlinepenalty \@M
       \normalfont
       \ifnum \c@secnumdepth >-2\relax
         \style[-1]{heading}%\huge\bfseries 
         \partname\nobreakspace\thepart
         \par
         \vskip 20\p@
       \fi
       \style[-2]{heading}%\Huge \bfseries 
       #2\par}%
      \@endpart}
    \def\@spart#1{%
      {\centering
       \interlinepenalty \@M
       \normalfont
       \style[-2]{heading}%\Huge \bfseries 
       #1\par}%
      \@endpart}
  }
\fi




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
  \expandafter\providecommand\csname vbefore\cs@to@str#2\endcsname{#3 \@plus #4 \@minus #5}
  \expandafter\providecommand\csname vafter\cs@to@str#2\endcsname{#6 \@plus #7}
  \renewcommand#2{
    \@startsection{\cs@to@str#2}{#1}{\z@}%
    {\csname vbefore\cs@to@str#2\endcsname}%
    {\csname vafter\cs@to@str#2\endcsname}%
    {\noindent\style[#1]{heading}}%\noindent to prevent sectioning from getting indented, because \style allows for it
  }
}

\ifsectioningstyling
  \createsectioningstyling[1]{\section}       {-3.5ex}  {-1ex}{-.2ex}{2.3ex}{.2ex}
  \createsectioningstyling[2]{\subsection}    {-3.25ex} {-1ex}{-.2ex}{1.5ex}{.2ex}
  \createsectioningstyling[3]{\subsubsection} {-3.25ex} {-1ex}{-.2ex}{1.5ex}{.2ex}
\fi

\ifsectioningstyling
  \ifparagraphstyling
    \createsectioningstyling[4]{\paragraph}{-3.25ex}{-1ex}{-.2ex}{.2ex}{.2ex} %Negative values to create linebreak
    \createsectioningstyling[5]{\subparagraph}{-3.25ex}{-1ex}{-.2ex}{.2ex}{.2ex}%Negative values to create linebreak
  \fi
\fi

\AtBeginDocument{
  \def\chaptermark#1{
   \markboth{\MakeUppercase{\ifnum \c@secnumdepth >\m@ne \chaptername\space\thechapter\fi\space#1}}{\rightmark}
  }
  
  \renewcommand\sectionmark[1]{%
    \markright{\ifnum \c@secnumdepth >\z@ \thesection . \ \fi #1}
  }
  
  \ifsubsecmark\relax\else
    \renewcommand{\subsectionmark}[1]{}
  \fi
}






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




\def\secingLevelLowest{6}% Subparagraph level (5) +1
\def\secingLevelHighest{-2}% Part level -1

\setnewcounter{sectioningcounterdisplay}{\secingLevelLowest}
\setnewcounter{sectioningcountertouched}{\secingLevelLowest}
\setnewcounter{sectioningcounterstarred}{\secingLevelHighest}

%%% Set counter depth to only exclude subsubsection and (sub)paragraph
\setcounter{secnumdepth}{2} % Section numbering depth in bodytext
\setcounter{tocdepth}{2}    % Section numbering depth in table of contents

%% custom counter for reverse senumdepth
\setnewcounter{reversesecnumdepth}{\secingLevelHighest}

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
    \ifinlinesec
      \FloatBarrier
      \ifnum #1 > -1% If not "part" sectioning, disable page skip
        \disablepageskip
      \fi
    \fi
    \csname old\expandafter\cs@to@str\string#2\endcsname##3{##2}
    \enablepageskip
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
        \setnewcounter{firstsectioningline}{\the\inputlineno}
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\sectioningdot{\texorpdfstring{\protect\watermark{.}}{.}}
\def\thechapterdot{\sectioningdot}
\def\thesectiondot{\sectioningdot}
\def\thesubsectiondot{\sectioningdot}
\def\thesubsubsectiondot{\sectioningdot}
\def\theparagraphdot{\sectioningdot}
\def\thesubparagraphdot{\sectioningdot}


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
      \thechapterdot%
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










\protected\def\c{\@ifnextchar[\@copymathDisplay\@copymathInline}
\def\@copymathDisplay[#1\c]{\copyable{\[#1\]}}
\def\@copymathInline(#1\c){\copyable{\(#1\)}}


%%% TODO style
\newcommand{\colophon}{
\tocless\section*{Colophon}
Typeset in XXXX, by \@author\\
by Dr. Donald Knuth's TEX system.\\
With the use of the TU/e document class\\
}

