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
\ProvidesClass{TUestyle_ReportBook}[\filedate\space\fileversion\space  TU/e style report & book 2008]



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

%%% Switch between book/report
%%  (report by default)
\newif\ifbook\bookfalse

%%% Switch between english/dutch
%%  (english by default)
\newif\ifenglish\englishtrue

%%% Draft mode
%%  (false by default)
\newif\ifdraft\draftfalse

%%% Use Meta OT fonts
%%  (false by default)
\newif\iftuefonts\tuefontsfalse

%%% Sectioning shift
\def\sectioningshift{0}





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

% language options
\DeclareOptionX{english}{\englishtrue}
\DeclareOptionX{engels}{\englishtrue}
\DeclareOptionX{dutch}{\englishfalse}
\DeclareOptionX{nederlands}{\englishfalse}

% draft mode
\DeclareOptionX{draft}{\drafttrue}


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
\DeclareOptionX{zeroindexed}{\def\sectioningshift{-1}}

% use auto labeling
\DeclareBooleanOptionX{autolabel}
\autolabeltrue


% pass options to underlying classes
\DeclareOptionX*{%
  \PassOptionsToClass{\CurrentOption}{book}%
  \PassOptionsToClass{\CurrentOption}{report}%
}

% fonts options
\DeclareOptionX{tuefonts}{\tuefontstrue}

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
	\immediate\closein\@in%
}

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

