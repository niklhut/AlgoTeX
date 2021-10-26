\def\fileversion{1.3.4}
\def\filedate{2021/07/26}

% Sets the LaTeX version for the package to work.
\NeedsTeXFormat{LaTeX2e}
% Identification of the class and its date and version.
\ProvidesClass{fopslides} [\filedate\space\fileversion\space]



% \DeclareGraphicsExtensions{.pdf,.png,.jpg}
\RequirePackage{pagecolor} % Used for dark Mode
\ExplSyntaxOn
\bool_gset_false:N \g_dark_mode_bool
\bool_gset_false:N \g_is_summary_bool
\bool_gset_false:N \g_is_main_file_bool
\bool_gset_false:N \g_ptxcd_ex_load_common_bool
\bool_gset_true:N \g_ptxcd_ex_fancy_rowcolor_bool
\tl_gclear_new:N \datename
\tl_gset:Nn \datename {Datum}
\tl_gclear_new:N \g_rubos_external_label_prefix_tl
\tl_gset:Nn \g_rubos_external_label_prefix_tl {ext:}
\prop_new:N \g_ptxcd_template_opts_prop

\tl_gclear_new:N \g_rubos_keys_tl
\tl_gset:Nn \g_rubos_keys_tl {
    boxarc .code:n = \prop_gput:Nnn \g_ptxcd_template_opts_prop {boxarc} {#1},
    boxarc .initial:n = {0pt},
    boxarc .default:n = {3pt},
    dark_mode .code:n = \pagecolor{rubos@anthrazitgrau}\color{white}\selectcolormodel{RGB}\bool_gset_true:N \g_dark_mode_bool,
    load_common .bool_gset:N = \g_ptxcd_ex_load_common_bool,
    load_common .initial:n = false,
    load_common . default:n = true,
    default_row_color .bool_gset_inverse:N = \g_ptxcd_ex_fancy_rowcolor_bool,
    default_row_color .initial:n = false,
    default_row_color .default:n = true,
    shell_escape .bool_gset:N = \g_rubos_shell_escape_bool,
    shell_escape .initial:n = true,
    shell_escape .default:n = true,
    main .bool_gset:N = \g_is_main_file_bool,
    main .initial:n = false,
    main .default:n = true,
}
% Additional Class Options
\exp_args:Nno \keys_define:nn {ptxcd/exercise} { \g_rubos_keys_tl }
% Compatibility with older versions (We can't use version check makros before loading the class)
\exp_args:Nno \keys_define:nn {TUDa/pub} { \g_rubos_keys_tl }
\ExplSyntaxOff

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{tudabeamer}}
\ProcessOptions\relax
% \ProcessKeyvalOptions{boxarc}\relax
\LoadClass[]{tudabeamer}

%Includes
\RequirePackage{float}
\RequirePackage{minted}
\RequirePackage[babel]{csquotes}
\RequirePackage{media9}
\RequirePackage{animate}
\RequirePackage[overlay]{textpos}
\RequirePackage{tuda-pgfplots}
\RequirePackage[utf8]{inputenc}
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage{listings}
% \RequirePackage[style=numeric]{biblatex}
\RequirePackage{amsmath, amsthm, amssymb}
\RequirePackage[squaren]{SIunits}
\RequirePackage[straightvoltages]{circuitikz}
\RequirePackage{caption}[2013/01/01] % needs v3.3 or newer
\RequirePackage{tikz}
\RequirePackage{tabularx,colortbl}
\usetikzlibrary{matrix, calc, positioning, chains, shapes,arrows}

\ExplSyntaxOn
\def\fopexercise@boxarc{\prop_item:Nn \g_ptxcd_template_opts_prop {boxarc}} % Used for Code Blocks, Info boxes, etc.
\tl_new:N \l_listings_boxed_options_tl
\keys_define:nn { listings/boxed }
{
    caption .tl_set:N = \l_listings_boxed_caption_tl,
    shortcaption .tl_set:N = \l_listings_boxed_shortcaption_tl,
    label .tl_set:N = \l_listings_boxed_label_tl,
    unknown .code:n =
    \tl_put_right:NV \l_listings_boxed_options_tl \l_keys_key_tl
    \tl_put_right:Nn \l_listings_boxed_options_tl { = #1 , },
}
\box_new:N \l_listings_boxed_box

\lstnewenvironment{blstlisting}[1][]
{
    \keys_set:nn { listings/boxed } { #1 }
    \exp_args:NV \lstset \l_listings_boxed_options_tl
    \hbox_set:Nw \l_listings_boxed_box
}
{
    \hbox_set_end:
    \cs_set_eq:cc {c@figure} {c@lstlisting}
    \tl_set_eq:NN \figurename \lstlistingname
    \tl_if_empty:NF \l_listings_boxed_caption_tl
    {
        \tl_if_empty:NTF \l_listings_boxed_shortcaption_tl
        {
            \captionof{figure}{\l_listings_boxed_caption_tl}
        }
        {
            \captionof{figure}[\l_listings_boxed_shortcaption_tl]{\l_listings_boxed_caption_tl}
        }
        \tl_if_empty:NF \l_listings_boxed_label_tl { \label{\l_listings_boxed_label_tl} }
    }
    \leavevmode\box_use:N \l_listings_boxed_box
}

\newcommand{\slidehead}{\frametitle{\insertsectionhead} \framesubtitle{\insertsubsectionhead}\vspace{3mm}}
\newcommand{\tocslide}{\begin{frame}[t]\frametitle{Inhaltsverzeichnis}\vspace{3mm}{\small\tableofcontents[subsectionstyle=shaded]}\end{frame}}
\prg_new_conditional:Nnn \__ptxcd_if_dark_mode: {T,F,TF} {
    \bool_if:NTF \g_dark_mode_bool {
        \prg_return_true:
    } {
        \prg_return_false:
    }
}
\cs_set_eq:NN\IfDarkModeT \__ptxcd_if_dark_mode:T
\cs_set_eq:NN\IfDarkModeF \__ptxcd_if_dark_mode:F
\cs_set_eq:NN\IfDarkModeTF \__ptxcd_if_dark_mode:TF
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,minted}
\ExplSyntaxOff
% Minted Line Number Styling
\renewcommand{\theFancyVerbLine}{\tikz{\coordinate(a);\node[text width=5mm,inner sep=0pt,align=center]{\ttfamily\textcolor{white}{\scriptsize\arabic{FancyVerbLine}}};}}

% Environment für meinen Code-Style (Arg 1 = minted Options, Arg 2 = tcolorbox Options)
\definecolor{codebg}{RGB}{22,43,58}
\newtcblisting{codeBlock}[2][]{
    listing engine=minted, % Minted verwenden
    colback=\IfDarkModeTF{codebg}{black!10!\thepagecolor}, %Hintergrundfarbe
    colframe=black!70, % Randfarbe
    coltext=.,
    listing only,  % Sonst will er den Plain Text nach dem Minted Listing noch anfügen
    frame hidden,
    boxrule=0pt,
    arc=3pt,
    % hbox, % This option could be used to limit the Length of Code Blocks automatically, but does not work with the minted Line Numbers
    title style=\IfDarkModeTF{accentcolor!60!black}{black!90},
    minted style=\IfDarkModeTF{paraiso-dark}{friendly}, %Sieht actually worse aus imo
    minted language=java, % Sprache setzen
    minted options={ %Minted Optionen
            linenos=true,
            numbersep=3mm,
            texcl=true,
            #1 % weitere optionen für Minted zulassen
        },
    left=7.1mm, % Links Platz lassen
    enhanced, % Erlaubt uns, den ramen zu zeichnen
    fonttitle=\sffamily, % Titelschriftart auf 
    overlay={ % Für Grauen Bereich links
            \begin{tcbclipinterior}
                \fill[black!70] (frame.south west) rectangle ([xshift=5mm]frame.north west); % Zeilennummernbereich färben
            \end{tcbclipinterior}
        },
    #2 % Weitere Argumente zulassen
}
