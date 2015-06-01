% This package defines the report/book class in the TU/e 2008 style.
% Besides new functionality, it also redefines some commands from
% the standard report/book document class, so it is designed to work with these
% classes only!
%
% Author: Alex Dings & Christiaan Dirkx, elaborated on the works of Marko Boon
% Date: May, 2015.





%%%
% 	Declare general initialisation
%%%

\NeedsTeXFormat{LaTeX2e}
\def\fileversion{v.2.0}
\def\filedate{2015/05/14}
\ProvidesClass{TUestyle_ReportBook}[\filedate\space\fileversion\space  TU/e style report & book 2008]





%%%
% 	Declare utility commands
%%%

%%
%	Command \newvariable
%	Declares a new variable
%	set : \variable{value}
%	get : \thevariable
%%
\newcommand{\newvariable}[2]{
	\@namedef{#1}##1{%
		\@namedef{the#1}{##1}
	}
	\@nameuse{#1}{#2}
}

%%
%	Environment onecolarea
%	Defines a temporary one-column area
%%
\newenvironment{onecolarea}{%
	\if@twocolumn
	  \@restonecoltrue\onecolumn
	\else
	  \@restonecolfalse
	\fi
	}{%
	\if@restonecol\twocolumn\fi
	}





%%%
% 	Declare options for this classfile
%%%

%%%	Require package used for options
\RequirePackage{xkeyval}
\RequirePackage{ifthen}
\RequirePackage{pgf}

%%% Sets cover image ratio
%	Ratio has to be bigger than 4:3
\newcommand{\setCoverRatio}[1]{
\pgfmathsetmacro{\@coverratio}{ifthenelse(#1>=4/3,#1,4/3)}
}
\setCoverRatio{4/3} % 4:3 by default

%%%	Option for the language used
\DeclareOptionX{english}{\def\lang{english}\let\nederlands\undefined}
\DeclareOptionX{nederlands}{\def\lang{dutch}\def\nederlands{rty}}
\DeclareOptionX{dutch}{\def\lang{dutch}\def\nederlands{rty}}

%%%	Option for leaving out the innovation mark
\DeclareOptionX{noinnovation}{\def\innovation{false}}

%%%	Option for leaving out the TU/e logo
\DeclareOptionX{notuelogo}{\def\drawtuelogo{false}}

%%%	Option for using standard chapter style
\DeclareOptionX{notuechapters}{\def\notuechapters{true}}

%%%	Option for using standard paragraph style
\DeclareOptionX{notuepars}{\def\notuepars{true}}

%%%	Option for adding a cover
\DeclareOptionX{cover}{
\ifthenelse{\equal{#1}{}}{\def\covername{cover}}{\def\covername{#1}}
\def\drawcover{true}}

%%%	Option for cover ratio
\DeclareOptionX{coverratio}{
\setCoverRatio{#1}
}

%%%	Option for showing margins
\DeclareOptionX{margins}{\def\drawmargins{true}}

%%%	Option for using twoside mode
%	Catch it
\DeclareOptionX{twoside}{\def\drawtwoside{true}}

%%%	Option for using onside mode
%	Catch it
\DeclareOptionX{oneside}{\def\drawoneside{true}}

%%%	Option for using oneside header and footer
%%%	for book class
\DeclareOptionX{onesidehf}{\def\onesidehf{true}}

%%%	Option for faded header and footer
\DeclareOptionX{fadehf}{\def\makefadehf{true}}

%%%	Option for chapter in footer
\DeclareOptionX{chapterf}{\def\makechapterf{true}}

%%%	Option for chapter in footer
\DeclareOptionX{copyf}{\def\makecopyf{true}}

%%%	Option for last page number in footer
\DeclareOptionX{endf}{\def\drawendf{true}}

%%%	Option to shorter header
\DeclareOptionX{shorth}{\def\makeshorth{true}}

%%%	Option for draftmark over document pages
\DeclareOptionX{draftmark}{\def\drawdraftmark{true}}

%%%	Option for custom left margin
\newlength{\leftspecified}
\setlength{\leftspecified}{1.1in}
\DeclareOptionX{left}{%
	\setlength{\leftspecified}{#1}
}

%%%	Option for custom top margin
\newlength{\topspecified}
\setlength{\topspecified}{0.55in}
\addtolength{\topspecified}{40pt}
\DeclareOptionX{top}{%
	\setlength{\topspecified}{#1}
}

%%%	Option for custom right margin
\newlength{\rightspecified}
\setlength{\rightspecified}{1.5in}
\DeclareOptionX{right}{%
	\setlength{\rightspecified}{#1}
}

%%%	Option for custom bottom margin
\newlength{\bottomspecified}
\setlength{\bottomspecified}{1.3in}
\addtolength{\topspecified}{37pt}
\DeclareOptionX{bottom}{%
	\setlength{\bottomspecified}{#1}
}

%%%	Set the graphicspath, the path where images are found
\def\definedpath{}
\DeclareOptionX{graphicspath}{% 
	\def\definedpath{#1}
}

%%%	Set the classfile used as a base
%	Standard class used is report
\def\classtype{report}
%	If the book option is specified, set book class
\DeclareOptionX{book}{%
	\def\classtype{book}
	\def\drawbook{true}
}

%%%	Option for displaying notes
\DeclareOptionX{drawnotes}{\def\drawnotes{true}}

%%%	Option for displaying instructions
\DeclareOptionX{drawinstructions}{\def\drawinstructions{true}}

%%%	Instructions to be caught, rendering these options useless 
%	The options can still be checked in this class
\DeclareOptionX{letterpaper}{}
\DeclareOptionX{a5paper}{}
\DeclareOptionX{b5paper}{}
\DeclareOptionX{executivepaper}{}
\DeclareOptionX{legalpaper}{}
\DeclareOptionX{twocolumn}{\def\drawtwocolumn{true}}
\DeclareOptionX{landscape}{}

%%%	Declare what happens to undefined and uncaught options
%	These get passed to the loaded class: report or book
\DeclareOptionX*{%
\PassOptionsToClass{\CurrentOption}{book}%
\PassOptionsToClass{\CurrentOption}{report}%
}

%%%	Execute english option to set english as standard language
\ExecuteOptionsX{english}

%%% Process all options
\ProcessOptionsX





%%%
% 	Execute code directly related to the options
%%%

%%%	Option for faded header and footer
%	Default is black

\ifx\makefadehf\undefined
	\definecolor{hfcolor}{gray}{0}
\else
	\definecolor{hfcolor}{gray}{0.5}
\fi

%%%	Load defined baseclass; report or article
%	\classtype is standard set as 'report'
\LoadClass{\classtype}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% not completely working with folder up and spaces
%%% Set graphicspath if the graphicspath= option is used 
\ifx\graphicspath\undefined\relax
	\else
		\RequirePackage{graphicx}
		\graphicspath{{\definedpath}}
\fi

%%% Set basic file margins using the geometry package
%%%	Use user specified margins
\RequirePackage[a4paper,layout=a4paper, headsep=30pt, bindingoffset=0cm,top=\topspecified, left=\leftspecified, right=\rightspecified, bottom=\bottomspecified, headheight=16pt]{geometry}

%%%%%%%%%%%%%%%% CATCH THE GEOMETRY OPTIONS

%%%	Showframe if the "margins" option is used
\ifx\drawmargins\undefined\relax
	\else
		\Gm@showframetrue
	\fi

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

%%%	Set cleardoublepage to also work with the "oneside" option
\def\cleardoublepage{\clearpage\ifodd\c@page\else
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi}


	
%%%
% Define lengths
%%%

%%% Vertical spacing
\newdimen\@Vspacing
\setlength\@Vspacing{8.5cm}

%%% Horizontal spacing
\newdimen\@Hspacing
\setlength\@Hspacing{0.5\paperwidth}
\addtolength\@Hspacing{-1.12cm}

%%% Axis width
\newdimen\@axiswidth
\setlength\@axiswidth{.2mm}

%%% Axis height
\newdimen\@axisheight
\setlength\@axisheight\paperheight
\addtolength\@axisheight{-\@Vspacing}

%%% Axis shift ratio
\def\@shiftratio{0.287}

%%% Axis horizontal shift
\newdimen\@Hshift
\setlength{\@Hshift}{\@shiftratio\paperheight}

%%% Table of Contents spacing
\newdimen\@leftcolumn
\setlength\@leftcolumn{1.55cm}

\newlength{\@tocleftspace}
\setlength{\@tocleftspace}{\@Hspacing}
\addtolength{\@tocleftspace}{-1.88cm}

\newlength{\@toctopspace}
\setlength{\@toctopspace}{\@Vspacing}
\addtolength{\@toctopspace}{\@axiswidth}
\addtolength{\@toctopspace}{0.48cm}

%%% Cover image lengths
\newlength{\@coverheight}
\newlength{\@coverwidth}
\newlength{\@covertop}
\newlength{\@coverbottom}

%%% Calculate cover image dimension and position based on the image ratio and the axes lengths
\pgfmathsetlength{\@coverheight}{(\paperwidth - \@Hspacing + \@shiftratio * \@Vspacing)/(\@coverratio - \@shiftratio)}
\pgfmathsetlength{\@coverwidth}{\paperwidth - \@Hspacing + \@shiftratio * \@Vspacing + \@shiftratio * \@coverheight}
\setlength\@covertop{\dimexpr \@axisheight-0.5\@axiswidth}
\setlength\@coverbottom{\dimexpr \@axisheight - \@coverheight}




%%%
% Define usage commands
%%%

%%% Set change margin command
%%% Usage: 	\beginchangemargin{left}{right}
%%%				\endchangemargin
%%%				Where "left" and "right" are units of length
\def\changemargin#1#2{\list{}{\rightmargin#2\leftmargin#1}\item[]}
\let\endchangemargin=\endlist 

%%%	Define the instructions command if the "instructions" option is used
\ifx\drawinstructions\undefined
		\newcommand{\instruction}[1]{}
	\else
		\newcommand{\instruction}[1]{\textit{\textcolor{tueblue}{\textbf{[INSTRUCTION:} #1\textbf{]}}}}
	\fi

%%%	Enquote text
\newcommand{\enquote}[1]{``#1''}

%%%	Supercript in text
\newcommand{\up}[1]{\ensuremath{^{\textrm{\small#1}}}} 

%%%	Abbreviation commands
\def\ie/{{\emph{i.e.}},}
\def\viz/{{\emph{viz.}},}
\def\eg/{{\emph{e.g.}},}
\def\etc/{etc.}
\def\etal/{{\emph{et al.}}}

\newcommand{\tue}{TU/e}
\newcommand{\tuesite}{www.tue.nl}
\newcommand{\tuefull}{Technische Universiteit \textbf{Eindhoven} University of Technology}
\ifx\nederlands\undefined
	\newcommand{\tuename}{Eindhoven University of Technology}	% english
\else
	\newcommand{\tuename}{Technische Universiteit Eindhoven}	% dutch
\fi





%%%
% 	Declare data commands, commands used by the user to enter data
%%%

%%% Defining the commands to specify name, department, etc.
\newvariable{name}{}
\newvariable{date}{\today}
\newvariable{administrativeunit}{}
\newvariable{department}{}
\newvariable{website}{\tuesite}
\newvariable{subtitle}{}
\newvariable{orderissuer}{}
\newvariable{reference}{}
\newvariable{address}{}
\newvariable{versionnum}{}
\newvariable{copyholder}{}
\newvariable{addfrontpage}{}


\ifx\nederlands\undefined
	% English
	\newvariable{copyholderlabel}{Copyholder}
	\newvariable{authorlabel}{Author}
	\newvariable{orderissuerlabel}{Order issuer}
	\newvariable{referencelabel}{Reference}
	\newvariable{datelabel}{Date}
	\newvariable{versionlabel}{Version}
	\newvariable{Netherlands}{The Netherlands\\}
	\newvariable{PObox}{P.O. Box}
\else
	% Dutch
	\newvariable{copyholderlabel}{Kopiehouder}
	\newvariable{authorlabel}{Auteur}
	\newvariable{orderissuerlabel}{Opdrachtgever}
	\newvariable{referencelabel}{Referentie}
	\newvariable{datelabel}{Datum}
	\newvariable{versionlabel}{Versie}
	\newvariable{Netherlands}{}
	\newvariable{PObox}{Postbus}
\fi




\newcounter{authorCounter}
\newcounter{maxAuthorCounter}

\newcommand{\authorM}[1]{%
	% #1 is an identifier
	% #2 is the text
	%\ifthenelse{#1>\theauthorCounter}{\setcounter{authorCounter}{#1}\setcounter{maxAuthorCounter}{#1}}{}
	\stepcounter{authorCounter}
	\setcounter{maxAuthorCounter}{\theauthorCounter}
	\@namedef{Author@\theauthorCounter}{#1}%
}

\newcommand{\displayAuthorM}[1]{%
\expandafter\expandafter\expandafter\csname Author@#1\endcsname
}

\newcommand{\VerticalAuthorM}{%
\begingroup
\setlength{\parskip}{0ex}
	\ifthenelse{\theauthorCounter>0}{%
			\displayAuthorM{\theauthorCounter}
			
			\addtocounter{authorCounter}{-1}%
			\VerticalAuthorM
}{}%
\endgroup
\setcounter{authorCounter}{\themaxAuthorCounter}
}

\newcommand{\GenerateAllAuthorM}{%
\def\AllAuthorM{}
\setcounter{authorCounter}{\themaxAuthorCounter}
	\edef\AllAuthorM{\displayAuthorM{\theauthorCounter}}
	%\displayAuthorM{\theauthorCounter}%
	\addtocounter{authorCounter}{-1}%
	\AllAuthorMBody
	\setcounter{authorCounter}{\themaxAuthorCounter}
}

\newcommand{\AllAuthorMBody}{%
	\ifthenelse{\theauthorCounter>1}{%
			\edef\AllAuthorM{\AllAuthorM{, }\displayAuthorM{\theauthorCounter}}
			%{, }\displayAuthorM{\theauthorCounter}%
			\addtocounter{authorCounter}{-1}%
			\AllAuthorMBody
	}{%
		\ifthenelse{\theauthorCounter>0}{%
			\edef\AllAuthorM{\AllAuthorM{ \& }\displayAuthorM{\theauthorCounter}}
			%{ \& }\displayAuthorM{\theauthorCounter}
			\setcounter{authorCounter}{\themaxAuthorCounter}
		}{}%
	}%
}

\author{\VerticalAuthorM}


%%% Defining the commands to add custom footer and header  data
\newcommand*{\extraf}[1]{\def\extrafooter{#1}}
\newcommand*{\extrah}[1]{\def\extraheader{#1}}

%%% Initialisation of the above commands
\extraf{}
\extrah{}


\newcommand{\frontpagehead}[1]{\metasmall\textbf{#1} \\[.5ex]}
\newcommand{\frontpagebody}[1]{\parbox[t]{\linewidth}{\meta#1} \\[2ex]}

%%%
% 	Set the required packages
%%%

%%%	Require the font package
\RequirePackage[T1]{fontenc}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{titletoc}
\RequirePackage{titlesec}

%%%%%%%%%%%%%%%%%%%\RequirePackage[\lang]{babel}

%%%	Package for linkstyling
%	Enable PDF bookmarks
%	Make index page numbers clickable
\usepackage[bookmarks=true,linktocpage=true,bookmarksnumbered=true,breaklinks=true]{hyperref}

%%%	Set link colors
\hypersetup{
	colorlinks,
	linkcolor={tuered},
	citecolor={tuedarkblue},
	urlcolor={tuewarmred}
}


%%%
% TU/e fonts & colours
%%%

%%% Set TU/e fonts
\renewcommand{\sfdefault}{phv}
\renewcommand{\rmdefault}{phv}
\renewcommand{\ttdefault}{pcr}
\def\meta{\normalfont\fontsize{8pt}{8.5pt}\selectfont}
\def\metasmall{\normalfont\fontsize{6.5pt}{8pt}\selectfont}

%%% Set TU/e colors

%	Set main Colours
\definecolor{tuepmswarmred}{rgb}{0.969,0.192,0.192}
\colorlet{tuewarmred}{tuepmswarmred}

\definecolor{tuepmsprocesscyan}{rgb}{0.000,0.635,0.871}
\colorlet{tuecyan}{tuepmsprocesscyan}

\definecolor{tuepms206}{rgb}{0.839,0.000,0.290}
\colorlet{tuered}{tuepms206}

\definecolor{tuepms300}{rgb}{0.000,0.400,0.800}
\colorlet{tueblue}{tuepms300}

\definecolor{tuepms2748}{rgb}{0.063,0.063,0.451}
\colorlet{tuedarkblue}{tuepms2748}

\definecolor{tuepms226}{rgb}{0.839,0.000,0.482}

\definecolor{tuepms253}{rgb}{0.678,0.125,0.678}

%	Set support Colours
\definecolor{tuepms137}{rgb}{1.000,0.604,0.000}
\colorlet{tueorange}{tuepms137}

\definecolor{tuepmsyellow012}{rgb}{1.000,0.867,0.000}
\colorlet{tueyellow}{tuepmsyellow012}

\definecolor{tuepms375}{rgb}{0.518,0.824,0.000}
\colorlet{tuelightgreen}{tuepms375}

\definecolor{tuepmsgreen}{rgb}{0.000,0.675,0.510}
\colorlet{tuegreen}{tuepmsgreen}

\definecolor{tuepms396}{rgb}{0.808,0.875,0.000}

\definecolor{tuepms3135}{rgb}{0.000,0.573,0.710}

% 	Set custom colour
\colorlet{linkpink}{tuewarmred!10!}





%%%
% Clean up the tables, figures, defintions and sources lists
%%%

%%%	Remove dots between text and pagenumbers
\renewcommand{\@dotsep}{10000}

%%%	Declare the \tuetables command for the list of tables
\newcommand{\tuetables}[1][List of Tables]{
	\renewcommand{\listtablename}{#1}
	\renewcommand*\l@table{\@dottedtocline{1}{0em}{3em}}% Default: 1.5em/2.3em
	\let\origaddvspace\addvspace
	\renewcommand{\addvspace}[1]{}
	\addcontentsline{toc}{chapter}{\listtablename}
	\listoftables
	\let\addvspace\origaddvspace
}

%%%	Declare the \tuefigures command for the list of figures
\newcommand{\tuefigures}[1][List of Figures]{
	\renewcommand*\l@figure{\@dottedtocline{1}{0em}{3em}}% Default: 1.5em/2.3em
	\let\origaddvspace\addvspace
	\renewcommand{\addvspace}[1]{}
	\addcontentsline{toc}{chapter}{\listfigurename}
	\listoffigures
	\let\addvspace\origaddvspace
}





%%%
% 	Create the TU/e style titlepage
%%%

\renewcommand\maketitle{\clearpage\begin{titlepage}%

	\let\footnotesize\small%
	\let\footnoterule\relax%
	\let \footnote \thanks%
	%\hfuzz=1000pt

	\newgeometry{left=0cm,top=0cm,bottom=0cm, right=0cm, ignoreall}
	\begin{pgfpicture}{0cm}{0cm}{\paperwidth}{\paperheight}

		%%%	If the cover is specified then draw cover and white overlays
		\ifx\drawcover\undefined\relax
			\else

			%%% If margins are to be displayed then display area to be filled by the cover image
			\ifx\drawmargins\undefined\relax
			\else
				\pgfsetcolor{black!20!white}
				\pgfpathmoveto{\pgfpoint{0mm}{\the\paperwidth + .2cm}}
				\pgfpathlineto{\pgfpoint{\the\paperwidth}{\the\paperwidth + .2cm}}
				\pgfpathlineto{\pgfpoint{\the\paperwidth}{0cm}}
				\pgfpathlineto{\pgfpoint{0mm}{0mm}}
				\pgfpathmoveto{\pgfpoint{0mm}{\the\paperwidth + .2cm}}
				\pgfusepath{fill}  
			\fi
 %%% HEREEE
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
		\pgftext[at=\pgfpoint{\@leftcolumn}{\@axisheight+0.35cm},left,bottom]{%
			\parbox[b][3.5cm]{5cm}%
			{\meta%
				\raggedright\textbf{\theadministrativeunit}
				\ifthenelse{\equal{\thedepartment}{}}{}{%
				\\\textit{\textbf{\thedepartment}}}\\[2ex]
				\ifthenelse{\equal{\theaddress}{}}{}{
				\theaddress ,}
				5612 AZ Eindhoven\\
				\thePObox\space513, 5600 MB Eindhoven\\
				\theNetherlands
				\hypersetup{urlcolor={black}}
				{\urlstyle{same}\url{\thewebsite}}
				\hypersetup{urlcolor={tuewarmred}}
			}\par
		}
		
		%%% Left column with info
		\pgftext[at=\pgfpoint{\@leftcolumn}{\@axisheight-\@axiswidth-0.48cm},left,top]{%
			\parbox[t]{5cm}{%
				\hbadness=10000
					\frontpagehead{\theauthorlabel}
					\frontpagebody{\@author} 
					\ifthenelse{\equal{\theorderissuer}{}}{}{
						\frontpagehead{\theorderissuerlabel}
						\frontpagebody{\theorderissuer} 
					}
					\ifthenelse{\equal{\thereference}{}}{}{
						\frontpagehead{\thereferencelabel}
						\frontpagebody{\thereference} 
					}
					\theaddfrontpage
					\ifthenelse{\equal{\thedate}{}}{}{
						\frontpagehead{\thedatelabel}
						\frontpagebody{\thedate} 
					}
					\ifthenelse{\equal{\theversionnum}{}}{}{
						\frontpagehead{\theversionlabel}
						\frontpagebody{\theversionnum} 
					}
			}
		}%

		%%% Title and subtitle at normal position
		\ifx\drawcover\undefined
			\pgftext[at=\pgfpoint{\@Hspacing-1.88cm}{\@axisheight-\@axiswidth-0.48cm},left,top]{%
				\parbox[t]{0.5\paperwidth}{\raggedright\normalfont\fontsize{17}{19}\selectfont\bfseries \@title\\[1ex]\large\mdseries \thesubtitle}%
			}

		%%% Title and subtitle positioned underneath cover
		\else           
			\pgftext[at=\pgfpoint{\paperwidth-\@coverwidth+0.5cm}{\@coverbottom-0.5cm},left,top]{%
				\parbox[t]{0.5\paperwidth}{\raggedright\normalfont\fontsize{17}{19}\selectfont\bfseries \@title\\[1ex]\large\mdseries \thesubtitle}%
			}
		\fi

		%%% Draw copyholder data
		\pgftext[at=\pgfpoint{\the\paperwidth/2-4cm}{1.2cm},left,bottom]{%
			\parbox[b][3.5cm]{8cm}{
				\centering
				\ifthenelse{\equal{\thecopyholder}{}}{}{
					\frontpagehead{\thecopyholderlabel}\meta\thecopyholder
				}

			\par}
		 }
	\end{pgfpicture}%
\end{titlepage}%


%%% Reset global variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% why?
\setcounter{footnote}{0}
\global\let\thanks\relax
\global\let\maketitle\relax
\global\let\@thanks\@empty
%\global\let\@author\@empty
\global\let\@date\@empty
%	\global\let\@title\@empty
%	\global\let\title\relax
%\global\let\author\relax
\global\let\date\relax
\global\let\and\relax
\hfuzz=0pt

%%%	Reset the original values of all margins
\disablepageskip
\setmargins
\enablepageskip

%%%	Set header and footers
\sethf

\ifx\drawtwocolumn\undefined
	\relax
\else
	\twocolumn
\fi
}





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





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%not only pars
%%%
% 	Redefine paragraph style 
%%%

%%% Change the paragraph indent and paragraph skip
\setlength{\parindent}{0cm}
\setlength{\parskip}{1ex}

\setcounter{secnumdepth}{2}

\ifx\notuepars\undefined
	\titleformat{\subsubsection}
	{\normalfont\fontsize{12}{15}\bfseries}{\thesubsubsection}{1em}{}

	\titleformat{\paragraph}
	{\normalfont\normalsize \bfseries \slshape}{\theparagraph}{1em}{}
	\titlespacing*{\paragraph}
	{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
	
	\titleformat{\subparagraph}
	{\normalfont\normalsize \slshape}{\thesubparagraph}{1em}{}
	\titlespacing*{\subparagraph}
	{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
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
% 	Redefine chapter heading style 
%%%

\ifx\notuechapters\undefined
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





%%%
% 	Redefine index command 
%%%


% Redefining the index command to show headers on the Index page.
\renewenvironment{theindex}
{
	\if@twocolumn
		\@restonecolfalse
	\else
		\@restonecoltrue
	\fi
	\twocolumn[\@makeschapterhead{\indexname}]%
	\@mkboth{\MakeUppercase\indexname}%
	{\MakeUppercase\indexname}%
%	\thispagestyle{plain}
	\parindent\z@
	\parskip\z@ \@plus .3\p@\relax
	\columnseprule \z@
	\columnsep 35\p@
	\let\item\@idxitem}
	{
		\if@restonecol
			\onecolumn
		\else
			\clearpage
		\fi
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

\newcommand\TUeTableofcontents{%
	\if@openright
		\cleardoublepage
	\else\relax\fi

	% The table of contents needs different margins. The package geometry is used to
	% change the margins of certain pages within a document.
	% After the table of contents, they will be reset.
	\newgeometry{bottom=\bottomspecified, twoside=false, right=\rightspecified, left=\@tocleftspace, top=\@toctopspace, headheight=0cm, headsep=0cm,footskip=0cm,marginpar=0cm,marginparsep=0cm}

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

	\disablepageskip

	%%%	Reset the original values of all margins
	\setmargins
	\sethf
	
	\renewcommand{\headrulewidth}{\oldheadrulewidth}
	
	\enablepageskip
	
	\ifx\drawtwocolumn\undefined
		\relax
	\else
		\twocolumn
	\fi
}

%%%	Disable clearpage, cleardoublepage & newpage commands
\newcommand{\disablepageskip}{
	%%%	Store them
	\let\oldclearpage\clearpage
	\let\oldcleardoublepage\cleardoublepage
	\let\oldnewpage\newpage

	%%%	Disable them
	\let\clearpage\relax
	\let\cleardoublepage\relax
	\let\newpage\relax
}

%%%	Re-enable clearpage, cleardoublepage & newpage commands
\newcommand{\enablepageskip}{
	\let\clearpage\oldclearpage
	\let\cleardoublepage\oldcleardoublepage
	\let\newpage\oldnewpage
}

%%%
% Set original margins
%%%

\newcommand{\setmargins}{
	%%%	If the document uses the "oneside" option
	\ifx\drawtwoside\undefined
		\newgeometry{headsep=30pt,twoside=false, bindingoffset=0cm,top=\topspecified, left=\leftspecified,right=\rightspecified,bottom=\bottomspecified,headheight=16pt}

	%%%	If the document uses the "twoside" option
	\else
		\newgeometry{headsep=30pt,twoside=true, bindingoffset=0cm,top=\topspecified, left=\leftspecified,right=\rightspecified,bottom=\bottomspecified,headheight=16pt}
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
	\pgftext[at=\pgfpoint{\@leftcolumn}{\@axisheight+0.35cm},left,bottom]{%
		\parbox[b][3.5cm]{5cm}{
			\Large\ifx\nederlands\undefined 
				Table of contents
			\else 
				Inhoudsopgave
			\fi
		}
	}

	%%% Draw title and subtitle
	\pgftext[at=\pgfpoint{\@leftcolumn}{\@axisheight-\@axiswidth-0.48cm},left,top]{%
		\parbox[t]{4.9cm}{%
			\ifx\nederlands\undefined
				\frontpagehead{Title}
				\parbox[t]{\linewidth}{\raggedright\mbox{}\meta\@title}
			\else
				\frontpagehead{Titel}
				\parbox[t]{\linewidth}{\raggedright\mbox{}\meta\@title}
			\fi
		}
	}
}





%%%
% Defining command for the TU/e logo, innovation and axes
%%%

%%% Use this command only INSIDE a pgfpicture environment
\newcommand{\drawtuelogoandaxes}{
	%%%	If drawtuelogo is not set to false, by the "notuelogo" option
	\ifx\drawtuelogo\undefined
		 % TU/e logo and red lines
		 \pgftext[at=\pgfpoint{\@Hspacing+1.035cm}{\the\paperheight-1.8cm},center,center]{\includegraphics[width=7cm]{tuelogo}}%        
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
		\pgftext[at=\pgfpoint{\@Hspacing-\@Hshift+0.42cm}{0.8cm},left,bottom]{\bfseries Where innovation starts}%
	\fi

	%%%	Reset colour to black
	\pgfsetcolor{black}
}





%%%
% Declare commands for parts, chapters and sections without number
%%%

%%%	Part no number command
\newcommand{\partnn}[1]{
	\setcounter{section}{0}
	\setcounter{subsection}{0}
	\setcounter{subsubsection}{0}
	\setcounter{paragraph}{0}
	\setcounter{subparagraph}{0}
	\part*{#1}
	\addcontentsline{toc}{part}{#1}
	\markboth{#1}{\rightmark}
}

%%%	Chapter no number command
\newcommand{\chapternn}[1]{
	\setcounter{section}{0}
	\setcounter{subsection}{0}
	\setcounter{subsubsection}{0}
	\setcounter{paragraph}{0}
	\setcounter{subparagraph}{0}
	\chapter*{#1}
	\addcontentsline{toc}{chapter}{#1}
	\markboth{#1}{\rightmark}
}

%%%	Section no number command
\newcommand{\sectionnn}[1]{
	\setcounter{subsection}{0}
	\setcounter{subsubsection}{0}
	\setcounter{paragraph}{0}
	\setcounter{subparagraph}{0}
	\section*{#1}
	\addcontentsline{toc}{section}{#1}
	\markboth{#1}{\rightmark}
}





%%%
% Declare regular header and footers
%%%

%%%	Using the fancyhdr package to set the TU/e headings.
%%%	Define left side header
\newcommand{\leftsidehead}{
	\small\color{hfcolor} 
	\ifx\makeshorth\undefined 
		\tuefull
	\else
		\tuename
	\fi
		\ifthenelse{\equal{\extraheader}{}}{}{- \extraheader}
}

%%%	Define right side header
\newcommand{\rightsidehead}{
	\small\color{hfcolor} 
	\ifthenelse{\equal{\extraheader}{}}{}{\extraheader\space-}
	\ifx\makeshorth\undefined 
		\tuefull
	\else 
		\tuename
	\fi
}

%%%	Define left side footer
\newcommand{\leftsidefoot}{
	\small \footnumber\hspace{0.1cm}\color{hfcolor} - 
	\@title \ifthenelse{\equal{\theversionnum}{}}{}{ / \theversionlabel \theversionnum }\\ 
	\ifx\makechapterf\undefined\relax\else{\itshape\nouppercase{\leftmark}}\fi
	\ifthenelse{\equal{\extrafooter}{}}{}{\\\extrafooter}
}

%%%	Define right side footer
\newcommand{\rightsidefoot}{
		\small \color{hfcolor} \@title
		\ifthenelse{\equal{\theversionnum}{}}{}{ / \theversionlabel \theversionnum } - \color{black}
		\hspace{0.1cm}\footnumber\color{hfcolor} \\ 
		\ifx\makechapterf\undefined\relax\else{\itshape\nouppercase{\leftmark}}\fi
		\ifthenelse{\equal{\extrafooter}{}}{}{\\\extrafooter}
}

%%%	Define copyholder footer
\newcommand{\copyfoot}{
	\ifx\makecopyf\undefined\relax\else
		\frontpagehead{\copyholderlabel}\meta\thecopyholder
	\fi
}

%%%	Define draft overlay
\newcommand{\draftmarking}{
	\ifx\drawdraftmark\undefined\relax\else
		\draftmark%
		\settoheight{\@tempdima}{\draftmark}%
		\vspace{-\@tempdima}%
		\vspace{-10cm}%
	\fi
}

%%%	Define footer number
\newcommand{\footnumber}{
	\thepage%
	\ifx\drawendf\undefined\relax\else
		/\pageref*{lastdocpage}
	\fi
}

%%%	Define headers and footers for twoside design
\newcommand{\setheadersTwo}{
	\pagestyle{fancy}
	\fancyhf{}
	%%%%	Header in the center of the page
	\fancyhead[C]{
		\draftmarking
	}
	%%%%	Header for the even pages, header on the left
	\fancyhead[LE]{
		\leftsidehead
	}
	%%%%	Header for the odd pages, header on the right
	\fancyhead[RO]{
		\rightsidehead
	}
	%%%%	Header for the even pages, footer on the right
	\fancyfoot[RE]{
		\rightsidefoot
	}
	%%%%	Header for the odd pages, footer on the left
	\fancyfoot[LO]{
		\leftsidefoot
	}
	%%%%	Copyholder on other side
	\fancyfoot[LE]{
		\copyfoot
	}
	%%%%	Copyholder on other side
	\fancyfoot[RO]{
		\copyfoot
	}
	\renewcommand{\headrulewidth}{0mm}
}

%%%	Define header and footers for oneside design
\newcommand{\setheadersOne}{
	\pagestyle{fancy}
	\fancyhf{}
	%%%%	Header in the center of the page
	\fancyhead[C]{
		\draftmarking
	}
	%%%%	Header only on the right side
	\fancyhead[R]{
		\rightsidehead
	}
	%%%%	Footer only on the left side
	\fancyfoot[L]{
		\leftsidefoot
	}
	
	%%%%	Copyholder on other side
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
		\ifx\drawtwoside\undefined
			%%%	Set oneside headers
			\setheadersOne
		\else
			\ifx\onesidehf\undefined
				%%%	Set oneside headers
				\setheadersTwo
			\else
				%%%	Set twoside headers
				\setheadersOne
			\fi
		\fi
	\fi
}
\sethf





%%%
% Define draftmark
%%%

\newsavebox{\draftBox}
\savebox{\draftBox}{%
	\color{linkpink}
	\rotatebox[origin=c]{-45}{Draft}%
}%

%%%	Declare the \draftmark command and scale it to the text
\newcommand{\draftmark}{%
	\resizebox{!}{200pt}{\usebox{\draftBox}}%
}





%%%
% \aLeX command
%%%

%%%	Declare \aLeXbox as a box containing the \aLeX lettering
\newsavebox{\aLeXbox}
\savebox{\aLeXbox}{\normalsize%
    \raisebox{0.50ex}{\scriptsize A}\hspace{-0.25ex}%
    L\hspace{-0.35ex}%
    \raisebox{-0.53ex}{E}\hspace{-0.35ex}%
    X%
  }%

%%%	Declare the \aLeX command and scale it to the text
\newcommand{\aLeX}{%
  \settoheight{\@tempdima}{L}%
  \resizebox{!}{\@tempdima}{\usebox{\aLeXbox}}%
}





%%%
% \CaTeX
%%%

%%%%%%%%%%%% Needs to be made



%%%
% set PDF meta data
%%%

\AtBeginDocument{
	%%%	Generate authors
	\GenerateAllAuthorM
	%%%	Set meta data
	\hypersetup{pdftitle = {\@title},pdfauthor = {\AllAuthorM},pdfsubject={\thesubtitle},pdfkeywords={Version \theversionnum} {Eindhoven University of Technology},pdfcreator={aLeX TU/e template}}
}





%%%
% Listing styling
%%%

%%%
%	Notes
%%%

%%
%	Variable \notelabel
%	The note label
%
%	Variable \listnotename
%	The list of notes' name
%%
\newvariable{notelabel}{}
\newvariable{listnotename}{}
\ifx\nederlands\undefined
	% english
	\notelabel{NOTE}
	\listnotename{List of Notes}
\else
	% dutch
	\notelabel{NOTITIE}
	\listnotename{Lijst van Notities}
\fi

% define \note command if the \drawnodes option is set
\ifx\drawnotes\undefined
		\newcommand{\note}[1]{}
	\else
		% note counter
		\newcounter{note}
		
		%%
		%	Command \note
		%	Declares a new note
		%%
		\newcommand{\note}[1]{%
			\refstepcounter{note}%
			\notestyle{\thenote}{#1}%
			\addcontentsline{lon}{note}{\numberline {\thenote} #1}
		}
	\fi

% defines the note styling
\newcommand{\notestyle}[2]{%
{\textcolor{tuewarmred}{\textbf{[\thenotelabel\space #1:} #2\textbf{]}}}%
}

%%
%	Command \listofnotes
%	Produces a list of all notes
%% 
\newcommand{\listofnotes}{%
	\begin{onecolarea}
		\chapternn{\thelistnotename}%
		\@starttoc{lon}%
	\end{onecolarea}
}

% defines the list of notes' formatting	
\newcommand{\l@note}[2]{%
	\@dottedtocline{1}
	 {0em} % Indent
	 {3em} % Listing number width
	 {#1} % Entry text
	 {#2}% % Page number
}




%%%
%	Definitions
%%%

% definition counter
\newcounter{definition}

%%
%	Command \definedef
%	Declares a new definition
%%
\newcommand{\definedef}[2]{%
	\refstepcounter{definition}%
	\refdef{#1}%
	\addcontentsline{lod}{definition}{\numberline{\string\definitionstyle{#1}}#2}%
	\addtocontents{lod}{\string\label{def:#1}}%
}

%%
%	Command \defineabbr
%	Declares a new abbreviation
%%
\newcommand{\defineabbr}[2]{%
	\refstepcounter{definition}%
	\refdef{#1}%
	\addcontentsline{lod}{definition}{\numberline{\string\definitionstyle{#1}}#2}%
	\addtocontents{lod}{\string\label{def:#1}}%
}

%	Defines the definition styling inside lod
%	This breaks long defintions in the lod
\newcommand{\definitionstyle}[1]{%
	\parbox[b]{7em}{#1}
}

%%
%	Command \refdef
%	References a definition
%%
\newcommand{\refdef}[1]{%
	\colorbox{linkpink}{\strut\hyperref[def:#1]{#1}}
}

%%
%	Variable \listdefinitionname
%	The list of definitions' name
%%
\newvariable{listdefintionname}{}
\ifx\nederlands\undefined
	% english
	\listdefintionname{List of Definitions}
\else
	% dutch
	\listdefintionname{Lijst van Definities}
\fi

%%
%	Command \listofdefinitions
%	Produces a list of all definitions
%% 
\newcommand{\listofdefinitions}{%
	\begin{onecolarea}
		\chapternn{\thelistdefintionname}%
		\@starttoc{lod}%
	\end{onecolarea}
}

% defines the list of definitions' formatting
\newcommand{\l@definition}[2]{%
	\@dottedtocline{0}%
	 {0em} % Indent
	 {8em} % Listing number width
	 {#1} % Entry text
	 {#2}% % Page number
}





%%%
%	Set last page label
%%%

\AtEndDocument{
	\label{lastdocpage}
}
\makeatother