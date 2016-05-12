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
\RequirePackage{fancyhdr}
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
\newif\iftuefonts\tuefontsfalse

%%% Show margins
%%  (false by default)
\newif\ifmargins
\marginsfalse

%%% Draw notes
%%  (false by default)
\newif\ifnotes
\notesfalse

%%% Draw instructions
%%  (false by default)
\newif\ifinstructions
\instructionsfalse

%%% Switch between one-sided / two-sided mode
%%  (one-sided by default)
\newif\iftwosided
\twosidedfalse

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





%%%
%   Class options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Report class option error
\def\ClassErrorNotSupported#1#2{\ClassError{TUestyle_ReportBook}{Sorry, only #1 is supported!}{Remove the #2 class option}}
\def\DeclareBooleanOptionX#1{\define@boolkey{TUestyle_Development.cls}[]{#1}{}}

% document options
\DeclareOptionX{report}{\bookfalse}
\DeclareOptionX{book}{\booktrue}

% throw error on not supported paper sizes
\DeclareOptionX{a5paper}{\ClassErrorNotSupported{a4paper}{a5paper}}
\DeclareOptionX{b5paper}{\ClassErrorNotSupported{a4paper}{b5paper}}
\DeclareOptionX{letterpaper}{\ClassErrorNotSupported{a4paper}{letterpaper}}
\DeclareOptionX{executivepaper}{\ClassErrorNotSupported{a4paper}{executivepaper}}
\DeclareOptionX{legalpaper}{\ClassErrorNotSupported{a4paper}{legalpaper}}
\DeclareOptionX{landscape}{\ClassErrorNotSupported{portrait}{landscape}}

