% This package defines the report/book class in the TU/e 2008 style.
% Besides new functionality, it also redefines some commands from
% the standard report/book document class, so it is designed to work with these
% classes only!
%
% Author: Alex Dings, elaborated on the works of Marko Boon
% Date: May, 2015.





%%%
% 	Declare general initialisation
%%%

\NeedsTeXFormat{LaTeX2e}
\def\fileversion{v.2.0}\def\filedate{2015/04/13}
\ProvidesClass{tuestyle_aLeX}
	[\filedate\space\fileversion\space  TU/e style report & book 2008]





%%%
% 	Declare options for this classfile
%%%

%%%	Require package used for options
\RequirePackage{xkeyval}
\RequirePackage{ifthen}

%%%	Option for the language used
\DeclareOptionX{english}{\def\lang{english}\let\nederlands\undefined}
\DeclareOptionX{nederlands}{\def\lang{dutch}\def\nederlands{rty}}
\DeclareOptionX{dutch}{\def\lang{dutch}\def\nederlands{rty}}

%%%	Option for leaving out the innovation mark
\DeclareOptionX{noinnovation}{\def\innovation{false}}

%%%	Option for leaving out the TU/e logo
\DeclareOptionX{notuelogo}{\def\drawtuelogo{false}}

%%%	Option for using standard table of contents style
\DeclareOptionX{notuetoc}{\def\notuetoc{true}}

%%%	Option for using standard chapter style
\DeclareOptionX{notuechapters}{\def\notuechapters{true}}

%%%	Option for using standard paragraph style
\DeclareOptionX{notuepars}{\def\notuepars{true}}

