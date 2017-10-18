% This package defines the report/book class in the TU/e 2008 style.
% Besides new functionality, it also redefines some commands from
% the standard report/book document class, so it is designed to work with these
% classes only!
%
% Author: Alex Dings, elaborated on the works of Marko Boon
% Date: May, 2015.

% Trying to follow the following naming convention:
%   Document level commands             (\section) lowercase.
%   Package interface commands          (\DeclareTextCommandDefault) CamelCase.
%   Package or kernel internal commands (\@text@composite@) lower@case@with@.
%   TeX primitives                      (\expandafter) lowercase.

\NeedsTeXFormat   {LaTeX2e}

\def\fileversion  {v.2.0}
\def\filedate     {2015/03/29}
\def\filename     {TU/e style report & book 2008}
\def\docname      {TUeStyleReportBook.cls}
\ProvidesClass    {TUeStyleReportBook}[\filedate\space\fileversion\space\filename]





%%%
%   General Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{errorcontextlines}{20}% Show more context of the LaTeX erros

%%%
%   Used Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}% loaded after »fontenc«

\RequirePackage{xkeyval}

\RequirePackage[table]{xcolor}% also loads »colortbl«
\RequirePackage{pgf}% also loads »xcolor«, so loaded after »xcolor«
\RequirePackage{pgffor}

\RequirePackage[dutch, english]{babel}

\RequirePackage{graphicx}

\RequirePackage{anyfontsize}% allow the usage of any arbitrary font size, stop fallback
\RequirePackage{lmodern}% better i18n Postscript version of Knuth's cm fonts

\RequirePackage{fancyhdr}

\RequirePackage{ulem}

\RequirePackage{accsupp}