% custom layout margins
\DeclareOptionX{left}{\setlength{\layoutleftmargin}{#1}}
\DeclareOptionX{right}{\setlength{\layoutrightmargin}{#1}}
\DeclareOptionX{top}{\setlength{\layouttopmargin}{#1}}
\DeclareOptionX{bottom}{\setlength{\layoutbottommargin}{#1}}
\DeclareOptionX{marginparL}{\setlength{\marginparL}{#1}}
\DeclareOptionX{marginparR}{\setlength{\marginparL}{#1}}

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
\DeclareOptionX{draftmark}{\linenumfalse}

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

% draw instructions
\DeclareOptionX{instructions}{\instructionsfalse}

% draw one-sided / two-sided
\DeclareOptionX{oneside}{\twosidedfalse}
\DeclareOptionX{twoside}{\twosidedtrue}

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


% header options

% draw one-sided / two-sided header and footer
\DeclareOptionX{onesidehf}{\onesidehftrue}
\DeclareOptionX{twosidehf}{\onesidehffalse}

% draw faded header and footer
\DeclareOptionX{fadehf}{
  \definecolor{hfcolor}{gray}{0}
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
\DeclareOptionX{print}{%
  \AtBeginDocument{
  \storeold{\href}
  \renewcommand{\href}[2]{\oldhref{##1}{##2}\footnote{\url{##1}}}
  }
}

% hide upper sectioning
\DeclareBooleanOptionX{hideuppersectioning}
\hideuppersectioningfalse

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

%%% command \enquote{<content>}
%%  correctly enquotes content, in the primary quoatation style
\newcommand{\enquote}[1]{``#1’’}

%%% command \secenquote{<content>}
%%  correctly enquotes content, in the secondary quoatation style
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


%%%%% TODO move
%%%	Define the instructions command if the "instructions" option is used
\ifinstructions
  \newcommand{\instruction}[1]{}
\else
  \newcommand{\instruction}[1]{\textit{\textcolor{tueblue}{\textbf{[INSTRUCTION:} #1\textbf{]}}}}
\fi


%%%
%   Package commands
%%%

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

%%% command \ifcounter{<counter>}{<on true>}{<on false>}
%%  check if a counter exists
\newcommand*\ifcounter[1]{%
  \ifcsname c@#1\endcsname%
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi%
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
  }{}
  \csname decl@\endcsname\checknextarg
}

    \newcommand{\checknextarg}{
      \@ifnextchar\bgroup{\gobblenext}{}% Check if another "argument" exists
    }

    \newcommand{\gobblenext}[1]{%
      \advance\csname c@\expandafter\cs@to@str\tmp@sum\endcsname 1\relax
      \let\tempname@sum\tempname
      \expandafter\def\csname data:\tempname:\the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname  \endcsname{#1}% Add value to numbered variable
      \@ifnextchar\bgroup{\gobblenext}{}% Gobble next "argument"
    }


%%% \getdata[<index>]\<name>
%%  prints data contained in \data:<name>:<index>
\def\getdata[#1]#2{\csname data:\string#2:#1\endcsname}

%%% \printdata{\<name>}{<global delimiter optional>}{<last delimiter optional>}
%%  prints data contained in \data:<name>:<range>
\newif\ifprint
\newcommand{\printdata}[1]{%
  \printtrue
  \def\tempname{\string#1}%
  \def\delimi{, }%
  \def\delimii{ \& }%
  \@ifnextchar\bgroup{\firstdelim}{\initiateprint{\tempname}}% If delimiter: set it, else, print
}

%%% \preprintdata{\<name>}{<global delimiter optional>}{<last delimiter optional>}
%%  prints data contained in \data:<name>:<range> to \all:<name>
\newcommand{\preprintdata}[1]{%
  \def\tempname{\string#1}%
  \printfalse
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

    \newcommand{\initiateprint}[1]{%
      \edef\tmp@sum{#1@sum}%
      \edef\tmp{#1}%
      \newcount\tempcount%
      \advance\tempcount 1\relax%
      \expandafter\def\csname all:\expandafter\cs@to@str\tmp\endcsname{} % define counter all:<name> if it doesn't exist yet, otherwise clear
      \printdatainternal#1%
    }

    \newcommand{\printdatainternal}[1]{%
      \ifnum \the\tempcount < \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname \relax%
        \ifnum \the\tempcount > 1% Use first delimiter in front of values, after the first value
          \printandwritedata[\delimi]% Print current value
        \else%
          \printandwritedata% Print first value
        \fi%
        \advance\tempcount 1\relax%
        \printdatainternal#1% Loop
      \else%
        \ifnum \the\tempcount = \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname \relax% % Use second delimiter in front of the last value
          \printandwritedata[\delimii]% Print last value
        \fi
      \fi
    }
    
    \newcommand{\printandwritedata}[1][]{%
      \ifprint
        #1\csname data:\tmp:\the\tempcount\endcsname%
      \fi
      \expandafter\edef\csname all:\expandafter\cs@to@str\tmp\expandafter\endcsname{%
        \csname all:\expandafter\cs@to@str\tmp\expandafter\endcsname%
        #1\csname data:\tmp:\the\tempcount\endcsname%
      }%
    }
    
%%% \printstring{\<name>}
%%  prints data contained in \all:<name> as a string, needed when commands can't be expanded
\newcommand{\printstring}[1]{%
  \csname all:\cs@to@str#1\endcsname
}

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
            \color{black!90}%
            %%%% TODO authorlist and actual copyholder
            This PDF was created by \@author\ for COPYHOLDER.
        }%
    }}}}%
}


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
  \setlength{\axispositionX}{\dimexpr \@Hspacing-\@Hshift + \@shiftratio\axispositionY -\@axiswidth \relax}%
}


%%% command \getlongestsentence{<string>}
%%  Splits sentences on \break and outputs longest sentence to \templongest
\def\getlongestsentence#1{%
	\setnewlength{\templongest}{0pt}
	\def\holder{}
	\def\delim{\break} %Split string at breaks
    \begingroup
    \edef\@tempa{\detokenize\expandafter{#1}\space}%
    \expandafter\endgroup
    \expandafter\readstring\@tempa\relax
}

    \long\def\readstring#1 #2\relax{%
          \partitionstring{#1}{\delim}%  #1 = substr, #2 = rest of string
          \begingroup%
          \ifx\relax#2\relax  % is #2 empty?
            \def\next{\endgroup\endstringpartition}% end-macro
          \else%
             \def\next{\endgroup\readstring#2\relax}%
          \fi%
          \next%
    }

    \long\def\partitionstring#1#2{%
      \expandafter\edef\expandafter\tempa{\detokenize{#1}}%
      \expandafter\edef\expandafter\tempb{\expandafter\string#2}%
        \ifx \tempa \tempb%
          \endstringpartition%
        \else%
          \g@addto@macro\holder{\scantokens{#1}}%
        \fi%
    }

    \def\endstringpartition{%
      \settowidth{\@tempdima}{\holder}%
      \ifnum \@tempdima > \templongest%
      \setlength{\templongest}{\@tempdima}%
      \else\fi%
      \def\holder{}%
    }

    
%%% Justify command
  \newcommand{\justified}{%
    \rightskip\z@skip%
    \leftskip\z@skip}
      
    

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
  \AtBeginDocument{
    \RequirePackage{uarial}
  }
\fi
\RequirePackage[bookmarks=true,linktocpage=true,bookmarksnumbered=true,breaklinks=true]{hyperref}
\RequirePackage{geometry}



%%%
%	Set last page label
%%%

%% Has to be the above any writeout AtEndDocument as the "labels have changed warning" will be triggered otherwise.

\AtEndDocument{
	\label{lastdocpage}
}




%%%
%   Grid
%%%

\setnewlength{\layoutleftmargin}{15mm}
\setnewlength{\layoutrightmargin}{15mm}
\setnewlength{\layouttopmargin}{\dimexpr 40.5mm\relax} % 2*20.25mm
\setnewlength{\layoutbottommargin}{\dimexpr 31.5mm\relax} % 2*15.75mm
\setnewlength{\marginparL}{\columnsep}
\setnewlength{\marginparR}{\layoutrightmargin}

\def\gridcolumns{12}
\def\gridleftcolumns{1}
\def\gridrightcolumns{2}
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


%%%
%   Layout
%%%

%%% TODO implement \sethf \pagestyle{fancy}


%%%
% Set original margins
%%%

\newcommand{\resetrightmargin}{
  \setlength{\marginparsep}{\marginparL}
  \setlength{\marginparwidth}{\dimexpr \frameright - \marginparL - \marginparR \relax}
  \setnewlength{\rightmargincalculated}{\dimexpr \layoutrightmargin + \marginparL + \marginparwidth \relax}
}


\newcommand{\resetlayout}{
  \disablepageskip
  \sethf
  
	%%%	If the document uses the "twoside" option
	\iftwosided
		\newgeometry{headsep=30pt,bindingoffset=0cm,top=\layouttopmargin,left=\frameleft,right=\frameright,bottom=\layoutbottommargin,headheight=16pt,twoside=true}
	%%%	If the document uses the "oneside" option
	\else
		\newgeometry{headsep=30pt,bindingoffset=0cm,top=\layouttopmargin,left=\frameleft,right=\frameright,bottom=\layoutbottommargin,headheight=16pt,twoside=false}
	\fi
  \resetrightmargin
  \enablepageskip
}


\AtBeginDocument{
\preprintdata\author{, }{ \& }
\def\@author{\printstring\author} %%% Todo, command doesn't work for pdf
	\hypersetup{pdftitle = {\@title},pdfauthor = {\@author},pdfsubject={\thesubtitle},pdfkeywords={Version \theversionnum} {Eindhoven University of Technology},pdfcreator={aLeX TU/e template}}
\preprintdata\author{,\hfill\break}{ \&\hfill\break}
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
	\newvariable{notesname}{note}
	\newvariable{listofnotesname}{List of Notes}
\else
	\newvariable{notesname}{notitie}
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
\renewcommand{\sfdefault}{phv}
\renewcommand{\rmdefault}{phv}
\renewcommand{\ttdefault}{pcr}
\renewcommand{\familydefault}{\sfdefault}

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
%   Text styles
%%%



% heading subparagraph
\def\styling@headingsubparagraph{%
  \setfontsize{9.25bp}{12.75bp}%
	\fontmedium%
  \leavevmode\color{colorsubheading}\it%
}


% heading paragraph
\def\styling@headingparagraph{%
  \setfontsize{10bp}{12.75bp}%
	\fontbold%
  \leavevmode\color{colorsubheading}%
}

% heading subsubsection
\def\styling@headingsubsubsection{%
  \setfontsize{12.25bp}{16bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading subsection
\def\styling@headingsubsection{%
  \setfontsize{16bp}{21,25bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading section
\def\styling@headingsection{%
  \setfontsize{20bp}{26,75bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading chapter
\def\styling@headingchapter{%
  \setfontsize{24bp}{32bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading part
\def\styling@headingpart{%
  \setfontsize{30bp}{40bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

%%%%%%%

% heading Large
\def\styling@headingLarge{%
  \setfontsize{36bp}{48bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading LARGE
\def\styling@headingLARGE{%
  \setfontsize{42bp}{54bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading huge
\def\styling@headinghuge{%
  \setfontsize{48bp}{58bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% intro normal
\def\styling@intronormal{%
  \setfontsize{10.75bp}{14.35bp}%
	\fontmedium%
  \leavevmode\color{colorintro}%
}

% intro large
\def\styling@introlarge{%
  \setfontsize{12.25bp}{16bp}%
	\fontmedium%
  \leavevmode\color{colorintro}%
}

% body text
\def\styling@body{%
  \setfontsize{9.25bp}{12.75bp}%
	\fontdefault%
  \leavevmode\color{colorbody}%
}

% promotional text
\def\styling@promotional{%
  \setfontsize{10.75bp}{14.35bp}%
	\fontnormal%
  \leavevmode\color{colorpromotional}%
}

% promotional heading
\def\styling@promotionalheading{%
  \setfontsize{11bp}{14.35bp}%
	\fontbold%
  \leavevmode\color{colorsubheading}%
}

% quote normal
\def\styling@quotenormal{%
  \setfontsize{15bp}{20bp}%
	\fontmedium%
  \leavevmode\color{colorquote}%
}

% quote large
\def\styling@quotelarge{%
  \setfontsize{18bp}{24bp}%
	\fontmedium%
  \leavevmode\color{colorquote}%
}

% accent text
\def\styling@accent{%
  \setfontsize{9.25bp}{12.75bp}%
	\fontmedium%
  \leavevmode\color{coloraccent}%
}

% info text
\def\styling@info{%
  \setfontsize{9.25bp}{12.75bp}%
	\fontnormal%
  \leavevmode\color{colorinfo}%
}

% caption
\def\styling@caption{%
  \setfontsize{9.25bp}{12.75bp}%
	\fontbold%
  \leavevmode\color{colorcaption}%
}

% note
\def\styling@note{%
  \setfontsize{7.75bp}{12.75bp}%
	\fontnormal%
  \leavevmode\color{colornote}%
}

% quote normal
\def\styling@payoffnormal{%
  \setfontsize{10bp}{12.75bp}%
	\fontmedium%
  \leavevmode\color{colorpayoff}%
}

% quote large
\def\styling@payofflarge{%
  \setfontsize{15bp}{12.75bp}%
	\fontmedium%
  \leavevmode\color{colorpayoff}%
}

% tiny (self-defined)
\def\styling@tiny{%
  \setfontsize{6,25bp}{12.75bp}%
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
    \@ifequal{#1}{1}{\styling@quotelarge}%
    {\@ifequal{#1}{2}{\styling@quotenormal}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
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

\renewcommand{\arraystretch}{1.75}

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


% redefine \raggedright to not create with \shapepar:
% i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
\def\raggedright{%
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

%%%	Set link colors
\hypersetup{
  bookmarks=true,
  linktocpage=true,
  bookmarksnumbered=true,
  breaklinks=true,
	colorlinks,
	linkcolor={tuered},
	citecolor={tuedarkblue},
	urlcolor={tuescarlet}
}

\urlstyle{allbreak} % set as default

%%% command \code{<content>}
%%  styles content as a non-linking url
%%  affected by restrictedbreak or allbreak
\DeclareUrlCommand\code{\urlstyle{same}}




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

\def\thepart{\the\numexpr\value{part}+\@sectioningshift\relax}

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
  \createsectioningstyling[1]{\section}{-3.5ex}{-1ex}{-.2ex}{2.3ex}{.2ex}
  \createsectioningstyling[2]{\subsection}{-3.25ex}{-1ex}{-.2ex}{1.5ex}{.2ex}
  \createsectioningstyling[3]{\subsubsection}{-3.25ex}{-1ex}{-.2ex}{1.5ex}{.2ex}

  \def\@makechapterhead#1{%
    \vspace*{50\p@}%
    {\parindent \z@ \raggedright \style[0]{heading}%\normalfont
      \ifnum \c@secnumdepth >\m@ne
        \ifchaptername % check for chaptername option
          \@chapapp\space\thechapter\linebreak
        \fi
         %\vskip 20\p@
      \fi
      \interlinepenalty\@M
      \Huge \bfseries #1\par\nobreak
      \vskip 40\p@
    }}
  \def\@makeschapterhead#1{%
    \vspace*{50\p@}%
    {\parindent \z@ \raggedright
      \style[0]{heading}%\normalfont
      \interlinepenalty\@M
      \Huge \bfseries  #1\par\nobreak
      \vskip 40\p@
    }}
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
    %%%% \thesectioningcounterdisplay TODO remove, used for testing
    \csname old\expandafter\cs@to@str\string#2\endcsname##3{##2}
    \ifx\@empty##1%
      \autolabeling{#2}{##2}%
    \else%
      \autolabeling{#2}{##1}%
    \fi
    \partmark{##2}
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

  \def\partmark#1{
    \markboth{\leftmark}{\MakeUppercase{\partname\space\thepart.\space#1}}
  }

  %%%	Chapter no number command
  \createsectioning[0]{\chapter}

    \def\chaptermark#1{
      \markboth{\MakeUppercase{\ifnum \c@secnumdepth >\m@ne \chaptername\space\thechapter.\fi\space#1}}{\rightmark}
    }


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
      
          \raggedright%
          \style{note}#2\vspace{-\baselineskip}\end{minipage}}
    }{%
      %%% Left bottom column
      \axisposition{\@axisheight-\@axiswidth-\@axispadding}%
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\axispositionY},left,top]{%
        \begin{minipage}[t][\dimexpr \@axisheight-\@axispadding \relax]{\dimexpr \axispositionX - \@tocleftpadding -\@axispadding \relax}%
          \slantedpar{40}{\linewidth}%
          \raggedright%
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

    \setlength{\tempboxaheight}{0pt}
    \ifprofilingtouched
        \axisposition{\paperheight-5.25mm-1.5cm}
        \ifprofilingfilled
          \titlepagecontent[\theprofilingcolor]{\theprofilingvalue}{white}{\style[1]{heading}}
        \else
          \titlepagecontent{\theprofilingvalue}{\theprofilingcolor}{\style[1]{heading}}
        \fi
    \else
      \axisposition{\paperheight-2.3cm}
      \titlepagecontent{\thelogoname}{tuedarkblue}{\style[4]{heading}}
    \fi
	\else
		\relax
	\fi

	%%%	Draw horizontal axis
	\pgfsetcolor{tuered}
	\pgfpathmoveto{\pgfpoint{0mm}			{\@axisheight}}
	\pgfpathlineto{\pgfpoint{\paperwidth}	{\@axisheight}}
	\pgfpathlineto{\pgfpoint{\paperwidth}	{\@axisheight-\@axiswidth}}
	\pgfpathlineto{\pgfpoint{0cm}			{\@axisheight-\@axiswidth}}
	\pgfusepath{fill}

	%%%	Draw diagonal axis
	\pgfpathmoveto{\pgfpoint{\@Hspacing}						{\paperheight}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@Hshift}				{0cm}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@axiswidth-\@Hshift}	{0cm}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@axiswidth}			{\paperheight}}
	\pgfusepath{fill}

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



            %% TODO move
            \newcommand{\settocompleteheight}[2]{
            \settoheight{#1}{#2}
            \settodepth{\@tempdima}{#2}
            \addtolength{#1}{\@tempdima}
            \global#1=#1
            }

   %% to use you need to set \axispostionX and \axispositionY lengths first, preferably by using \axisposition
   % also set tempboxaheight 0 if it is the first
   \setnewlength{\tempboxaheight}{0pt}
   \setnewlength{\tempboxawidth}{0pt}
   
\newcommand{\titlepagecontent}[4][\@empty]{
  \setlength{\tempboxawidth}{0pt}
  \axisposition{\axispositionY-2\tempboxaheight}
  \setnewlength{\@tempbaselength}{\dimexpr\paperwidth-\axispositionX-\@axispadding-\layoutrightmargin\relax}
  \pgftext[at=\pgfpoint{\axispositionX+\@axispadding}{\axispositionY},left,top]{%% TODO better positioning 
    \@ifequal{#1}{}{
      \setlength{\tempboxaheight}{0pt}
    }{
      \def\@tempcontentinside{
          #4%
          \leavevmode\color{#3}%
          #2
      }
      \def\@tempcontent{% 
        #4%
        \leavevmode\color{#3}%      
        \vbox{%
          \slantedpar[right]{40}{\linewidth}%
          \raggedright%
           \@tempcontentinside\vspace{\baselineskip}}%
      }%
      \global\sbox{\@tempboxa}{%
        \begin{minipage}[t]{\@tempbaselength}%
        \parbox{\linewidth}{%
          \@tempcontent%
        }
        \end{minipage}%
      }%
      \settocompleteheight{\tempboxaheight}{\usebox{\@tempboxa}}
      
      \ifx#1\@empty\else
        #4
        \getlongestsentence{#2}
        \ifdim \templongest < \@tempbaselength
          \setlength{\tempboxawidth}{\templongest}
        \else
          \setlength{\tempboxawidth}{\@tempbaselength}
        \fi
          \global\tempboxawidth=\tempboxawidth
      \fi
    }
  }
  \ifx#1\@empty\else
    \pgfsetcolor{#1}
    \pgfpathmoveto{\pgfpoint{\axispositionX }                                                  {\axispositionY}}
    \pgfpathlineto{\pgfpoint{\axispositionX  + \tempboxawidth + 2\baselineskip}                {\axispositionY}}
    \pgfpathlineto{\pgfpoint{\axispositionX   + \tempboxawidth + 2\baselineskip}                {\axispositionY - 2\tempboxaheight}}
    \pgfpathlineto{\pgfpoint{\axispositionX  - \@shiftratio\tempboxaheight*2}                  {\axispositionY - 2\tempboxaheight}}
    \pgfusepath{fill}
  \fi
  \pgftext[at=\pgfpoint{\axispositionX+\@axispadding}{\axispositionY-\baselineskip},left,top]{%% TODO better positioning 
     \usebox{\@tempboxa}
  }
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
      
    
%%% TODO use only on frontpage, then reset
\def\@fnsymbol#1{\ifcase\value{footnote}\or*\or
†\or‡\or§\or¶\or||\or**\or††\or‡‡\or|||\or***\or†††\or‡‡‡\or \ClassError{TUeStyle}{Frontpage counter too large. Are you sure you need that many authors?}\fi}

\renewcommand\maketitle{
  \clearpage%
  \setcounter{footnote}{-1}
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}
  \def\and{} %%% TODO add warning
  \begin{titlepage}
    %%%% TODO footnotesize and settings
    \let\footnotesize\small%
    \let\footnoterule\relax%
    \let\footnote\thanks%
    %%%\hfuzz=1000pt

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
      \titlepagecontent{\@title}{black}{\style[0]{heading}}
      \titlepagecontent{\thesubtitle}{black}{\style[3]{heading}}
      \titlepagecontent{\thesubsubtitle}{black}{\style{body}\justified}    
      
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
  \setlength{\parskip}{\listofparskip}

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
	\style{body}\color{black}\footnumber\color{hfcolor}\space-\space
	\@title 
  	\ifx\theversionnum\empty\relax\else
      { / \theversionlabel\space\theversionnum }
    \fi
	\ifsectioningf
    \\\itshape\nouppercase{\leftmark}
  \fi
	\ifx\theextraf\empty\relax\else
    \\\theextraf
  \fi
}

%%%	Define right side footer
\newcommand{\rightsidefoot}{
	\style{body}\color{hfcolor}
  \@title
  \ifx\theversionnum\empty\relax\else
    { / \theversionlabel\space\theversionnum }
  \fi
  \space-\space\color{black}\footnumber\color{hfcolor}
	\ifsectioningf
    \\\itshape\nouppercase{\rightmark}
  \fi
	\ifx\theextraf\empty\relax\else
    \\\theextraf
  \fi
}

%%%	Define copyholder footer
\newcommand{\copyfoot}{
	\ifcopyf
		\frontpagehead{\thecopyholderlabel}\meta\thecopyholder
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
	%	Header in the center of the page
	\fancyhead[C]{
		\draftmarking
	}
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
	%	Copyholder on other side
	\fancyfoot[LE]{
		\copyfoot
	}
	%	Copyholder on other side
	\fancyfoot[RO]{
		\copyfoot
	}
	\renewcommand{\headrulewidth}{0mm}
}

%%%	Define header and footers for oneside design
\newcommand{\setheadersOne}{
	\pagestyle{fancy}
	\fancyhf{}
	%	Header in the center of the page
	\fancyhead[C]{
		\draftmarking
	}
	%	Header only on the right side
	\fancyhead[R]{
		\rightsidehead
	}
	%	Footer only on the left side
	\fancyfoot[L]{
		\leftsidefoot
	}
	%	Copyholder on other side
	\fancyfoot[R]{
		\copyfoot
	}
	\renewcommand{\headrulewidth}{0mm}
}

%%%	Set defined header/footers, custom, twoside or oneside
\newcommand{\sethf}{
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
}
\sethf





%%%
% Define draftmark
%%%

\newsavebox{\draftBox}
\savebox{\draftBox}{%
	\color{colorlink}
	\rotatebox[origin=c]{-45}{\fontsize{300bp}{0bp} \selectfont \textbf{\textsc{draft}}}%
}%

%%%	Declare the \draftmark command and scale it to the text
\newcommand{\draftmark}{%
	\resizebox{!}{200pt}{\usebox{\draftBox}}%
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
\begingroup\fontfamily{crm}\textlatin{\oldaLeX}\endgroup%
}

\DeclareRobustCommand{\org@LeX}{%
L\kern -.1667em\lower .5ex\hbox {E}\kern -.125emX\@
}

\DeclareRobustCommand{\oldLeX}{%
\org@LeX%
}

\DeclareRobustCommand{\LeX}{%
\begingroup\fontfamily{crm}\textlatin{\oldLeX}\endgroup%
}





%%%
% \CaLaTeX command
%%%

\DeclareRobustCommand{\oldCaLaTeX}{%
C\kern-.2em%
{\sbox\z@ T%
\vbox to\ht\z@{\hbox{%
\check@mathfonts
\fontsize\sf@size\z@
\math@fontsfalse\selectfont A}%
\vss}%
}%
\kern-.15em%
\oldLaTeX}

\DeclareRobustCommand{\CaLaTeX}{%
\begingroup\fontfamily{crm}\textlatin{\oldCaLaTeX}\endgroup%
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
\begingroup\fontfamily{crm}\textlatin{\oldLaTeX}\endgroup%
}

\DeclareRobustCommand{\oldTeX}{%
\org@TeX%
}

\DeclareRobustCommand{\TeX}{%
\begingroup\fontfamily{crm}\textlatin{\oldTeX}\endgroup%
}




%%%
% \CaTeX
%%%

%%%%%%%%%%%% Needs to be created






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
  
  \newcommand{\note}[1]{%
    \refstepcounter{note}%
    \notestyle{\thenote}{#1}%
    \addcontentsline{lon}{note}{\numberline {\thenote} #1}
  }
\else
  \newcommand{\note}[1]{}
\fi


%% defines the note styling
\newcommand{\notestyle}[2]{%
  \textcolor{tuescarlet}{
    \textbf{[\thenotesname\space #1:}
    #2%
    \textbf{]}
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
\oldmarginpar{\style{note}#1}
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
% set default font
%%%

\AtBeginDocument{
	%% Set font
	\style{body}
  %%  Removes extreme spacing between paragraphs
  %   Boxes on every page are of a different height
\raggedbottom
}