%%%	command \ifrealnum{<number1>}{<number2>}{<on 1 > 2>}{<on 1 < 2>}{<on 1 = 2>}
%%	compares two (non) integer numbers (real numbers)
\def\ifrealnum #1#2#3#4#5 {%
  \def\@tempa{\numexpr #1 \relax} % allow for fractions (and calculations)
  \def\@tempb{\numexpr #2 \relax} % allow for fractions (and calculations)
  \ifdim\@tempa pt>\@tempb pt % on 1 > 2
    #3
  \else
    \ifdim\@tempa pt<\@tempb pt % on 1 < 2
      #4
    \else % on 1 = 2
      #5
    \fi
  \fi
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

%%%
%   Internal debug commands
%%%


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
%   Layout
%%%

\setnewlength{\layoutleftmargin}{15mm}
\setnewlength{\layoutrightmargin}{15mm}
\setnewlength{\layouttopmargin}{\dimexpr 40.5mm\relax} % 2*20.25mm
\setnewlength{\layoutbottommargin}{\dimexpr 31.5mm\relax} % 2*15.75mm

% TODO implement marginparL & marginparR

%%%
% Set original margins
%%%

\newcommand{\resetlayout}{
	%%%	If the document uses the "oneside" option
	\ifx\drawtwoside\undefined
		\newgeometry{headsep=30pt,bindingoffset=0cm,top=\layouttopmargin,left=\layoutleftmargin,right=\layoutrightmargin,bottom=\layoutbottommargin,headheight=16pt,twoside=false}

	%%%	If the document uses the "twoside" option
	\else
		\newgeometry{headsep=30pt,bindingoffset=0cm,top=\layouttopmargin,left=\layoutleftmargin,right=\layoutrightmargin,bottom=\layoutbottommargin,headheight=16pt,twoside=true}
	\fi
}


%%%
%   Grid
%%%

\def\gridcolumns{12}
\def\gridleftcolumns{1}
\def\gridrightcolumns{2}
\def\gridbodycolumns{\numexpr\gridcolumns-\gridleftmargin-\gridrightmargin\relax}

\setnewlength{\gridgutterwidth}{3.853mm}
\setlength{\columnsep}{\gridgutterwidth}

\setnewlength{\gridcolumnwidth}{\dimexpr (\paperwidth - \layoutleftmargin - \layoutrightmargin - \numexpr\gridcolumns-1\relax\columnsep) / \gridcolumns \relax}

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
%   Draft
%%%





%%%
%   Localization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   Language
%%%

\ifenglish
  %\selectlanguage{english}
\else
  %\selectlanguage{dutch}
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
%   Metadata
%%%


%%%
%   Drafting options
%%%

%%%	Option for showing margins
\newif\ifshowmargins
\showmarginsfalse
%\DeclareOptionX{margins}{
%  \showmarginstrue
%  \Gm@showframetrue
%}

%%%	Option for displaying notes
\newif\ifdrawnotes
\drawnotesfalse
%\DeclareOptionX{drawnotes}{\drawnotestrue}

%%%	Option for displaying instructions
\newif\ifdrawinstructions
\drawinstructionstrue
%\DeclareOptionX{drawinstructions}{\drawinstructionsfalse}


%%%
%   Oneside/twoside & twocolumn options
%%%

%%%	Option for using twoside mode
%	Catch it
\newif\ifdrawtwoside
\drawtwosidefalse
%\DeclareOptionX{twoside}{\drawtwosidetrue}

%%%	Option for using oneside mode
%	Catch it
\newif\ifdrawoneside
\drawonesidefalse
%\DeclareOptionX{oneside}{\drawonesidetrue}

%%%	Option for using twocolumn mode
%	Catch it
\newif\iftwocolumn
\twocolumnfalse
%\DeclareOptionX{twocolumn}{\twocolumntrue}


%%%
%   Header/footer options
%%%

%%%	Option for using oneside header and footer
%%%	for book class
\newif\ifonesidehf
\onesidehffalse
%\DeclareOptionX{onesidehf}{\onesidehftrue}

%%%	Option for faded header and footer
\newif\iffadehf
\fadehffalse
\definecolor{hfcolor}{gray}{0}
%\DeclareOptionX{fadehf}{
%  \fadehftrue
%  \definecolor{hfcolor}{gray}{0}
%}

%%%	Option for chapter in footer
\newif\ifchapterf
\chapterffalse
%\DeclareOptionX{chapterf}{\chapterftrue}

%%%	Option for chapter in footer
\newif\ifcopyf
\copyffalse
%\DeclareOptionX{copyf}{\copyftrue}

%%%	Option for last page number in footer
\newif\ifendf
\endffalse
%\DeclareOptionX{endf}{\endftrue}

%%%	Option to shorter header
\newif\ifshorth
\shorthfalse
%\DeclareOptionX{shorth}{\shorthtrue}

%%%	Option for draftmark over document pages
\newif\ifdraftmark
\draftmarkfalse
%\DeclareOptionX{draftmark}{\draftmarktrue}

%%% command \extraf{<string>} & \extrah{<string>}
%%  Adds custom footer and header  data
\newcommand*{\extraf}[1]{\def\extrafooter{#1}}
\newcommand*{\extrah}[1]{\def\extraheader{#1}}

%%% Initialisation of the above commands
\extraf{}
\extrah{}


%%%
%   Align options
%%%

\def\autocenter{}
\def\autocentershort{}
\def\autocentercap{}

%%%	Option for not-centering images
%\DeclareOptionX{align}{
%  \@ifequal{#1}{left}{%
%    \def\autocenter{\raggedright}%
%    \def\autocentercap{\raggedright}%
%    \def\autocentershort{l}%
%  }{
%  \@ifequal{#1}{center}{%
%    \def\autocenter{\centering}%
%    \def\autocentercap{\centering}%
%    \def\autocentershort{c}%
%  }{
%  \@ifequal{#1}{right}{%
%    \def\autocenter{\raggedleft}%
%    \def\autocentercap{\raggedleft}%
%    \def\autocentershort{r}%
%  }{
%  \@ifequal{#1}{none}{%
%    \def\autocenter{\raggedright}%
%    \def\autocentercap{\centering}%
%    \def\autocentershort{c}%
%  }{}}}}
%}

%\ExecuteOptionsX{align=center}

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
%   Graphicspath
%%%

%%%	Set the graphicspath, the path where images are found
\def\definedpath{}
%\DeclareOptionX{graphicspath}{%
%	\def\definedpath{#1}
%  \graphicspath{{\definedpath}}
%}



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

\newcommand{\fontdefault}{
  \normalfont\selectfont
}

\newcommand{\fontnormal}{
  \iftuefonts
    \usefont{T1}{meta}{m}{n}
  \else
    \normalfont\fontseries{m}\selectfont
  \fi
}

\newcommand{\fontmedium}{
  \iftuefonts
    \usefont{T1}{zmb}{m}{n}
  \else
    \normalfont\fontseries{sb}\selectfont
  \fi
}

\newcommand{\fontbold}{
  \iftuefonts
    \usefont{T1}{zmw}{m}{n}
  \else
    \normalfont\fontseries{b}\selectfont
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
  \color{colorheading}%
  \setfontsize{10bp}{12.75bp}%
	\fontbold%
}

% heading normal
\def\styling@headingnormal{%
  \color{colorheading}%
  \setfontsize{24bp}{32bp}%
	\fontbold%
}

% heading large
\def\styling@headinglarge{%
  \color{colorheading}%
  \setfontsize{30bp}{40bp}%
	\fontbold%
}

% heading Large
\def\styling@headingLarge{%
  \color{colorheading}%
  \setfontsize{36bp}{48bp}%
	\fontbold%
}

% heading LARGE
\def\styling@headingLARGE{%
  \color{colorheading}%
  \setfontsize{42bp}{54bp}%
	\fontbold%
}

% heading huge
\def\styling@headinghuge{%
  \color{colorheading}%
  \setfontsize{48bp}{58bp}%
	\fontbold%
}

% sub heading large
\def\styling@subheadinglarge{%
  \color{colorheading}%
  \setfontsize{18bp}{24bp}%
	\fontmedium%
}

% sub heading normal
\def\styling@subheadingnormal{%
  \color{colorsubheading}%
  \setfontsize{12.25bp}{16bp}%
	\fontmedium%
}

% sub heading small
\def\styling@subheadingsmall{%
  \color{colorsubheading}%
  \setfontsize{9.25bp}{12.75bp}%
	\fontnormal%
}

% intro normal
\def\styling@intronormal{%
  \color{colorintro}%
  \setfontsize{10.75bp}{14.35bp}%
	\fontmedium%
}

% intro large
\def\styling@introlarge{%
  \color{colorintro}%
  \setfontsize{12.25bp}{16bp}%
	\fontmedium%
}

% body text
\def\styling@body{%
  \color{colorbody}%
  \setfontsize{9.25bp}{12.75bp}%
	\fontdefault%
}

% promotional text
\def\styling@promotional{%
  \color{colorpromotional}%
  \setfontsize{10.75bp}{14.35bp}%
	\fontnormal%
}

% promotional heading
\def\styling@promotionalheading{%
  \color{colorsubheading}%
  \setfontsize{11bp}{14.35bp}%
	\fontbold%
}

% quote normal
\def\styling@quotenormal{%
  \color{colorquote}%
  \setfontsize{15bp}{20bp}%
	\fontmedium%
}

% quote large
\def\styling@quotelarge{%
  \color{colorquote}%
  \setfontsize{18bp}{24bp}%
	\fontmedium%
}

% accent text
\def\styling@accent{%
  \color{coloraccent}%
  \setfontsize{9.25bp}{12.75bp}%
	\fontmedium%
}

% info text
\def\styling@info{%
  \color{colorinfo}%
  \setfontsize{9.25bp}{12.75bp}%
	\fontnormal%
}

% caption
\def\styling@caption{%
  \color{colorcaption}%
  \setfontsize{9.25bp}{12.75bp}%
	\fontbold%
}

% note
\def\styling@note{%
  \color{colornote}%
  \setfontsize{7.75bp}{12.75bp}%
	\fontnormal%
}

% quote normal
\def\styling@payoffnormal{%
  \color{colorpayoff}%
  \setfontsize{10bp}{12.75bp}%
	\fontmedium%
}

% quote large
\def\styling@payofflarge{%
  \color{colorpayoff}%
  \setfontsize{15bp}{12.75bp}%
	\fontmedium%
}

% tiny (self-defined)
\def\styling@tiny{%
  \color{colorbody}%
  \setfontsize{6,25bp}{8bp}%
	\fontmedium%
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
\newcommand{\frontpagehead}[1]{{\style{tiny}\textbf{#1}\\[.5ex]}}
\newcommand{\frontpagebody}[1]{{\parbox[t]{\linewidth}{\style{note}#1}\\[2ex]}}



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
%   Cover drawing
%%%

%%%	Option for cover ratio
%%  Ratio has to be bigger than 4:3
%\DeclareOptionX{coverratio}{
%    \ifrealnum{#1}{4/3}{%
%      \def\@coverratio{#1}
%    }{
%	  \def\@coverratio{4/3}
%    }{}
%}

% Set default cover ratio
\def\@coverratio{4/3}

%%%% TODO make option
\newif\ifcover
\covertrue
\def\covername{cover}

%%%	Use twoside standard for book type base class
%	If book is defined and oneside is not then set twoside
\ifx\drawbook\undefined\relax
	\else
		\ifx\drawoneside\undefined
			\def\drawtwoside{true}
		\else
			\def\drawoneside{true}
		\fi
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
\def\@shiftratio{0.287} % 74 degree axis

%%% Axis horizontal shift
\setnewlength{\@Hshift}{\@shiftratio\paperheight}

%%% Table of Contents spacing
\setnewlength{\@tocleftpadding}{1.55cm}

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
  %bookmarksnumbered=true,
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
		\def\@input{}
    \@readfrom{\buildfile}{\@input}
    \@input
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

\def\thepart{\the\numexpr\value{part}+\sectioningshift\relax}

\def\thechapter{%
\ifnum\value{chapter} < 1%
	\addtocounter{chapter}{1}%
\fi
\ifnum\the\numexpr\value{chapter}+\sectioningshift\relax < 10
	0\the\numexpr\value{chapter}+\sectioningshift
\else
	\the\numexpr\value{chapter}+\sectioningshift
\fi\space
}

\def\thesection{\thechapter\relax%
\texorpdfstring{\protect\watermark{.}}{.}%
\ifnum\value{section} < 1%
	\addtocounter{section}{1}%
\fi%
\the\numexpr\value{section}+\sectioningshift\relax}

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
\the\numexpr\value{subsubsection}+\sectioningshift\relax}











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
			\pgfpathmoveto{\pgfpoint{0mm}{\the\paperwidth + .2cm}}
			\pgfpathlineto{\pgfpoint{\the\paperwidth}{\the\paperwidth + .2cm}}
			\pgfpathlineto{\pgfpoint{\the\paperwidth}{0cm}}
			\pgfpathlineto{\pgfpoint{0mm}{0mm}}
			\pgfusepath{fill}


			%%% Draw the cover 
			\pgftext[at=\pgfpoint{\paperwidth-\@coverwidth}{\@covertop},left,top]{\includegraphics[width={\@coverwidth}]{\definedpath \covername}}%

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
		\pgftext[at=\pgfpoint{\@tocleftpadding}{\@axisheight+\baselineskip+\@axiswidth+\@axispadding},left,bottom]{%
			\parbox[b][3.5cm]{5cm}%
			{\meta%
				\raggedright\textbf{\theadministrativeunit}\\[2ex]
				\ifx\thedepartment\empty
        \else
          \textit{\textbf{\thedepartment}}\\
        \fi
				\ifx\theaddress\empty
        \else
          \theaddress ,\\%
        \fi
				\ifaddress
					5612 AZ Eindhoven\\
					\thePObox\space513, 5600 MB Eindhoven\\
					\ifx\theNetherlands\empty
          \else
            \theNetherlands\\
          \fi
				\fi
				\ifx\thewebsite\empty
        \else
					\hypersetup{urlcolor={black}}
					{\urlstyle{same}\url{\thewebsite}}
					\hypersetup{urlcolor={tuewarmred}}\\
				\fi
			}%
    }
    %%% Left column with info
    \pgftext[at=\pgfpoint{\@tocleftpadding}{\@axisheight-\@axispadding},left,top]{%
      \parbox[t]{5cm}{%
        \hbadness=10000%
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
\disablepageskip
\resetlayout
\enablepageskip

%%%% TODO add back
%%%	Set header and footers
%\sethf
%
\iftwocolumn
	\twocolumn
\else
	\relax
\fi
}
