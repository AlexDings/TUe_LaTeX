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
\ProvidesClass{TUestyle}[\filedate\space\fileversion\space  TU/e style report & book 2008]

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{pgf}
\RequirePackage{xkeyval}




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

%%% Abbreviation commands
\def\ie{i.e.,\space}
\def\viz{viz.,\space}
\def\eg{e.g.,\space}
\def\etc{etc.\space}
\def\etal{et al.\space}
\def\tue{TU/e\space}



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

%%% command \ifequal{<stringA>}}{<stringB>}{<true>}{<false>}
%%  compares two strings for equality
\newcommand{\@ifequal}[4]{%
  \def\string@a{#1}
  \def\string@b{#2}
  \ifx\string@a\string@b
    #3
  \else
    #4
  \fi
}

%%% command \setfontsize{<fontsize>}}{<linespacing>}
%%  correctly sets the font size and spacing
\newcommand{\setfontsize}[2]{%
	\fontsize{#1}{#2}\selectfont%
	\setlength{\baselineskip}{#2}%
	\setlength{\parskip}{#2}%
}




	
%%%
%   Document settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   Document
%%%

%%% book / report
%   report by default

\newif\ifbook
\bookfalse
\DeclareOption{report}{\bookfalse}
\DeclareOption{book}{\booktrue}
\ProcessOptions

% load underlying class
\ifbook
  \LoadClass{book}
\else
  \LoadClass{report}
\fi

%%% Not supported paper options

\DeclareOption{a5paper}{\ClassErrorNotSupported{a5paper}}
\DeclareOption{b5paper}{\ClassErrorNotSupported{b5paper}}
\DeclareOption{letterpaper}{\ClassErrorNotSupported{letterpaper}}
\DeclareOption{executivepaper}{\ClassErrorNotSupported{executivepaper}}
\DeclareOption{legalpaper}{\ClassErrorNotSupported{legalpaper}}
\DeclareOption{landscape}{\ClassErrorNotSupported{landscape}}
\ProcessOptions



%%%
%   Layout
%%%

\newlength{\layoutleftmargin}
\setlength{\layoutleftmargin}{15mm}
\DeclareOptionX{left}{\setlength{\layoutleftmargin}{#1}}

\newlength{\layoutrightmargin}
\setlength{\layoutrightmargin}{15mm}
\DeclareOptionX{right}{\setlength{\layoutrightmargin}{#1}}

\newlength{\layouttopmargin}
\setlength{\layouttopmargin}{20.25mm}
\DeclareOptionX{top}{\setlength{\layouttopmargin}{#1}}

\newlength{\layoutbottommargin}
\setlength{\layoutbottommargin}{15.75mm}
\DeclareOptionX{bottom}{\setlength{\layoutbottommargin}{#1}}

\ProcessOptionsX

\RequirePackage{geometry}
\geometry{top=\layouttopmargin, left=\layoutleftmargin, right=\layoutrightmargin, bottom=\layoutbottommargin, nomarginpar, nofoot}



%%%
%   Grid
%%%

\def\gridcolumns{12}
\def\gridleftcolumns{1}
\def\gridrightcolumns{2}
\def\gridbodycolumns{\numexpr\gridcolumns-\gridleftmargin-\gridrightmargin\relax}

\newlength{\gridgutterwidth}
\setlength{\gridgutterwidth}{3.853mm}
\setlength{\columnsep}{\gridgutterwidth}

\newlength{\gridcolumnwidth}
\setlength{\gridcolumnwidth}{\dimexpr (\paperwidth - \layoutleftmargin - \layoutrightmargin - \numexpr\gridcolumns-1\relax\columnsep) / \gridcolumns \relax}

\newlength{\lineheight}
\setlength{\lineheight}{12.75bp}

%%% command \drawgrid
%%  draws document grid
\newcommand{\drawgrid}{%
  % TODO implement drawing grid
}



%%%
%   Draft
%%%

\newif\ifdraft
\draftfalse
\DeclareOption{draft}{\drafttrue}
\ProcessOptions




%%%
%   Localization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%   Language
%%%

% english by default
\newif\ifenglish
\englishtrue
\DeclareOptionX{english}{\englishtrue}
\DeclareOptionX{engels}{\englishtrue}
\DeclareOptionX{dutch}{\englishfalse}
\DeclareOptionX{nederlands}{\englishfalse}
\ProcessOptionsX



%%%
%   TU/e
%%%

\newvariable{website}{www.tue.nl}
\newvariable{phonenumber}{+31 (0)40 247 9111}
\newvariable{phonenumberlabel}{Tel.}
\newvariable{fullname}{Technische Universiteit \textbf{Eindhoven} University of Technology}

\ifenglish
	\newvariable{university}{Eindhoven University of Technology}
  \newvariable{visitingaddresslabel}{Visiting adress}
  \newvariable{postaladdresslabel}{Postal adress}
\else
  \newvariable{university}{Technische Universiteit Eindhoven}
  \newvariable{visitingaddresslabel}{Bezoekadres}
  \newvariable{postaladdresslabel}{Postadres}
\fi



%%%
%   Metadata
%%%








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
\newif\iftuefonts
\tuefontsfalse
\DeclareOption{tuefonts}{\tuefontstrue}
\ProcessOptions

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
  \color{colorheading}
  \setfontsize{10bp}{12.75bp}
	\fontbold
}

% heading normal
\def\styling@headingnormal{%
  \color{colorheading}
  \setfontsize{24bp}{32bp}
	\fontbold
}

% heading large
\def\styling@headinglarge{%
  \color{colorheading}
  \setfontsize{30bp}{40bp}
	\fontbold
}

% heading Large
\def\styling@headingLarge{%
  \color{colorheading}
  \setfontsize{36bp}{48bp}
	\fontbold
}

% heading LARGE
\def\styling@headingLARGE{%
  \color{colorheading}
  \setfontsize{42bp}{54bp}
	\fontbold
}

% heading huge
\def\styling@headinghuge{%
  \color{colorheading}
  \setfontsize{48bp}{58bp}
	\fontbold
}

% sub heading large
\def\styling@subheadinglarge{%
  \color{colorheading}
  \setfontsize{18bp}{24bp}
	\fontmedium
}

% sub heading normal
\def\styling@subheadingnormal{%
  \color{colorsubheading}
  \setfontsize{12.25bp}{16bp}
	\fontmedium
}

% sub heading small
\def\styling@subheadingsmall{%
  \color{colorsubheading}
  \setfontsize{9.25bp}{12.75bp}
	\fontnormal
}

% intro normal
\def\styling@intronormal{%
  \color{colorintro}
  \setfontsize{10.75bp}{14.35bp}
	\fontmedium
}

% intro large
\def\styling@introlarge{%
  \color{colorintro}
  \setfontsize{12.25bp}{16bp}
	\fontmedium
}

% body text
\def\styling@body{%
  \color{colorbody}
  \setfontsize{9.25bp}{12.75bp}
	\fontdefault
}

% promotional text
\def\styling@promotional{%
  \color{colorpromotional}
  \setfontsize{10.75bp}{14.35bp}
	\fontnormal
}

% promotional heading
\def\styling@promotionalheading{%
  \color{colorsubheading}
  \setfontsize{11bp}{14.35bp}
	\fontbold
}

% quote normal
\def\styling@quotenormal{%
  \color{colorquote}
  \setfontsize{15bp}{20bp}
	\fontmedium
}

% quote large
\def\styling@quotelarge{%
  \color{colorquote}
  \setfontsize{18bp}{24bp}
	\fontmedium
}

% accent text
\def\styling@accent{%
  \color{coloraccent}
  \setfontsize{9.25bp}{12.75bp}
	\fontmedium
}

% info text
\def\styling@info{%
  \color{colorinfo}
  \setfontsize{9.25bp}{12.75bp}
	\fontnormal
}

% caption
\def\styling@caption{%
  \color{colorcaption}
  \setfontsize{9.25bp}{12.75bp}
	\fontbold
}

% note
\def\styling@note{%
  \color{colornote}
  \setfontsize{7.75bp}{12.75bp}
	\fontnormal
}

% quote normal
\def\styling@payoffnormal{%
  \color{colorpayoff}
  \setfontsize{10bp}{12.75bp}
	\fontmedium
}

% quote large
\def\styling@payofflarge{%
  \color{colorpayoff}
  \setfontsize{15bp}{12.75bp}
	\fontmedium
}


%%% command \style{<size>}{<type>}
%%  sets the font style
\newcommand{\style}[2][normal]{%
  \@ifequal{#2}{heading}{%
    \@ifequal{#1}{huge}{\styling@headinghuge}
    {\@ifequal{#1}{LARGE}{\styling@headingLARGE}
    {\@ifequal{#1}{Large}{\styling@headingLarge}
    {\@ifequal{#1}{large}{\styling@headinglarge}
    {\@ifequal{#1}{normal}{\styling@headingnormal}
    {\@ifequal{#1}{small}{\styling@headingsmall}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}}}}}}
  }{\@ifequal{#2}{subheading}{%
    \@ifequal{#1}{large}{\styling@subheadinglarge}
    {\@ifequal{#1}{normal}{\styling@subheadingnormal}
    {\@ifequal{#1}{small}{\styling@subheadingsmall}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}}}
  }{\@ifequal{#2}{intro}{%
    \@ifequal{#1}{large}{\styling@introlarge}
    {\@ifequal{#1}{normal}{\styling@intronormal}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}}
  }{\@ifequal{#2}{body}{%
    \@ifequal{#1}{normal}{\styling@body}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{promotional}{%
    \@ifequal{#1}{normal}{\styling@promotional}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{promotional-heading}{%
    \@ifequal{#1}{normal}{\styling@promotionalheading}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{quote}{%
    \@ifequal{#1}{normal}{\styling@quotenormal}
    {\@ifequal{#1}{large}{\styling@quotelarge}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}}
  }{\@ifequal{#2}{accent}{%
    \@ifequal{#1}{normal}{\styling@accent}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{info}{%
    \@ifequal{#1}{normal}{\styling@info}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{caption}{%
    \@ifequal{#1}{normal}{\styling@caption}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{note}{%
    \@ifequal{#1}{normal}{\styling@note}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}
  }{\@ifequal{#2}{payoff}{%
    \@ifequal{#1}{normal}{\styling@payoffnormal}
    {\@ifequal{#1}{large}{\styling@payofflarge}
    {\ClassWarning{TUestyle}{Not a valid size for style <#2>: #1}}}
  }}}}}}}}}}}}
}



%%%
%   Enumeration styles
%%%

\renewcommand{\labelitemi}{\color{colorlabel}$\bullet$}



%%%
%   Table styles
%%%

\PassOptionsToPackage{table}{xcolor}

\def\zapcolorreset{\let\reset@color\relax\ignorespaces}
\def\colorrows#1{\noalign{\aftergroup\zapcolorreset#1}\ignorespaces}

\edef\endtabular{\unexpanded\expandafter{\endtabular}\noexpand\reset@color}

\let\oldtable\table
\let\endoldtable\endtable
\renewenvironment{table}[1][ht]{%
  \oldtable[#1]}%
  {\endoldtable}

\let\oldtabular\tabular
\let\endoldtabular\endtabular
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
%   Document data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