%%%	Option for adding a cover
\DeclareOptionX{cover}{
\ifthenelse{\equal{#1}{}}{\def\covername{cover}}{\def\covername{#1}}
\def\drawcover{true}}

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
\RequirePackage{pgf}
\RequirePackage{color}
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
% Define usage commands
%%%

%%% Set change margin command
%%% Useage: 	\beginchangemargin{left}{right}
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
\newcommand{\ie}{{\emph{i.e.}},}
\newcommand{\viz}{{\emph{viz.}},}
\newcommand{\eg}{{\emph{e.g.}},}
\newcommand{\etc}{etc.}
\newcommand{\etal}{{\emph{et al.}}}


%%%
% 	Declare data commands, commands used by the user to enter data
%%%

%%% Defining the commands to specify name, department, etc.
\newcommand*{\name}[1]{\def\fromname{#1}}
\renewcommand*{\date}[1]{\def\datedata{#1}}
\newcommand*{\administrativeunit}[1]{\def\departmentdata{#1}}
\newcommand*{\department}[1]{\def\afdelingdata{#1}}
\newcommand*{\website}[1]{\def\websitedata{#1}}
\newcommand*{\subtitle}[1]{\def\subtitledata{#1}}
\newcommand*{\orderissuer}[1]{\def\orderissuerdata{#1}}
\newcommand*{\reference}[1]{\def\referencedata{#1}}
\newcommand*{\versionnum}[1]{\def\versiondata{#1}}
\newcommand*{\copyholder}[1]{\def\copyholderdata{#1}}
\newcommand*{\address}[1]{\def\addressdata{#1}}
\newcommand*{\addfrontpage}[1]{\def\addfrontpagedata{#1}}

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

%%% Initialisation of the above commands
\name{}
\date{\today}
\administrativeunit{}
\department{}
\website{www.tue.nl}
\subtitle{}
\orderissuer{}
\reference{}
\versionnum{}
\copyholder{}
\address{}
\addfrontpage{}

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
%%%%\RequirePackage{pgf}
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ENGELS VS NEDERLANDSSSSSSSSSS
%%%
% Clean up the tables, figures, defintions and sources lists
%%%

%%%	Remove dots between text and pagenumbers
\renewcommand{\@dotsep}{10000}





%%%
% 	Create the TU/e style titlepage
%%%

\renewcommand\maketitle{\clearpage\begin{titlepage}%

	\let\footnotesize\small%
	\let\footnoterule\relax%
	\let \footnote \thanks%
	\hfuzz=1000pt

	\newgeometry{left=0cm,top=0cm, voffset=0cm,ignoreall}

	\begin{pgfpicture}{0cm}{\the\paperheight-10pt}{\the\paperwidth*2}{16pt}

		%%%	If the cover is specified then draw cover and white overlays
		\ifx\drawcover\undefined\relax
			\else

			%%% If margins are to be displayed then display area to be filled by the cover image
			\ifx\drawmargins\undefined\relax
			\else
				\pgfsetcolor{black!20!white}
				\pgfpathmoveto{\pgfpoint{0mm}{21.2cm}}
				\pgfpathlineto{\pgfpoint{\the\paperwidth}{21.2cm}}
				\pgfpathlineto{\pgfpoint{\the\paperwidth}{0cm}}
				\pgfpathlineto{\pgfpoint{0mm}{0mm}}
				\pgfpathmoveto{\pgfpoint{0mm}{21.2cm}}
				\pgfusepath{fill}  
			\fi

			%%% Draw the cover from the bottom left corner to the top right corner
			\pgftext[at=\pgfpoint{\the\paperwidth/2-7.1cm}{\the\paperheight-8.51cm},left,top]{\includegraphics[width={18cm}]{\definedpath \covername}}%             

			%%% Draw left white overlay for the cover
			\pgfsetcolor{white}
			\pgfpathmoveto{\pgfpoint{0mm}{\the\paperheight-8.51cm}}
			\pgfpathlineto{\pgfpoint{\the\paperwidth/2-3.56cm}{\the\paperheight-8.51cm}}
			\pgfpathlineto{\pgfpoint{\the\paperwidth/2-1.12cm-\the\paperheight/3.487}{0cm}}
			\pgfpathlineto{\pgfpoint{0mm}{0mm}}
			\pgfpathlineto{\pgfpoint{0cm}{\the\paperheight-9.5cm}}
			\pgfusepath{fill}              

			 %%% Draw bottom white overlay for the cover
			\pgfsetcolor{white}
			\pgfpathmoveto{\pgfpoint{0mm}{9cm}}
			\pgfpathlineto{\pgfpoint{\the\paperwidth}{9cm}}
			\pgfpathlineto{\pgfpoint{\the\paperwidth}{0cm}}
			\pgfpathlineto{\pgfpoint{0mm}{0mm}}
			\pgfpathmoveto{\pgfpoint{0mm}{9cm}}
			\pgfusepath{fill}           
		\fi
		
		%%%	Drawing of the TU/e axes and logo
		\drawtuelogoandaxes
		
		%%% From name and address
		\pgfsetcolor{black}
		\pgftext[at=\pgfpoint{1.55cm}{\the\paperheight-8.15cm},left,bottom]{%
			\ifx\nederlands\undefined
				\parbox[b][3.5cm]{5cm}%
				{\meta%
					\raggedright\mbox{}\textbf{\departmentdata}\\
					\mbox{}\afdelingdata\\
					\ifthenelse{\equal{\addressdata}{}}{}{
					\addressdata ,}
					5612 AZ Eindhoven\\
					P.O. Box 513, 5600 MB Eindhoven\\
					The Netherlands\\
					\hypersetup{urlcolor={black}}
					{\urlstyle{same}\url{\websitedata}}
					\hypersetup{urlcolor={tuewarmred}}
				}\par
			\else
				\parbox[b][3.5cm]{5cm}%
				{\meta%
					\raggedright\mbox{}\textbf{\departmentdata}\\
					\mbox{}\afdelingdata\\
					\ifthenelse{\equal{\addressdata}{}}{}{
					\addressdata ,}
					5612 AZ Eindhoven\\
					Postbus 513, 5600 MB Eindhoven\\
					\hypersetup{urlcolor={black}}
					{\urlstyle{same}\url{\websitedata}}
					\hypersetup{urlcolor={tuewarmred}}
				}\par
			 \fi
		}
		
		%%% Left column with info
		\pgftext[at=\pgfpoint{1.55cm}{\the\paperheight-9cm},left,top]{%
			\parbox[t]{5cm}{%
				\hbadness=10000
				\ifx\nederlands\undefined
					\frontpagehead{Author}
					\frontpagebody{\@author} 
					\ifthenelse{\equal{\orderissuerdata}{}}{}{
						\frontpagehead{Order issuer}
						\frontpagebody{\orderissuerdata} 
					}
					\ifthenelse{\equal{\referencedata}{}}{}{
						\frontpagehead{Reference}
						\frontpagebody{\referencedata} 
					}
					\addfrontpagedata
					\ifthenelse{\equal{\datedata}{}}{}{
						\frontpagehead{Date}
						\frontpagebody{\datedata} 
					}
					\ifthenelse{\equal{\versiondata}{}}{}{
						\frontpagehead{Version}
						\frontpagebody{\versiondata} 
					}
				\else%
					\frontpagehead{Auteur}
					\frontpagebody{\@author} 
					\ifthenelse{\equal{\orderissuerdata}{}}{}{
						\frontpagehead{Opdrachtgever}
						\frontpagebody{\orderissuerdata} 
					}
					\ifthenelse{\equal{\referencedata}{}}{}{
						\frontpagehead{Referentie}
						\frontpagebody{\referencedata} 
					}
					\addfrontpagedata
					\ifthenelse{\equal{\datedata}{}}{}{
						\frontpagehead{Datum}
						\frontpagebody{\datedata} 
					}
					\ifthenelse{\equal{\versiondata}{}}{}{
						\frontpagehead{Versie}
						\frontpagebody{\versiondata} 
					}
				\fi%
			}
		}%

		%%% Title and subtitle at normal position
		\ifx\drawcover\undefined
			\pgftext[at=\pgfpoint{\the\paperwidth/2-3cm}{\the\paperheight-9cm},left,top]{%
				\parbox[t]{0.5\paperwidth}{\raggedright\normalfont\fontsize{17}{19}\selectfont\bfseries \@title\\[1ex]\large\mdseries \subtitledata}%
			}

		%%% Title and subtitle positioned underneath cover
		\else           
			\pgftext[at=\pgfpoint{4cm}{8.5cm},left,top]{%
				\parbox[t]{0.5\paperwidth}{\raggedright\normalfont\fontsize{17}{19}\selectfont\bfseries \@title\\[1ex]\large\mdseries \subtitledata}%
			}
		\fi

		%%% Draw copyholder data
		\pgftext[at=\pgfpoint{\the\paperwidth/2-4cm}{1.2cm},left,bottom]{%
			\parbox[b][3.5cm]{8cm}{
				\centering
				\ifx\nederlands\undefined
					\ifthenelse{\equal{\copyholderdata}{}}{}{
						\frontpagehead{Copy holder}\meta\copyholderdata
					}
				\else
					\ifthenelse{\equal{\copyholderdata}{}}{}{
						\frontpagehead{Kopiehouder}\meta\copyholderdata
					}
				\fi
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bad practice to set the table of contents to this

\newlength{\oldheadrulewidth}
% Completely redefine the \tableofcontents command.
% It shows the TU/e logo and draws the axes.
% It also needs to redefine the margins temporarily,
% for which the geometry package is used.
\ifx\notuetoc\undefined
	\renewcommand\tableofcontents{%
		\if@openright
			\cleardoublepage
		\else\relax\fi

		% The table of contents needs different margins. The package geometry is used to
		% change the margins of certain pages within a document.
		% After the table of contents, they will be reset.

		\newgeometry{layouthoffset=0cm, bottom=\bottomspecified, twoside=false,marginparsep=0pt, marginpar=0pt, right=\rightspecified, left=7.2cm, top=9cm,headheight=16pt}

		\fancyhf{}
		\setlength{\oldheadrulewidth}{\headrulewidth}
		\renewcommand{\headrulewidth}{0.0pt}

		\fancyhead[R]{
			\hfuzz=1000pt
			\begin{pgfpicture}{7.2cm}{\headheight+\headsep+\textheight+\bottomspecified}{\the\paperwidth*2}{0cm}
			\drawtuetableofcontents
			\end{pgfpicture}
		}
		\hfuzz=0pt
		
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
\fi

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
	\pgftext[at=\pgfpoint{1.55cm}{\the\paperheight-8.15cm},left,bottom]{%
		\parbox[b][3.5cm]{5cm}{
			\Large\ifx\nederlands\undefined 
				Table of contents
			\else 
				Inhoudsopgave
			\fi
		}
	}

	%%% Draw title and subtitle
	\pgftext[at=\pgfpoint{1.55cm}{\the\paperheight-9cm},left,top]{%
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
		 \pgftext[at=\pgfpoint{\the\paperwidth/2-0.85mm}{\the\paperheight-1.8cm},center,center]{\includegraphics[width=7cm]{tuelogo}}%        
	\else
		\relax
	\fi
	
	%%%	Draw horizontal axis
	\pgfsetcolor{tuered}
	\pgfpathmoveto{\pgfpoint{0mm}{\the\paperheight-8.5cm}}
	\pgfpathlineto{\pgfpoint{\the\paperwidth}{\the\paperheight-8.5cm}}
	\pgfpathlineto{\pgfpoint{\the\paperwidth}{\the\paperheight-8.52cm}}
	\pgfpathlineto{\pgfpoint{0cm}{\the\paperheight-8.52cm}}
	\pgfusepath{fill}
	
	%%%	Draw diagonal axis
	\pgfpathmoveto{\pgfpoint{\the\paperwidth/2-1.12cm}{\the\paperheight}}
	\pgfpathlineto{\pgfpoint{\the\paperwidth/2-1.12cm-\the\paperheight/3.487}{0cm}}
	\pgfpathlineto{\pgfpoint{\the\paperwidth/2-1.14cm-\the\paperheight/3.487}{0cm}}
	\pgfpathlineto{\pgfpoint{\the\paperwidth/2-1.14cm}{\the\paperheight}}
	\pgfusepath{fill}

	%%%	If innovation is not set to false, by the "noinnovation" option
	\ifx\innovation\undefined
		\pgfsetcolor{tuedarkblue}
		\pgftext[at=\pgfpoint{\the\paperwidth/2-0.7cm-\the\paperheight/3.487}{0.8cm},left,bottom]{\bfseries Where innovation starts}%
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
		Technische Universiteit \textbf{Eindhoven} University of Technology
	\else 
		\ifx\nederlands\undefined 
			\textbf{Eindhoven University of Technology}
		\else  
			\textbf{Technische Universiteit Eindhoven}
		\fi
	\fi
		\ifthenelse{\equal{\extraheader}{}}{}{- \extraheader}
}

%%%	Define right side header
\newcommand{\rightsidehead}{
	\small\color{hfcolor} 
	\ifthenelse{\equal{\extraheader}{}}{}{\extraheader\space-}
	\ifx\makeshorth\undefined 
		Technische Universiteit \textbf{Eindhoven} University of Technology
	\else 
		\ifx\nederlands\undefined 
			\textbf{Eindhoven University of Technology}
		\else  
			\textbf{Technische Universiteit Eindhoven}
		\fi
	\fi
}

%%%	Define left side footer
\newcommand{\leftsidefoot}{
	\small \footnumber\hspace{0.1cm}\color{hfcolor} - 
	\@title \ifthenelse{\equal{\versiondata}{}}{}{ / \ifx\nederlands\undefined Version \else Versie \fi \versiondata }\\ 
	\ifx\makechapterf\undefined\relax\else{\itshape\nouppercase{\leftmark}}\fi
	\ifthenelse{\equal{\extrafooter}{}}{}{\\\extrafooter}
}

%%%	Define right side footer
\newcommand{\rightsidefoot}{
		\small \hspace{0.1cm}\color{hfcolor} \@title
		\ifthenelse{\equal{\versiondata}{}}{}{ / \ifx\nederlands\undefined Version \else Versie \fi \versiondata } - \color{black}
		\footnumber\hspace{0.1cm}\color{hfcolor} \\ 
		\ifx\makechapterf\undefined\relax\else{\itshape\nouppercase{\leftmark}}\fi
		\ifthenelse{\equal{\extrafooter}{}}{}{\\\extrafooter}
}

%%%	Define copyholder footer
\newcommand{\copyfoot}{
\ifx\makecopyf\undefined\relax\else
	\ifx\nederlands\undefined
		\ifthenelse{\equal{\copyholderdata}{}}{}{
			\frontpagehead{Copy holder}\meta\copyholderdata
		}
	\else
		\ifthenelse{\equal{\copyholderdata}{}}{}{
			\frontpagehead{Kopiehouder}\meta\copyholderdata
		}
	\fi
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


\newsavebox{\draftBox}
\savebox{\draftBox}{%
	%%%%%%%%%%%%%%%%%%%%%\pgfsetfillopacity{0.2}
	\color{linkpink}
	\rotatebox[origin=c]{-45}{Draft}%
}%

%%%	Declare the \aLeX command and scale it to the text
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

\newsavebox{\DirkxDingsBox}
\savebox{\DirkxDingsBox}{\Large DI\hspace{-0.8ex} %
%    \raisebox{0.80ex}{\scriptsize I}%
%    \settowidth{\@tempdima}{\scriptsize I}%
%    \hspace{-\@tempdima}%
%    \raisebox{0.0ex}{\scriptsize I}%
 
    \raisebox{0.80ex}{\scriptsize R}%
    \settowidth{\@tempdima}{\scriptsize R}%
    \hspace{-\@tempdima}%
    \raisebox{0.0ex}{\scriptsize N}%   
    
    \raisebox{0.80ex}{\scriptsize K}%
    \settowidth{\@tempdima}{\scriptsize K}%
    \hspace{-\@tempdima}%
    \raisebox{0.0ex}{\scriptsize G}% 

	S\hspace{-1.4ex}\raisebox{0.40ex}{\scriptsize X}

	%S%
    %\hspace{-1.4ex}%
    %X%   
    
	%X\hspace{-1.8ex}\raisebox{0.40ex}{\scriptsize S}
  }%

\newcommand{\DirkxDings}{%
  \settoheight{\@tempdima}{L}%
  \addtolength{\@tempdima}{\@tempdima}
  \resizebox{!}{\@tempdima}{\usebox{\DirkxDingsBox}}%
}


%%%
% set PDF meta data
%%%

\makeatletter
\AtBeginDocument{
	%%%	Generate authors
	\GenerateAllAuthorM
	%%%	Set meta data
	\hypersetup{pdftitle = {\@title},pdfauthor = {\AllAuthorM},pdfsubject={\subtitledata},pdfkeywords={Version \versiondata} {Eindhoven University of Technology},pdfcreator={aLeX TU/e template}}
}
\makeatother

%%%
% Listing styling
%%%

\makeatletter
\AtBeginDocument{
\@ifpackageloaded{listings}{
	\renewcommand\lstlistoflistings{%
		\if@twocolumn
		  \@restonecoltrue\onecolumn
		\else
		  \@restonecolfalse
		\fi
	\chapternn{Listings}
		\@starttoc{lol}%
		\if@restonecol\twocolumn\fi
	}
		
	\renewcommand*{\l@lstlisting}[2]{%
		\@dottedtocline{1}
		 {0em} % Indent
		 {3em} % Listing number width
		 {#1} % Entry text
		 {#2}% % Page number
	}
}{}
}

%%%	Define the note command if the "notes" option is used
\ifx\drawnotes\undefined
		\newcommand{\note}[1]{}
	\else
		\newcounter{note}%
		\newcommand{\note}[1]{%
			\refstepcounter{note}%
			\notestyle{\thenote}{#1}%
			\addcontentsline{lon}{note}{\numberline {\thenote} #1}%
		}%
	\fi

\newcommand{\notestyle}[2]{%
{\textcolor{tuewarmred}{\textbf{[NOTE #1:} #2\textbf{]}}}%
}

\newcommand{\l@note}[2]{%
	\@dottedtocline{1}%
	 {0em} % Indent
	 {3em} % Listing number width
	 {#1} % Entry text
	 {#2}% % Page number
}

\newcommand{\listnotename}{List of Notes}
\newcommand{\listofnotes}{%
	\if@twocolumn
	  \@restonecoltrue\onecolumn
	\else
	  \@restonecolfalse
	\fi
	\chapternn{\listnotename
	\@mkboth{\MakeUppercase\listnotename}%
	{\MakeUppercase\listnotename}}%
	\@starttoc{lon}%
	\if@restonecol\twocolumn\fi
}









\newcounter{definition}
\newcommand{\definedef}[2]{%
	\refstepcounter{definition}%
	\begingroup%
		\setlength{\fboxsep}{1pt}%
		\colorbox{linkpink}{\hyperref[def:#1]{#1}}%
	\endgroup%
	\addcontentsline{lod}{definition}{\numberline{\string\definitionstyle{#1}}%
	#2}%
	\addtocontents{lod}{\string\label{def:#1}}%
}

\newcommand{\defineabbr}[2]{%
	\refstepcounter{definition}%
	\begingroup%
		\setlength{\fboxsep}{1pt}%
		\colorbox{linkpink}{\hyperref[def:#1]{#1}} (#2)%
	\endgroup%
	\addcontentsline{lod}{definition}{\numberline{\string\definitionstyle{#1}}%
	#2}%
	\addtocontents{lod}{\string\label{def:#1}}%
}

\newcommand{\definitionstyle}[1]{%
\begingroup
\parbox[b]{7em}{#1}
\endgroup
}

\newcommand{\refdef}[1]{%
	\hyperref[def:#1]{#1}
}

\newcommand{\listdefintionname}{List of Definitions}
\newcommand{\listofdefinitions}{%
	\if@twocolumn
	  \@restonecoltrue\onecolumn
	\else
	  \@restonecolfalse
	\fi
	\chapternn{\listdefintionname
	\@mkboth{\MakeUppercase\listdefintionname}%
	{\MakeUppercase\listdefintionname}}%
	\@starttoc{lod}%
	\if@restonecol\twocolumn\fi
}

\newcommand{\l@definition}[2]{%
	\@dottedtocline{0}%
	 {0em} % Indent
	 {8em} % Listing number width
	 {#1} % Entry text
	 {#2}% % Page number
}

\makeatother

\makeatletter
\AtEndDocument{
	\label{lastdocpage}
}
\makeatother