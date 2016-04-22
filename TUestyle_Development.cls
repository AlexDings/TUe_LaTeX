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

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{pgf}
\RequirePackage{xkeyval}
\RequirePackage{pgf}  % loads also »xcolor«
\RequirePackage[dutch, english]{babel}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
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
\newif\ifchapterf
\chapterffalse

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
%%  Note: in order to avoid rounding off errors, compare fractions to fractions and real numbers X.XX to real numbers
%%%% TODO DOESN'T WORK WHEN USING TWO FRACTIONS
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
\DeclareOptionX{onesided}{\twosidedfalse}
\DeclareOptionX{twosided}{\twosidedtrue}

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
    \def\@coverratio{#1} %%%TODO doesn't work
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
\DeclareOptionX{chapterf}{\chapterftrue}

% draw chapter in footer
\DeclareOptionX{copyf}{\copyftrue}

% draw last page number in footer
\DeclareOptionX{endf}{\endftrue}

% draw shorter header
\DeclareOptionX{shorth}{\shorthtrue}
}

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
%%  correctly enquotes content
\newcommand{\enquote}[1]{``#1''}

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

%%%%% TODO move
%%%	Define the instructions command if the "instructions" option is used
\ifx\drawinstructions\undefined
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
  \setlength{#1}{#2}
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




%%% \adddata\<name>{<value 1}...{<value n-1}{<value n}
%%  saves data in \data:<name>:<range>
\newcommand{\adddata}[1]{% Use a declaration
  \edef\tempname{\string#1}
  \edef\tmp@sum{\string#1@sum}
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
      \expandafter\def\csname data:\tempname:\the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname  \endcsname{#1}%
      \@ifnextchar\bgroup{\gobblenext}{}% Gobble next "argument"
    }


%%% \getdata[<index>]\<name>
%%  prints data contained in \data:<name>:<index>
\def\getdata[#1]#2{\csname data:\string#2:#1\endcsname}

%%% \printdata{\<name>}{<global delimiter optional>}{<last delimiter optional>}
%%  prints data contained in \data:<name>:<range>
\newcommand{\printdata}[1]{%
  \def\tempname{\string#1}%
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
      \printdatainternal#1%
    }

    \newcommand{\printdatainternal}[1]{%
      \ifnum \the\tempcount < \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname \relax%
        \ifnum \the\tempcount > 1% Use first delimiter in front of values, after the first value
          \delimi%
        \fi%
        \csname data:\tmp:\the\tempcount\endcsname% Print current value
        \advance\tempcount 1\relax%
        \printdatainternal#1% % Loop
      \else%
        \ifnum \the\tempcount = \the\csname c@\expandafter\cs@to@str\tmp@sum\endcsname \relax% % Use second delimiter in front of the last value
          \delimii%
          \csname data:\tmp:\the\tempcount\endcsname% Print last value
        \fi
      \fi
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
    \label{[part:#2]}
  }{\@ifequal{#1}{\chapter}{%
		\label{ch:#2}%
  }{\@ifequal{#1}{\chapter}{%
		\label{sec:#2}
  }{\@ifequal{#1}{\chapter}{%
		\label{subsec:#2}%
  }{\@ifequal{#1}{\chapter}{%
		\label{sssec:#2}%
  }}}}}
}

%%% \DivideLengths{\<name>}{\<name>}
%%  Divides two given lengths
\newcommand*{\DivideLengths}[2]{%
  \strip@pt\dimexpr\number\numexpr\number\dimexpr#1\relax*65536/\number\dimexpr#2\relax\relax sp\relax
}

%%% command \slantedpar{<integer #lines>}{<paragraph width>}
%%  initiates parshape settings
\newcommand{\slantedpar}[2]{
  \setnewlength{\interval}{\@shiftratio\baselineskip}
  %\rightskip=0pt plus 2em\relax
  \raggedright
  \slantedparvalues{#1}{#1}{#2}
  \parshape=#1
  \temphold
}

    %%  Command to calculate current line width
    \newcommand{\axislinewidth}[3]{%
      \expandafter\dimexpr #3-#2\interval+#1\interval \relax%
    }

    % Definition to hold the result calculations as strings
    \long\def\temphold{}

    \newcounter{templine}

    %%  loop command, also expanding \temphold with string result
    \newcommand{\slantedparvalues}[3]{
      \long\edef\temphold{%
        \temphold%
        0cm \axislinewidth{#1}{#2}{#3}%
      }
      \setcounter{templine}{#1}
      \addtocounter{templine}{-1}
      \ifnum #1 > 0 %loop if we are not out of lines
        \slantedparvalues{\thetempline}{#2}{#3}
      \else\fi
    }

    
%%% command \axispositionlength{<y-position from bottom>}
%%  initiates parshape settings
\newlength{\axispositionlength}
\newcommand{\axisposition}[1]{%
  \setlength{\axispositionlength}{\dimexpr #1 \relax}%
  \setlength{\axispositionlength}{\dimexpr \@Hspacing-\@Hshift + \@shiftratio\axispositionlength -\@axiswidth \relax}%
}





%%%
%   Internal debug commands
%%%

\newcommand{\stripmacro}[1]{\expandafter\begingroup\escapechar=-1\edef\x{\endgroup\string#1}\x}

%%% Define showlength command
\def\convertto#1#2{\strip@pt\dimexpr #2*65536/\number\dimexpr 1#1}
\newcommand{\showlength}[2]{\textbf{\stripmacro{#2}}:\space\convertto{#1}{#2}\space#1}




	
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
\RequirePackage{hyperref}
\RequirePackage{geometry}






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

\setnewlength{\gridcolumnwidth}{\dimexpr (\paperwidth - \layoutleftmargin - \layoutrightmargin - \numexpr\gridcolumns-1\relax\gridcolumnwidth) / \gridcolumns \relax}

\setnewlength{\frameleft}{\dimexpr \layoutleftmargin + \gridleftcolumns\gridcolumnwidth \relax}
\setnewlength{\frameright}{\dimexpr \layoutrightmargin + \gridrightcolumns\gridcolumnwidth \relax}

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
\newcommand{\sethf}{\pagestyle{plain}}

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
  
	%%%	If the document uses the "oneside" option
	\ifx\drawtwoside\undefined
		\newgeometry{headsep=30pt,bindingoffset=0cm,top=\layouttopmargin,left=\frameleft,right=\frameright,bottom=\layoutbottommargin,headheight=16pt,twoside=false}

	%%%	If the document uses the "twoside" option
	\else
		\newgeometry{headsep=30pt,bindingoffset=0cm,top=\layouttopmargin,left=\frameleft,right=\frameright,bottom=\layoutbottommargin,headheight=16pt,twoside=true}
	\fi
  \resetrightmargin
  \enablepageskip
}

\AtBeginDocument{
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
  \newvariable{university}{Eindhoven University of Technology}
\else
  \newvariable{university}{Technische Universiteit Eindhoven}
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
\newcommand*{\extraf}[1]{\def\extrafooter{#1}}
\newcommand*{\extrah}[1]{\def\extraheader{#1}}

%%% Initialisation of the above commands
\extraf{}
\extrah{}


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
	\noindent\makebox[0pt][l]{}\\*[-\baselineskip]\hspace*{#1\tabsize}%
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
    \renewcommand{\addvspace}[1]{}
    \addcontentsline{toc}{chapter}{\listtablename}
    \oldlistoftables
	\endgroup
}

%%%	Declare the \listoffigures command for the list of figures
\storeold{\listoffigures}
\renewcommand{\listoffigures}[1][\thelistoffiguresname]{
	\renewcommand{\listfigurename}{#1}
	\renewcommand*\l@figure{\@dottedtocline{1}{0em}{\listindent}}% Default: 1.5em/2.3em
  \begingroup
    \renewcommand{\addvspace}[1]{}
    \addcontentsline{toc}{chapter}{\listfigurename}
    \oldlistoftables
	\endgroup
}





%%%
%   TU/e style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%   Fonts
%%%

% Helvetica
\renewcommand{\sfdefault}{phv}
\renewcommand{\rmdefault}{phv}
\renewcommand{\ttdefault}{pcr}

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



%%%
%   Text styles
%%%

% heading small
\def\styling@headingsmall{%
  \setfontsize{10bp}{12.75bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading normal
\def\styling@headingnormal{%
  \setfontsize{24bp}{32bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

% heading large
\def\styling@headinglarge{%
  \setfontsize{30bp}{40bp}%
	\fontbold%
  \leavevmode\color{colorheading}%
}

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

% sub heading large
\def\styling@subheadinglarge{%
  \setfontsize{18bp}{24bp}%
	\fontmedium%
  \leavevmode\color{colorheading}%
}

% sub heading normal
\def\styling@subheadingnormal{%
  \setfontsize{12.25bp}{16bp}%
	\fontmedium%
  \leavevmode\color{colorsubheading}%
}

% sub heading small
\def\styling@subheadingsmall{%
  \setfontsize{9.25bp}{12.75bp}%
	\fontnormal%
  \leavevmode\color{colorsubheading}%
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
\newcommand{\style}[2][normal]{%
  \@ifequal{#2}{heading}{%
    \@ifequal{#1}{huge}{\styling@headinghuge}%
    {\@ifequal{#1}{LARGE}{\styling@headingLARGE}%
    {\@ifequal{#1}{Large}{\styling@headingLarge}%
    {\@ifequal{#1}{large}{\styling@headinglarge}%
    {\@ifequal{#1}{normal}{\styling@headingnormal}%
    {\@ifequal{#1}{small}{\styling@headingsmall}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}}}}}%
  }{\@ifequal{#2}{subheading}{%
    \@ifequal{#1}{large}{\styling@subheadinglarge}%
    {\@ifequal{#1}{normal}{\styling@subheadingnormal}%
    {\@ifequal{#1}{small}{\styling@subheadingsmall}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}}%
  }{\@ifequal{#2}{intro}{%
    \@ifequal{#1}{large}{\styling@introlarge}%
    {\@ifequal{#1}{normal}{\styling@intronormal}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\@ifequal{#2}{body}{%
    \@ifequal{#1}{normal}{\styling@body}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{promotional}{%
    \@ifequal{#1}{normal}{\styling@promotional}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{promotional-heading}{%
    \@ifequal{#1}{normal}{\styling@promotionalheading}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{quote}{%
    \@ifequal{#1}{normal}{\styling@quotenormal}%
    {\@ifequal{#1}{large}{\styling@quotelarge}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\@ifequal{#2}{accent}{%
    \@ifequal{#1}{normal}{\styling@accent}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{info}{%
    \@ifequal{#1}{normal}{\styling@info}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{caption}{%
    \@ifequal{#1}{normal}{\styling@caption}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{note}{%
    \@ifequal{#1}{normal}{\styling@note}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\@ifequal{#2}{payoff}{%
    \@ifequal{#1}{normal}{\styling@payoffnormal}%
    {\@ifequal{#1}{large}{\styling@payofflarge}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\@ifequal{#2}{tiny}{%
    \@ifequal{#1}{normal}{\styling@tiny}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }%
  }}}}}}}}}}}}%
}

%%% meta shortcuts
\def\metasmall{\style{tiny}}
\def\meta{\style{note}}
\def\metanormal{\style{body}}

%%% titlepage styling
\def\frontpagehead#1{
  \iffirsthead
    \firstheadfalse
  \else
    \hfill\break% Leave a blank space
  \fi
  \leavevmode\style{tiny}\textbf{#1}\hfill\break 
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
\setlength{\labelsep}{\tabsize}

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

\PassOptionsToPackage{table}{xcolor}

\def\zapcolorreset{\let\reset@color\relax\ignorespaces}
\def\colorrows#1{\noalign{\aftergroup\zapcolorreset#1}\ignorespaces}

\edef\endtabular{\unexpanded\expandafter{\endtabular}\noexpand\reset@color}

\storeoldenv{\table}
\renewenvironment{table}[1][ht]{%
  \oldtable[#1]}%
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
\newlength{\listindent}
\setlength{\listindent}{2\tabsize}

%%%
%   Fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
\newvariable{orderissuer}{}
\newvariable{reference}{}
\newvariable{address}{}
\newvariable{versionnum}{}
\newvariable{copyholder}{}
\newvariable{addfrontpage}{}

\newif\ifprofilingtouched
\profilingtouchedfalse
\newcommand\profiling[1]{
	\profilingtouchedtrue
	\newvariable{profilingvalue}{#1}
}


\RequirePackage{hyperref}

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
	urlcolor={tuewarmred}
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
	\ifnum #1 < 2	
		\setcounter{part}{1}
	\fi
	\ifnum #1 < 3	
		\setcounter{chapter}{1}
		\setcounter{figure}{1}
		\setcounter{table}{1}
	\fi
	\ifnum #1 < 4	
		\setcounter{section}{1}
	\fi
	\setcounter{subsection}{1}
	\setcounter{subsubsection}{1}
	\setcounter{paragraph}{1}
	\setcounter{subparagraph}{1}
}

%%% Set counter depth to only exclude subsubsection and (sub)paragraph
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}

\def\thepart{\the\numexpr\value{part}+\@sectioningshift\relax}

\def\thechapter{%
\ifnum\value{chapter} < 1%
	\addtocounter{chapter}{1}%
\fi
\ifnum\the\numexpr\value{chapter}+\@sectioningshift\relax < 10
	0\the\numexpr\value{chapter}+\@sectioningshift
\else
	\the\numexpr\value{chapter}+\@sectioningshift
\fi\space
}

\def\thesection{\thechapter\relax%
\texorpdfstring{\protect\watermark{.}}{.}%
\ifnum\value{section} < 1%
	\addtocounter{section}{1}%
\fi%
\the\numexpr\value{section}+\@sectioningshift\relax}

\def\thesubsection{\thesection\relax%
\texorpdfstring{\protect\watermark{.}}{.}%
\ifnum\value{subsection} < 1%
	\addtocounter{subsection}{1}%
\fi%
\the\numexpr\value{subsection}+\sectioningshift\relax}

\def\thesubsubsection{\thesubsection\relax%
\texorpdfstring{\protect\watermark{.}}{.}%
\ifnum\value{subsubsection} < 1%
	\addtocounter{subsubsection}{1}%
\fi%
\the\numexpr\value{subsubsection}+\@sectioningshift\relax}








\newif\iffirsthead
\newcommand{\infobox}[2][bottom]{%
  \begingroup
  \firstheadtrue
  \setlength{\fboxsep}{0pt}
    \@ifequal{#1}{top}{%
      %%% Left top column
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\@axisheight+\@axiswidth+\@axispadding},left,bottom]{%
        \axisposition{\@axisheight+\@axispadding}%
        \begin{minipage}[b][\dimexpr \paperheight-\@axisheight-\@axispadding \relax]{\dimexpr \axispositionlength - \@tocleftpadding -\@axispadding \relax}%
      
          \raggedright%
          \style{note}#2\vspace{-\baselineskip}\end{minipage}}
    }{%
      %%% Left bottom column
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\@axisheight-\@axispadding-\@axiswidth},left,top]{%
        \axisposition{\@axisheight-\@axiswidth-\@axispadding}%
        \begin{minipage}[t][\dimexpr \@axisheight-\@axispadding \relax]{\dimexpr \axispositionlength - \@tocleftpadding -\@axispadding \relax}%
          \raggedright%
          \slantedpar{40}{\linewidth}%
          #2\end{minipage}}
    }
  \endgroup
}








%%%
%   Titlepage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\setnewlength{\@axispadding}{2mm}

%%%
% Defining command for the TU/e logo, innovation and axes
%%%

%%% Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtuelogoandaxes}{
	%%%	If drawtuelogo is not set to false, by the "notuelogo" option
	\iflogo
		 % TU/e logo and red lines
		 \pgftext[at=\pgfpoint{\@Hspacing-2.31cm}{\the\paperheight-5.25mm},left,top]{\includegraphics[width=7cm]{tuelogo}}%
		
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
		\pgfsetcolor{tuedarkblue}
		\pgftext[at=\pgfpoint{\@Hspacing-.5cm}{\the\paperheight-2.3cm},left,top]{\bfseries \thelogoname}%		
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
	\ifx\innovation\undefined
		\pgfsetcolor{tuedarkblue}
		\pgftext[at=\pgfpoint{\@Hspacing-\@Hshift+420mm}{6.75mm},left,bottom]{\bfseries Where innovation starts}%
	\fi

	%%%	Reset colour to black
	\pgfsetcolor{black}
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
      
\renewcommand\maketitle{
\clearpage%
\begin{titlepage}

  %%%% TODO footnotesize and settings
	\let\footnotesize\small%
	\let\footnoterule\relax%
	\let\footnote\thanks%
	%\hfuzz=1000pt

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
		
		%%%	Drawing of the TU/e axes and logo
		\drawtuelogoandaxes
		
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
					\hypersetup{urlcolor={tuewarmred}}
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
      \pgftext[at=\pgfpoint{\paperwidth-\@coverwidth+0.5cm}{\@coverbottom-0.5cm},left,top]{%
        \parbox[t]{0.5\paperwidth}{\raggedright\normalfont\fontsize{17}{19}\selectfont\bfseries \@title\\[1ex]\large\mdseries \thesubtitle}%
      }
    \else 
    %%% Title and subtitle at normal position
      \pgftext[at=\pgfpoint{\@Hspacing-1.88cm}{\@axisheight-\@axiswidth-0.48cm},left,top]{%
        \parbox[t]{0.5\paperwidth}{\raggedright\normalfont\fontsize{17}{19}\selectfont\bfseries \@title\\[1ex]\large\mdseries \thesubtitle}%
      }
    \fi
	\end{pgfpicture}%
\end{titlepage}

\hfuzz=0pt

%%%	Reset the original values of all margins
\resetlayout
}

%%%
% 	Redefine chapter heading style 
%%%

\ifsectioningstyling
  % Redefining the \chapter command from the report and book class
  % to make sure that headings are also printed on pages
  % that start a new chapter. The "Chapter" word is also removed.
  % Most of the modifications are lines being commented out.
  \renewcommand\chapter
  {
    \if@openright
      \cleardoublepage
    \else
      \clearpage
    \fi
  %	\thispagestyle{plain}%
    \global\@topnum\z@
    \@afterindentfalse
    \secdef
    \@chapter
    \@schapter
  }

  \def\@makechapterhead#1{%
    \vspace*{50\p@}%
    {
      \parindent \z@ \raggedright \normalfont
      \ifnum \c@secnumdepth >\m@ne
      \LARGE\bfseries \thechapter
  %		\par\nobreak
  %		\vskip 20\p@
    \fi
  %		\interlinepenalty\@M
      \LARGE \bfseries \hspace{1em} #1\par\nobreak
      \vskip 40\p@
    }
  }
    
  \def\@makeschapterhead#1{%
    \vspace*{50\p@}%
    {
      \parindent \z@ \raggedright
      \normalfont
      \interlinepenalty\@M
      \LARGE \bfseries  #1\par\nobreak
      \vskip 40\p@
    }
  }
\fi



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
    \frontpagehead{\thetitlelabel}%
    \frontpagebody{\@title}%
    \frontpagebody{\thesubtitle}%
  }
}