\AtBeginDocument{
  %%% Make the sentence spacing single spaced
  %%    Also avoids microtype "\nonfrenchspacing is active. Adjustment of
  %%    (microtype) interword spacing will disable it." warning
  \frenchspacing

  %%% Package »microtype«
  %%    activate={true,nocompatibility} - activate protrusion and expansion
  %%    final - enable microtype; use "draft" to disable
  %%    tracking=true, kerning=true, spacing=true - activate these techniques
  %%    factor=1100 - add 10% to the protrusion amount (default is 1000)
  %%    stretch=10, shrink=10 - reduce stretchability/shrinkability (default is 20/20)
  \RequirePackage[
    activate={true,nocompatibility},
    final,
    tracking=true,
    kerning=true,
    spacing=true,
    factor=1100,stretch=100,shrink=100
  ]{microtype}
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

%%% Sectioning shift
%%  (0 by default)
\def\@sectioningshift{0}

%%% "List of" parskip
\newlength{\listofparskip}
\setlength{\listofparskip}{0cm}

%%% Default image paths
\graphicspath{{./}%       0th
              {Images/}%  1st
              {Imgs/}%    2nd
              {Img/}%     3rd
              {images/}%  4th
              {imgs/}%    5th
              {img/}}%    6th


%%%
%   Commands used in class options 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% command \ifequal{<stringA>}}{<stringB>}{<on true>}{<on false>}
%%  compares two parameters for equality
\newcommand{\ifequal}[4]{%
  \expandafter\edef\expandafter\string@a{#1}%
  \expandafter\edef\expandafter\string@b{#2}%
  \ifx\string@a\string@b%
    #3%
  \else%
    #4%
  \fi%
}

%%% command \PassOptionsToBaseClass{<options>}
%%  used to pass <options> to the baseclass
\newcommand{\PassOptionsToBaseClass}[1]{%
  \PassOptionsToClass{#1}{book}%
  \PassOptionsToClass{#1}{report}%
}

%%% command \ClassErrorNotSupported[<suggested option>]{<unsupported option>}
%%  outputs the warning: "Please remove class option <unsupported option>, Only <suggested option> is supported!"
\newcommand{\ClassErrorNotSupported}[2][\@empty]{%
  \ClassError{\docname}{%
    Please remove class option #2,\MessageBreak%
    \ifx\@empty#1%
    \else%
      Only #1 is supported!%
    \fi
  }{}%
}

%%% command \DeclareBooleanOptionX[<value>]{<switch name>}
%%  defines switch \if<switch name> and sets \<switch name><value>
\newcommand{\DeclareBooleanOptionX}[2][true]{%
  \define@boolkey{\docname}[]{#2}{}\csname#2#1\endcsname%
}


%%%
%   Class options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%   General options
%%%

%%% option report style
%%  sets \ifbook switch false
%%  sets \iftwosided false,   if twosided isn't set by user yet
\DeclareOptionX{report}{%
  \bookfalse%
  \iftwosidedtouched\relax\else\twosidedfalse\fi%
}

%%% option book style
%%  sets \ifbook switch true
%%  sets \iftwosided true,    if twosided isn't set by user yet
\DeclareOptionX{book}{%
  \booktrue%
  \iftwosidedtouched\relax\else\twosidedtrue\fi%
}

%%%
%   Layout options
%%%

%%% option showframe to show layout frame
\DeclareBooleanOptionX[false]{showframe}

%%% option onsesided to draw one-sided
\DeclareOptionX{oneside}{\twosidedfalse \twosidedtouchedtrue}
%%% option twosided to draw two-sided
\DeclareOptionX{twoside}{\twosidedtrue  \twosidedtouchedtrue}

%%% option onecolumn to draw one-column
\DeclareOptionX{onecolumn}{\twocolumnfalse}
%%% option twocolumn to draw two-column
\DeclareOptionX{twocolumn}{\twocolumntrue}

%%% option bleed
%%  sets layout bleed length
%%  default 0pt
\DeclareOptionX{bleed}{
  \setlength{\layoutbleed}{#1}
  \ifdim \layoutbleed < 0pt\relax
    \ClassError{TUeStyle}{The layout bleed can't be negative.}
  \fi
}
    \newlength{\layoutbleed}
    \ExecuteOptionsX{bleed=0pt}

%%% command \TUe@definepapersize{<paper type>}{<width>}{<height>}
%%  used to store <width>   in \<paper type>@width
%%  used to store <height>  in \<paper type>@height
\newcommand{\TUe@definepapersize}[3]{
  \expandafter\def\csname #1@width\endcsname{#2}
  \expandafter\def\csname #1@height\endcsname{#3}
}

%%% TU/e (Eindhoven University of Technology) paper sizes
%%  Standard sizes:     a4paper, a45paper, a5paper
%%  Exceptional sizes:  a34paper, a4papersquare, a5papersquare, a6paper
\TUe@definepapersize{a4papersquare}{210mm}{210mm}
\TUe@definepapersize{a5papersquare}{148mm}{148mm}
\TUe@definepapersize{a45paper}     {168mm}{240mm}
\TUe@definepapersize{a34paper}     {240mm}{336mm}

%% ISO (International Organization for Standardization) paper sizes
\TUe@definepapersize{a0paper}{841mm} {1189mm}
\TUe@definepapersize{a1paper}{594mm} {841mm}
\TUe@definepapersize{a2paper}{420mm} {594mm}
\TUe@definepapersize{a3paper}{297mm} {420mm}
\TUe@definepapersize{a4paper}{210mm} {297mm}
\TUe@definepapersize{a5paper}{148mm} {210mm}
\TUe@definepapersize{a6paper}{105mm} {148mm}
\TUe@definepapersize{b0paper}{1000mm}{1414mm}
\TUe@definepapersize{b1paper}{707mm} {1000mm}
\TUe@definepapersize{b2paper}{500mm} {707mm}
\TUe@definepapersize{b3paper}{353mm} {500mm}
\TUe@definepapersize{b4paper}{250mm} {353mm}
\TUe@definepapersize{b5paper}{176mm} {250mm}
\TUe@definepapersize{b6paper}{125mm} {176mm}
\TUe@definepapersize{c0paper}{917mm} {1297mm}
\TUe@definepapersize{c1paper}{648mm} {917mm}
\TUe@definepapersize{c2paper}{4580mm}{648mm}
\TUe@definepapersize{c3paper}{324mm} {458mm}
\TUe@definepapersize{c4paper}{229mm} {324mm}
\TUe@definepapersize{c5paper}{162mm} {229mm}
\TUe@definepapersize{c6paper}{114mm} {162mm}

%%  ANSI (American National Standards Institute) paper sizes
\TUe@definepapersize{ansiapaper}     {8.5in} {11.0in}
\TUe@definepapersize{ansibpaper}     {11.0in}{17.0in}
\TUe@definepapersize{ansicpaper}     {17.0in}{22.0in}
\TUe@definepapersize{ansidpaper}     {22.0in}{34.0in}
\TUe@definepapersize{ansiepaper}     {34.0in}{44.0in}
\TUe@definepapersize{letterpaper}    {8.5in} {11.0in}
\TUe@definepapersize{legalpaper}     {8.5in} {14.0in}
\TUe@definepapersize{executivepaper} {7.25in}{10.5in}

%%  JIS (Japanese Industrial Standards)
%   Note: JIS A-series is identical to the ISO A-series
\TUe@definepapersize{b0j}{1030mm}{1456mm}
\TUe@definepapersize{b1j}{738mm} {1030mm}
\TUe@definepapersize{b2j}{515mm} {728mm}
\TUe@definepapersize{b3j}{364mm} {515mm}
\TUe@definepapersize{b4j}{257mm} {364mm}
\TUe@definepapersize{b5j}{182mm} {257mm}
\TUe@definepapersize{b6j}{128mm} {182mm}

%%% option paper
%%  sets layout width and height to values defined by \TUe@definepapersize
\DeclareOptionX{paper}{\def\TUePapersize{#1}%
  \setlength{\temp@layoutwidth}{\csname #1@width\endcsname}%
  \setlength{\temp@layoutheight}{\csname #1@height\endcsname}%
}
    \newlength{\temp@layoutwidth}
    \newlength{\temp@layoutheight}

%%% options for papersize shortcuts for papersizes defined by the default book & report classes
\DeclareOptionX{a4paper}        {\ExecuteOptionsX{paper=a4paper}}
\DeclareOptionX{a5paper}        {\ExecuteOptionsX{paper=a5paper}}
\DeclareOptionX{b5paper}        {\ExecuteOptionsX{paper=b5paper}}
\DeclareOptionX{letterpaper}    {\ExecuteOptionsX{paper=letterpaper}}
\DeclareOptionX{executivepaper} {\ExecuteOptionsX{paper=executivepaper}}
\DeclareOptionX{legalpaper}     {\ExecuteOptionsX{paper=legalpaper}}
\DeclareOptionX{landscape}      {\ClassErrorNotSupported[portrait]{landscape}}

    %%  default paper size
    \ExecuteOptionsX{a4paper}

%%% options custom layout margins
\DeclareOptionX{left}       {\newlength{\layoutleftmargin}  \setlength{\layoutleftmargin}   {#1}}
\DeclareOptionX{right}      {\newlength{\layoutrightmargin} \setlength{\layoutrightmargin}  {#1}}
\DeclareOptionX{top}        {\newlength{\layouttopmargin}   \setlength{\layouttopmargin}    {#1}}
\DeclareOptionX{bottom}     {\newlength{\layoutbottommargin}\setlength{\layoutbottommargin} {#1}}
\DeclareOptionX{marginparL} {\newlength{\marginparL}        \setlength{\marginparL}         {#1}}
\DeclareOptionX{marginparR} {\newlength{\marginparL}        \setlength{\marginparL}         {#1}}

%%%
%   TU/e style options
%%%

%%% option slogan to draw TU/e slogan
\DeclareBooleanOptionX[true]{slogan}

%%% option innovation to draw the innovation mark
\DeclareBooleanOptionX[true]{innovation}

%%% option logo to draw the TU/e logo mark
\DeclareBooleanOptionX[true]{logo}

%%% option title to draw the title in ToC
\DeclareBooleanOptionX[true]{title}

%%% option subtitle to draw the subtitle in ToC
\DeclareBooleanOptionX[true]{subtitle}

%%% option address to draw the (TU/e) address
\DeclareBooleanOptionX[true]{address}

%%% option author to draw the author
\DeclareBooleanOptionX[true]{author}

%%% option date to draw the date
\DeclareBooleanOptionX[true]{date}

%%%
%   sectioning options
%%%

%%% option sectioningstyling to use sectioning style
\DeclareBooleanOptionX[true]{sectioningstyling}

%%% option chaptername to draw "chapter XX" above chaptername
\DeclareBooleanOptionX[false]{chaptername}

%%% option leadzero to add a leading zero to chapter numbering
\DeclareBooleanOptionX[true]{leadzero}

%%% option inlinesec to disable pagebreak before sectioning, making it inline
\DeclareBooleanOptionX[false]{inlinesec}

%%% option leftch to left align chapter head
\DeclareBooleanOptionX[false]{leftch}

%%% option runinsec
%%  Shift all sectioning numbering to left margin,
%%  widen left margin
%%  Shift complete chapter heading in left margin
\DeclareBooleanOptionX[false]{runinsec}

%%% option subsecmark to keep subsectionmark
\DeclareBooleanOptionX[false]{subsecmark}

%%% option watermark to have a hidden watermark in sectioning
\DeclareBooleanOptionX[false]{watermark}

%%% option zeroindexed to start sectioning counters at zero
\DeclareOptionX{zeroindexed}{\def\@sectioningshift{-1}}

%%% option coloredsectioning to give the sectioning color
\DeclareBooleanOptionX[true]{coloredsectioning}

%%%
%   Font options
%%%

%%% option coloredtext to color TU/e style text
\DeclareBooleanOptionX[true]{coloredtext}

%%% option tuefonts to load tuefonts
\DeclareBooleanOptionX[false]{tuefonts}

%%% option paragraphstyling to use (TU/e) paragraph styling
\DeclareBooleanOptionX[true]{paragraphstyling}

%%% option indentafter to disable the indent on the first paragraph after sectioning
\DeclareBooleanOptionX[false]{indentafter}

%%% option parindent to indent paragraphs
\DeclareBooleanOptionX[false]{parindent}

%%% option parskip to adjust parskip
\DeclareBooleanOptionX[true]{parskip}

%%% option hyperstyle
%%  border:     border all around links
%%  underline:  border underneath links
%%  color:            coloring of links
\define@choicekey*{\docname}{hyperstyle}{border,underline,color}[color]{%
  \def\hyperstyle{#1}
}
    \setkeys{\docname}{hyperstyle}

%%% option urlstyle
%%  same:             mimmick surrounding font style
%%  allbreak:               break links everywhere
%%  restrictedbreak:  don't break links anywhere
\define@choicekey*{\docname}{urlstyle}{same,allbreak,restrictedbreak}[allbreak]{%
  \AtBeginDocument{\urlstyle{#1}}
}
    \setkeys{\docname}{urlstyle}

%%% options for fontsize
\DeclareOptionX{9pt}  {\PassOptionsToBaseClass{10pt}            \def\classFontSize{9} }
\DeclareOptionX{10pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{10}}
\DeclareOptionX{11pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{11}}
\DeclareOptionX{12pt} {\PassOptionsToBaseClass{\CurrentOption}  \def\classFontSize{12}}
    %% default 9pt
    \ExecuteOptionsX{9pt}

%%%
%   Cover options     TODO make cover specific
%%%

%%% Option for cover ratio
%%  Ratio has to be bigger than 4:3       TODO make cover specific
\DeclareOptionX{coverratio}[4/3]{%
  \pgfmathsetmacro\@coverratio{%
    ifthenelse(
    #1 > (4/3),
    #1,
    4/3
    )
  }%
}
    \ExecuteOptionsX{coverratio}

%%% Option for cover alignment        TODO make cover specific + only allow width OR height
\DeclareOptionX{coveralign}[width]{
    \def\@coveralign{#1}
}
    \ExecuteOptionsX{coveralign=width}
    
%%%% TODO make option per cover
\DeclareOptionX{cover}{%
  \ifequal{#1}{}{}{
    \def\covername{#1}
  }
  \covertrue
}
    \newif\ifcover
    \coverfalse
    \def\covername{cover}

%%%
%   image & caption options
%%%
    
%%% option nofloat to not float images
\DeclareBooleanOptionX[false]{nofloat}
    
%%% Align options
%%  (centered by default)
%%  aligns captions and images
%%  left:     left aligns
%%  center:   center aligns
%%  right:    right aligns
%%  none:     invokes default LaTeX behaviour
\define@choicekey*{\docname}{align}[\val\nr]{left,center,right,none}[center]{%
  \ifcase\nr\relax
    \def\autocenter{\raggedright}%
    \def\autocentercap{\raggedright}%
    %\def\autocentershort{l}%
  \or
    \def\autocenter{\centering}%
    \def\autocentercap{\centering}%
    %\def\autocentershort{c}%
  \or
    \def\autocenter{\raggedleft}%
    \def\autocentercap{\raggedleft}%
    %\def\autocentershort{r}%
  \or
    \def\autocenter{\raggedright}%
    \def\autocentercap{\centering}%
    %\def\autocentershort{c}%
  \fi
}
    \setkeys{\docname}{align}

%%%
%   header & footer options
%%%

%%% option onesidehf to draw header footers onesided
\DeclareOptionX{onesidehf}{\onesidehftrue}
%%% option twosidehf to draw header footers twosided
\DeclareOptionX{twosidehf}{\onesidehffalse}
%%  not caught in a single true/false command to work nicely with onesided/twosided

%%% option fadehf to draw faded header and footer
%%  (false by default)
\DeclareBooleanOptionX[false]{fadehf}

%%% option sectioningf to draw chapter in footer
\DeclareBooleanOptionX[false]{sectioningf}

%%% option copyf to draw the copyholer in footer
\DeclareBooleanOptionX[false]{copyf}

%%% option enf to draw last page number in footer
\DeclareBooleanOptionX[false]{endf}

%%% option shorth to draw shorter header
\DeclareBooleanOptionX[false]{shorth}

%%%
%   Other options
%%%

%%% options for languages
\DeclareOptionX{english}    {\dutchfalse}
\DeclareOptionX{engels}     {\dutchfalse}
\DeclareOptionX{dutch}      {\dutchtrue}
\DeclareOptionX{nederlands} {\dutchtrue}

%%% option load BibLaTeX, and use the BibLaTeX presets
\DeclareBooleanOptionX[false]{biblatex}

%%% option draft mode
\DeclareBooleanOptionX[false]{draft}

% Print optimalization
\DeclareBooleanOptionX[false]{print}

%%% option draw draft mark
\DeclareBooleanOptionX[false]{draftmark}

%%% option draw draft line numbering
\DeclareBooleanOptionX[false]{linenum}

%%% option to load »refcheck«
\DeclareBooleanOptionX[true]{refcheck}

%%% options for notes
%%  textmargin: inline marker, expanded text in margin
%%  text:       inline marker, expanded text is inline
%%  margin:     margin marker, expanded text in margin
%%  false:          no marker, expanded text is hidden
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
    \newif\ifmarginnotes
    \newif\ifnotes
    \newif\iftextnotes
    \setkeys{\docname}{notes}

%%% options for footnotealign
%%  hang:     hangs the footnotes
%%  inline:   makes the footnote styling inline
\define@choicekey*{\docname}{footnotealign}[\val\nr]{hang,inline}[hang]{%
  \ifcase\nr\relax
    \AtBeginDocument{\hangfntext}
  \or
    \AtBeginDocument{\inlinefntext}
  \fi
}
    \setkeys{\docname}{footnotealign}

%%% option markblank to mark blank pages
\DeclareBooleanOptionX[false]{markblank}

%%% option globallistspacing to give all "list ofs" the same spacing
\DeclareBooleanOptionX[true]{globallistspacing}

%%% option includesource to include TeX sourcecode in the pdf
\DeclareBooleanOptionX[false]{includesource}

%%% option buildnumber to show build number behind version number
\DeclareBooleanOptionX[false]{buildnumber}

%%%
%   Option processing
%%%

%%% Pass options to underlying classes
\DeclareOptionX*{%
  \PassOptionsToBaseClass{\CurrentOption}
}

%%% Process all options
\ProcessOptionsX % TODO define family: <>

%%%
%   User utility commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
%   
%%%

%%% command \rotatepdfpage
%%  Rotates the page in the pdf view, possible values are: 0, 90, 180, 270 etc.
\newcommand{\rotatepdfpage}[1]{\global\pdfpageattr\expandafter{\the\pdfpageattr/Rotate #1}}

%%% command \vcenterinclude
%%  Includes something vertically centered
\newcommand{\inlinevcenter}[1]{%
  \begingroup%
    \setbox0=\hbox{#1}%
    \parbox[c]{\wd0}{\box0}% [c] is not needed, added for clarity
  \endgroup%
}

%%% command \newpageafterblank
%%  Creates an empty - blank - page
\newcommand*\newpageafterblank{\newpage\null\thispagestyle{empty}\newpage}

%%% symbol reshaping commands
%%  used to rotate symbols to create new symbols

%%% command \reflh
%%  reflects symbol horizontally
%%% command \reflh
%%  reflects symbol vertically
%%% command \turnover 
%%  turns a symbol 180°
%%% command \turnne   
%%  turns a symbol north east
%%% command \turnnw   
%%  turns a symbol north west
%%% command \turnsw   
%%  turns a symbol south west
%%% command \turnse   
%%  turns a symbol south east
\newcommand{\reflh}     [1]{\reflectbox                          {#1}}
\newcommand{\reflv}     [1]{\reflectbox{\rotatebox[origin=c]{180}{#1}}}
\newcommand{\turnover}  [1]{\rotatebox            [origin=c]{180}{#1}}
\newcommand{\turnne}    [1]{\rotatebox            [origin=c]{45 }{#1}}
\newcommand{\turnnw}    [1]{\rotatebox            [origin=c]{135}{#1}}
\newcommand{\turnsw}    [1]{\rotatebox            [origin=c]{225}{#1}}
\newcommand{\turnse}    [1]{\rotatebox            [origin=c]{315}{#1}}

%%  symbol reshaping commands
%%  same as above, with math mode enabled
\newcommand{\mreflh}    [1]{\reflecth {\ensuremath{#1}}}
\newcommand{\mreflv}    [1]{\reflectv {\ensuremath{#1}}}
\newcommand{\mturnover} [1]{\turnover {\ensuremath{#1}}}
\newcommand{\mturnne}   [1]{\turnne   {\ensuremath{#1}}}
\newcommand{\mturnnw}   [1]{\turnnw   {\ensuremath{#1}}}
\newcommand{\mturnsw}   [1]{\turnsw   {\ensuremath{#1}}}
\newcommand{\mturnse}   [1]{\turnse   {\ensuremath{#1}}}

%%% command \superscript{<content>}
%%  correctly writes content as superscript
\newcommand{\superscript}[1]{\@textsuperscript{#1}}
%%% command \up as a \superscript shorthand
\let\up\superscript

%%% command \subscript{<content>}
%%  correctly writes content as subscript
\newcommand{\subscript}[1]{\@textsubscript{#1}}
%%% command \down as a \subscript shorthand
\let\down\subscript

%%%	Abbreviation commands
%   they end with a / to prevent swallowing of following space
\def  \ie/{\emph {i.e.},}
\def \viz/{\emph {viz.},}
\def  \eg/{\emph {e.g.},}
\def \etc/{\emph {etc.}}
\def\etal/{\emph {et al.}}
\def \tue/{\emph {TU/e}}

%%% Partial derivative command
\newcommand{\pd}[2]{\frac{\partial #1}{\partial #2}}

%%% Command: \quads{<# of quads>}
%%  Used as a shorthand for multiple quads
%%  Usage: \quads[4] yiels the same result as \quad\quad\quad\quad
\newcommand{\quads}[1][1]{%
	\hspace*{#1em}\ignorespaces%
}

%%% Set change margin command
%%  Usage:  \begin{shiftmargin}{<left>}{<right>} \end{shiftmargin}
%%				  Where "left" and "right" are units of length
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

%%% Environment: {shiftcolumn}{<left shift # columns>}{<right shift # columns>}
\newenvironment{shiftcolumn}[2]{%
  \begin{shiftmargin}{\dimexpr -#1\columnsize}{\dimexpr -#2\columnsize}%
}{%
  \end{shiftmargin}%
}

%%%	\crule[<color>]{<width>}{<height>}
\newcommand\crule[3][colorrule]{%
  \textcolor{#1}{\rule{#2}{#3}}%
}

%%%	\chrulefill[<color>][<height>]
\def\chrulefill{%
   \@ifnextchar[% check if the first optional argument <color> is specified
     {\chrulefill@i}
     {\chrulefill@i[colorrule]}%
}
        \def\chrulefill@i[#1]{%
           \@ifnextchar[% check if the second optional argument <height> is specified
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
   \@ifnextchar[% check if the first optional argument <color> is specified
     {\chrule@i}
     {\chrule@i[colorrule]}%
}
        \def\chrule@i[#1]{%
           \@ifnextchar[% check if the second optional argument <height> is specified
             {\chrule@ii{#1}}
             {\chrule@ii{#1}[0.4pt]}% According to p. 221 of the TeXbook, the height of \hrule is 0.4pt.
        }
        \def\chrule@ii#1[#2]{%
          \begingroup
            \leavevmode\color{#1}\hrule height #2
          \endgroup
        }

%%% Command: \urlstyle{allbreak}
%%  switch to break urls anywhere
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

%%% Command: \urlstyle{restrictedbreak}
%%  switch to disable breaking of urls anywhere
%%  default LaTeX urls, no breaks all urls
\def\url@restrictedbreakstyle{%
  \def\UrlBreaks{\do\.\do\@\do\\\do\/\do\!\do\_\do\|\do\;\do\>\do\]%
    \do\)\do\,\do\?\do\'\do+\do\=\do\#}%
}

%%%
%	Hide from ToC
%%% 

%%%	Command: \stoplistentries
%	  Switch to stop any entries from being added to the ToC and other lists
\newcommand{\stoplistentries}{\storeoldrelax{\addcontentsline}\def\addcontentsline##1##2##3{}}

%%% Command: \startlistentries
%	  Switch to re-enable any entries being added to the ToC and other lists
\newcommand{\startlistentries}{\restoreold{\addcontentsline}}

%%%	Command: \tocless{<content>}
%	  Disables adding of <content> to the ToC and other lists
%	  Example: \tocless{\chapter{Title}}
\newcommand{\tocless}[1]{\begingroup\stoplistentries#1\endgroup}

%%% Command: \justified
%%  Justification command, used to negate commands like: \raggedright / \raggedleft
\newcommand{\justified}{%
  \rightskip\z@skip% zero rightskip
  \leftskip\z@skip% zero leftskip
}
  
%%% Command: \zeroRoman{<counter>}
%%  Converts <counter> to large caps Roman numerals
%%  Returns zero if <counter> is zero
\newcommand{\zeroRoman}[1]{% 0 + \Roman
  \ifcase\value{#1}\relax 0\else%
  \Roman{#1}\fi}%
  
%%% Command: \zeroroman{<counter>}
%%  Converts <counter> to small caps roman numerals
%%  Returns zero if <counter> is zero
\newcommand{\zeroroman}[1]{% 0 + \roman
  \ifcase\value{#1}\relax 0\else%
  \roman{#1}\fi}%

%%% Command: \leadzero{<counter>}
%%  Pads a number with zeros on the left for 1-9, -> 01-09
\newcommand{\leadzero}[1]{%
  \ifleadzero%
    \ifnum \createsectioningnumber{#1} < 10
      0%
    \fi%
  \fi%
}

%%%
%   Package commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Command: \ObsoleteWarning[<obsoletion definition of old command>]{<obsolete command>}{<new option(s)>}
%%  Outputs the warning: "Command \<obsolete command> is [<obsoletion definition of old command>], use <new option(s)> instead"
\newcommand{\ObsoleteWarning}[3][obsolete]{%
  \ClassWarning{TUeStyle}{%
    Command \@backslashchar#2 is #1,\MessageBreak
    use #3 instead%
  }{}%
}

%%% Command: \if\getcondition{<if-name>}
%%  Usage:  \if\getcondition{<name>} "true" \else "false" \fi
%%          where \if<name> is declared by \newif\if<name>
\newcommand*{\getcondition}[1]{%
  T\expandafter
  \ifx\csname if#1\endcsname\iftrue
    \expandafter T%
  \else
    \expandafter F%
  \fi
}

%%% Command: \if\instring{<item>}{<string>}
%%  Checks if <string> contains <item>
\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}
    
%%% Environment: \switchif[<value in environment>]{<switch name>}
%%  Switches <switch name>'s value to its opposite inside of the environment,
%%  or to <value in environment> in specified
\newenvironment{switchif}[2][\@empty]{%
	\if\getcondition{#2}
	  \@switchif[#1]{#2}{false}{true}
	\else
	  \@switchif[#1]{#2}{true}{false}
	\fi
}{%
	\global\temporaryswitch@Temp
}

        \newcommand{\@switchif}[4][\@empty]{%
          \ifx\@empty#1\relax
            \expandafter\global\csname #2#3\endcsname
          \else
            \expandafter\global\csname #2#1\endcsname
          \fi
          \def\temporaryswitch@Temp{\csname #2#4\endcsname}
        }

%%% command \newvariable{<variable>}{<value>}
%%  defines commands for getting and setting a variable
%%    SET : \<variable>{<value>}
%%    GET : \the<variable>
\newcommand{\newvariable}[2]{%
  \ifexists{the#1}{%
    \ClassError{Tuestyle}{Variable #1 already defined, try \string\renewvariable}{}
  }{
    \@namedef{#1}##1{\@namedef{the#1}{##1}}
    \@nameuse{#1}{#2}
  }
}

%%% command \renewvariable{<variable>}{<value>}
%%  redefines commands for getting and setting a variable
%%    SET : \<variable>{<value>}
%%    GET : \the<variable>
\newcommand{\renewvariable}[2]{%
  \ifexists{the#1}{%
    \@namedef{#1}##1{\@namedef{the#1}{##1}}
    \@nameuse{#1}{#2}
  }{
    \ClassError{Tuestyle}{Variable #1 not yet defined}{}
  }
}

%%% Command: \ifexists{<commandname>}{<on true>}{<on false>}
%%  Checks if \<commandname> exists an executes:
%%    <on true>   on true
%%    <on false>  on false
\newcommand{\ifexists}[1]{
  \ifcsname #1\endcsname
    \expandafter\@firstoftwo%
  \else%
    \expandafter\@secondoftwo%
  \fi%
}

%%% Command: \ifnumber{<value>}{<on true>}{<on false>}
%%  check if <value> is a number
%%  true on <value>=""
\def\ifnumber#1{%
  \afterassignment\get@args\count@=0#1\hfuzz#1\hfuzz}
\def\get@args#1\hfuzz#2\hfuzz{%
  \if\relax\detokenize{#1}\relax
    \expandafter\@firstoftwo
  \else
    \expandafter\@secondoftwo
  \fi
}


%%% Command: \printisbn<13-17 characters>\endprintbsn
%%  Prints a bsn with a barcode underneath
\def\printisbn#1#2#3#4#5#6#7#8#9{%
  \def\@printisbn##1##2##3##4{%
  \ifnumber{#1} {\printisbnAddToString#1} {}% 01
  \ifnumber{#2} {\printisbnAddToString#2} {}% 02
  \ifnumber{#3} {\printisbnAddToString#3} {}% 03
  \ifnumber{#4} {\printisbnAddToString#4} {}% 04
  \ifnumber{#5} {\printisbnAddToString#5} {}% 05
  \ifnumber{#6} {\printisbnAddToString#6} {}% 06
  \ifnumber{#7} {\printisbnAddToString#7} {}% 07
  \ifnumber{#8} {\printisbnAddToString#8} {}% 08
  \ifnumber{#9} {\printisbnAddToString#9} {}% 09
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
  \@ifnextchar\endprintbsn{\@@@printisbn}{\@@printisbn}%
  }%
  \@printisbn%
}

        \def\endprintbsn{}

        \def\@@@@printisbn#1{%
            \parbox{4cm}{\begin{center}%
            \makebox[4cm][c]{\small ISBN\,#1}\\[.1cm]
            \expandafter\barcode\isbnTempNumberSum%
            \end{center}}
        }

        \def\printisbnAddToString#1{%
          \edef\isbnTempNumberSum{\isbnTempNumberSum#1}%
          \edef\isbnTempNumberSum{\isbnTempNumberSum}%
        }

        \def\isbnTempNumberSum{}

        \def\barcode#1#2#3#4#5#6#7{%
          \begingroup%
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
            \def\bcR##1##2##3##4##5##6{\R##1\R##2\R##3\R##4\R##5\R##6\11\01\11\09\stack{}{\vphantom{1}\textgreater}%
          \endgroup}%
          \stack{\09}#1\11\01\11\L#2%
          \ifcase#1\L#3\L#4\L#5\L#6\L#7\or\L#3\G#4\L#5\G#6\G#7%
            \or\L#3\G#4\G#5\L#6\G#7\or\L#3\G#4\G#5\G#6\L#7%
            \or\G#3\L#4\L#5\G#6\G#7\or\G#3\G#4\L#5\L#6\G#7%
            \or\G#3\G#4\G#5\L#6\L#7\or\G#3\L#4\G#5\L#6\G#7%
            \or\G#3\L#4\G#5\G#6\L#7\or\G#3\G#4\L#5\G#6\L#7%
          \fi\01\11\01\11\01\bcR}
         
%%% Command:  \copyable{<content>}
%%  Outputs its <content> regularly
%%  But returns the LaTeX source on selection         
\newcommand*{\copyable}[1]{%
  \BeginAccSupp{%
    ActualText=\detokenize{#1},%
    method=escape,
  }%
  #1%
  \EndAccSupp{}%
}

%%% Command:  \unselectable[<selection-alternative>]{<content>}
%%  Outputs its <content> regularly
%%  But returns nothing on selection, or the optional <selection-alternative> when specified   
\newcommand*{\unselectable}[2][\@empty]{%
  \BeginAccSupp{%
    ActualText={#1},%
    method=escape,
  }%
  #2%
  \EndAccSupp{}%
}

%%% Command:  \cf[ <display math> \]
%%  Works the same as \[ <display math> \]
%%  But returns the LaTeX source on selection

%%% Command:  \cf( <inline math>  \)
%%  Works the same as \( <inline math>  \)
%%  But returns the LaTeX source on selection
\protected\def\cf{\@ifnextchar[\@copymathDisplay\@copymathInline}
        \def\@copymathDisplay[#1\]{\copyable{\[#1\]}}
        \def\@copymathInline(#1\){\copyable{\(#1\)}}

%%% Environment: onecolarea{<content at begin>}{<content after>}
%%  A temporary one column area with:
%%    <content at begin>  at beginning if twocolumn is used
%%    <content after>     after the environment if twocolumn is used
\newenvironment{onecolarea}[2]{%
	\if@twocolumn
	  \@restonecoltrue\onecolumn
	\else
	  \@restonecolfalse#1%
	\fi
  \def\onecolarea@temp{#2}
}{%
	\if@restonecol\twocolumn\else\onecolarea@temp\fi
}

%%% Command: \writeto{<filename>}{<content>}
%%  Writes <content> to a file: <filename>
%%  Obeys linebreaks
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
%%  correctly sets the font size baselineskip and parskip
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

%%%	command \setnewlengthifnone{\<name>}{<value>}
%%	sets length \<name> to <value> if the length \<name> doesn't exist yet
\def\setnewlengthifnone#1#2{
  \@ifundefined{\expandafter\@gobble\string#1}{
    \newlength{#1}
    \setlength{#1}{\dimexpr#2\relax}
  }{}
}

%%%	command \settobiggest{\<length 1 name>}{<length 2 name>}
%%	sets length \<length 1 name> to the length of the biggest the two (\<length 1 name> VS \<length 2 name>).
\newcommand{\settobiggest}[2]{%
  \ifdim #2 > #1%
    \setlength{#1}{#2}%
  \fi%
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

%%% command \providecounter{<counter>}
%%  check if a counter exists, and if it doesn't creates it
\newcommand*\providecounter[1]{
  \ifcounter{#1}{}{\newcounter{#1}}
}

%%% command \providecounter{<counter>}{<value>}
%%  check if a counter exists, and if it doesn't creates it,
%%  and sets it to <value>
\newcommand*\setnewcounter[2]{
  \providecounter{#1}
  \setcounter{#1}{#2}
}

%%% command \cs@to@str{\<command>}
%%  makes a string from a cs
%%  example: \cs@to@str\foo % => "foo"
%%  example: \expandafter\cs@to@str\csname\space foo\endcsname => " foo"
\catcode`\@=11 %
\def\cs@to@str{%
  \romannumeral\if\string\ \cs@to@str@aux@i\fi
    \expandafter\cs@to@str@aux@ii\string
}
    \long\def\cs@to@str@aux@i#1\cs@to@str@aux@ii{%
      -\number\fi\expandafter\z@
    }
    \long\def\cs@to@str@aux@ii#1{\z@}

%%%	command \letnewcolorifnone{<name>}{<value>}
%%	defines new color-variable if the color-variable <name> doesn't exist yet
%%  sets color-variable to color: <value>
\newcommand{\letnewcolorifnone}[2]{%
  \@ifundefinedcolor{#1}{\colorlet{#1}{#2}}{}}

%%% command \colorbrightness{<opacity>}
%%  takes the current color and set a new current color as (current color)!<opacity>!(white)
%%  the higher the <opacity> value, the more opaque the color
\newcommand{\colorbrightness}[1]{%
  \colorlet{mycolor}{.}\color{mycolor!#1!white}
}

%%% \textlcsc{<string>}
%%  Make <string> LowerCase Small Caps
\newcommand\textlcsc[1]{\textsc{\MakeLowercase{#1}}}

%%% \forcetextlcsc{<string>}
%%  Make <string> LowerCase Small Caps , used if the font doesn't support it
\def\forcetextlcsc{\lctrue\bgroup\obeyspaces\forcetextscaux}

%%% \forcetextsc  {<string>}
%%  Make <string>           Small Caps , used if the font doesn't support it
\def\forcetextsc{\lcfalse\bgroup\obeyspaces\forcetextscaux}

        \newif\iflc

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

%%% Environment "holdtogether"
%%  \begin{holdtogether}
%%  Environment used when a page break may absolutely not occur
\newenvironment{holdtogether}
  {\nobreak\nopagebreak[4]\penalty0\vfilneg
   \vtop\bgroup}
  {\par\xdef\tpd{\the\prevdepth}\egroup
   \prevdepth=\tpd}
        
%%% \scalefont{<scalefactor>}{<string>}
%%  Scale fontsize in string by scalefactor, keep baselineskip
\def\scalefont#1{%
    \setlength{\scalefontTempCurrentFontsize}{\f@size pt}%
    \setfontsize{#1\scalefontTempCurrentFontsize}{\baselineskip}%
}

        \newlength{\scalefontTempCurrentFontsize}

%%% TODO add comments
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

%%% TODO add comments
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
    \csname data:\string#2:#1\endcsname%
  \else
    \ClassError{Tuestyle}{data:\string#2:#1 undefined}{}
  \fi
}

%%% \getstring[<index>]\<name>
%%  prints data contained in \data:<name>:<index> as string
\def\getstring[#1]#2{
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

%%% TODO description
\newcommand\watermark[1]{#1}

\ifwatermark
  %%% \watermark
  %%  Creates tiny watermark inside the following character, intended use: \watermark{.}
  \renewcommand\watermark[1]{%
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
               (V.\space\theversionnum)\space%
              \fi%
              was created by \@author\ %
              \ifx\thecopyholder\empty\relax%
              \else%
                ,for \thecopyholder%
              \fi.%
          }%
      }}}}%
  }
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

%%% \dividelengths{\<name>}{\<name>}
%%  Divides two given lengths
\newcommand*{\dividelengths}[2]{%
  \strip@pt\dimexpr\number\numexpr\number\dimexpr#1\relax*65536/\number\dimexpr#2\relax\relax sp\relax
}

%%% command \slantedpar{<integer #lines>}{<paragraph width>}
%%  initiates parshape settings
\newcommand{\slantedpar}[3][left]{
  \setnewlength{\interval}{\@shiftratio\baselineskip}
  % Definition to hold the result calculations as strings
  \long\edef\slantedparTempHold{}
  \setcounter{slantedparTempLineNum}{0}
  \slantedparvalues{#1}{#2}{#2}{#3}
  \parshape=#2
  \slantedparTempHold 
}

    \newcounter{slantedparTempLineNum}

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
    \ifequal{#1}{left}{
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
%%  Splits sentences on \linebreak and outputs longest sentence to \longestsentence
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
        % \number primitive, will give you the underlying integer value in sp
        % 65536 sp = 1 pt

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
\textblockorigin{\layoutbleed}{\layoutbleed}

\RequirePackage{caption}% loaded after document class

\RequirePackage{csquotes}% loaded after document class
\setquotestyle{american}

\iftuefonts\relax\else
  \RequirePackage{arial}
\fi



\ifprint
  %%  colored links
  \PassOptionsToPackage{colorlinks}{hyperref}
\else
  \ifequal{\hyperstyle}{color}{
    %%  colored links
    \PassOptionsToPackage{colorlinks}{hyperref}
  }{}
\fi

\RequirePackage[hypertexnames=false]{hyperref}% Option hypertexnames=false prevents table of contents link collision with two sectioning items with same number and name






\newcommand{\calculatecolumns}[1]{
\edef\calculatecolumns@temp{\convertto{mm}{#1}}
\pgfmathtruncatemacro\calculatecolumns@result{
	\@calculatecolumns{\calculatecolumns@temp}
}%
}

        % to be used inside pgf math environment
        \newcommand{\@calculatecolumns}[1]{%%% TODO add positivity check
          ifthenelse(
          #1 < 75,
            ifthenelse(
            #1 <  6.819,
              1,                                    % DOMAIN: [0      :6.819[   -> 1
              round(\@@calculatecolumns{#1})        % DOMAIN: [6.819  :75[      -> Normal
            ),
            ifthenelse(
            #1 < 122.728,
              ifthenelse(
              #1 <= 113,
                round(\@@calculatecolumns{#1}),     % DOMAIN: [75     :113]     -> Normal
                round(\@@calculatecolumns{#1}+0.5)  % DOMAIN: ]113    :122.728[ -> Ceil
              ),
              ifthenelse(
              #1 > 135 && #1 < 136.363,
                                                    % DOMAIN: [122.728:135]     -> Floor
                round(\@@calculatecolumns{#1}+0.5), % DOMAIN: ]135    :136.363[ -> Ceil
                round(\@@calculatecolumns{#1}-0.5)  % DOMAIN: [136.363:infty)   -> Floor
              )
            )
          )%
        }

        % to be used inside pgf math environment
        \newcommand{\@@calculatecolumns}[1]{
         (11*#1/150)
        }





\ifshowframe
  \def\showframevalue{showframe}
  \def\showcropvalue{showcrop}
\else
  \def\showframevalue{}
  \def\showcropvalue{}
\fi

\setnewlength{\temp@paperwidth}{\dimexpr \temp@layoutwidth + 2\layoutbleed\relax}
\setnewlength{\temp@paperheight}{\dimexpr \temp@layoutheight + 2\layoutbleed\relax}

\RequirePackage[paperwidth=\temp@paperwidth,paperheight=\temp@paperheight,%
  \showframevalue,%
  \showcropvalue,%
]{geometry}

\ifshowframe
  \AtBeginShipout{%%% TODO fix for odd even
    \begin{fullpagetextblock}%
      \pgfsetlinewidth{.5pt}
      \ifodd\value{page}%
        \let\temp@gridleftcolumns\gridleftcolumns
        \let\temp@gridrightcolumns\gridrightcolumns
      \else
        \let\temp@gridleftcolumns\gridrightcolumns
        \let\temp@gridrightcolumns\gridleftcolumns
      \fi
      %% Page outline
      \pgfpathrectangle{\pgfpoint{0mm}{0mm}}{\pgfpoint{\temp@layoutwidth}{\temp@layoutheight}}%
      \pgfsetcolor{red}%
      \pgfusepath{stroke}%
      %% Content outline
   %   \pgfpathrectangle{\pgfpoint{0mm+\layoutbleed}{0mm+\layoutbleed}}{\pgfpoint{\temp@layoutwidth}{\temp@layoutheight}}%
   %   \pgfpathrectangle
   %     {\pgfpoint{\layoutleftmargin}
   %       {\layoutbottommargin}}
   %     {\pgfpoint{\temp@layoutwidth-\layoutleftmargin-\layoutrightmargin}
   %       {\temp@layoutheight-\layoutbottommargin-\layouttopmargin}}%
   %   \pgfsetcolor{tuepink}%
   %   \pgfusepath{stroke}%
      %% Grid
      \foreach \n in {1,...,\gridcolumns}{
        \ifnum\gridcolumns=\n
          \relax
        \else
          \pgfpathrectangle
            {\pgfpoint{\layoutleftmargin+(\n-1)*\columnsize+\gridcolumnwidth}
              {\layoutbottommargin}}
            {\pgfpoint{\gridgutterwidth}
              {\temp@layoutheight-\layoutbottommargin-\layouttopmargin}}%
        \fi
      }%
      \pgfsetfillcolor{tueblue}
      \pgfsetfillopacity{0.05}
      \pgfsetstrokecolor{tueblue}
      \pgfusepath{stroke,fill}
      \foreach \n in {1,...,\gridcolumns}{
        \pgfpathrectangle
          {\pgfpoint{\layoutleftmargin+(\n-1)*\columnsize}
            {\layoutbottommargin}}
          {\pgfpoint{\gridcolumnwidth}
            {\temp@layoutheight-\layoutbottommargin-\layouttopmargin}}%
      }%
      \pgfsetfillcolor{tuered}
      \pgfsetfillopacity{0.05}
      \pgfsetstrokecolor{tuered}
      \pgfusepath{stroke,fill}
      %%
      %% Left outline
      \ifnum\temp@gridleftcolumns>0
        \pgfpathrectangle
          {\pgfpoint{\layoutleftmargin}
            {\layoutbottommargin-\footskipvalue}}
          {\pgfpoint{\temp@gridleftcolumns\columnsize-\gridgutterwidth}
            {\temp@layoutheight-\layoutbottommargin+\footskipvalue-\layouttopmargin+\headheight+\headfootsep}}%
        \pgfsetstrokecolor{black}
        \pgfsetfillcolor{tuered}
        \pgfsetfillopacity{0.05}
        \pgfusepath{stroke,fill}
      \fi
      %%
      %% Center outline
      \pgfpathrectangle
        {\pgfpoint{\layoutleftmargin+\temp@gridleftcolumns\columnsize}
          {\layoutbottommargin-\footskipvalue}}
        {\pgfpoint{\temp@layoutwidth-\layoutleftmargin-\layoutrightmargin-\temp@gridleftcolumns\columnsize-\temp@gridrightcolumns\columnsize}
          {\temp@layoutheight-\layoutbottommargin+\footskipvalue-\layouttopmargin+\headheight+\headfootsep}}%
      \pgfsetfillcolor{black}
      \pgfsetfillcolor{tuered}
      \pgfsetfillopacity{0.05}
      \pgfusepath{stroke,fill}
      %% Right outline
      \ifnum\temp@gridrightcolumns>0
        \pgfpathrectangle
          {\pgfpoint{\layoutleftmargin+\gridbodycolumns\columnsize+\temp@gridleftcolumns\columnsize}
            {\layoutbottommargin-\footskipvalue}}
          {\pgfpoint{\temp@layoutwidth-\layoutleftmargin-\layoutrightmargin-\gridbodycolumns\columnsize-\temp@gridleftcolumns\columnsize}
            {\temp@layoutheight-\layoutbottommargin+\footskipvalue-\layouttopmargin+\headheight+\headfootsep}}%
        \pgfsetfillcolor{black}
        \pgfsetfillcolor{tuered}
        \pgfsetfillopacity{0.05}
        \pgfusepath{stroke,fill}
      \fi
      %% Footer outline
      \pgfpathrectangle
        {\pgfpoint{\layoutleftmargin+\temp@gridleftcolumns\columnsize}
          {\layoutbottommargin-\footskipvalue}}
        {\pgfpoint{\temp@layoutwidth-\layoutleftmargin-\layoutrightmargin-\temp@gridleftcolumns\columnsize-\temp@gridrightcolumns\columnsize}
          {\thefooterlines\baselineskip}}%
      \pgfsetfillcolor{tueblue}
      \pgfsetfillopacity{0.05}
      \pgfsetstrokecolor{black}
      \pgfusepath{stroke,fill}
      %% Header outline
      \pgfpathrectangle
        {\pgfpoint{\layoutleftmargin+\temp@gridleftcolumns\columnsize}
          {\temp@layoutheight-\layouttopmargin+\headsep}}
        {\pgfpoint{\temp@layoutwidth-\layoutleftmargin-\layoutrightmargin-\temp@gridleftcolumns\columnsize-\temp@gridrightcolumns\columnsize}
          {\headheight}}%
      \pgfsetfillcolor{tueblue}
      \pgfsetfillopacity{0.05}
      \pgfsetstrokecolor{black}
      \pgfusepath{stroke,fill}
    \end{fullpagetextblock}
  }
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

\ifrefcheck
  \AtBeginDocument{
    \RequirePackage{refcheck}% to be loaded after »amsmath« and »hyperref«
  }
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

\def\inner@seccntformat#1{\@ifundefinedcolor{colornumsec}{}{\color{colornumsec}}\csname the#1\endcsname}

\ifruninsec
  \def\gridleftcolumns{2}
  \def\default@seccntformat#1{\llap{\protect\makebox[2\columnsize][l]{\inner@seccntformat{#1}}}}
\else
  \def\default@seccntformat#1{\inner@seccntformat{#1}\quad}
\fi

%%% TODO move
    \def\@seccntformat#1{\@ifundefined{#1@cntformat}%
   {\default@seccntformat{#1}}%    default
   {\csname #1@cntformat\endcsname}}% enable indiv. control
% example usage:
%\newcommand\section@cntformat{\thesection\quad} 

\ifleftch
  \def\gridleftcolumns{2}
\fi

%%%
%   Grid
%%%
\AtBeginDocument{
  \begingroup
    \def\sentencedelimi{\break}
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
  \setnewlengthifnone{\footskipvalue}{\thefooterlines\baselineskip + \headfootsep}
  \setnewlengthifnone{\layoutbottommargin}{15.75mm+\footskipvalue} % 15.75mm
}

\setnewlength{\headfootsep}{3\baselineskip}

  \setnewlengthifnone{\headsepvalue}{\headfootsep}
  \setnewlengthifnone{\layoutleftmargin}{15mm}
  \setnewlengthifnone{\layoutrightmargin}{15mm}
  \setnewlengthifnone{\layouttopmargin}{20.25mm+\headheight+\headsepvalue} % 20.25mm
  \setnewlengthifnone{\marginparL}{\columnsep}
  \setnewlengthifnone{\marginparR}{\layoutrightmargin}


\setnewlength{\gridgutterwidth}{3.853mm}
\setlength{\columnsep}{\gridgutterwidth}



\ifexists{gridcolumns}{
    \ifnum \gridcolumns < 0
      \PackageError{TUeStyle}{\string\gridcolumns\ can't be a negative number}{}%
    \fi
}{
  \calculatecolumns{\dimexpr\temp@layoutwidth-\layoutleftmargin-\layoutrightmargin\relax}
  \let\gridcolumns\calculatecolumns@result
}

\ifexists{gridleftcolumns}{
    \ifnum \gridleftcolumns < 0
      \PackageError{TUeStyle}{\string\gridleftcolumns\ can't be a negative number}{}%
    \fi
}{
  \def\gridleftcolumns{1}
}

\ifexists{gridrightcolumns}{
    \ifnum \gridrightcolumns < 0
      \PackageError{TUeStyle}{\string\gridrightcolumns\ can't be a negative number}{}%
    \fi
}{
  \def\gridrightcolumns{2}
}


\def\gridbodycolumns{\numexpr\gridcolumns-\gridleftcolumns-\gridrightcolumns\relax}
    %% check if the number of columns is valid
    \ifnum \gridbodycolumns < 1
      \PackageError{TUeStyle}{There are 0 or less body columns. Try defining less left/right-columns}{}%
    \fi

\setnewlength{\gridcolumnwidth}{\dimexpr(\temp@layoutwidth - \layoutleftmargin - \layoutrightmargin + \gridgutterwidth) / \gridcolumns \relax}
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
\newlength{\columnsize}
\setlength{\columnsize}{\dimexpr \gridcolumnwidth + \gridgutterwidth}

%%% Tab size
\newlength{\tabsize}
\setlength{\tabsize}{\dimexpr .5\columnsize}

%%% Textpos grid intervals
\setlength{\TPHorizModule}{\columnsize}
\setlength{\TPVertModule}{\columnsize}

\newcommand{\showtab}[1][1]{%
  \Repeat{#1}{%
    \crule[tuered]{\dimexpr \tabsize-\gridgutterwidth}{5pt}%
    \crule[tueblue]{\gridgutterwidth}{5pt}%
  }%
}

\newcommand{\showcolumn}[1][1]{%
  \Repeat{#1}{%
    \crule[tuered]{\gridcolumnwidth}{5pt}%
    \crule[tueblue]{\gridgutterwidth}{5pt}%
  }%
}

\ifruninsec
  \setnewlength{\chaptershift}{2\columnsize}
\else
  \ifleftch
    \setnewlength{\chaptershift}{2\columnsize}
  \else
    \setnewlength{\chaptershift}{0pt}
  \fi
\fi


%%% TODO move
\def\@title{}% Set default title TODO add warning
\author{}\setcounter{author@sum}{-1}% Set default author and reset counter TODO add warning

\AtBeginDocument{
  \ifnum \value{author@sum} < 0
    \ClassWarningNoLine{TUeStyle}{Consider adding author(s) to your document}{}
  \fi
  \ifequal{\@title}{}{
    \ClassWarningNoLine{TUeStyle}{Consider adding a title to your document}{}
  }{}
}

%%%
%   Layout
%%%
\newcommand{\resethfwidth}{\f@nch@setoffs}%\resethfwidth which calls the fancyhdr macro for defining the header and footer widths.


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
    \@localconvertpagenumbering{arabic}% local pagenumbering arabic because otherwise \getpagerefnumber might fail on e.g. roman numerals
    \expandafter\ifodd\getpagerefnumber{pageOddEven:\theoddevencount}%
      #1%
    \else%
      #2%
    \fi%
}

%%% TODO move
%%  Changed definition of the global \pagenumbering{<type>}
\def\@localconvertpagenumbering#1{
%\global\c@page\@ne %don't reset pagecounter
\def\thepage{\csname @#1\endcsname \c@page}
}

%%% TODO move
\storeold{\@outputpage}
\gdef\@oddevengeometry{}% Initialize \@oddevengeometry
\def\oddevengeometry#1#2{%
  \def\@outputpage{\expandafter\@oddevengeometry\old@outputpage}% Execute our @thisgeometry routine before the original @outputpage
  \gdef\@oddevengeometry{% Create @thisgeometry to store if statement and geometry options
  \ifodd\c@page\relax% Doesn't use \ifoddpage because it takes place just before the outputpage routine, this would place the label on the previous page
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

\AtBeginDocument{
  \global\addtolength{\frameright}{\layoutbleed}
  \global\addtolength{\frameleft}{\layoutbleed}
  \global\addtolength{\layoutrightmargin}{\layoutbleed}
  \global\addtolength{\layoutleftmargin}{\layoutbleed}
  \global\addtolength{\layouttopmargin}{\layoutbleed}
  \global\addtolength{\layoutbottommargin}{\layoutbleed}
  \global\addtolength{\@tocleftspace}{\layoutbleed}
  \global\addtolength{\@toctopspace}{\layoutbleed}
}

\newlength{\marginparsepvalue}
\newlength{\marginparwidthvalue}
\newlength{\rightmargincalculated}

\newcommand{\calculatelayout}{
  \begingroup

  \global\setlength{\marginparsepvalue}{\marginparL}
  \global\setlength{\marginparwidthvalue}{\dimexpr \frameright - \marginparL - \marginparR - \layoutbleed \relax}
  \global\setlength{\rightmargincalculated}{\dimexpr \layoutrightmargin + \marginparL + \marginparwidth \relax}
  
      \global\edef\TUE@GeometryOptionsRightSideGENERAL{%
        right           = \frameright,%           Next to margin
        marginparsep    = \marginparsepvalue,%
        marginparwidth  = \marginparwidthvalue,%
      }
      
      \global\edef\TUE@GeometryOptionsLeftSideGENERAL{%
        left            = \frameleft,%
      }

      \global\edef\TUE@GeometryOptionsTopSideGENERAL{%
        top             = \layouttopmargin,%
      }
      
  \global\edef\TUE@GeometryOptionsBASIC{% Basic values which stay the same for all pages except the titlepage
    bottom          = \layoutbottommargin,%
    footskip        = \footskipvalue,%
    headsep         = \headsepvalue,%
    bindingoffset   = 0cm,%
    headheight      = 16pt,%
    \asymmetricvalue,%
  }
  
      \global\edef\TUE@GeometryOptionsGENERAL{%
        \TUE@GeometryOptionsBASIC,%
        \TUE@GeometryOptionsTopSideGENERAL,%
        \TUE@GeometryOptionsRightSideGENERAL,%
        \TUE@GeometryOptionsLeftSideGENERAL,%
      }
      
  %%% General geometry twoside
  \global\edef\TUE@GeometryOptionsTwosideGENERAL{%
    \TUE@GeometryOptionsGENERAL,%
    twoside=true,%    
  }
  
  %%% General geometry oneside
  \global\edef\TUE@GeometryOptionsOnesideGENERAL{%
    \TUE@GeometryOptionsGENERAL,%
    twoside=false,%    
  }
  
      \global\edef\TUE@GeometryOptionsLefSideCONTENT{%
        left=\@tocleftspace,%
      }
      
      \global\edef\TUE@GeometryOptionsTopSideCONTENT{%
        top=\@toctopspace,%
      }
      
      \global\edef\TUE@GeometryOptionsCONTENT{%
        \TUE@GeometryOptionsBASIC,%
        \TUE@GeometryOptionsTopSideCONTENT,%
        \TUE@GeometryOptionsLefSideCONTENT,%
        marginparsep    = 0pt,%
        marginparwidth  = 0pt,%
        twoside=false,%
      }
  
  %%% Even content geometry
  \global\edef\TUE@GeometryOptionsOddCONTENT{%
    \TUE@GeometryOptionsCONTENT,%
    right           = \frameright,%
  }
  
  \iftwosided
    %%% Odd content geometry (twoside)
    \global\edef\TUE@GeometryOptionsEvenCONTENT{%
      \TUE@GeometryOptionsCONTENT,%
      right           = \frameleft,%
    }
  \else
    %%% Odd content geometry (oneside)
    \global\edef\TUE@GeometryOptionsEvenCONTENT{%
      \TUE@GeometryOptionsCONTENT,%
      right           = \frameright,%
    }
  \fi
  
      \global\edef\TUE@GeometryOptionsLefSideFULL{%
        left=\layoutleftmargin,%
      }
      
      \global\edef\TUE@GeometryOptionsFULL{%
        \TUE@GeometryOptionsBASIC,%
        \TUE@GeometryOptionsTopSideGENERAL,%
        \TUE@GeometryOptionsLefSideFULL,%
        marginparsep    = 0pt,%
        marginparwidth  = 0pt,%
        twoside=false,%
      }
  
  \iftwosided
    %%% Odd content geometry (twoside)
    \global\edef\TUE@GeometryOptionsOddFULL{%
      \TUE@GeometryOptionsFULL,%
      right           = \frameleft,%
    }
  \else
    %%% Odd content geometry (oneside)
    \global\edef\TUE@GeometryOptionsOddFULL{%
      \TUE@GeometryOptionsFULL,%
      right           = \frameright,%
    }
  \fi
  
  %%% Even content geometry
  \global\edef\TUE@GeometryOptionsEvenFULL{%
    \TUE@GeometryOptionsFULL,%
    right           = \frameright,%
  }
  
  %%% Titlepage geometry
  \global\edef\TUE@GeometryOptionsTITLEPAGE{%
    \TUE@GeometryOptionsTopSideCONTENT,%
    \TUE@GeometryOptionsLefSideCONTENT,%
    bottom=\dimexpr\layoutbleed+6.75mm\relax,%
    right=\layoutrightmargin,%
    \showframevalue,%
    \showcropvalue,%
    headheight=0pt,%
    headsep=0pt,%
    footskip=15.75mm,%
    marginparsep    = 0pt,%
    marginparwidth  = 0pt,%
    twoside=false,%
  }
  
  \endgroup
}

\newcommand{\initializelayout}{
  \normalgeometry
  \disablepageskip
  \calculatelayout
}

\newcommand{\finalizelayout}{
  \enablepageskip
  \resethf
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

\let\restoregeometry\resetlayout% To avoid people using restoregeometry from the geometry package

\def\setoddcontentlayout{
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \relax\fi
  
  \initializelayout
  \ifodd\c@page\relax% Use c@page to keep page empty
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsOddCONTENT}
  \else
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsEvenCONTENT}
  \fi
  \finalizelayout
  \iftwosided
    \oddevengeometry{\TUE@GeometryOptionsOddCONTENT}{\TUE@GeometryOptionsEvenCONTENT}
  \fi
}

\newcommand{\setfulloddlayout}{
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \relax\fi
  
  \initializelayout
  \ifoddpage{
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsOddFULL}
  }{
    \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsEvenFULL}
  }
  \finalizelayout
  \ifodd\c@page% Use c@page to keep page empty
    \setnewlength{\titlepagecontentright}{\frameright}
  \else
    \setnewlength{\titlepagecontentright}{\frameleft}
  \fi
}

\newcommand{\settitlelayout}{
  \initializelayout
  \expandafter\newgeometry\expandafter{\TUE@GeometryOptionsTITLEPAGE}
  \finalizelayout
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
  \newvariable{pricelabel}{Prijs}
  \newvariable{copyrightnotice}{Exclusief te gebruiken door de bedoelde ontvanger.\\
                                Niets van de inhoud mag worden vermenigvuldigd, openbaar gemaakt, of in de handel gebracht.}
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
  \newvariable{pricelabel}{Price}
  \newvariable{copyrightnotice}{To be used exclusively by intended recipient.\\
                                Nothing of its content may be duplicated, published or distributed in any way, shape or form.}
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
  \renewcommand{\sfdefault}{ua1}% TODO load TUE font family
\else
  \renewcommand{\sfdefault}{ua1}
\fi
\renewcommand{\rmdefault}{lmr}
\renewcommand{\ttdefault}{pcr}
\renewcommand\familydefault{\sfdefault}

\newcommand{\titlefamilydefault}{\sffamily}
\newcommand{\bodyfamilydefault}{\sffamily}

\iftuefonts\relax\else
  \sbox0{\sffamily X}% Force loading the .fd file (into a unused box)
  \DeclareFontShape{T1}{ua1}{sb}{n}{ <-> ua1b8t}{}  % map semi bold to bold
  \DeclareFontShape{T1}{ua1}{sb}{it}{ <-> ua1bi8t}{}% map semi bold italic to bold italic
\fi

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

%%% Store font measurements
\newlength{\bodytextdepth}
\settodepth{\bodytextdepth}{ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890}

\newlength{\bodytextheight}
\settoheight{\bodytextheight}{ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890}



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
  \letnewcolorifnone{colorbody}{black}
  \letnewcolorifnone{colormain}{tuered}
  \letnewcolorifnone{coloraccent}{tuedarkblue}
  \letnewcolorifnone{colorextra}{tuecyan}
  \letnewcolorifnone{colorhighlight}{colormain!20!white}
  \letnewcolorifnone{colorwhite}{white}
  \letnewcolorifnone{colorgray}{colorbody!50}
  \letnewcolorifnone{colorlightgray}{colorgray!12.5}
  \letnewcolorifnone{colorpayoff}{tuedarkblue}
  \letnewcolorifnone{coloraxis}{tuered}
  \letnewcolorifnone{colorbackground}{white}

  %%% body colors
  \iffadehf
    \letnewcolorifnone{hfcolor}{colorgray}
  \else
    \letnewcolorifnone{hfcolor}{colorbody}
  \fi
  \letnewcolorifnone{colorpromotional}{colorbody}
  \letnewcolorifnone{colorcaption}{colorbody}
  \letnewcolorifnone{colornote}{colorbody}

  \ifcoloredsectioning
    %%% heading colors
    \letnewcolorifnone{colorheading}{colormain}
    \letnewcolorifnone{colorsubheading}{colorheading}
    % colornumsec, if not defined -> heading color
  \else
    %%% heading colors
    \letnewcolorifnone{colorheading}{colorbody}
    \letnewcolorifnone{colorsubheading}{colorbody}
  \fi

  \ifcoloredtext
    %%% text colors
    \letnewcolorifnone{colorintro}{coloraccent}
    \letnewcolorifnone{colorquote}{coloraccent}
    \letnewcolorifnone{colorinfo}{coloraccent}
    \letnewcolorifnone{colorlabel}{colormain}
    \letnewcolorifnone{colorlink}{colorhighlight}
  \else
    %%% text colors
    \letnewcolorifnone{colorintro}{colorbody}
    \letnewcolorifnone{colorquote}{colorbody}
    \letnewcolorifnone{colorinfo}{colorbody}
    \letnewcolorifnone{colorlabel}{colormain}
    \letnewcolorifnone{colorlink}{colorgray}
  \fi
  
  \letnewcolorifnone{colorquoteaccent}{colorquote!40!white}

  %%% element colors
  \letnewcolorifnone{tablehighlight}{colormain}
  \letnewcolorifnone{tablerule}{tablehighlight}
  \letnewcolorifnone{tablewhite}{colorwhite}
  \letnewcolorifnone{tableblack}{colorbody}
  \letnewcolorifnone{tableodd}{colorlightgray}
  \letnewcolorifnone{tableeven}{colorwhite}
  %
  \letnewcolorifnone{linkcolorhyper}{colormain}
  \letnewcolorifnone{anchorcolorhyper}{colormain}
  \letnewcolorifnone{filecolorhyper}{colormain}
  \letnewcolorifnone{runcolorhyper}{colormain}
  \letnewcolorifnone{menucolorhyper}{colormain}
  \letnewcolorifnone{citecolorhyper}{colorextra}
  \letnewcolorifnone{urlcolorhyper}{coloraccent}
  %
  \letnewcolorifnone{colorrule}{colormain}
  %
  \letnewcolorifnone{notescolor}{colormain}
  %
  \letnewcolorifnone{colorfootrule}{colormain}
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

\renewcommand \tiny       {\useclassFontSize{tiny}}
\renewcommand \scriptsize {\useclassFontSize{scriptsize}}
\renewcommand \large      {\useclassFontSize{articleHeadviii}}
\renewcommand \Large      {\useclassFontSize{articleHeadviihalf}}
\renewcommand \LARGE      {\useclassFontSize{articleHeadvii}}
\renewcommand \huge       {\useclassFontSize{articleHeadvi}}
\renewcommand \Huge       {\useclassFontSize{articleHeadv}}
\newcommand   \HUGE       {\useclassFontSize{articleHeadiv}}


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
  \styling@@body%
  \leavevmode\color{colorbody}%
}

\def\styling@@body{%
  \normalsize%
	\fontdefault\bodyfamilydefault%
  \color{colorbody}%
}

% footer text
\def\styling@headerfooter{%
  \small%
	\fontdefault\bodyfamilydefault%
  \leavevmode\color{hfcolor}%
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
  \ifequal{#2}{heading}{%
    \ifequal{#1}{-4}{\styling@headinghuge}%
    {\ifequal{#1}{-3}{\styling@headingLARGE}%
    {\ifequal{#1}{-2}{\styling@headingLarge}%
    {\ifequal{#1}{-1}{\styling@headingpart}%
    {\ifequal{#1}{0}{\styling@headingchapter}%
    {\ifequal{#1}{1}{\styling@headingsection}%
    {\ifequal{#1}{2}{\styling@headingsubsection}%
    {\ifequal{#1}{3}{\styling@headingsubsubsection}%
    {\ifequal{#1}{4}{\styling@headingparagraph}%
    {\ifequal{#1}{5}{\styling@headingsubparagraph}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}}}}}}}}}%
  }{\ifequal{#2}{headerfooter}{%
    \styling@headerfooter%
  }{\ifequal{#2}{intro}{%
    \ifequal{#1}{1}{\styling@introlarge}%
    {\ifequal{#1}{2}{\styling@intronormal}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\ifequal{#2}{body}{%
    \ifequal{#1}{1}{\styling@body}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{promotional}{%
    \ifequal{#1}{1}{\styling@promotional}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{promotional-heading}{%
    \ifequal{#1}{1}{\styling@promotionalheading}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{quote}{%
    \ifequal{#1}{1}{\styling@quoteLarge}%
    {\ifequal{#1}{2}{\styling@quotelarge}%
    {\ifequal{#1}{3}{\styling@quotenormal}%
    {\ifequal{#1}{4}{\styling@quotesmall}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}}}%
  }{\ifequal{#2}{accent}{%
    \ifequal{#1}{1}{\styling@accent}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{info}{%
    \ifequal{#1}{1}{\styling@info}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{caption}{%
    \ifequal{#1}{1}{\styling@caption}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{note}{%
    \ifequal{#1}{1}{\styling@note}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }{\ifequal{#2}{payoff}{%
    \ifequal{#1}{1}{\styling@payofflarge}%
    {\ifequal{#1}{2}{\styling@payoffnormal}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}}%
  }{\ifequal{#2}{tiny}{%
    \ifequal{#1}{1}{\styling@tiny}%
    {\ClassError{TUestyle}{Not a valid size for style <#2>: #1}}%
  }%
  }}}}}}}}}}}}%
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

\usepackage{ amssymb }

%%% TODO enable with option
\renewcommand{\labelitemi}{\scriptsize\labelstyle{$\blacksquare$}}%%% TODO add actual $bullet$ behind there
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
  \if@twocolumn\null\newpage\fi\fi\fi}
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
\setnewlength{\@Hspacing}{0.5\temp@layoutwidth}
\addtolength\@Hspacing{-1.12cm}

%%% Axis width
\setnewlength{\@axiswidth}{.2mm}

%%% Axis height
\setnewlength{\@axisheight}{\temp@layoutheight}
\addtolength\@axisheight{-\@Vspacing}

%%% Axis shift ratio
\def\@shiftratio{0.287}% 74 degree axis

%%% Axis horizontal shift
\setnewlength{\@Hshift}{\@shiftratio\temp@layoutheight}

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
\pgfmathsetlength{\@coverheight}{(\temp@layoutwidth - \@Hspacing + \@shiftratio * \@Vspacing)/(\@coverratio - \@shiftratio)}
\pgfmathsetlength{\@coverwidth}{\temp@layoutwidth - \@Hspacing + \@shiftratio * \@Vspacing + \@shiftratio * \@coverheight}
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
  \def\@testdef@temp{#3}\expandafter
  \ifx\csname#1@#2\endcsname
    \@testdef@temp
  \else
    \typeout{^^J%
      label "#2" changed:^^J%
      old:\space\csname #1@#2\endcsname^^J%
      new:\space\@testdef@temp%
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
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i i i i i i i i i i i i i i i i i i i i i i
% i i i ...

\def\shapedraggedright{%
\let\\\@centercr\@rightskip \z@ plus\linewidth \rightskip\@rightskip
\leftskip\z@skip
\parindent\z@}


%%%	Redefine cleardoublepage to also work with the "oneside" option
\def\cleardoublepage{\clearpage\ifodd\c@page\else
    \null\newpage\if@twocolumn\null\newpage\fi\fi}

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
\newcommand{\includegraphics}[2][\@empty]{%
	\ifx\@empty#1%
		\oldincludegraphics[width=\maxwidth]{#2}%
	\else%
		\oldincludegraphics[#1]{#2}%
	\fi%
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
\newvariable{price}{}

\newcommand{\isbn}[1]{\def\theisbn{\printisbn#1\endprintbsn}}
\def\theisbn{}

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
	\newvariable{bmt} {Biomedical Engineering}
  \newvariable{bwk} {Built Environment}
  \newvariable{ele} {Electrical Engineering}
  \newvariable{id}  {Industrial Design}
  \newvariable{tm}  {Industrial Engineering \& Innovation Sciences}
  \newvariable{chem}{Chemical Engineering and Chemistry}
  \newvariable{phys}{Applied Physics}
  \newvariable{wtb} {Mechanical Engineering}
  \newvariable{win} {Mathematics and Computer Science}
\fi

\newcommand{\administrativeunitswitch}[1]{
  \ifequal{#1}{}{
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
  linktoc=all,
  breaklinks=true,
  bookmarksnumbered=true,
}

\def\linehypersetup{
  \hypersetup{
    linkbordercolor={linkcolorhyper},
    citebordercolor={citecolorhyper},
    urlbordercolor={urlcolorhyper},
    filebordercolor={filecolorhyper},
    runbordercolor={runcolorhyper},
    menubordercolor={menucolorhyper},
    anchorcolor={anchorcolorhyper}
  }
}

\def\colorhypersetup{
  \hypersetup{
    linkcolor={linkcolorhyper},
    citecolor={citecolorhyper},
    urlcolor={urlcolorhyper},
    filecolor={filecolorhyper},
    runcolor={runcolorhyper},
    menucolor={menucolorhyper},
    anchorcolor={anchorcolorhyper}
  }
}

\ifprint
  %%  colored links
  \colorhypersetup
\else
  \ifequal{\hyperstyle}{color}{
    %%  colored links
    \colorhypersetup
  }{
    \ifequal{\hyperstyle}{border}{
      %%  links with colored border
      \linehypersetup
    }{
      \ifequal{\hyperstyle}{underline}{
        %%  links with colored underline
        \linehypersetup
        \hypersetup{pdfborderstyle={/S/U/W 1}}% Border style will be underline of width 1pt
      }{}
    }
  }
\fi

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
    \setcounter{paragraph}    {1}% Level 4, counter not used by default
  \fi
	\ifnum #1 < 5
    \setcounter{subparagraph} {1}% Level 5, counter not used by default
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
\newcommand{\axesinfobox}[2][bottom]{%
  \begingroup
  \firstheadtrue
  \setlength{\fboxsep}{0pt}
    \ifequal{#1}{top}{%
      %%% Left top column
      \setaxisposition{\@axisheight+\@axispadding}%
      \pgftext[at=\pgfpoint{\@tocleftpadding}{\@axiswidth+\axispositionY},left,bottom]{%
        \begin{minipage}[b][\dimexpr \temp@layoutheight-\axispositionY \relax]{\dimexpr \axispositionX - \@tocleftpadding -\@axispadding \relax}%
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
%   TU/e logo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\TUe@checkloadtuelogo[2]{
  \IfFileExists{#1tuelogo.pdf}{
    \def\tuelogo{\includegraphics{#1tuelogo.pdf}}
  }{#2}
}
\TUe@checkloadtuelogo             {}{
  \TUe@checkloadtuelogo           {Images/}{
    \TUe@checkloadtuelogo         {Imgs/}{
      \TUe@checkloadtuelogo       {Img/}{
        \TUe@checkloadtuelogo     {images/}{
          \TUe@checkloadtuelogo   {imgs/}{
            \TUe@checkloadtuelogo {img/}{
              \@ifpackageloaded{tikz}{}{
                \ClassWarningNoLine{TUeStyle}{Package tikz is loaded because "tuelogo.pdf" is missing. For speed reasons, consider adding tuelogo.pdf to your file directory.}
              }
              \RequirePackage{tikz} 
              \def\tuelogo{%
                \begin{tikzpicture}[y=1pt, x=1pt, yscale=-1, xscale=1, inner sep=0pt, outer sep=0pt]
                  % T
                  \path[fill=tuedarkblue] (218.5,70.9) -- (0.0,70.9) -- (0.0,121.8) -- (68.3,121.8) -- (68.3,354.3) --(133.9,354.3) -- (133.9,121.8) -- (203.9,121.8) -- (218.5,70.9);
                  % U
                  \path[fill=tuedarkblue] (357.9,355.2) .. controls (436.4,355.2) and (458.4,314.1) .. (458.4,269.6) -- (458.4,70.9) -- (396.6,70.9) -- (396.6,255.5) .. controls (396.6,286.8) and (385.1,302.8) .. (357.9,302.8) .. controls (330.7,302.8) and (319.2,286.8) .. (319.2,255.5) -- (319.2,70.9) -- (257.4,70.9) -- (257.4,269.6) .. controls (257.4,314.1) and (279.3,355.2) .. (357.9,355.2);
                  % /
                  \path[fill=tuered] (537.4,425.2) -- (659.3,0.0) -- (613.9,0.0) -- (492.0,425.2) -- (537.4,425.2);
                  % e
                  \path[fill=tuedarkblue] (759.1,237.4) -- (703.1,237.4) -- (703.1,236.7) .. controls (703.1,224.6) and (706.3,196.6) .. (731.1,196.6) .. controls (737.6,196.6) and (759.1,196.3) .. (759.1,233.4) -- (759.1,237.4)(809.4,259.2) .. controls (809.4,200.3) and (787.4,161.1) .. (731.2,161.1) .. controls (678.2,161.1) and (650.0,202.0) .. (650.0,259.2) .. controls (650.0,294.4) and (664.7,355.2) .. (740.7,355.2) .. controls (771.5,355.2) and (795.7,338.9) .. (807.3,329.5) -- (788.5,300.4) .. controls (788.5,300.4) and (769.7,319.0) .. (741.0,319.0) .. controls (714.0,319.0) and (702.6,299.5) .. (702.6,272.4) -- (809.6,272.4) -- (809.6,259.2) -- cycle;
                  % Technische Universiteit
                  \path[fill=tuedarkblue] (1939.2,89.7) -- (1926.7,89.7) .. controls (1926.7,83.1) and (1927.7,75.3) .. (1927.7,75.3) -- (1919.5,77.1) .. controls (1919.5,77.1) and (1918.7,84.9) .. (1918.7,89.7) -- (1912.2,89.7) -- (1912.2,95.6) -- (1918.7,95.6) -- (1918.7,129.8) .. controls (1918.7,134.8) and (1920.0,138.0) .. (1923.5,139.7) .. controls (1925.4,140.6) and (1927.4,141.1) .. (1930.0,141.1) .. controls (1933.5,141.1) and (1936.3,140.4) .. (1938.8,139.1) -- (1937.7,134.1) .. controls (1936.3,134.8) and (1935.0,135.1) .. (1932.8,135.1) .. controls (1927.9,135.1) and (1926.4,133.2) .. (1926.4,127.7) -- (1926.4,95.6) -- (1936.8,95.6) -- (1939.2,89.7)(1899.9,74.3) .. controls (1899.9,70.9) and (1897.2,68.2) .. (1893.8,68.2) .. controls (1890.4,68.2) and (1887.7,71.0) .. (1887.7,74.4) .. controls (1887.7,77.7) and (1890.4,80.4) .. (1893.8,80.4) .. controls (1897.2,80.4) and (1899.9,77.7) .. (1899.9,74.3)(1897.7,139.5) -- (1897.7,88.6) -- (1889.6,89.9) -- (1889.6,139.5) -- (1897.7,139.5) -- cycle(1864.3,110.0) -- (1841.5,110.0) .. controls (1841.9,99.7) and (1845.9,94.5) .. (1853.0,94.5) .. controls (1856.8,94.5) and (1860.3,96.2) .. (1862.0,98.9) .. controls (1863.5,101.3) and (1864.2,104.6) .. (1864.3,110.0)(1872.6,115.9) -- (1872.6,114.8) .. controls (1872.6,102.9) and (1871.2,98.2) .. (1866.9,93.8) .. controls (1863.5,90.3) and (1858.8,88.4) .. (1853.4,88.4) .. controls (1847.4,88.4) and (1842.5,90.6) .. (1838.5,95.3) .. controls (1834.3,100.3) and (1832.5,105.7) .. (1832.5,114.1) .. controls (1832.5,130.6) and (1840.8,140.6) .. (1854.6,140.6) .. controls (1861.0,140.6) and (1867.0,138.4) .. (1871.4,134.4) -- (1868.4,129.4) .. controls (1864.9,132.6) and (1861.0,134.1) .. (1856.2,134.1) .. controls (1851.2,134.1) and (1846.6,132.3) .. (1843.8,128.0) .. controls (1842.1,125.4) and (1841.5,121.8) .. (1841.5,117.1) -- (1841.5,115.9) -- (1872.6,115.9) -- cycle(1822.5,89.7) -- (1810.0,89.7) .. controls (1810.0,83.1) and (1811.0,75.3) .. (1811.0,75.3) -- (1802.8,77.1) .. controls (1802.8,77.1) and (1802.0,84.9) .. (1802.0,89.7) -- (1795.5,89.7) -- (1795.5,95.6) -- (1802.0,95.6) -- (1802.0,129.8) .. controls (1802.0,134.8) and (1803.3,138.0) .. (1806.8,139.7) .. controls (1808.7,140.6) and (1810.7,141.1) .. (1813.3,141.1) .. controls (1816.8,141.1) and (1819.6,140.4) .. (1822.1,139.1) -- (1821.0,134.1) .. controls (1819.6,134.8) and (1818.3,135.1) .. (1816.1,135.1) .. controls (1811.2,135.1) and (1809.7,133.2) .. (1809.7,127.7) -- (1809.7,95.6) -- (1820.1,95.6) -- (1822.5,89.7) -- cycle(1783.2,74.3) .. controls (1783.2,70.9) and (1780.5,68.2) .. (1777.1,68.2) .. controls (1773.7,68.2) and (1771.0,71.0) .. (1771.0,74.4) .. controls (1771.0,77.7) and (1773.7,80.4) .. (1777.1,80.4) .. controls (1780.5,80.4) and (1783.2,77.7) .. (1783.2,74.3)(1781.0,139.5) -- (1781.0,88.6) -- (1772.9,89.9) -- (1772.9,139.5) -- (1781.0,139.5) -- cycle(1756.9,124.7) .. controls (1756.9,117.3) and (1752.6,112.7) .. (1743.6,110.8) -- (1737.0,109.4) .. controls (1731.7,108.3) and (1729.8,106.0) .. (1729.8,102.2) .. controls (1729.8,97.3) and (1733.5,94.0) .. (1739.2,94.0) .. controls (1743.6,94.0) and (1747.3,95.5) .. (1751.7,97.6) -- (1754.6,91.8) .. controls (1750.4,89.4) and (1744.6,87.8) .. (1739.4,87.8) .. controls (1729.0,87.8) and (1721.7,94.1) .. (1721.7,103.1) .. controls (1721.7,110.0) and (1726.1,115.1) .. (1734.3,116.8) -- (1740.5,118.1) .. controls (1746.2,119.3) and (1748.7,121.8) .. (1748.7,126.3) .. controls (1748.7,131.6) and (1744.7,134.9) .. (1738.6,134.9) .. controls (1733.1,134.9) and (1727.9,133.3) .. (1722.8,130.2) -- (1719.8,136.0) .. controls (1724.9,139.1) and (1731.8,141.0) .. (1738.1,141.0) .. controls (1749.3,141.0) and (1756.9,134.4) .. (1756.9,124.7)(1714.3,88.7) .. controls (1714.3,88.7) and (1712.9,88.2) .. (1711.6,88.2) .. controls (1706.5,88.2) and (1701.2,91.4) .. (1697.6,96.5) .. controls (1697.9,92.3) and (1696.0,88.4) .. (1696.0,88.4) -- (1688.2,90.5) .. controls (1688.2,90.5) and (1689.9,93.8) .. (1689.9,101.1) -- (1689.9,139.5) -- (1697.7,139.5) -- (1697.7,108.3) .. controls (1697.7,104.2) and (1698.3,102.7) .. (1700.6,100.4) .. controls (1702.9,98.1) and (1705.9,96.8) .. (1708.9,96.8) .. controls (1709.7,96.8) and (1710.6,97.0) .. (1711.1,97.2) -- (1714.3,88.7) -- cycle(1664.6,110.0) -- (1641.8,110.0) .. controls (1642.2,99.7) and (1646.2,94.5) .. (1653.3,94.5) .. controls (1657.1,94.5) and (1660.6,96.2) .. (1662.3,98.9) .. controls (1663.8,101.3) and (1664.5,104.6) .. (1664.6,110.0)(1672.9,115.9) -- (1672.9,114.8) .. controls (1672.9,102.9) and (1671.5,98.2) .. (1667.2,93.8) .. controls (1663.8,90.3) and (1659.1,88.4) .. (1653.7,88.4) .. controls (1647.7,88.4) and (1642.8,90.6) .. (1638.8,95.3) .. controls (1634.6,100.3) and (1632.8,105.7) .. (1632.8,114.1) .. controls (1632.8,130.6) and (1641.1,140.6) .. (1654.9,140.6) .. controls (1661.3,140.6) and (1667.3,138.4) .. (1671.7,134.4) -- (1668.7,129.4) .. controls (1665.2,132.6) and (1661.3,134.1) .. (1656.5,134.1) .. controls (1651.5,134.1) and (1646.9,132.3) .. (1644.1,128.0) .. controls (1642.4,125.4) and (1641.8,121.8) .. (1641.8,117.1) -- (1641.8,115.9) -- (1672.9,115.9) -- cycle(1623.3,89.7) -- (1615.0,89.7) -- (1603.6,122.8) .. controls (1602.0,127.3) and (1601.2,131.2) .. (1601.2,131.2) -- (1601.0,131.2) .. controls (1601.0,131.2) and (1600.0,126.8) .. (1598.6,122.7) -- (1587.0,88.4) -- (1579.0,90.1) -- (1596.9,140.0) -- (1604.6,140.0) -- (1623.3,89.7) -- cycle(1568.2,74.3) .. controls (1568.2,70.9) and (1565.5,68.2) .. (1562.1,68.2) .. controls (1558.7,68.2) and (1556.0,71.0) .. (1556.0,74.4) .. controls (1556.0,77.7) and (1558.7,80.4) .. (1562.1,80.4) .. controls (1565.5,80.4) and (1568.2,77.7) .. (1568.2,74.3)(1566.0,139.5) -- (1566.0,88.6) -- (1557.9,89.9) -- (1557.9,139.5) -- (1566.0,139.5) -- cycle(1536.9,139.5) -- (1536.9,101.7) .. controls (1536.9,99.7) and (1536.5,97.7) .. (1535.7,95.9) .. controls (1533.7,91.5) and (1528.9,88.6) .. (1523.5,88.6) .. controls (1518.2,88.6) and (1513.0,91.1) .. (1507.8,96.3) .. controls (1507.8,92.2) and (1506.0,88.5) .. (1506.0,88.5) -- (1498.4,90.6) .. controls (1498.4,90.6) and (1500.3,94.0) .. (1500.3,101.1) -- (1500.3,139.5) -- (1507.9,139.5) -- (1507.9,102.4) .. controls (1511.5,98.6) and (1517.7,95.4) .. (1521.7,95.4) .. controls (1524.0,95.4) and (1526.1,96.2) .. (1527.2,97.5) .. controls (1528.6,99.2) and (1529.0,100.5) .. (1529.0,105.8) -- (1529.0,139.5) -- (1536.9,139.5) -- cycle(1479.8,119.7) -- (1479.8,70.9) -- (1471.7,70.9) -- (1471.7,118.7) .. controls (1471.7,123.3) and (1471.4,126.3) .. (1469.1,129.4) .. controls (1467.0,132.2) and (1462.7,133.7) .. (1457.0,133.7) .. controls (1448.6,133.7) and (1444.9,130.0) .. (1443.6,127.0) .. controls (1442.7,124.9) and (1442.4,120.5) .. (1442.4,117.1) -- (1442.4,70.9) -- (1434.3,70.9) -- (1434.3,120.1) .. controls (1434.3,123.1) and (1434.5,127.5) .. (1436.3,130.8) .. controls (1440.0,137.6) and (1446.0,140.7) .. (1456.6,140.7) .. controls (1464.9,140.7) and (1470.4,139.0) .. (1474.6,135.4) .. controls (1478.7,131.9) and (1479.8,128.0) .. (1479.8,119.7)(1384.5,110.0) -- (1361.7,110.0) .. controls (1362.1,99.7) and (1366.1,94.5) .. (1373.2,94.5) .. controls (1377.0,94.5) and (1380.5,96.2) .. (1382.2,98.9) .. controls (1383.7,101.3) and (1384.4,104.6) .. (1384.5,110.0)(1392.8,115.9) -- (1392.8,114.8) .. controls (1392.8,102.9) and (1391.4,98.2) .. (1387.1,93.8) .. controls (1383.7,90.3) and (1379.0,88.4) .. (1373.6,88.4) .. controls (1367.6,88.4) and (1362.7,90.6) .. (1358.7,95.3) .. controls (1354.5,100.3) and (1352.7,105.7) .. (1352.7,114.1) .. controls (1352.7,130.6) and (1361.0,140.6) .. (1374.8,140.6) .. controls (1381.2,140.6) and (1387.2,138.4) .. (1391.6,134.4) -- (1388.6,129.4) .. controls (1385.1,132.6) and (1381.2,134.1) .. (1376.4,134.1) .. controls (1371.4,134.1) and (1366.8,132.3) .. (1364.0,128.0) .. controls (1362.3,125.4) and (1361.7,121.8) .. (1361.7,117.1) -- (1361.7,115.9) -- (1392.8,115.9) -- cycle(1334.7,139.5) -- (1334.7,103.8) .. controls (1334.7,100.2) and (1334.5,98.6) .. (1333.9,96.6) .. controls (1332.5,92.0) and (1327.1,88.7) .. (1321.1,88.7) .. controls (1314.7,88.7) and (1309.0,92.4) .. (1304.5,96.6) .. controls (1304.5,96.6) and (1304.8,93.0) .. (1304.8,89.8) -- (1304.8,78.2) .. controls (1304.8,70.6) and (1303.5,66.4) .. (1303.5,66.4) -- (1295.7,67.9) .. controls (1295.7,67.9) and (1297.0,71.6) .. (1297.0,78.1) -- (1297.0,139.5) -- (1304.8,139.5) -- (1304.8,104.1) .. controls (1309.1,98.8) and (1314.5,95.7) .. (1319.3,95.7) .. controls (1321.8,95.7) and (1323.9,96.5) .. (1325.1,97.7) .. controls (1326.5,99.1) and (1327.0,101.4) .. (1327.0,105.1) -- (1327.0,139.5) -- (1334.7,139.5) -- cycle(1283.5,134.0) -- (1279.2,129.0) .. controls (1276.3,132.5) and (1272.5,134.4) .. (1268.5,134.4) .. controls (1260.5,134.4) and (1256.2,128.3) .. (1256.2,117.1) .. controls (1256.2,109.8) and (1257.1,104.3) .. (1259.0,100.8) .. controls (1260.8,97.4) and (1264.5,95.2) .. (1268.4,95.2) .. controls (1272.2,95.2) and (1274.4,96.3) .. (1277.9,99.2) -- (1282.2,93.8) .. controls (1278.6,90.8) and (1274.9,88.4) .. (1268.6,88.4) .. controls (1263.3,88.4) and (1259.0,90.3) .. (1255.1,94.2) .. controls (1250.8,98.5) and (1247.6,104.5) .. (1247.6,115.4) .. controls (1247.6,122.8) and (1249.1,128.3) .. (1252.4,133.1) .. controls (1255.9,138.1) and (1261.2,140.6) .. (1268.3,140.6) .. controls (1274.5,140.6) and (1278.9,138.7) .. (1283.5,134.0)(1234.1,124.7) .. controls (1234.1,117.3) and (1229.8,112.7) .. (1220.8,110.8) -- (1214.2,109.4) .. controls (1208.9,108.3) and (1207.0,106.0) .. (1207.0,102.2) .. controls (1207.0,97.3) and (1210.7,94.0) .. (1216.4,94.0) .. controls (1220.8,94.0) and (1224.5,95.5) .. (1228.9,97.6) -- (1231.8,91.8) .. controls (1227.6,89.4) and (1221.8,87.8) .. (1216.6,87.8) .. controls (1206.2,87.8) and (1198.9,94.1) .. (1198.9,103.1) .. controls (1198.9,110.0) and (1203.3,115.1) .. (1211.5,116.8) -- (1217.7,118.1) .. controls (1223.4,119.3) and (1225.9,121.8) .. (1225.9,126.3) .. controls (1225.9,131.6) and (1221.9,134.9) .. (1215.8,134.9) .. controls (1210.3,134.9) and (1205.1,133.3) .. (1200.0,130.2) -- (1197.0,136.0) .. controls (1202.1,139.1) and (1209.0,141.0) .. (1215.3,141.0) .. controls (1226.5,141.0) and (1234.1,134.4) .. (1234.1,124.7)(1183.2,74.3) .. controls (1183.2,70.9) and (1180.5,68.2) .. (1177.1,68.2) .. controls (1173.7,68.2) and (1171.0,71.0) .. (1171.0,74.4) .. controls (1171.0,77.7) and (1173.7,80.4) .. (1177.1,80.4) .. controls (1180.5,80.4) and (1183.2,77.7) .. (1183.2,74.3)(1181.0,139.5) -- (1181.0,88.6) -- (1172.9,89.9) -- (1172.9,139.5) -- (1181.0,139.5) -- cycle(1151.9,139.5) -- (1151.9,101.7) .. controls (1151.9,99.7) and (1151.5,97.7) .. (1150.7,95.9) .. controls (1148.7,91.5) and (1143.9,88.6) .. (1138.5,88.6) .. controls (1133.2,88.6) and (1128.0,91.1) .. (1122.8,96.3) .. controls (1122.8,92.2) and (1121.0,88.5) .. (1121.0,88.5) -- (1113.4,90.6) .. controls (1113.4,90.6) and (1115.3,94.0) .. (1115.3,101.1) -- (1115.3,139.5) -- (1122.9,139.5) -- (1122.9,102.4) .. controls (1126.5,98.6) and (1132.7,95.4) .. (1136.7,95.4) .. controls (1139.0,95.4) and (1141.1,96.2) .. (1142.2,97.5) .. controls (1143.6,99.2) and (1144.0,100.5) .. (1144.0,105.8) -- (1144.0,139.5) -- (1151.9,139.5) -- cycle(1094.3,139.5) -- (1094.3,103.8) .. controls (1094.3,100.2) and (1094.1,98.6) .. (1093.5,96.6) .. controls (1092.1,92.0) and (1086.7,88.7) .. (1080.7,88.7) .. controls (1074.3,88.7) and (1068.6,92.4) .. (1064.1,96.6) .. controls (1064.1,96.6) and (1064.4,93.0) .. (1064.4,89.8) -- (1064.4,78.2) .. controls (1064.4,70.6) and (1063.1,66.4) .. (1063.1,66.4) -- (1055.3,67.9) .. controls (1055.3,67.9) and (1056.6,71.6) .. (1056.6,78.1) -- (1056.6,139.5) -- (1064.4,139.5) -- (1064.4,104.1) .. controls (1068.7,98.8) and (1074.1,95.7) .. (1078.9,95.7) .. controls (1081.4,95.7) and (1083.5,96.5) .. (1084.7,97.7) .. controls (1086.1,99.1) and (1086.6,101.4) .. (1086.6,105.1) -- (1086.6,139.5) -- (1094.3,139.5) -- cycle(1043.1,134.0) -- (1038.8,129.0) .. controls (1035.9,132.5) and (1032.1,134.4) .. (1028.1,134.4) .. controls (1020.1,134.4) and (1015.8,128.3) .. (1015.8,117.1) .. controls (1015.8,109.8) and (1016.7,104.3) .. (1018.6,100.8) .. controls (1020.4,97.4) and (1024.1,95.2) .. (1028.0,95.2) .. controls (1031.8,95.2) and (1034.0,96.3) .. (1037.5,99.2) -- (1041.8,93.8) .. controls (1038.2,90.8) and (1034.5,88.4) .. (1028.2,88.4) .. controls (1022.9,88.4) and (1018.6,90.3) .. (1014.7,94.2) .. controls (1010.4,98.5) and (1007.2,104.5) .. (1007.2,115.4) .. controls (1007.2,122.8) and (1008.7,128.3) .. (1012.0,133.1) .. controls (1015.5,138.1) and (1020.8,140.6) .. (1027.9,140.6) .. controls (1034.1,140.6) and (1038.5,138.7) .. (1043.1,134.0)(984.9,110.0) -- (962.1,110.0) .. controls (962.5,99.7) and (966.5,94.5) .. (973.6,94.5) .. controls (977.4,94.5) and (980.9,96.2) .. (982.6,98.9) .. controls (984.1,101.3) and (984.8,104.6) .. (984.9,110.0)(993.2,115.9) -- (993.2,114.8) .. controls (993.2,102.9) and (991.8,98.2) .. (987.5,93.8) .. controls (984.1,90.3) and (979.4,88.4) .. (974.0,88.4) .. controls (968.0,88.4) and (963.1,90.6) .. (959.1,95.3) .. controls (954.9,100.3) and (953.1,105.7) .. (953.1,114.1) .. controls (953.1,130.6) and (961.4,140.6) .. (975.2,140.6) .. controls (981.6,140.6) and (987.6,138.4) .. (992.0,134.4) -- (989.0,129.4) .. controls (985.5,132.6) and (981.6,134.1) .. (976.8,134.1) .. controls (971.8,134.1) and (967.2,132.3) .. (964.4,128.0) .. controls (962.7,125.4) and (962.1,121.8) .. (962.1,117.1) -- (962.1,115.9) -- (993.2,115.9) -- cycle(951.1,70.9) -- (905.7,70.9) -- (905.7,77.8) -- (924.1,77.8) -- (924.1,139.5) -- (932.0,139.5) -- (932.0,77.8) -- (950.6,77.8) -- (951.1,70.9) -- cycle;
                  % Eindhoven
                  \path[fill=tuedarkblue] (1377.3,246.9) -- (1377.3,209.5) .. controls (1377.3,206.3) and (1377.0,204.1) .. (1376.3,202.2) .. controls (1374.7,197.8) and (1369.7,194.8) .. (1364.0,194.8) .. controls (1361.0,194.8) and (1357.5,195.6) .. (1354.8,197.0) .. controls (1352.6,198.2) and (1350.9,199.4) .. (1348.9,200.8) .. controls (1348.9,198.7) and (1348.2,196.5) .. (1347.0,194.4) -- (1335.1,197.8) .. controls (1336.3,201.2) and (1336.9,205.4) .. (1336.9,209.8) -- (1336.9,246.9) -- (1350.3,246.9) -- (1350.3,210.7) .. controls (1353.4,207.9) and (1356.9,206.1) .. (1359.6,206.1) .. controls (1363.1,206.1) and (1364.1,207.8) .. (1364.1,213.6) -- (1364.1,246.9) -- (1377.3,246.9)(1310.5,215.7) -- (1295.0,215.7) -- (1295.0,215.5) .. controls (1295.0,208.4) and (1297.9,204.4) .. (1303.0,204.4) .. controls (1305.7,204.4) and (1307.6,205.4) .. (1308.9,207.4) .. controls (1310.1,209.3) and (1310.5,211.3) .. (1310.5,215.1) -- (1310.5,215.7) -- cycle(1324.4,225.5) -- (1324.4,222.4) .. controls (1324.4,211.7) and (1322.3,204.8) .. (1317.6,200.0) .. controls (1314.3,196.6) and (1308.7,194.6) .. (1302.8,194.6) .. controls (1296.0,194.6) and (1290.9,196.8) .. (1286.7,201.5) .. controls (1282.2,206.5) and (1280.3,212.6) .. (1280.3,221.8) .. controls (1280.3,237.9) and (1289.8,248.3) .. (1304.5,248.3) .. controls (1311.7,248.3) and (1317.9,246.0) .. (1323.8,241.2) -- (1318.6,233.2) .. controls (1314.5,236.6) and (1310.2,238.3) .. (1305.6,238.3) .. controls (1298.7,238.3) and (1294.8,233.8) .. (1294.8,225.9) -- (1294.8,225.5) -- (1324.4,225.5) -- cycle(1274.8,195.7) -- (1260.8,195.7) -- (1253.9,217.2) .. controls (1252.3,222.3) and (1251.2,227.2) .. (1250.8,230.2) .. controls (1250.1,226.9) and (1248.6,221.3) .. (1247.5,217.9) -- (1240.1,194.8) -- (1226.4,196.5) -- (1245.0,246.9) -- (1256.1,246.9) -- (1274.8,195.7) -- cycle(1207.3,221.0) .. controls (1207.3,233.1) and (1204.8,238.3) .. (1199.0,238.3) .. controls (1196.4,238.3) and (1193.4,236.9) .. (1192.2,234.1) .. controls (1191.1,231.5) and (1190.5,227.1) .. (1190.5,221.2) .. controls (1190.5,216.1) and (1191.0,212.5) .. (1191.9,209.8) .. controls (1193.0,206.6) and (1195.6,204.6) .. (1198.8,204.6) .. controls (1201.2,204.6) and (1203.3,205.6) .. (1204.6,207.3) .. controls (1206.4,209.6) and (1207.3,214.1) .. (1207.3,221.0)(1221.9,221.1) .. controls (1221.9,212.8) and (1220.1,207.2) .. (1216.0,202.4) .. controls (1211.6,197.2) and (1205.9,194.7) .. (1198.6,194.7) .. controls (1184.8,194.7) and (1175.6,205.4) .. (1175.6,221.5) .. controls (1175.6,237.6) and (1184.7,248.0) .. (1198.6,248.0) .. controls (1206.5,248.0) and (1211.6,245.3) .. (1215.5,240.9) .. controls (1219.9,235.9) and (1221.9,229.9) .. (1221.9,221.1)(1162.1,246.9) -- (1162.1,211.1) .. controls (1162.1,206.2) and (1161.8,204.5) .. (1160.8,201.6) .. controls (1159.2,197.1) and (1154.0,194.3) .. (1147.5,194.3) .. controls (1142.3,194.3) and (1136.5,196.5) .. (1133.0,199.8) .. controls (1133.0,199.2) and (1133.2,197.1) .. (1133.2,195.5) -- (1133.2,185.3) .. controls (1133.2,180.4) and (1132.9,175.6) .. (1132.3,172.8) -- (1118.6,176.0) .. controls (1119.2,178.1) and (1119.6,182.9) .. (1119.6,187.7) -- (1119.6,246.9) -- (1133.2,246.9) -- (1133.2,210.2) .. controls (1136.2,207.5) and (1140.5,205.5) .. (1143.8,205.5) .. controls (1147.6,205.5) and (1149.0,207.4) .. (1149.0,212.5) -- (1149.0,246.9) -- (1162.1,246.9) -- cycle(1089.5,233.6) .. controls (1088.2,235.2) and (1085.4,236.9) .. (1082.9,236.9) .. controls (1075.9,236.9) and (1073.6,233.3) .. (1073.6,222.3) .. controls (1073.6,210.9) and (1076.2,205.9) .. (1082.2,205.9) .. controls (1084.6,205.9) and (1087.0,207.0) .. (1089.5,209.2) -- (1089.5,233.6) -- cycle(1104.5,246.9) .. controls (1103.6,244.9) and (1102.6,240.8) .. (1102.6,228.2) -- (1102.6,175.0) -- (1089.3,172.9) -- (1089.3,190.5) .. controls (1089.3,193.5) and (1089.5,197.0) .. (1089.7,198.1) .. controls (1087.2,196.1) and (1084.3,195.2) .. (1080.6,195.2) .. controls (1067.6,195.2) and (1058.7,206.2) .. (1058.7,222.2) .. controls (1058.7,238.1) and (1066.9,248.2) .. (1079.9,248.2) .. controls (1084.5,248.2) and (1088.4,246.8) .. (1091.7,243.9) .. controls (1091.9,245.3) and (1092.1,246.1) .. (1092.5,246.9) -- (1104.5,246.9) -- cycle(1044.7,246.9) -- (1044.7,209.5) .. controls (1044.7,206.3) and (1044.4,204.1) .. (1043.7,202.2) .. controls (1042.1,197.8) and (1037.1,194.8) .. (1031.4,194.8) .. controls (1028.4,194.8) and (1024.9,195.6) .. (1022.2,197.0) .. controls (1020.0,198.2) and (1018.3,199.4) .. (1016.3,200.8) .. controls (1016.3,198.7) and (1015.6,196.5) .. (1014.4,194.4) -- (1002.5,197.8) .. controls (1003.7,201.2) and (1004.3,205.4) .. (1004.3,209.8) -- (1004.3,246.9) -- (1017.7,246.9) -- (1017.7,210.7) .. controls (1020.8,207.9) and (1024.3,206.1) .. (1027.0,206.1) .. controls (1030.5,206.1) and (1031.5,207.8) .. (1031.5,213.6) -- (1031.5,246.9) -- (1044.7,246.9) -- cycle(988.9,181.6) .. controls (988.9,177.0) and (985.3,173.3) .. (980.8,173.3) .. controls (976.2,173.3) and (972.4,177.0) .. (972.4,181.6) .. controls (972.4,186.2) and (976.1,189.9) .. (980.6,189.9) .. controls (985.2,189.9) and (988.9,186.2) .. (988.9,181.6)(987.3,246.9) -- (987.3,194.5) -- (973.9,196.6) -- (973.9,246.9) -- (987.3,246.9) -- cycle(961.9,246.9) -- (961.9,234.9) -- (935.6,234.9) -- (935.6,216.3) -- (955.3,216.3) -- (955.3,204.9) -- (935.4,204.9) -- (935.4,188.8) -- (959.2,188.8) -- (961.0,177.4) -- (921.4,177.4) -- (921.4,246.9) -- (961.9,246.9) -- cycle;
                  % University of Technology
                  \path[fill=tuedarkblue] (1996.8,304.5) -- (1987.9,304.5) -- (1978.1,337.2) .. controls (1976.9,341.3) and (1975.0,347.7) .. (1975.0,347.7) -- (1974.8,347.7) .. controls (1974.8,347.7) and (1973.3,340.0) .. (1971.8,335.3) -- (1961.6,303.0) -- (1953.9,305.6) -- (1964.6,336.8) .. controls (1966.3,341.8) and (1969.0,351.5) .. (1969.6,354.7) -- (1972.8,354.2) .. controls (1970.1,364.3) and (1967.7,367.5) .. (1961.3,369.5) -- (1963.6,374.8) .. controls (1972.3,372.7) and (1976.4,366.1) .. (1979.7,356.1) -- (1996.8,304.5)(1931.5,319.9) .. controls (1931.5,326.6) and (1928.5,330.1) .. (1922.5,330.1) .. controls (1916.2,330.1) and (1912.9,326.6) .. (1912.9,320.2) .. controls (1912.9,313.3) and (1916.1,309.9) .. (1922.3,309.9) .. controls (1928.9,309.9) and (1931.5,313.1) .. (1931.5,319.9)(1949.4,308.9) -- (1944.6,304.1) .. controls (1942.2,305.7) and (1940.3,306.3) .. (1937.7,306.3) .. controls (1931.6,306.3) and (1930.1,303.5) .. (1922.5,303.5) .. controls (1911.6,303.5) and (1904.1,310.3) .. (1904.1,320.3) .. controls (1904.1,326.9) and (1908.6,332.6) .. (1915.3,334.7) .. controls (1908.5,336.8) and (1906.3,339.2) .. (1906.3,343.2) .. controls (1906.3,347.7) and (1909.8,350.4) .. (1915.7,350.4) .. controls (1917.3,350.4) and (1921.4,350.3) .. (1923.4,350.3) .. controls (1928.3,350.3) and (1931.3,350.8) .. (1933.2,352.1) .. controls (1935.0,353.3) and (1935.9,355.4) .. (1935.9,358.1) .. controls (1935.9,364.3) and (1931.5,366.8) .. (1923.8,366.8) .. controls (1919.8,366.8) and (1916.1,365.9) .. (1913.7,364.5) .. controls (1911.9,363.4) and (1910.8,361.3) .. (1910.8,358.7) .. controls (1910.8,357.1) and (1911.5,355.3) .. (1912.2,354.2) -- (1904.0,354.9) .. controls (1903.3,356.9) and (1903.0,358.4) .. (1903.0,360.2) .. controls (1903.0,367.3) and (1909.0,372.9) .. (1924.6,372.9) .. controls (1936.7,372.9) and (1944.4,368.0) .. (1944.4,357.2) .. controls (1944.4,352.9) and (1942.8,349.4) .. (1938.9,346.7) .. controls (1935.9,344.6) and (1932.7,343.9) .. (1926.9,343.9) -- (1918.9,343.9) .. controls (1916.4,343.9) and (1914.9,343.0) .. (1914.9,341.5) .. controls (1914.9,339.8) and (1917.2,338.1) .. (1923.9,335.7) .. controls (1927.5,335.7) and (1930.7,335.1) .. (1933.2,333.5) .. controls (1937.8,330.6) and (1940.6,325.4) .. (1940.6,319.8) .. controls (1940.6,316.6) and (1939.6,313.8) .. (1937.6,311.3) .. controls (1938.5,311.7) and (1939.7,311.9) .. (1941.0,311.9) .. controls (1944.0,311.9) and (1946.3,311.1) .. (1949.4,308.9)(1881.1,330.8) .. controls (1881.1,335.7) and (1880.7,338.5) .. (1879.6,341.6) .. controls (1877.9,346.4) and (1874.0,349.1) .. (1868.8,349.1) .. controls (1864.5,349.1) and (1860.5,347.1) .. (1858.7,344.1) .. controls (1856.8,341.0) and (1855.6,334.8) .. (1855.6,327.8) .. controls (1855.6,321.9) and (1856.4,317.9) .. (1858.0,314.8) .. controls (1859.7,311.5) and (1863.8,309.4) .. (1868.2,309.4) .. controls (1872.3,309.4) and (1876.7,311.4) .. (1878.8,315.8) .. controls (1880.4,319.1) and (1881.1,323.8) .. (1881.1,330.8)(1890.0,330.2) .. controls (1890.0,322.1) and (1888.5,316.2) .. (1885.4,311.7) .. controls (1882.0,306.8) and (1876.6,303.0) .. (1868.3,303.0) .. controls (1855.2,303.0) and (1847.1,312.9) .. (1847.1,329.1) .. controls (1847.1,345.5) and (1854.9,355.6) .. (1868.6,355.6) .. controls (1881.1,355.6) and (1890.0,346.8) .. (1890.0,330.2)(1835.0,354.2) -- (1833.4,349.1) .. controls (1833.4,349.1) and (1832.7,349.3) .. (1832.4,349.3) .. controls (1830.2,349.3) and (1829.6,348.2) .. (1829.6,344.3) -- (1829.6,293.4) .. controls (1829.6,285.8) and (1828.3,281.6) .. (1828.3,281.6) -- (1820.5,283.1) .. controls (1820.5,283.1) and (1821.7,286.8) .. (1821.7,293.3) -- (1821.7,346.1) .. controls (1821.7,349.7) and (1822.5,351.8) .. (1824.1,353.2) .. controls (1825.6,354.6) and (1827.6,355.3) .. (1830.0,355.3) .. controls (1832.1,355.3) and (1833.0,355.1) .. (1835.0,354.2)(1795.8,330.8) .. controls (1795.8,335.7) and (1795.4,338.5) .. (1794.3,341.6) .. controls (1792.6,346.4) and (1788.7,349.1) .. (1783.5,349.1) .. controls (1779.2,349.1) and (1775.2,347.1) .. (1773.4,344.1) .. controls (1771.5,341.0) and (1770.3,334.8) .. (1770.3,327.8) .. controls (1770.3,321.9) and (1771.1,317.9) .. (1772.7,314.8) .. controls (1774.4,311.5) and (1778.5,309.4) .. (1782.9,309.4) .. controls (1787.0,309.4) and (1791.4,311.4) .. (1793.5,315.8) .. controls (1795.1,319.1) and (1795.8,323.8) .. (1795.8,330.8)(1804.7,330.2) .. controls (1804.7,322.1) and (1803.2,316.2) .. (1800.1,311.7) .. controls (1796.7,306.8) and (1791.3,303.0) .. (1783.0,303.0) .. controls (1769.9,303.0) and (1761.8,312.9) .. (1761.8,329.1) .. controls (1761.8,345.5) and (1769.6,355.6) .. (1783.3,355.6) .. controls (1795.8,355.6) and (1804.7,346.8) .. (1804.7,330.2)(1744.3,354.3) -- (1744.3,316.5) .. controls (1744.3,314.5) and (1743.9,312.5) .. (1743.1,310.7) .. controls (1741.1,306.3) and (1736.3,303.4) .. (1730.9,303.4) .. controls (1725.6,303.4) and (1720.4,305.9) .. (1715.2,311.1) .. controls (1715.2,307.0) and (1713.4,303.3) .. (1713.4,303.3) -- (1705.8,305.4) .. controls (1705.8,305.4) and (1707.7,308.8) .. (1707.7,315.9) -- (1707.7,354.3) -- (1715.3,354.3) -- (1715.3,317.2) .. controls (1718.9,313.4) and (1725.1,310.2) .. (1729.1,310.2) .. controls (1731.4,310.2) and (1733.5,311.0) .. (1734.6,312.3) .. controls (1736.0,314.0) and (1736.4,315.3) .. (1736.4,320.6) -- (1736.4,354.3) -- (1744.3,354.3) -- cycle(1686.7,354.3) -- (1686.7,318.6) .. controls (1686.7,315.0) and (1686.5,313.4) .. (1685.9,311.4) .. controls (1684.5,306.8) and (1679.1,303.5) .. (1673.1,303.5) .. controls (1666.7,303.5) and (1661.0,307.2) .. (1656.5,311.4) .. controls (1656.5,311.4) and (1656.8,307.8) .. (1656.8,304.6) -- (1656.8,293.0) .. controls (1656.8,285.4) and (1655.5,281.2) .. (1655.5,281.2) -- (1647.7,282.7) .. controls (1647.7,282.7) and (1649.0,286.4) .. (1649.0,292.9) -- (1649.0,354.3) -- (1656.8,354.3) -- (1656.8,318.9) .. controls (1661.1,313.6) and (1666.5,310.5) .. (1671.3,310.5) .. controls (1673.8,310.5) and (1675.9,311.3) .. (1677.1,312.5) .. controls (1678.5,313.9) and (1679.0,316.2) .. (1679.0,319.9) -- (1679.0,354.3) -- (1686.7,354.3) -- cycle(1635.5,348.8) -- (1631.2,343.8) .. controls (1628.3,347.3) and (1624.5,349.2) .. (1620.5,349.2) .. controls (1612.5,349.2) and (1608.2,343.1) .. (1608.2,331.9) .. controls (1608.2,324.6) and (1609.1,319.1) .. (1611.0,315.6) .. controls (1612.8,312.2) and (1616.5,310.0) .. (1620.4,310.0) .. controls (1624.2,310.0) and (1626.4,311.1) .. (1629.9,314.0) -- (1634.2,308.6) .. controls (1630.6,305.6) and (1626.9,303.2) .. (1620.6,303.2) .. controls (1615.3,303.2) and (1611.0,305.1) .. (1607.1,309.0) .. controls (1602.8,313.3) and (1599.6,319.3) .. (1599.6,330.2) .. controls (1599.6,337.6) and (1601.1,343.1) .. (1604.4,347.9) .. controls (1607.9,352.9) and (1613.2,355.4) .. (1620.3,355.4) .. controls (1626.5,355.4) and (1630.9,353.5) .. (1635.5,348.8)(1577.3,324.8) -- (1554.5,324.8) .. controls (1554.9,314.5) and (1558.9,309.3) .. (1566.0,309.3) .. controls (1569.8,309.3) and (1573.3,311.0) .. (1575.0,313.7) .. controls (1576.5,316.1) and (1577.2,319.4) .. (1577.3,324.8)(1585.6,330.7) -- (1585.6,329.6) .. controls (1585.6,317.7) and (1584.2,313.0) .. (1579.9,308.6) .. controls (1576.5,305.1) and (1571.8,303.2) .. (1566.4,303.2) .. controls (1560.4,303.2) and (1555.5,305.4) .. (1551.5,310.1) .. controls (1547.3,315.1) and (1545.5,320.5) .. (1545.5,328.9) .. controls (1545.5,345.4) and (1553.8,355.4) .. (1567.6,355.4) .. controls (1574.0,355.4) and (1580.0,353.2) .. (1584.4,349.2) -- (1581.4,344.2) .. controls (1577.9,347.4) and (1574.0,348.9) .. (1569.2,348.9) .. controls (1564.2,348.9) and (1559.6,347.1) .. (1556.8,342.8) .. controls (1555.1,340.2) and (1554.5,336.6) .. (1554.5,331.9) -- (1554.5,330.7) -- (1585.6,330.7) -- cycle(1543.5,285.7) -- (1498.1,285.7) -- (1498.1,292.6) -- (1516.5,292.6) -- (1516.5,354.3) -- (1524.4,354.3) -- (1524.4,292.6) -- (1543.0,292.6) -- (1543.5,285.7) -- cycle(1476.1,284.8) .. controls (1473.2,282.9) and (1469.4,281.9) .. (1465.1,281.9) .. controls (1461.4,281.9) and (1458.7,282.7) .. (1456.3,284.5) .. controls (1454.2,286.1) and (1450.8,289.3) .. (1450.8,296.7) -- (1450.8,304.5) -- (1446.0,304.5) -- (1446.0,310.4) -- (1450.8,310.4) -- (1450.8,354.3) -- (1459.0,354.3) -- (1459.0,310.4) -- (1470.4,310.4) -- (1472.8,304.5) -- (1459.0,304.5) -- (1459.0,296.8) .. controls (1459.0,291.1) and (1461.4,288.0) .. (1465.8,288.0) .. controls (1468.5,288.0) and (1471.3,289.2) .. (1473.2,290.3) -- (1476.1,284.8) -- cycle(1424.4,330.8) .. controls (1424.4,335.7) and (1424.0,338.5) .. (1422.9,341.6) .. controls (1421.2,346.4) and (1417.3,349.1) .. (1412.1,349.1) .. controls (1407.8,349.1) and (1403.8,347.1) .. (1402.0,344.1) .. controls (1400.1,341.0) and (1398.9,334.8) .. (1398.9,327.8) .. controls (1398.9,321.9) and (1399.7,317.9) .. (1401.3,314.8) .. controls (1403.0,311.5) and (1407.1,309.4) .. (1411.5,309.4) .. controls (1415.6,309.4) and (1420.0,311.4) .. (1422.1,315.8) .. controls (1423.7,319.1) and (1424.4,323.8) .. (1424.4,330.8)(1433.3,330.2) .. controls (1433.3,322.1) and (1431.8,316.2) .. (1428.7,311.7) .. controls (1425.3,306.8) and (1419.9,303.0) .. (1411.6,303.0) .. controls (1398.5,303.0) and (1390.4,312.9) .. (1390.4,329.1) .. controls (1390.4,345.5) and (1398.2,355.6) .. (1411.9,355.6) .. controls (1424.4,355.6) and (1433.3,346.8) .. (1433.3,330.2)(1356.9,304.5) -- (1348.0,304.5) -- (1338.2,337.2) .. controls (1337.0,341.3) and (1335.1,347.7) .. (1335.1,347.7) -- (1334.9,347.7) .. controls (1334.9,347.7) and (1333.4,340.0) .. (1331.9,335.3) -- (1321.7,303.0) -- (1314.0,305.6) -- (1324.7,336.8) .. controls (1326.4,341.8) and (1329.1,351.5) .. (1329.7,354.7) -- (1332.9,354.2) .. controls (1330.2,364.3) and (1327.8,367.5) .. (1321.4,369.5) -- (1323.7,374.8) .. controls (1332.4,372.7) and (1336.5,366.1) .. (1339.8,356.1) -- (1356.9,304.5) -- cycle(1308.5,304.5) -- (1296.0,304.5) .. controls (1296.0,297.9) and (1297.0,290.1) .. (1297.0,290.1) -- (1288.8,291.9) .. controls (1288.8,291.9) and (1288.0,299.7) .. (1288.0,304.5) -- (1281.5,304.5) -- (1281.5,310.4) -- (1288.0,310.4) -- (1288.0,344.6) .. controls (1288.0,349.6) and (1289.3,352.8) .. (1292.8,354.5) .. controls (1294.7,355.4) and (1296.7,355.9) .. (1299.3,355.9) .. controls (1302.8,355.9) and (1305.6,355.2) .. (1308.1,353.9) -- (1307.0,348.9) .. controls (1305.6,349.6) and (1304.3,349.9) .. (1302.1,349.9) .. controls (1297.2,349.9) and (1295.7,348.0) .. (1295.7,342.5) -- (1295.7,310.4) -- (1306.1,310.4) -- (1308.5,304.5) -- cycle(1269.2,289.1) .. controls (1269.2,285.7) and (1266.5,283.0) .. (1263.1,283.0) .. controls (1259.7,283.0) and (1257.0,285.8) .. (1257.0,289.2) .. controls (1257.0,292.5) and (1259.7,295.2) .. (1263.1,295.2) .. controls (1266.5,295.2) and (1269.2,292.5) .. (1269.2,289.1)(1267.0,354.3) -- (1267.0,303.4) -- (1258.9,304.7) -- (1258.9,354.3) -- (1267.0,354.3) -- cycle(1242.9,339.5) .. controls (1242.9,332.1) and (1238.6,327.5) .. (1229.6,325.6) -- (1223.0,324.2) ..  controls (1217.7,323.1) and (1215.8,320.8) .. (1215.8,317.0) .. controls (1215.8,312.1) and (1219.5,308.8) .. (1225.2,308.8) .. controls (1229.6,308.8) and (1233.3,310.3) .. (1237.7,312.4) -- (1240.6,306.6) .. controls (1236.4,304.2) and (1230.6,302.6) .. (1225.4,302.6) .. controls (1215.0,302.6) and (1207.7,308.9) .. (1207.7,317.9) .. controls (1207.7,324.8) and (1212.1,329.9) .. (1220.3,331.6) -- (1226.5,332.9) .. controls (1232.2,334.1) and (1234.7,336.6) .. (1234.7,341.1) .. controls (1234.7,346.4) and (1230.7,349.7) .. (1224.6,349.7) .. controls (1219.1,349.7) and (1213.9,348.1) .. (1208.8,345.0) -- (1205.8,350.8) .. controls (1210.9,353.9) and (1217.8,355.8) .. (1224.1,355.8) .. controls (1235.3,355.8) and (1242.9,349.2) .. (1242.9,339.5)(1200.3,303.5) .. controls (1200.3,303.5) and (1198.9,303.0) .. (1197.6,303.0) .. controls (1192.5,303.0) and (1187.2,306.2) .. (1183.6,311.3) .. controls (1183.9,307.1) and (1182.0,303.2) .. (1182.0,303.2) -- (1174.2,305.3) .. controls (1174.2,305.3) and (1175.9,308.6) .. (1175.9,315.9) -- (1175.9,354.3) -- (1183.7,354.3) -- (1183.7,323.1) .. controls (1183.7,319.0) and (1184.3,317.5) .. (1186.6,315.2) .. controls (1188.9,312.9) and (1191.9,311.6) .. (1194.9,311.6) .. controls (1195.7,311.6) and (1196.6,311.8) .. (1197.1,312.0) -- (1200.3,303.5) -- cycle(1150.6,324.8) -- (1127.8,324.8) .. controls (1128.2,314.5) and (1132.2,309.3) .. (1139.3,309.3) .. controls (1143.1,309.3) and (1146.6,311.0) .. (1148.3,313.7) .. controls (1149.8,316.1) and (1150.5,319.4) .. (1150.6,324.8)(1158.9,330.7) -- (1158.9,329.6) .. controls (1158.9,317.7) and (1157.5,313.0) .. (1153.2,308.6) .. controls (1149.8,305.1) and (1145.1,303.2) .. (1139.7,303.2) .. controls (1133.7,303.2) and (1128.8,305.4) .. (1124.8,310.1) .. controls (1120.6,315.1) and (1118.8,320.5) .. (1118.8,328.9) .. controls (1118.8,345.4) and (1127.1,355.4) .. (1140.9,355.4) .. controls (1147.3,355.4) and (1153.3,353.2) .. (1157.7,349.2) -- (1154.7,344.2) .. controls (1151.2,347.4) and (1147.3,348.9) .. (1142.5,348.9) .. controls (1137.5,348.9) and (1132.9,347.1) .. (1130.1,342.8) .. controls (1128.4,340.2) and (1127.8,336.6) .. (1127.8,331.9) -- (1127.8,330.7) -- (1158.9,330.7) -- cycle(1109.3,304.5) -- (1101.0,304.5) -- (1089.6,337.6) .. controls (1088.0,342.1) and (1087.2,346.0) .. (1087.2,346.0) -- (1087.0,346.0) .. controls (1087.0,346.0) and (1086.0,341.6) .. (1084.6,337.5) -- (1073.0,303.2) -- (1065.0,304.9) -- (1082.9,354.8) -- (1090.6,354.8) -- (1109.3,304.5) -- cycle(1054.2,289.1) .. controls (1054.2,285.7) and (1051.5,283.0) .. (1048.1,283.0) ..  controls (1044.7,283.0) and (1042.0,285.8) .. (1042.0,289.2) .. controls (1042.0,292.5) and (1044.7,295.2) .. (1048.1,295.2) .. controls (1051.5,295.2) and (1054.2,292.5) .. (1054.2,289.1)(1052.0,354.3) -- (1052.0,303.4) -- (1043.9,304.7) -- (1043.9,354.3) -- (1052.0,354.3) -- cycle(1022.9,354.3) -- (1022.9,316.5) .. controls (1022.9,314.5) and (1022.5,312.5) .. (1021.7,310.7) .. controls (1019.7,306.3) and (1014.9,303.4) .. (1009.5,303.4) .. controls (1004.2,303.4) and (999.0,305.9) .. (993.8,311.1) .. controls (993.8,307.0) and (992.0,303.3) .. (992.0,303.3) -- (984.4,305.4) .. controls (984.4,305.4) and (986.3,308.8) .. (986.3,315.9) -- (986.3,354.3) -- (993.9,354.3) -- (993.9,317.2) .. controls (997.5,313.4) and (1003.7,310.2) .. (1007.7,310.2) .. controls (1010.0,310.2) and (1012.1,311.0) .. (1013.2,312.3) .. controls (1014.6,314.0) and (1015.0,315.3) .. (1015.0,320.6) -- (1015.0,354.3) -- (1022.9,354.3) -- cycle(965.8,334.5) -- (965.8,285.7) -- (957.7,285.7) -- (957.7,333.5) .. controls (957.7,338.1) and (957.4,341.1) .. (955.1,344.2) .. controls (953.0,347.0) and (948.7,348.5) .. (943.0,348.5) .. controls (934.6,348.5) and (930.9,344.8) .. (929.6,341.8) .. controls (928.7,339.7) and (928.4,335.3) .. (928.4,331.9) -- (928.4,285.7) -- (920.3,285.7) -- (920.3,334.9) .. controls (920.3,337.9) and (920.5,342.3) .. (922.3,345.6) .. controls (926.0,352.4) and (932.0,355.5) .. (942.6,355.5) .. controls (950.9,355.5) and (956.4,353.8) .. (960.6,350.2) .. controls (964.7,346.7) and (965.8,342.8) .. (965.8,334.5);
                \end{tikzpicture}
              }
            }
          }
        }
      }
    }
  }
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
    \setaxisposition{\temp@layoutheight-5.25mm}
    
    \setnewlength{\@logoheight}       {1.5cm}
    \setnewlength{\@logospacingleft } {\dimexpr1.5485\@logoheight\relax}
    \setnewlength{\@logospacingright} {\dimexpr3.4333\@logoheight\relax}
    
		\pgftext[at=\pgfpoint{\axispositionX-\@logospacingleft}{\axispositionY},left,top]{\resizebox{!}{\@logoheight}{\tuelogo}}%
		
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
        \fi
      \fi
    \fi
    \begingroup
      \enablefrontbreak
      \resetaxisposition
      \ifprofilingtouched            
        \resetaxisposition
        \setaxisposition{\temp@layoutheight-5.25mm-1.5cm}
        \ifprofilingfilled
          \titlepagecontent[right][profilingcolor]{\theprofilingvalue}{white}{\style[1]{heading}}{\@logospacingright}{\axispositionY}{\dimexpr\temp@layoutwidth-.5\axispositionX-.5\layoutrightmargin\relax}{}
        \else
          \titlepagecontent[right]{\theprofilingvalue}{\theprofilingcolor}{\style[1]{heading}}{}{\axispositionY}{}{}
        \fi
      \else
        \resetaxisposition
        \setaxisposition{\temp@layoutheight-2.3cm}
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
\newcommand{\drawtueaxes}[1][true]{%
  \pgfsetcolor{coloraxis}%
  \ifequal{#1}{true}{%
    %%%	Draw horizontal axis
    \pgfpathmoveto{\pgfpoint{0mm              -\layoutbleed}{\@axisheight             }}
    \pgfpathlineto{\pgfpoint{\temp@layoutwidth+\layoutbleed}{\@axisheight             }}
    \pgfpathlineto{\pgfpoint{\temp@layoutwidth+\layoutbleed}{\@axisheight-\@axiswidth }}
    \pgfpathlineto{\pgfpoint{0mm              -\layoutbleed}{\@axisheight-\@axiswidth }}
    \pgfusepath{fill}
  }{}%
	%%%	Draw diagonal axis
	\pgfpathmoveto{\pgfpoint{\@Hspacing                       +\@shiftratio\layoutbleed}{\temp@layoutheight +\layoutbleed}}
	\pgfpathlineto{\pgfpoint{\@Hspacing             -\@Hshift -\@shiftratio\layoutbleed}{0cm                -\layoutbleed}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@axiswidth -\@Hshift -\@shiftratio\layoutbleed}{0cm                -\layoutbleed}}
	\pgfpathlineto{\pgfpoint{\@Hspacing-\@axiswidth           +\@shiftratio\layoutbleed}{\temp@layoutheight +\layoutbleed}}
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

  \ifx\@empty#3\relax
  \else

    \ifequal{#1}{left}{}
    {% If right go to the right side of the axis
      \addtolength{\axispositionX}{\@axiswidth}
    }
    
    \ifequal{#9}{}{% If the vertical padding is not specified
      \setlength{\fillverticalpadding}{\@axispadding}% Set vertical padding to equal to horizontal padding
    }{% If the vertical padding is specified
      \setlength{\fillverticalpadding}{#9}% Set vertical padding to value specified
    }
    
    \ifequal{#1}{left}{% If left set baselength:
      \setlength{\@tempbaselength}{\dimexpr\titlepagecontentX-\@axispadding-\titlepagecontentleft-.5em\relax}
      \ifx#2\@empty\else
        \addtolength{\@tempbaselength}{\dimexpr-\fillhorizontalpadding-.5em\relax}% Substract padding from baselength
      \fi
    }{% If right set baselength:
      \setlength{\@tempbaselength}{\dimexpr\temp@layoutwidth-\titlepagecontentX-.3em-\titlepagecontentright-\@axispadding+\layoutbleed\relax}
      \ifx#2\@empty\else
        \addtolength{\@tempbaselength}{-\fillhorizontalpadding}% Substract padding from baselength
      \fi
    }
    
    \ifequal{#6}{}{% If no minimum width is specified
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
            \ifequal{#1}{left}{%
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
          \ifequal{#1}{left}{
            \addtolength{\tempboxawidth}{\dimexpr 3\fillhorizontalpadding\relax}
          }{
            \addtolength{\tempboxawidth}{\dimexpr\fillhorizontalpadding+\@axispadding+.3em\relax}
          }
        \fi
        \global\tempboxawidth=\tempboxawidth
    }
    \ifx#2\@empty\else
      \pgfsetcolor{#2}
      \ifequal{#1}{left}{
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
    \ifequal{#1}{left}{
      \pgftext[at=\pgfpoint{\dimexpr\titlepagecontentX-\@axispadding-\@axiswidth}{\titlepagecontentY-.25\baselineskip-\fillverticalpadding},right,top]{%
       \usebox{\@tempboxa}
      }
    }{
      \pgftext[at=\pgfpoint{\titlepagecontentX+\@axispadding}{\titlepagecontentY-.25\baselineskip-\fillverticalpadding},left,top]{%
        \usebox{\@tempboxa}
      }
    }
    \ifequal{#8}{nospace}{
      \resetaxisposition
      \global\tempboxaheight=\tempboxaheight
    }{}
  \fi
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
      \def\actual@coverratio{\dividelengths{\@coverwidth}{\actual@coverheight}}
     
\fi
      
\newcommand\enablefrontbreak{
  \def\titlebreak{\hfill\break}
}

\newcommand\disablefrontbreak{
  \def\titlebreak{\unskip\ }
}


%%% command \modulo
\def\truncdiv#1#2{((#1-(#2-1)/2)/#2)} 
\def\moduloop#1#2{(#1-\truncdiv{#1}{#2}*#2)} 
\def\modulo#1#2{\number\numexpr\moduloop{#1}{#2}\relax}

%%% command \@fnsymbol to create an infinite symbol list
\def\@fnsymbol#1{%
\ifcase\modulo{#1}{7}$\|$%
\or $*$%
\or $\dagger$%
\or $\mathsection$%
\or $\ddagger$%
\or $\mathparagraph$%
\or $\circ$%
\fi%
\ifnum \numexpr#1-7\relax > 0\relax%
	\@fnsymbol{\numexpr#1-7\relax}%
\fi%
}



\def\thanks#1{\footnotemark
    \protected@xdef\@thanks{\@thanks
        \protect\footnotetext[\the\c@footnote]{#1}}%
        \checkIsThanks
}

\storeold{\thanks}

\newcounter{footnotestore}

\renewcommand\maketitle{
  \begingroup
    \def\and{\ClassWarning{TUestyle}{\string\and\space command is disabled, use \string\author{<name1>}{<name2>}{<name3>}[<key3>] for proper styling}{}}
    \begin{titlepage}
      \setcounter{footnotestore}{\thefootnote}
      \setcounter{footnote}{0}
      \renewcommand{\thefootnote}{\fnsymbol{footnote}}
      \setlength{\fnmarkbox}{0em}
   
      \let\@thanks\@empty% Clear \@thanks, which will hold the footnotes for this titlepage
      \restoreold{\thanks}%     Enable the \thanks command
      
      \let\footnoterule\relax%  No footnote rule
      \let\footnote\thanks%     In order to collect footnotes just as done with \thanks
      
      %%%\hfuzz=1000pt
      \enablefrontbreak
      
      \settitlelayout

      \null% Geometry requires an item on the page, textblock doesn't get detected
      
      \begin{fullpagetextblock}
      
        %%%	If the cover option is set, then draw cover and white overlays
        \ifcover
          %%% Display area to be filled by the cover image
          \@axisfill[right]{colorgray}{\@coverbottom}{\@covertop}
          
          %%% Draw the cover 
          \pgftext[at=\pgfpoint{\temp@layoutwidth-.5\@coverwidth}{\@covertop-.5\@coverheight},center,center]{%
            \ifequal{\@coveralign}{width}{%
              \includegraphics[width={\@coverwidth}]{\covername}%
            }{\ifequal{\@coveralign}{height}{%
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
        \axesinfobox[top]{%
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
            \begingroup
              \hypersetup{urlcolor={colorbody}}\urlstyle{same}
              \frontpagebody{\url{\thewebsite}}
            \endgroup
          \fi
        }%
        %%% Left column with info
        \axesinfobox[bottom]{%
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

       
        %%%	Drawing of the TU/e axes and logo
        %   Drawn last so it overlays everything else
        \drawtuelogoandaxes
        
      \end{fullpagetextblock}
      \@thanks    
    \end{titlepage}

    %%%% \hfuzz=0pt

  \endgroup
  \setcounter{footnote}{\thefootnotestore}
  
  \gdef\thanks##1{}% Disarm \thanks
  \let\@thanks\@empty% Clear \@thanks, which holds the footnotes for this titlepage
  \resetlayout
  \clearpage
}

%%% disable \and command 
\global\let\and\relax




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
  \ifequal{#1}{left}{%
    \pgfpathmoveto{\pgfpoint{0mm          -\layoutbleed                                       } {#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing   -\@shiftratio*(\temp@layoutheight-(#4))-\@axiswidth } {#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing   -\@shiftratio*(\temp@layoutheight-(#3))-\@axiswidth } {#3}}
    \pgfpathlineto{\pgfpoint{0mm          -\layoutbleed                                       } {#3}}
  }{
    \pgfpathmoveto{\pgfpoint{\paperwidth  +\layoutbleed                                       } {#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing   -\@shiftratio*(\temp@layoutheight-(#4))             } {#4}}
    \pgfpathlineto{\pgfpoint{\@Hspacing   -\@shiftratio*(\temp@layoutheight-(#3))             } {#3}}
    \pgfpathlineto{\pgfpoint{\paperwidth  +\layoutbleed                                       } {#3}}
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
  \microtypesetup{protrusion=false}%
  \begin{onecolarea}{}{\newpage}%

  \localdisablerefcheck
  
    \iftwosided
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
    \fi%
%
    
    \setoddcontentlayout


    % The table of contents needs different margins. The package geometry is used to
    % change the margins of certain pages within a document.
    % After the table of contents, they will be reset.


    \fancyfoot[L]{%
      \begin{fullpagetextblock}
            \drawtuetableofcontents
      \end{fullpagetextblock}
    }
    
    \fancyfoot[C]{%
      \datafoot
    }%

    \pagestyle{fancy}
      %%%	Draw TOC (Table of Contents)
      {\@starttoc{toc} 
     }%
    
	\end{onecolarea}

	%%%	Reset the original values of all margins
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
  \axesinfobox[top]{%
      \Large\contentsname\hfill\break%
  }

	%%% Draw title and subtitle
  \axesinfobox[bottom]{%
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
\newcommand{\leftsidehead}{%
	\style{headerfooter}%
	\ifshorth%
		\thefullname%
	\else
		\theshortname%
	\fi%
	\ifx\theextrah\empty\relax\else
    \space-\space\theextrah
  \fi
}

%%%	Define right side header
\newcommand{\rightsidehead}{%
	\style{headerfooter}%
	\ifx\theextrah\empty\relax\else%
    \theextrah\space-
  \fi%
	\ifshorth%
		\thefullname%
	\else%
		\theshortname%
	\fi%
	\ifx\theextrah\empty\relax\else
    \space-\space\theextrah
  \fi
}

%%%	Define left side footer
\newcommand{\leftsidefoot}{
  \parbox[b]{\linewidth}{\raggedright
    \style{headerfooter}\color{colorbody}\footnumber\color{hfcolor}\space-\space
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
    \style{headerfooter}%
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
    \style{headerfooter}%
    \ifx\theextrafo\empty\relax\else%
      \theextrafo%
    \fi%
  }%
}

%%%	Define odd left side footer
\newcommand{\oddleftsidefoot}{%
  \parbox[b]{\linewidth}{\raggedright
    \style{headerfooter}%
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
  \if@twoside
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
    \ifequal{\theversionnum}{}{}{\theversionlabel\space\theversionnum\space/}\space\today,\space\now\end{oldtabular}%
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
\leavevmode% \leavevmode is added to keep the "a" and "LeX" on the same line
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
              \expandafter\chapter*{#3}%
              \setlength{\parskip}{\listofparskip}
              \@starttoc{#2}%
            \endgroup\end{onecolarea}
        }

\def\stylelist{\@ifstar\@stylelist\@@stylelist}
        
\newcommand{\@@stylelist}[3][2]{
  \ifgloballistspacing 
    \expandafter\providecommand\csname l@tabs@globalitem\endcsname{#1}
    \expandafter\stylelistSingle[\csname l@tabs@globalitem\endcsname]{#2}{#3}
  \else
    \expandafter\providecommand\csname l@tabs@#2\endcsname{#1}
    \expandafter\stylelistSingle[\csname l@tabs@#2\endcsname]{#2}{#3}
  \fi
}

%% TODO make starred command
\newcommand{\@stylelist}[3][2]{
  \expandafter\providecommand\csname l@tabs@#2\endcsname{#1}
  \expandafter\stylelistSingle[\csname l@tabs@#2\endcsname]{#2}{#3}
}

\newcommand{\stylelistTabdefault}[2]{
  \pgfmathparse{int(round(#2))}
  \expandafter\edef\csname l@tabs@#1\endcsname{\numexpr\pgfmathresult+1\relax}% edef to make sure \pgfmathresult is expanded before it is stored
}

\newcommand{\stylelistSingle}[3][2]{
  \expandafter\def\csname l@#2\endcsname##1##2{%
    \@dottedtocline{1}
     {0em} % Indent
     {#1\listindent} % Listing number width
     {\hypersetup{hidelinks}#3##1} % Entry text %Hidelinks so the page number and text don't get colored, eventough they link
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

%%%	Declare the \listofnotes command for the list of notes
\definelist{note}{lon}


%redefined from book
\renewcommand*\l@chapter[2]{%
  \def\@currentlist{chapter}% Added currentlist clause
  \ifnum \c@tocdepth >\m@ne%
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@%
    \setlength\@tempdima{\l@tabs@chapter\listindent}% Changed indent
    \begingroup%
      \parindent \z@ \rightskip \@pnumwidth%
      \parfillskip -\@pnumwidth%
      \leavevmode \bfseries%
      \advance\leftskip\@tempdima%
      \hskip -\leftskip%
      {\hypersetup{hidelinks}#1}\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par% Added hidelinks to body
      \penalty\@highpenalty%
    \endgroup
  \fi}
  
\providecommand{\l@tabs@chapter}{2}

\stylelist*{section}{\def\@currentlist{section}}
\stylelist*{subsection}{\def\@currentlist{subsection}}
\stylelist*{subsubsection}{\def\@currentlist{subsubsection}}
\stylelist*{paragraph}{\def\@currentlist{paragraph}}
\stylelist*{subparagraph}{\def\@currentlist{subparagraph}}
\stylelist*{subsubparagraph}{\def\@currentlist{subsubparagraph}}




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
      \letnewcolorifnone{notes@#1}{notescolor}%
      \addtocontents{lon}{\string\letnewcolorifnone{notes@#1}{notescolor}}
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
  \addtocontents{lon}{\string\letnewcolorifnone{notes@#1}{#2}}
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
      {\mbox{\ifx\@empty#1\relax\else\thl[notes@#1]{\space}\fi%
      \thlarrowright[notes@#1]}%
      \space\itshape#3\space%
      \ifmarginnotes\ifx\@empty#1\relax\else\hfill\fi\fi\mbox{\thlarrowleft[notes@#1]\thl[notes@#1]{\space}}}%
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






\newcommand\nextToken\relax

\newcommand\isThanks{%
    \ifx\thanks\nextToken\textsuperscript{,}\fi}
    
\newcommand\checkIsThanks{\futurelet\nextToken\isThanks}


%%%
%	Footnote styling
%	Marginpar styling
%	Footnote* command creation
%%%

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
  \makebox[0pt]{% Hide \footnotemark
    \footnotemark% Needs to be "printed" for correct hyperref
  }%
  \restoreold{\@makefnmark}% Restore fnmark so it is used in the footmark
  \ifequal{\thecurrentFootnoteLabel}{}{%
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
  \ifequal{\thecurrentFootnoteLabel}{}{%
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
  \ifequal{\thecurrentFootnoteLabel}{}{%
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
    ##1% empty line to start new paragraph
    
  }
}

%%% style marginpar command
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

\newsavebox{\hugequoteleftBox}
\newcommand{\hugequoteleft}{%
  \begingroup%
  \savebox{\hugequoteleftBox}{\raisebox{-1em}{\style[-3]{heading}\color{colorquoteaccent}
  \raggedleft\textbf{``}}}%
  \leavevmode\smash{\makebox[0pt]{\hspace{\dimexpr-\tabsize-5pt\relax}\usebox{\hugequoteleftBox}}}%TODO change tabsize to left margin (current)
  \endgroup%
}

\newcommand{\@quotesource}[1]{\par\smallskip\hfill{\color{colorquoteaccent}\normalsize---\space\space\color{colorquote}#1}}

\newcommand{\quotesource}[1]{\ifequal{#1}{}{}{\@quotesource{#1}}}

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


\newenvironment{fullpagetextblock}{%
  \begingroup
    \ifTPshowboxes
      \TPshowboxesfalse% Showing the fullpage textblock border introduces unwanted vertical spacing, so this is temporarily disabled
    \fi
    \begin{textblock*}{\temp@layoutwidth}(0pt,0pt)%
      \noindent\begin{pgfpicture}{0mm}{0mm}{\temp@layoutwidth}{\temp@layoutheight}%
}
{
      \end{pgfpicture}%
    \end{textblock*}
  \endgroup
}

    \newsavebox{\fullpagetextblockbox}

\newenvironment{absolutelynopagebreak}
  {\par\nobreak\vfil\penalty0\vfilneg
   \vtop\bgroup}
  {\par\xdef\tpd{\the\prevdepth}\egroup
   \prevdepth=\tpd}

   
\newcommand{\localdisablerefcheck}{
  \ifrefcheck
    \@show@reffalse% disable »refcheck« showing labels
    \@give@msgsfalse% disable »refcheck« log writing so the oddpagelabels don't create logs
  \fi
}
   
\newenvironment{axispage}{
    \setoddcontentlayout
    
    \begingroup
    \iftwosided
      \pagestyle{empty}
    \else
      \fancyfoot[L]{%
        \begin{fullpagetextblock}
          \drawtueaxes
        \end{fullpagetextblock}
      }
      \fancyfoot[C]{%
        \datafoot
      }%
      \pagestyle{fancy}
    \fi
}{\null
    \iftwosided
        \begin{fullpagetextblock}% By design placed after the content so it forces the user to keep the content 1 page long (max)
          \drawtueaxes
        \end{fullpagetextblock}
    \fi
\endgroup
  %%%	Begin new page to start layout-change
  \clearpage
  %%%	Reset the original values of all margins
  \resetlayout
}



\newcommand{\makeaxis}{

  \setfulloddlayout
  
  \thispagestyle{empty}

  \newtoks\mylinetoks%use token register to allow \linebreak etc., this doesn't work in edef
  \mylinetoks={}
  
  \null
  
\checknextargb%
}

\newcommand{\checknextargb}{%
  \@ifnextchar\bgroup{%
    \gobblenextb % Check if another "argument" exists
  }{%
    \@ifnextchar[{%
      \gobblenextb@key%
    }{% Ending
      \begin{fullpagetextblock}
        \resetaxisposition
        \setaxisposition{\paperheight-\layoutbleed-\layouttopmargin+.5\baselineskip}% Shift the amount of "\titlepagecontent padding" up to make it align with normal text
        \setlength{\titlepagecontentY}{\axispositionY}
        \drawtueaxes[false]
        \the\mylinetoks
      \end{fullpagetextblock}
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



\def\titlebreak{\unskip\space}% unskip to remove space in front




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
%%  coloring the footnote rule and setting its width to 3\columnsize
%%  keeping the height and spacing the same
\AtBeginDocument{
  \renewcommand{\footnoterule}{\begingroup\color{colorfootrule}%
    \kern -3pt
    \hrule width 3\columnsize height .4pt
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
      %  \ifequal{#3}{}{}{% TODO fix
      %    \iffalse%
      %      \captionof{\multypecurrent}{#3}%
      %    \else%
       %     \subcaption{#3}%\label{img:#1}%
       %   \fi}%
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
%%  Example usage: \switchfont{cmss10}, call \switchback to switch the font back to the last switched font
\newcommand{\switchfont}[1]{
\expandafter \let \expandafter \switchback \the\font
\font\1=#1\1
}

\AtBeginDocument{
  %%  Removes extreme spacing between paragraphs
  %   \raggedbottom %%%% TODO make option
  %   Boxes on every page are of a different height
\disablefrontbreak%% TODO test if needed
\styling@@body%
}







\def\DividedListChapterTitle{}

\newcommand{\DeclareDividedList}[1]%
  {\setnewcounter{#1@chapter}{0}}
  
\def\DividedListChapterCheck#1#2{
\ifcounter{#1@chapter}{%
     \ifnum \value{chapter} > \value{#1@chapter}%
       \setcounter{#1@chapter}{\value{chapter}}%
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
\typeout{NUMBERLINE IS \@currentlist}%% TODO remove
  \expandafter\providelength\csname\@currentlist Widest\endcsname%
  \settowidth{\numberlineTemp}{#1}%
  \expandafter\settobiggest\csname\@currentlist Widest\endcsname{\numberlineTemp}%
  \expandafter\global\csname\@currentlist Widest\endcsname=\csname\@currentlist Widest\endcsname
  \immediate\write\preaux{\expandafter\string\expandafter\stylelistTabdefault{\@currentlist}{\dividelengths{\the\csname\@currentlist Widest\endcsname+\gridgutterwidth}{\tabsize}}}%
  \oldnumberline{#1}%
}
\def\@currentlist{none}








\normalem% Disable ulem package \em overwrite
\DeclareRobustCommand{\em}{%
  \@nomath\em \if b\expandafter\@car\f@series\@nil
  \normalfont \itshape \else \bfseries\itshape \fi}
  




  
\newcommand{\verbatimfont}[1]{\renewcommand{\verbatim@font}{\ttfamily#1}}



\ifsectioningstyling
  \setnewlength{\vbeforechapter}{25\p@}% Half
  \setnewlength{\vafterchapter}{20\p@}% Half
\else
  \setnewlength{\vafterchapter}{40\p@}% Original
  \setnewlength{\vbeforechapter}{50\p@}% Original
\fi

\ifsectioningstyling
  \AtBeginDocument{
    \def\@makechapterhead#1{%
      \gdef\DividedListChapterTitle{#1}% Store chapter title for devided list ofs
      \vspace*{\vbeforechapter}%
        {\raggedright\style[0]{heading}%
          \ifnum \c@secnumdepth >\m@ne%
            \leftskip -\chaptershift
            \ifchaptername% check for chaptername option
              \@chapapp\space\inner@seccntformat{#1}\\[0pt]\nobreak
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
      
      \def\@makeschapterhead#1{%
      \vspace*{\vbeforechapter}%
      {\raggedright\style[0]{heading}%
        \interlinepenalty\@M
        #1\par\nobreak
        \vskip \vafterchapter
      }}

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
%%%

\renewcommand\chapter{%
\ifinlinesec%
  \relax%
\else%
  \if@openright\cleardoublepage\else\clearpage\fi%
\fi%
%\thispagestyle{plain}%
\global\@topnum\z@%
\@afterindentfalse%
\secdef\@chapter\@schapter%
}

%%% command \TUe@createsectioningstyling[<level>]{\<name>}{<style>}{<space before>}{<space after>}
\newcommand{\TUe@createsectioningstyling}[7][\secingLevelLowest]{
  \expandafter\providecommand\csname vbefore\cs@to@str#2\endcsname{#3 \@plus #4 \@minus #5}
  \expandafter\providecommand\csname vafter\cs@to@str#2\endcsname{#6 \@plus #7}
  \renewcommand#2{
    \@startsection{\cs@to@str#2}              % counter
    {#1}                                      % level
    {\z@}                                     % indent
    {\csname vbefore\cs@to@str#2\endcsname}   % beforeskip
    {\csname vafter\cs@to@str#2\endcsname}    % afterskip
    {\noindent\style[#1]{heading}}            % styling
    % \noindent to prevent sectioning from getting indented, because \style allows for it
  }
}

\ifsectioningstyling
  \TUe@createsectioningstyling[1]{\section}       {-3.5ex}  {-1ex}{-.2ex}{2.3ex}{.2ex}
  \TUe@createsectioningstyling[2]{\subsection}    {-3.25ex} {-1ex}{-.2ex}{1.5ex}{.2ex}
  \TUe@createsectioningstyling[3]{\subsubsection} {-3.25ex} {-1ex}{-.2ex}{1.5ex}{.2ex}
\fi

\ifsectioningstyling
  \ifparagraphstyling
    \TUe@createsectioningstyling[4]{\paragraph}   {-3.25ex} {-1ex}{-.2ex}{.2ex} {.2ex}% Negative values to create linebreak
    \TUe@createsectioningstyling[5]{\subparagraph}{-3.25ex} {-1ex}{-.2ex}{.2ex} {.2ex}% Negative values to create linebreak
  \fi
\fi

    \newcommand\subsubparagraph{}
    \newcounter{subsubparagraph}[subparagraph]
    \newcommand{\subsubparagraphmark}[1]{}
    \providecommand*{\toclevel@subsubparagraph}{6}% toclevel, also used for bookmarks

\TUe@createsectioningstyling[5]{\subsubparagraph} {-3.25ex} {-1ex}{-.2ex}{.2ex} {.2ex}% Negative values to create linebreak



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

          \def\sectioningdot{\texorpdfstring{\unselectable[.]{\protect\watermark{.}}}{.}}

          \newcommand{\createsectioningnumber}[1]{\the\numexpr\value{#1}+\@sectioningshift\relax}

          
%%% Counter: reversesecnumdepth
%%  Used like secnumdepth, except that it removes higher sectioning number which comes before the current sectioning number
\setnewcounter{reversesecnumdepth}{0}

%%% Command: \the<sectioningname>prefix
%%  Used to display higher sectioning numbers before current sectioning number

%%% Internal Command: \TUe@createthesectioning[<sectioning-prefix>]{<sectioning-parent>}{<current-sectioning>}{<current-level>}
%%  Used to define all sectioning numbering structures in the following manner:
%%    \def\the<current-sectioning>{
%%      \the<sectioning-parent>
%%      <sectioning-prefix>
%%      \the<current-level>
%%    }
\newcommand{\TUe@createthesectioning}[4][]{
  \expandafter\def\csname the#3\endcsname{%
    \csname the#3prefix\endcsname%
    #1\createsectioningnumber{#3}%
  }
  \ifequal{#2}{}{
    \expandafter\def\csname the#3prefix\endcsname{}%
  }{
    \expandafter\def\csname the#3prefix\endcsname{%
      \ifnum \value{reversesecnumdepth} < #4
        \csname the#2\endcsname\sectioningdot%
      \fi
    }
  }
}

%%%
%%  Setup: Setting up the sectioning numbering

%                       Parent          Current           Level of current
\TUe@createthesectioning{}              {part}            {-1}
\TUe@createthesectioning[\leadzero{chapter}]
                        {part}          {chapter}         { 0}
\TUe@createthesectioning{chapter}       {section}         { 1}
\TUe@createthesectioning{section}       {subsection}      { 2}
\TUe@createthesectioning{subsection}    {subsubsection}   { 3}
\TUe@createthesectioning{subsubsection} {paragraph}       { 4}
\TUe@createthesectioning{paragraph}     {subparagraph}    { 5}
\TUe@createthesectioning{subparagraph}  {subsubparagraph} { 6}

%%
%%%%

%%% Command: \showfilelist[<extension filter>]
%%  Prints the filelist of loaded files
%%  Possibly filtered on the optional <extension filter>
\newcommand{\showfilelist}[1][]{%
  \@for\@currname:=\@filelist\do{%
    \if\instring{#1}{\@currname}
      \expandafter\showfilelist@split\@currname\showfilelist@endsplit\tab[2]%
      \expandafter\detokenize\expandafter{\@currname}\\%
    \fi
  }
}

        %%% Command:  \showfileslist@split<string.withdot>\showfilelist@endsplit
        %%  Usage:    \showfileslist@split TUestyleReportBook.cls \showfilelist@endsplit
        \def\showfilelist@split#1.#2\showfilelist@endsplit{#2}
        
        
        
        


\DeclareOldFontCommand{\rm}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{rm}
  {\protect\rmfamily\space or \protect\textrm}
  \normalfont\rmfamily
}{\mathrm}

\DeclareOldFontCommand{\sf}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{sf}
  {\protect\sffamily\space or \protect\textsf}
  \normalfont\sffamily
}{\mathsf}

\DeclareOldFontCommand{\tt}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{tt}
  {\protect\ttfamily\space or \protect\texttt}
  \normalfont\ttfamily
}{\mathtt}

\DeclareOldFontCommand{\bf}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{bf}
  {\protect\bfseries\space or \protect\textbf}
  \normalfont\bfseries
}{\mathbf}

\DeclareOldFontCommand{\it}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{it}
  {\protect\itshape\space or \protect\textit}
  \normalfont\itshape
}{\mathit}

\DeclareOldFontCommand{\sl}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{sl}
  {\protect\slshape\space or \protect\textsl}
  \normalfont\slshape
}{\@nomath\sl}

\DeclareOldFontCommand{\sc}{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{sc}
  {\protect\scshape\space or \protect\textsc}
  \normalfont\scshape
}{\@nomath\sc}

\DeclareRobustCommand*\cal{
  \ObsoleteWarning[an old (obsolete) LaTeX 2.09 command]{cal}
  {\protect\mathcal}
\@fontswitch\relax\mathcal}

\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}