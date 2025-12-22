%% DODIresume (v1.0.0, 2021-09-04). Derived from AltaCV.
%% LPPL-1.3c-or-later.
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{dodiresume}[2021-09-04 DODIresume v1.0.0, a simple two column LaTeX resume, derived from AltaCV v1.6.2.]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
\ProcessOptions\relax

\LoadClass{article}
\RequirePackage{etoolbox}
% pdfx (PDF/A) loads xcolor internally; preloading xcolor avoids pdfx passing
% the obsolete xcolor option `hyperref` (TeX Live 2025 warns about it).
\RequirePackage{xcolor}
% pdfx also emits a benign informational warning about forcing RGB colors for
% PDF/A compliance; silence just that message.
\RequirePackage{silence}
\WarningFilter{pdfx}{Setting all color commands to rgb}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{accsupp}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{xparse}

\newif\ifxetexorluatex
\ifxetex
    \xetexorluatextrue
\else
    \ifluatex
        \xetexorluatextrue
    \else
        \xetexorluatexfalse
    \fi
\fi

\ifxetexorluatex
    \RequirePackage{fontspec}
\else
    \RequirePackage{cmap}
    \RequirePackage[utf8]{inputenc}
    \RequirePackage[T1]{fontenc}
    \input{glyphtounicode}
    \pdfglyphtounicode{f_f}{FB00}
    \pdfglyphtounicode{f_f_i}{FB03}
    \pdfglyphtounicode{f_f_l}{FB04}
    \pdfglyphtounicode{f_i}{FB01}
    \pdfgentounicode=1
\fi

\if@raggedtwoe
    \RequirePackage[newcommands]{ragged2e}
\fi

\if@withhyper
    \AtBeginDocument{%
        \hypersetup{hidelinks}
        \urlstyle{same}}
\fi

\RequirePackage{array}

\definecolor{LightGrey}{HTML}{666666}
\definecolor{BlueBlack}{HTML}{0B5394} % 0B5394
\definecolor{GdocLink}{HTML}{1155CC}
\colorlet{name}{BlueBlack}
\colorlet{heading}{BlueBlack}
\colorlet{subheading}{black}
\colorlet{accent}{black}
\colorlet{body}{LightGrey}
\colorlet{link}{GdocLink}
\newcommand{\itemmarker}{{\small\textbullet}}

\RequirePackage{tikz}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{changepage}

\setlength{\parindent}{0pt}

\newenvironment{fullwidth}{%
    \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
    {\end{adjustwidth}}

\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
    \catcode`\_=12%
    \catcode`\&=12%
    \catcode`\$=12%
    \catcode`\#=12%
    \catcode`\~=12%
    {#1}}}

\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
    \BeginAccSupp{method=escape,ActualText={#1:~#2}}
    \IfNoValueTF{#3}{%
        \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
    }{%
    \if@withhyper%
        \mbox{\textcolor{accent}{\normalfont #1}~
        \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
    \else%
        \ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
        \mbox{\textcolor{accent}{\normalfont #1}~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
    \fi%
    }%
    \EndAccSupp{}
}%


\NewDocumentCommand{\NewInfoField}{s m m o}{%
    \IfBooleanF{#1}{
        \IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
    }
    \csdef{#2 symbol}{#3}%
    \IfBooleanTF{#1}{
        \csdef{#2}##1##2{%
        \if@withhyper
            \IfNoValueTF {##2}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[##2]}%
        \else
            \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
        }
    }{%
    \csdef{#2}##1{%
        \if@withhyper
            \IfNoValueTF {#4}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
        \else
            \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
        }
    }
}
\ExplSyntaxOff

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{}[mailto:]
\NewInfoField{phone}{}[tel:]
\NewInfoField{linkedin}{}[https://]
\NewInfoField{github}{}[https://]
\NewInfoField{location}{}

\newcommand{\namefont}{\bfseries\fontsize{30pt}{30pt}\selectfont}
\newcommand{\personalinfofont}{\normalsize}
\newcommand{\cvsectionfont}{\large\bfseries\MakeUppercase}
\newcommand{\cvsubsectionfont}{\normalsize\bfseries}

%% Horizontal shift applied between name block and personal info block
%% (useful to align contact info with the right paracol column)
\newlength{\headerinfoshift}
\setlength{\headerinfoshift}{0.08in}

\newcommand{\makecvheader}{%
    \setlength\tabcolsep{0pt}
    \begin{tabular}{l@{\hspace{\headerinfoshift}}l}
        \raggedright
        \begin{minipage}{0.18\textwidth}  
            \begin{tikzpicture}[baseline=0]
                \clip (0,0) circle (1.5cm);
                \node at (-0.05,-0.2) {\includegraphics[width=6cm]{static/profile_offwhite.png}};
            \end{tikzpicture}
        \end{minipage}\hfill
        \begin{minipage}{0.487\textwidth}
            {\namefont\color{name}{\@name}\par}
        \end{minipage}
        &\begin{tabular}{>{\color{accent}}l}
            \personalinfofont\@personalinfo\par
        \end{tabular}
    \hfill%
    \end{tabular}
    \vspace{6pt}}

\newcommand{\cvsection}[2][]{%
    \nointerlineskip\vspace{18pt}%
    \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
    {\color{heading}\cvsectionfont{#2}}
    \vspace{0pt}}

\newcommand{\cvsubsection}[1]{%
    \vspace{12pt}
    {\color{subheading}\normalsize\bfseries{#1}\par}
    \vspace{6pt}}

\newcommand{\cvevent}[4]{%
    \vspace{6pt}
    {\color{accent}\textbf{#1}}
    \ifstrequal{#2}{}{}{\textit{\color{accent}--~#2,}}
    \ifstrequal{#3}{}{}{{\color{accent}#3}}
    \par
    \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\MakeUppercase{#4}}}}
    \normalsize\par}

\newcommand{\cvskill}[1]{
    \small{#1}\par}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

\AtBeginDocument{%
    \pagestyle{empty}
    \color{body}
    \raggedright}
