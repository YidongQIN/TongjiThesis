\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{tongjithesis}
[2019/06/21 Tongji University Thesis Template modified by YidongQIN]
\hyphenation{Tongji-Thesis}
\def\tongjithesis{\textsc{Tongji~\LaTeX{}~Thesis}}
\def\tongjiname{\raisebox{-0.1em}{\TJTextLogo[black]{1em}}}
\def\version{3}

%% 参数前缀
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=tongji,
  prefix=tongji@,
  setkeys=\kvsetkeys}
% 学位类型
  \newif\iftongji@master
  \newif\iftongji@doctor
  \define@key{tongji}{degree}{%
    \tongji@masterfalse
    \tongji@doctorfalse
    \expandafter\csname tongji@#1true\endcsname}
% 数字式引用 以及 作者-年份引用
  \newif\iftongji@numeric
  \tongji@numerictrue% 默认为数字式引用
  \newif\iftongji@authoryear
  \define@key{tongji}{bibtype}{%
    \tongji@numericfalse
    \tongji@authoryearfalse
    \expandafter\csname tongji@#1true\endcsname}
% 学术型|专业型|同等学力
  \newif\iftongji@academic
  \tongji@academictrue% 默认为学术型
  \newif\iftongji@profession
  \newif\iftongji@equaleducation
  \define@key{tongji}{degreetype}{%
    \tongji@academicfalse
    \tongji@professionfalse
    \tongji@equaleducationfalse
    \expandafter\csname tongji@#1true\endcsname}
% 章节题目中的编号数字字体
  \newif\iftongji@rmtitlenum
  \tongji@rmtitlenumtrue% 默认衬线
  \newif\iftongji@sftitlenum% 无衬线半角字体
  \newif\iftongji@heititlenum% 黑体
  \define@key{tongji}{titlenum}{%
    \tongji@rmtitlenumfalse
    \tongji@sftitlenumfalse
    \tongji@heititlenumfalse
    \expandafter\csname tongji@#1true\endcsname}
% 脚注中的编号数字形式
\newif\iftongji@pifont
\tongji@pifonttrue% 默认衬线
\newif\iftongji@circle% 采用圆圈字体
\newif\iftongji@normal% 原始的数字
\define@key{tongji}{footnotenum}{%
  \tongji@pifontfalse
  \tongji@circlefalse
  \tongji@normalfalse
  \expandafter\csname tongji@#1true\endcsname}
% 封面的 electronic 选项（打印时删除）且尽量避免空白页
\DeclareBoolOption{electronic}
% 论文是否保密
\DeclareBoolOption{secret}
% bottom margins 选项
  % 如果没有调用\raggedbottom，那么tex就会尽量使得所有page的bottom margins相等。
  % 而这个命令就是告诉tex不要这么搞，即允许不同page的不一样，方便一大段材料跨页排版。
\DeclareBoolOption{raggedbottom}
% 参数传递给 ctexbook 模版
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexbook}}
% 设置以下参数的默认值为true。
\kvsetkeys{tongji}{
  raggedbottom,
  }% 未加入的参数，\DeclareBoolOption 导致其默认false
\ProcessKeyvalOptions*

%% 参数检查
% 杜绝非法的degree选项。
\iftongji@master\relax\else
  \iftongji@doctor\relax\else
    \ClassError{tongjithesis}{Please specify thesis degree in option: \MessageBreak degree=[master | doctor]}{}
  \fi
\fi
% 杜绝非法的 bibtype 选项。
\iftongji@numeric\relax\else
  \iftongji@authoryear\relax\else
    \ClassError{tongjithesis}{Unknown bib type option.\MessageBreak Please check your bib type option.}{}
  \fi
\fi
% 杜绝非法的 degreetype 选项。
\iftongji@academic\relax\else
  \iftongji@profession\relax\else
    \iftongji@equaleducation\relax\else
      \ClassError{tongjithesis}{Unknown degree type option.\MessageBreak Please check your degree type option.}{}
    \fi
  \fi
\fi
% 杜绝非法的 titlenum 选项。
\iftongji@rmtitlenum\relax\else
  \iftongji@sftitlenum\relax\else
    \iftongji@heititlenum\relax\else
      \ClassError{tongjithesis}{Unknown title number font option.\MessageBreak Please check your titlenum option.}{}
    \fi
  \fi
\fi
% 使用 \XeTeX\ 引擎时，\pkg{fontspec} 宏包会被 \pkg{xeCJK} 自动调用。
% 传递给 \pkg{fontspec} 宏包 \option{no-math} 选项，避免部分数学符号字体自动调整为 CMR。
% 其他引擎下没有这个问题，这一行会被无视。
\PassOptionsToPackage{no-math}{fontspec}
% 将伪粗体与伪斜体的选项传递给xeCJK package
\PassOptionsToPackage{AutoFakeBold=1.2,AutoFakeSlant}{xeCJK}
% 使用 CTeX 宏包的默认中文字体配置，支持不同引擎
\LoadClass[a4paper,openany,UTF8,zihao=-4,scheme=plain]{ctexbook}
% 判断是否运行在xetex模式。
\RequirePackage{ifxetex}
\ifxetex\relax\else\ClassWarning{TongjiThesis}{XeLaTex Compiler Required \MessageBreak Without XeLaTeX, somefeatures like addCJKfontfeatures and hyperref won't work}{}\fi
% xparse 提供了 \newcommand 的一种高性能的替代，即 \NewDocumentCommand
\RequirePackage{xparse}
% etoolbox 引入了 LATEX kernel commands 的不同实现，但功能一样。
\RequirePackage{etoolbox}
% environ 创建新的环境
\RequirePackage{environ}
% 分章节独立编译
\RequirePackage{subfiles}

%% Layout布局设置
% 页面纸张设置
\RequirePackage{geometry}% [showframe]
  \geometry{
    a4paper,% 210 * 297mm
    nomarginpar,% 即\marginparwidth=0pt and \marginparsep=0pt
    hcentering,% 将hmarginratio设为1:1，即left=right
    left=31.7mm,% 注意left=right
    includehead=true,% body 部分包含top
    top=20.0mm,% Word 模板页眉顶端距离20mm
    headheight=5.4mm,% 上缘页边距25.4mm-top=5.4mm
    headsep=14bp,% 文本距离页眉底线0.7行=14bp
    includefoot=false,% body部分不包含bottom
    bottom=25.4mm,% 校方模板底面页边距
    footskip=5.4mm,% \footskip指的是baseline of last line of text and baseline of footer的距离
    }
% 页眉页脚\pkg{fancyhdr} 设置
\RequirePackage{fancyhdr}% 定义种页眉页脚格式：
  % {tongji@empty}：页眉页脚都没有
  % {tongji@plain}：只显示页脚的页码
  % {tongji@headings}：页眉页脚同时显示
  \fancypagestyle{tongji@empty}{%
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
    }
  \fancypagestyle{tongji@plain}{%
    \fancyhead{}
    \fancyfoot[C]{\songti\wuhao\thepage}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}}
  \fancypagestyle{tongji@headings}{%
    \fancyhead{}
    \fancyhead[RO]{\wuhao\songti\leftmark}
    \fancyhead[LE]{\wuhao\songti\tongji@schoolname~\tongji@capply~\tongji@cheadingtitle}
    \fancyfoot{}
    \fancyfoot[C]{\songti\wuhao\thepage}
    \renewcommand{\headrulewidth}{0.5pt}
    \renewcommand{\footrulewidth}{0pt}}
  \fancypagestyle{tongji@appendix@heading}{% 附录页眉样式类似 headings
    \fancyhead{}
    \fancyhead[RO,LE]{\wuhao\songti\tongji@schoolname~\tongji@capply~\appendixname}% 不确定页眉是否左右一致
    \fancyfoot{}
    \fancyfoot[C]{\songti\wuhao\thepage}
    \renewcommand{\headrulewidth}{0.5pt}
    \renewcommand{\footrulewidth}{0pt}
}
% 论文整体版面布置分为三部分
\renewcommand\frontmatter{%
  \tjclearpage
  \@mainmatterfalse
  \pagenumbering{Roman}
  \pagestyle{tongji@headings}
  }
\renewcommand\mainmatter{%
  \tjclearpage
  \@mainmattertrue
  \pagenumbering{arabic}
  \pagestyle{tongji@headings}
  }
\renewcommand\backmatter{%
  \tjclearpage
  \@mainmattertrue
}
% 创建空白页的宏包
\RequirePackage{emptypage}
\newcommand{\tjclearpage}% 如果是紧凑版，则尽量少空页
  {\iftongji@electronic{\clearpage}\else{\cleardoublepage}\fi}
% Tikz 绘制的封面中的同济 Logo
\RequirePackage{tjlogo}

%% 字体
%% 中文字体已经由ctexbook文档类型接管（调用 xeCJK）
% \setmainfont{Source Serif Pro}% 只是展示和测试字体命令
% \setsansfont{Source Sans Pro}% 建议用 ctex 的功能成体系地更改字体
% \setmonofont{Source Code Pro}% 不建议手动单独更改
% \setCJKmainfont{思源宋体 CN}% 思源字体与常用 Word 中易字体差距很大
% \setCJKsansfont{思源黑体}% 且多种字重很复杂
% 特别地，设置章节标题中的编号字体
\def\tongji@title@font{% 在 \ctexset 的 numberformat 中调用
  \iftongji@rmtitlenum\rmfamily\else% 常用的 Roman 衬线字体
    \iftongji@sftitlenum\sffamily\else% 默认的无衬线字体
      \iftongji@heititlenum\heitinumber\fi% 黑体，分隔号（.）为全角宽度
    \fi
  \fi
}
\newfontfamily\heitinumber{SimHei}% 用 fontspec 宏包跨过 ctex 直接调用使用黑体
%% 英文字体设置 Times New Roman，Helvetic.
% 这是txfonts的替代品，即txfonts.sty分成了俩独立的package：newtxtext 和 newtxmath
\RequirePackage[defaultsups]{newtxtext}
\RequirePackage{newtxmath}
% 使用 Courier 等宽字体
\RequirePackage{courier}
%% 字号的实现 https://tex.stackexchange.com/questions/112492/setfontsize-vs-fontsize
\def\tongji@define@fontsize#1#2{%
  \expandafter\newcommand\csname #1\endcsname[1][1.3]{%
    \fontsize{#2}{##1\dimexpr #2}\selectfont}}
% \fontsize{size}{skip} 其中skip就是行之间的baseline to baseline的距离，即行距。
  % 关于 #1 \dimexpr #2 就是#1和#2相乘，其中\dimexpr来自etex宏包。
  % 以上的例子用\tongji@define@fontsize{chuhao}{42bp}展开就是这样：
  % \newcommand \chuhao [1][1.3]{\fontsize{42bp}{#1\dimexpr 42bp}\selectfont}
  % 其中[1][1.3]表示只有一个参数，该参数默认为1.3
\tongji@define@fontsize{chuhao}{42bp}
\tongji@define@fontsize{xiaochu}{36bp}
\tongji@define@fontsize{yihao}{26bp}
\tongji@define@fontsize{xiaoyi}{24bp}
\tongji@define@fontsize{erhao}{22bp}
\tongji@define@fontsize{xiaoer}{18bp}
\tongji@define@fontsize{sanhao}{16bp}
\tongji@define@fontsize{xiaosan}{15bp}
\tongji@define@fontsize{sihao}{14bp}
\tongji@define@fontsize{banxiaosi}{13bp}
\tongji@define@fontsize{xiaosi}{12bp}
\tongji@define@fontsize{dawu}{11bp}
\tongji@define@fontsize{wuhao}{10.5bp}
\tongji@define@fontsize{xiaowu}{9bp}
\tongji@define@fontsize{liuhao}{7.5bp}
\tongji@define@fontsize{xiaoliu}{6.5bp}
\tongji@define@fontsize{qihao}{5.5bp}
\tongji@define@fontsize{bahao}{5bp}
% 相比CTeX的\zihao{}，此处可以更加方便的同时更改字号与行距。
%% normal正文字体：小四号 (12bp) 字，行距为固定值 20 bp
  % \DeclareRobustCommand{\fontsize}[2]{\set@fontsize \baselinestretch {#1}{#2}}
  % \selectfont 用来使得字体的配置生效
  % 而\@setfontsize具有三个参数，对于上面的用法\@setfontsize\normalsize{12bp}{20bp}
  % 展开为：
  % \@nomath\normalsize
  % \ifx\protect\@typeset@protect\let\@currsize\normalsize\fi
  % \fontsize{12bp}{20bp}\selectfont
  % 第一行确保LaTeX to disallow \normalsize in math mode。
  % 第二行将\@currsize设为\normalsize，第三行调用\fontsize，字体12bp，行距20bp
\renewcommand\normalsize{%
  \@setfontsize\normalsize{12bp}{20bp}%
  \abovedisplayskip=10bp \@plus 2bp \@minus 2bp% 以下\abovedisplayskip等用来调整math相关的skip
  \abovedisplayshortskip=10bp \@plus 2bp \@minus 2bp
  \belowdisplayskip=\abovedisplayskip
  \belowdisplayshortskip=\abovedisplayshortskip
}

% 图形基础宏包
\RequirePackage{graphicx}
% 并排图形用\pkg{subcaption}取代老旧的\pkg{subfigure}、\pkg{subfig}
\RequirePackage[labelformat=simple]{subcaption}

% 表格基础宏包
\RequirePackage{array}% array支持数学模式表格，例如矩阵
\RequirePackage{booktabs}% 基础三线表\cs{toprule}，\cs{midrule}，\cs{bottomrule}
\RequirePackage{makecell}% 行内换行

% 公式基础宏包 AmSTeX
\RequirePackage{amsmath}
% 允许太长的公式断行、分页等。
\allowdisplaybreaks[4]
\renewcommand\theequation{\ifnum \c@chapter>\z@ \thechapter.\fi\@arabic\c@equation}
% 美化的微分符号 d
\newcommand*{\dif}{\mathop{}\!\mathrm{d}}

% 定理环境，启用 amsmath 选项确保兼容性
\RequirePackage[amsmath,thmmarks,hyperref]{ntheorem}

% 列表
\RequirePackage[shortlabels]{enumitem}
\setlist{nosep}% 移除所有列表环境的竖向默认间距，以符合中文习惯。

% \pkg{pdfpages} 宏包便于插入扫描后的授权页和声明页 PDF 文档。
\RequirePackage{pdfpages}
\includepdfset{fitpaper=true}

% 参考文献使用 biblatex 宏包执行 gb7714-2015 格式
\iftongji@numeric
  \RequirePackage[backend=biber,style=gb7714-2015,gbpub=false,isbn=false,doi=false,gbtitlelink=true,url=false,sortlocale=zh__pinyin,gbnamefmt=lowercase]{biblatex}
\else\iftongji@authoryear% 若需author-year格式，style选择为gb7714-2015ay
    \RequirePackage[backend=biber,style=gb7714-2015ay,gbpub=false,isbn=false,doi=false,gbtitlelink=true,url=false,sortlocale=zh__pinyin,gbnamefmt=lowercase]{biblatex}
  \fi
\fi
% 选项 gbpub=false 用于去除参考文献中的出版地不详
% 后续选项 isbn 和 doi 选项同理

% PDF书签
\RequirePackage[% 设置 PDF 电子书签格式
  CJKbookmarks=true,% 删除原 \ifxetex 判断
  linktoc=all,
  bookmarksnumbered=true,
  bookmarksopen=true,
  bookmarksopenlevel=1,
  breaklinks=true,
  plainpages=false,
  pdfpagelabels=true,
  ]{hyperref}
\iftongji@electronic
  \hypersetup{% 电子版彩色超链接
    colorlinks=true,
    linkcolor=blue,
  }
\else
  \hypersetup{% 付印版黑色超链接
    colorlinks=false,
    pdfborder=0 0 0,% 移除超链接的 color box 边框
  }
\fi
% 超链接URL的字体格式设置
% \urlstyle{tt}% 四选一设置 \url{} 的字体样式 tt/rm/sf/same（与前文保持一致）
\def\UrlFont{\ttfamily\small}% 可以用此命令精确设定 URL 的字体样式
\RequirePackage{bookmark}% 生成 PDF 电子书签

%% 浮动对象和文字之间的距离
% 语法举例：{10pt plus 1.0pt minus 2.0pt} The plus and minus parts allow the space to stretch or shrink (the greater they are, the more it stretches or shrinks when needed).
\setlength{\floatsep}{12bp \@plus4pt \@minus1pt}% vertical distance between two floats
\setlength{\intextsep}{12bp \@plus4pt \@minus2pt}% distance between floats inserted inside the page text (using h) and the text proper. 对于插入正文中的float用\intextsep调节图片上部和下部距离正文的距离。
\setlength{\textfloatsep}{12bp \@plus4pt \@minus2pt}% distance between floats on the top or the bottom and the text
\setlength{\@fptop}{0bp \@plus1.0fil}
\setlength{\@fpsep}{12bp \@plus2.0fil}
\setlength{\@fpbot}{0bp \@plus1.0fil}

%% 浮动体页面布局优化
% 防止浮动对象占据过多的文本页面，防止在很大空白的浮动页上放置很小的图形。
\renewcommand{\textfraction}{0.15}% 一个page的text的最小比例是0.15，默认是0.2。当然如果浮动对象占的比例太大，就会移到另一个页面。
\renewcommand{\topfraction}{0.85}% 页面顶部至多有0.85的空间被浮动对象填充。
\renewcommand{\bottomfraction}{0.65}% 同理，底部的。
\renewcommand{\floatpagefraction}{0.60}% float page(no text, only floats)被浮动对象占的比例最少是0.6

%% 浮动体标题样式
% 图表标题、表内容字体为宋体五号
\let\old@tabular\@tabular
\def\tongji@tabular{\wuhao[1.5]\old@tabular}
% \DeclareCaptionLabelFormat 来自 subcaption 宏包。
\DeclareCaptionLabelFormat{tongji}{{\wuhao[1]\normalfont #1~#2}}
% \DeclareCaptionLabelFormat{tongji}{{\wuhao[1]\hei #1~\rmfamily #2}}% 去掉图表号后面的冒号。
% 图序与图名文字之间空一个汉字符宽度。
\DeclareCaptionLabelSeparator{tongji}{\hspace{1em}}
\DeclareCaptionFont{tongji}{\wuhao[1]}
\captionsetup{labelformat=tongji,labelsep=tongji,font=tongji}
% 图：caption 在下，段前空 6 磅，段后空 12 磅，单倍行距
\captionsetup[table]{position=top,aboveskip=6bp,belowskip={12bp-\intextsep}}
% 表：caption 在上，段前空 6 磅，段后空 6 磅，单倍行距
\captionsetup[figure]{position=bottom,aboveskip=6bp,belowskip={6bp-\intextsep}}
\captionsetup[sub]{font=tongji,aboveskip=6bp,belowskip=6bp}
\renewcommand{\thesubfigure}{(\alph{subfigure})}% 子图编号是 1.a, 1.b
\renewcommand{\thesubtable}{(\alph{subtable})}% 子表编号是 1.a, 1.b

% 圆圈数字序号 \textcircled 的美化
\RequirePackage{pifont}% 传统方案 pkg{pifont}
\newcommand{\circlerm}[1]{\ding{\numexpr\value{#1}+171\relax}}% 衬线字体数字
\newcommand{\circlesf}[1]{\ding{\numexpr\value{#1}+191\relax}}% 非衬线字体数字
\RequirePackage{tikz}% 绘图方案 pkg{Tikz}
\DeclareRobustCommand{\tikzcircnum}[1]{\tikz[baseline=(char.base)]{\node[shape=circle,draw,inner sep=0.5pt] (char) {#1};}}% 绘制圆
\let\textcircled@old\textcircled
\RenewDocumentCommand\textcircled{s m}{% 带*则替换为新 Tikz 命令
  \IfBooleanTF{#1} {\tikzcircnum{#2}} {\textcircled@old{#2}}
  }

\AtBeginDocument{%
  \pagestyle{tongji@empty}
  \pagenumbering{roman}
  % 通过 \pkg{fancyhdr} 定义的样式在第一次被调用时会修改 \cs{chaptermark}，这会导致页眉信息错误（多余章号并且英文大写）。thuthesis对此专门进行了解决：
  % \renewcommand{\chaptermark}[1]{\@mkboth{\CTEXthechapter\hspace{\ccwd}#1}{}}}
}
% 中文文档设置
\ctexset{%
  punct=quanjiao,% 标点符号用全角
  space=auto,
  autoindent=true,% 首行缩进 2 字符
  chapter={% 章标题
    name={第,章},
    format=\centering\heiti\bfseries\sanhao[1],% format 章节标题的全局格式，作用域为章节名字和随后的标题内容。
    nameformat={},% 默认\huge\bfseries，需要取消
    numberformat=\tongji@title@font\xiaosan,% 默认为\huge，改为比中文小一号
    aftername=\hspace{\ccwd},% 章编号与标题内容间距一个汉字
    titleformat={},% 默认\Huge\bfseries，需要取消
    afterindent=true,% afterindent 选项用于设置章节标题后首段的缩进。
    beforeskip={10bp},% 章节标题前的垂直间距 24bp 扣除 headsep=14bp
    afterskip={18bp},% 章节标题与后面下方之间的距离
    lofskip=0pt,% 插图目录（.lof）章之间的插图标题的距离
    lotskip=0pt,% 表格目录（.lot）章之间的表格标题的距离
    pagestyle={tongji@headings},% 这句用来保证章首页的页眉正确
  },
  section={% 一级节标题
    format=\heiti\xiaosan[1],
    % nameformat={},% 默认已经为空
    nameformat=\tongji@title@font\sihao,% 默认为空，改为比中文小一号
    aftername=\hspace{\ccwd},% 节编号与标题内容默认\quad，改为间距一个汉字
    % titleformat={},% 默认已经为空
    afterindent=true,
    beforeskip={24bp \@plus 1ex \@minus .2ex},
    afterskip={6bp \@plus .2ex},
  },
  subsection={
    format=\heiti\sihao[1],
    nameformat=\tongji@title@font\banxiaosi,% 默认为空，改为比中文小一号
    aftername=\hspace{\ccwd},% 章节编号与标题内容间距一个汉字
    afterindent=true,
    beforeskip={12bp \@plus 1ex \@minus .2ex},
    afterskip={6bp \@plus .2ex},
  },
  subsubsection={
    format=\heiti\xiaosi[1],% 即 normalsize
    nameformat=\tongji@title@font\dawu,% 默认为空，改为比中文小一号
    aftername=\hspace{\ccwd},% 章节编号与标题内容间距一个汉字
    afterindent=true,
    beforeskip={12bp \@plus 1ex \@minus .2ex},
    afterskip={6bp \@plus .2ex},
    aftername=\hspace{\ccwd},
  },
  paragraph={
    name={（,）},
    number=\arabic{paragraph},
    format=\heiti\normalsize,% 即小四
    nameformat=\tongji@title@font\dawu,
    aftername=\hspace{0pt},
    titleformat={},
    runin=false,
    afterindent=true,
    beforeskip={0bp \@plus .2ex},
    afterskip={0bp \@plus .2ex},
  },
  subparagraph={
    format=\normalsize,
    number=\tikzcircnum{\arabic{subparagraph}},%\circlerm{subparagraph},% pifont 有点小
    nameformat=\tongji@title@font\dawu,
    aftername=\hspace{0.5em},
    aftertitle=\hspace{0pt},
    runin=true,
    indent=2em,
    afterindent=true,
    beforeskip={0bp \@plus .2ex},
    afterskip={0bp \@plus .2ex},
    },
  appendixname=附录,
  contentsname=目录,
  listfigurename=插图索引,
  listtablename=表格索引,
  figurename=图,
  tablename=表,
  bibname=参考文献,
  indexname=索引,
}%

%% 章节标题命令，可以更方便地设置是否出现在目录
% \NewDocumentCommand旨在替代\newcommand，由xparse宏包提供。
  % 这个命令的灵活性体现在参数的指定上。如{s o m o}中：
  % s 表示 optional star，如果这个命令调用的时候带*，那么就会产生一个\BooleanTrue，进而可以使用\IfBooleanF，\IfBooleanT和\IfBooleanTF；
  % o 表示可选参数；
  % m 表示强制参数。
  % 举个例子：对于's o o m',如果输入‘*[Foo]{Bar}’，那么#1 = \BooleanTrue，#2 = Foo，#3 = -NoValue-，#4 = Bar。
% 下面定义的用法是：\cs{tongji@chapter*}\oarg{tocline}\marg{title}\oarg{header}
% 其中 tocline 是出现在目录中的条目，如果为空则此 chapter 不出现在目录中，如果省略表示目录出现 title；title 是章标题；header 是页眉出现的标题，如果忽略则取 title。
\newcounter{tongji@bookmark}
\NewDocumentCommand\tongji@chapter{s o m o}{
  \IfBooleanF{#1}{% 如果调用的时候不带*，那么 #1 = \BooleanFalse
    \ClassError{tongjithesis}{You have to use the star form: \string\tongji@chapter*}{}
  }% 在cls中的\chapter命令必须带*号。
  \clearpage
  \chapter*{#3}% 生成不计入目录的章节标题，后续手动控制它是否加入目录或电子书签
  % \IfValueTF {<argument>} {<true code>} {<false code>}
  \IfValueTF{#2}{% 若第一个o对应的可选参数没有提供，那么#2=-NoValue-,此判断为false。
    \ifthenelse{\equal{#2}{}}{% 第二个参数有、且空，此 chapter 不出现在目录中，只出现电子书签中
      \addtocounter{tongji@bookmark}\@ne
      \bookmark[dest=\HyperLocalCurrentHref, level=0]{#3}
      }
    {% 第二个参数有，且不为空，则将其加入目录
      \addcontentsline{toc}{chapter}{#3}
    }
  }
  {% 若没有指定该参数（即#2=-NoValue-），表示目录出现title
    \addcontentsline{toc}{chapter}{#3}
  }%
  \IfValueTF{#4}{% 提供了第四个参数，即header
    \ifthenelse{\equal{#4}{}}
      {\@mkboth{}{}}% #4=空，则左、右页眉为空、为空
      % 此命令等同于\markboth{left}{right}
      % 也就是定义一个“left-hand heading” 和“righthand heading”
      % 这样，\leftmark读出来的就是设的left，\rightmark就是设的right
      {% #4 不为空，则成为页眉
        \thispagestyle{fancy}
        \fancyhead{}
        \fancyhead[RO,LE]{#4}
        \fancyfoot{}
        \fancyfoot[C]{\songti\wuhao\thepage}
        \renewcommand{\headrulewidth}{0.5pt}
        \renewcommand{\footrulewidth}{0pt}
        }
      }
    {% 如果没有提供 #4 即 header 参数，则取 title 作为页眉 header 出现的标题，
      \thispagestyle{fancy}
      \fancyhead{}
      \fancyhead[RO,LE]{#3}
      \fancyfoot{}
      \fancyfoot[C]{\songti\wuhao\thepage}
      \renewcommand{\headrulewidth}{0.5pt}
      \renewcommand{\footrulewidth}{0pt}
    }
}

%% 非正文页面
% * \make页面：中文封面、EngCover、书脊、版权授权、原创声明、
% * \frontmatter：中文摘要、Abastract、目录
% * \backmatter：致谢、参考文献、附录、个人简历
% * 可选：符号说明（主要符号对照表）、图索引、表索引、公式索引
%% 封面信息收集
\def\tongji@def@term#1{%
  % \define@key{fam}{key}{对参数#1的处理,即handler}
  \define@key{tongji}{#1}{\csname #1\endcsname{##1}}
  \expandafter
  \gdef\csname #1\endcsname##1{%
  \expandafter
  \gdef\csname tongji@#1\endcsname{##1}}
  \csname #1\endcsname{}}
  % 语法解释 使用\tongji@def@term{secretlevel}，展开之后就是：
  % \define@key{tongji}{secretlevel}{\secretlevel{#1}}
  % \gdef\secretlevel#1{\gdef\tongji@secretlevel{#1}}
  % \secretlevel{}
% 参数定义
  % 定义密级参数。
  \tongji@def@term{secretlevel}
  \tongji@def@term{secretyear}
  % 论文中英文题目
  \tongji@def@term{ctitle}
  \tongji@def@term{cheadingtitle}
  \tongji@def@term{etitle}
  % 作者、导师、副导师（校外）老师。
  \tongji@def@term{cauthor}
  \tongji@def@term{csupervisor}
  \tongji@def@term{cassosupervisor}
  \tongji@def@term{eauthor}
  \tongji@def@term{esupervisor}
  \tongji@def@term{eassosupervisor}
  % 学位中英文
  \tongji@def@term{cdegree}
  \tongji@def@term{edegree}
  % 院系中英文名称。
  \tongji@def@term{cdepartment}
  \tongji@def@term{edepartment}
  % 学位中英文名称。
  \tongji@def@term{cmajor}
  \tongji@def@term{emajor}
  % 论文成文日期。
  \tongji@def@term{cdate}
  \tongji@def@term{edate}
  % 为了兼容老版本同济模板的封面定义,仍然使用majorfirst，majorsecond
  % 这里majorfirst表示学科门类如工学、理学，majorsecond表示一级学科或二级学科。
  \tongji@def@term{cmajorfirst}
  \tongji@def@term{cmajorsecond}
  \tongji@def@term{emajorfirst}
  \tongji@def@term{emajorsecond}
  % 定义基金支持
  \tongji@def@term{cfunds}
  \tongji@def@term{efunds}
  % 学号
  \tongji@def@term{studentnumber}
  % 校名变量 schoolname & eschoolname 已经写入了 .cfg 文件

% 通过 \cs{tongjisetup} 统一设置封面信息。
% 为了简化操作界面，提供一个 \cs{tongjisetup} 命令支持 key/value 的方式来设置。
% key 就是前面各个设置项的名字。
% 只能设置普通项，不支持环境项，
% 如 \texttt{cabstract} 和 \texttt{eabstract}。
% 由于这些设置项被 \cs{makecover} 调用，所以此命令需要其之前被调用。
\def\tongjisetup{\kvsetkeys{tongji}}

%% 中文封面页面
\newlength{\tongji@title@width}% 用于计算申请人信息首列宽度
% \def\tongji@put@title#1{\makebox{\hb@xt@\tongji@title@width{#1}}}% 用于分散对齐
% 其中的生成给定长度的一个水平盒子 \hb@xt@ = \hbox to
\newcommand{\chncover}{
  \phantomsection
  \bookmark[dest=\HyperLocalCurrentHref, level=0]{封面}
  \centering\noindent\normalsize
  \parbox[b][36bp][t]{\textwidth}{% 左上角电子标识、右上角的保密标识，通常无用
    \iftongji@electronic{% 是否电子版
      {\kaishu\xiaosi\bfseries\itshape\tongji@thesistype（打印时删除）}}
    \fi
    \hfill
    \iftongji@secret{% 是否保密
      \fbox{\sanhao\tongji@secret@title}}
    \fi
  }

  \parbox[t][2.6cm][t]{\textwidth}{% logo控制高度2.6cm
    \centering%\includegraphics[width=10cm]{tjlogofull.eps}% 校徽校名logo
    \parbox[b][25mm][c]{30mm}{\TJLogo[black]{21mm}}
    \parbox[b][25mm][c]{65mm}{
      \TJTextLogo[black]{16mm}
      {\xiaoer TONGJI UNIVERSITY}
    }
  }

  \vspace*{14bp}% \\[14bp]%二号字段前0.5行=0.5*22*1.3
  \parbox[t][3cm][t]{\textwidth}{% 学位类型
    \centering{\erhao[1]\lishu\tongji@capply}% 硕/博学位类型
    \iftongji@academic{\empty}% 学位类型补充
      \else \iftongji@profession{
        \par \vspace*{0.4cm} {\sihao[1]\bfseries\lishu（专业学位）}
        \par \vspace*{0.9cm}}
        \else \iftongji@equaleducation{
          \par \vspace*{0.4cm} {\sihao[1]\bfseries\lishu（同等学力）}
          \par \vspace*{0.9cm}}
        \fi
      \fi
    \fi
  }

  \parbox[t][6cm][t]{\textwidth}{% 标题与基金
    \centering
    {\erhao[1]\bfseries\heiti\tongji@ctitle}% 中文题目
    \par \vspace{12bp}
    \ifx\cfunds\@empty% 基金，若有
      \else{\xiaosi\tongji@cfunds}
    \fi
  }

  \parbox[t][8.5cm][t]{143mm}{% 申请人信息
    \fangsong\sanhao[1.75]% 目测1.75倍行距。
    \setlength{\extrarowheight}{4pt}
    \iftongji@profession% 确定第一列的宽度
      \setlength{\tongji@title@width}{6em}
      \else \ifx\tongji@cassosupervisor\@empty
        \setlength{\tongji@title@width}{4em}
      \else
        \setlength{\tongji@title@width}{5em}
      \fi
    \fi
    \centering% \hspace{4.5em}% 校方模版要求的缩进 4.5em 是相对其文本框
    \begin{tabular}{W{s}{\tongji@title@width}@{}>{：\,}l}
      姓名 & \tongji@cauthor \\
      学号 & \tongji@studentnumber \\
      所在院系 & \tongji@cdepartment \\
      \iftongji@profession% 专业型仅中间两行是例外
        专业学位名称 & \tongji@cmajorfirst \\
        专业领域  & \tongji@cmajorsecond \\
      \else
        学科门类 & \tongji@cmajorfirst \\
        学科专业 & \tongji@cmajorsecond \\
      \fi
      指导教师 & \tongji@csupervisor \\
      \ifx\tongji@cassosupervisor\@empty% 若是空，没有任何命令
      \else% 若有副指导
        副指导教师 & \tongji@cassosupervisor \\
      \fi
      \end{tabular}
  }

  \vfill
  \sanhao\songti\tongji@cdate% 日期
  \tjclearpage
}% 结束中文封面页

%% English Cover 英文封面页面
\newcommand{\engcover}{
  \phantomsection
  \bookmark[dest=\HyperLocalCurrentHref, level=0]{Cover}
  \centering\noindent\normalsize
  \vspace*{24bp}% labels on top

  \parbox[t][2.6cm][t]{\textwidth}{% logo
    \centering%\includegraphics[width=10cm]{tjlogofull.eps}
    \parbox[b][25mm][c]{30mm}{\TJLogo[black]{21mm}}
    \parbox[b][25mm][c]{65mm}{
      \TJTextLogo[black]{16mm}
      {\xiaoer TONGJI UNIVERSITY}
    }
  }

  \vspace*{14bp}% \\[14bp]% 二号字段前0.5行=0.5*22*1.3
  \parbox[t][3cm][t]{\textwidth}{% Eng degree type
    \centering\sihao\tongji@eapply
    }

  \parbox[t][6cm][t]{\textwidth}{% title and fund
    \centering
    \xiaoer{\bfseries\sffamily\tongji@etitle}% Eng title
    \par \vspace{12bp}
    \ifx\efunds\@empty\else% fund
      \xiaosi[1.3]{\tongji@efunds}
      \fi
    }

  \parbox[t][8.5cm][t]{\textwidth}{% candidate's info
    \sanhao[1.75]\centering% \hspace{4.5em}% 若按照校方模版的要求缩进4.5字符，则太偏右
    \begin{tabular}{l<{:}l}
      Candidate         & \tongji@eauthor       \\
      Student Number    & \tongji@studentnumber \\
      School/Department & \tongji@edepartment   \\
      Discipline        & \tongji@emajorfirst   \\
      Major             & \tongji@emajorsecond  \\
      Supervisor        & \tongji@esupervisor \\
      \ifx\tongji@eassosupervisor\@empty\else
        Associate Supervisor & \tongji@eassosupervisor \\
      \fi
    \end{tabular}
  }

  \vfill
  \sanhao\rmfamily\tongji@edate% date
  \tjclearpage
}% end of english cover

%% 书脊页面，无外框线，含三个默认参数（标题 作者 “同济大学”）
\NewDocumentCommand{\shuji}{%
  O{\tongji@cheadingtitle} O{\tongji@cauthor} O{\tongji@schoolname}}{%
  \noindent\hfill
  \phantomsection
  \bookmark[dest=\HyperLocalCurrentHref, level=0]{书脊}%
  \hspace{0.65em}% 旋转导致基线偏移
  \rotatebox[origin=lt]{-90}{% 旋转
    \makebox[\textheight]{%
      \sihao\fangsong\bfseries% 四号 仿宋 加粗
      \ziju{0.14}% 字距 1.14*14=15.96≈16 相当于行距
      \ifxetex\addCJKfontfeatures{RawFeature={vertical:}}\fi
        \hspace{3cm \@plus 2cm \@minus 1cm}%上下边距5cm可能导致无法完成排版
        #1% 页眉 heading 中的标题（不可换行）
        \hspace{2em \@plus 2em}%
        #2% 作者
        \hspace{2em \@plus 2em}%
        #3% 学校名
        \hspace{3cm \@plus 2cm \@minus 1cm}%
        }%
    }%
    \hfill% 文本框framebox右边的hfill以居中排布
    \tjclearpage%
  }
% 重做书脊，有外框线，三个默认参数（标题 作者 “同济大学”）
\NewDocumentCommand{\bookspine}{%
  O{\tongji@cheadingtitle} O{\tongji@cauthor} O{\tongji@schoolname}}{%
  \newgeometry{vmargin=1cm,hmargin=3cm}%
  \noindent\hfill% 边框左右各有一个hfill保证framebox居中
  \phantomsection%
  \bookmark[dest=\HyperLocalCurrentHref, level=0]{书脊框}%
  \setlength{\fboxrule}{1pt}%
  \framebox{%
    \hspace{0.65em}% 旋转导致基线偏移
    \rotatebox[origin=lt]{-90}{% 旋转
      \makebox[276mm]{% 不能撑满页面，会导致多余空白页
        \sihao\fangsong\bfseries% 四号 仿宋 加粗
        \ziju{0.14}% 字距 1.14*14=15.96≈16 相当于行距
        \addCJKfontfeatures*{RawFeature={vertical}}%
          \hspace{3cm \@plus 2cm \@minus 1cm}%上下边距5cm可能导致无法完成排版
          #1% 页眉 heading 中的标题（不可换行）
          \hspace{2em \@plus 2em}%
          #2% 作者
          \hspace{2em \@plus 2em}%
          #3% 学校名
          \hspace{3cm \@plus 2cm \@minus 1cm}%
          }%
      }%
    }%
  \hfill% 文本框framebox右边的hfill以居中排布
  \restoregeometry%
  \tjclearpage
}

%% 组装中英文封面与书脊
\NewDocumentCommand{\makecover}{s m}{
  \input{#2}% 首先读取 cover.tex 中的标题、作者等信息
  \hypersetup{% 设置PDF属性为文档元数据
    pdftitle={\tongji@cheadingtitle},
    pdfauthor={\tongji@cauthor},
    pdfsubject={\tongji@schoolname\tongji@capply},
    pdfcreator={\tongji@eauthor},
    pdfproducer={\tongjithesis}}
  \begin{titlepage}% 生成封面页
    % \tolerance=10000% 改变排版容忍度
    \hbadness=10000% 改变水平排版警报等级
    \vbadness=10000% 改变竖向排版警报等级
    \chncover% 中文封面
    \engcover% English Cover
    \IfBooleanTF#1{\relax}{\bookspine}% 不带星则生成书脊（默认带框书脊），带星则无书脊
  \end{titlepage}
  \let\@tabular\tongji@tabular
}

%% 原创声明 支持导入扫描页
\NewDocumentCommand{\makedeclarepage}{o}{
  \phantomsection
  \IfNoValueTF{#1}
    {\tongji@declareshortname@mk}% 没有PDF就生成电子版
    {\includepdf{#1}} % 有PDF就导入扫描页
  \bookmark[dest=\HyperLocalCurrentHref, level=0]{\tongji@declarename}
  \tjclearpage
}
% 电子版原创性声明页面
\newcommand{\tongji@declareshortname@mk}{%
  \vspace*{18pt}
  \begin{center}
    \xiaoer\heiti\bfseries\tongji@declarename
  \end{center}

  \vspace*{18pt}
  \sihao[2.03]\tongji@declaretext

  \vspace*{8.9cm}
  \begingroup
    \parindent0pt\xiaosi
    \hspace*{5.5cm}\tongji@authorsig\relax\hspace*{1cm}\\
    \hspace*{9.5cm}\tongji@date\relax\hspace*{1cm}
  \endgroup
}

%% 授权页面，修改思路同原创声明
\NewDocumentCommand{\makeauthorizationpage}{o}{
  \phantomsection
  \IfNoValueTF{#1}
    {\tongji@authorization@mk}% 没有PDF就生成电子版
    {\includepdf{#1}}% 有PDF就导入扫描页
  \bookmark[dest=\HyperLocalCurrentHref, level=0]{\tongji@authtitle}
  \tjclearpage
}
% 电子版授权页面
\newcommand{\tongji@authorization@mk}{%
  \vspace*{18pt}
  \begin{center}
    \xiaoer\heiti\bfseries\tongji@authtitle
  \end{center}

  \vspace*{18pt}
  \sihao[2.03]\tongji@authorization

  \vspace*{7.9cm}
  \begingroup
    \parindent0pt\xiaosi
    \hspace*{5.5cm}\tongji@authorsig\relax\hspace*{1cm}\\
    \hspace*{9.5cm}\tongji@date\relax\hspace*{1cm}
  \endgroup
}

%% 摘要
  % 摘要以环境的形式，保存内容留待以后使用。
  % 使用 \pkg{environ} 的\cs{Collect@Body} 来实现。
  \newcommand{\tongji@@cabstract}[1]{\long\gdef\tongji@cabstract{#1}}
  \newenvironment{cabstract}{\Collect@Body\tongji@@cabstract}{}
  \newcommand{\tongji@@eabstract}[1]{\long\gdef\tongji@eabstract{#1}}
  \newenvironment{eabstract}{\Collect@Body\tongji@@eabstract}{}
  % 中英文关键词分别用 \cs{ckeywords} 和 \cs{ekeywords} 收集
  \def\tongji@parse@keywords#1{
    \define@key{tongji}{#1}{\csname #1\endcsname{##1}}
    \expandafter\gdef\csname tongji@#1\endcsname{}
    \expandafter\gdef\csname #1\endcsname##1{
      \@for\reserved@a:=##1\do{
        \expandafter\ifx\csname tongji@#1\endcsname\@empty\else
          \expandafter\g@addto@macro\csname tongji@#1\endcsname{%
            \ignorespaces\csname tongji@#1@separator\endcsname}
        \fi
        \expandafter\expandafter\expandafter\g@addto@macro%
          \expandafter\csname tongji@#1\expandafter\endcsname\expandafter{\reserved@a}}}}
  % 文档内部通过 \cs{tongji@ckeywords} 和 \cs{tongji@ekeywords} 引用
  \tongji@parse@keywords{ckeywords}
  \tongji@parse@keywords{ekeywords}

% 原本摘要命令\tongji@makeabstract独立
\newcommand{\makeabstract}{%
  \tjclearpage\normalsize% always openright for Abstract
  \tongji@chapter*[]{\cabstractname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\cabstractname]
  \tongji@cabstract
  \vspace*{12bp}\par
  \setbox0=\hbox{{\bfseries\tongji@ckeywords@title}}
  \noindent\hangindent\wd0\hangafter1
  \box0\tongji@ckeywords% 结束中文摘要，以下 Abstract
  \tongji@chapter*[]{\eabstractname}[\wuhao\tongji@eschoolname~\tongji@edegree~\eabstractname]
  \tongji@eabstract
  \vspace*{12bp}\par
  \setbox0=\hbox{{\bfseries Key Words:\enskip}}
  \noindent\hangindent\wd0\hangafter1
  \box0\tongji@ekeywords
}

%% 目录
% 章节编号等级从 \chapter=0 至 \subparagraph=5
\setcounter{secnumdepth}{5}
% 目录显示等级，最多三层，即: x.x.x
\setcounter{tocdepth}{2}
% 目录生成
% 减小目录项中的导引小点跟页码之间的留白
\renewcommand\tableofcontents{%
  \tongji@chapter*[]{\contentsname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\contentsname]
  \xiaosi[1.5]\@starttoc{toc}\normalsize\clearpage}
% 同济要求目录的行距为18磅 = 1.5 * 16(16是小四的默认行距)
\RequirePackage{titletoc}
\contentsmargin{0em}
\titlecontents{chapter}[0em]{\filright}%
  {\xiaosi\songti\thecontentslabel\enspace}%
  {\xiaosi[1.5]\songti}{\dotfill\contentspage}[\addvspace{0pt}]
\titlecontents{section}[1em]{\addvspace{0pt}}%
  {\xiaosi\songti\thecontentslabel\enspace}%
  {\xiaosi\songti}{\dotfill\contentspage}[\addvspace{0pt}]
\titlecontents{subsection}[2em]{\addvspace{0pt}}%
  {\xiaosi\songti\thecontentslabel\enspace}%
  {\xiaosi\songti}{\dotfill\contentspage}[\addvspace{0pt}]

%% 致谢
\NewDocumentEnvironment{acknowledgement}{}{%
\tongji@chapter*[\tongji@ackname]{\tongji@ackname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\tongji@ackname]
\fangsong\xiaosi[1.5]}{\clearpage\normalsize}

%% 参考文献
% 兼容参考文献的老命令
\let\inlinecite\parencite
% 参考文献字体
\renewcommand{\bibfont}{\wuhao[1.6]\songti}% 宋体五号
% \setlength{\bibitemsep}{0ex}
\setlength{\bibnamesep}{0ex}
\setlength{\bibinitsep}{0ex}
% 解决参考文献页眉问题（当存在附录时，参考文献页眉会出问题）
\newcommand\printTJbibliography{\printbibliography[heading=bibintoc]\clearpage}

%% 附录
\let\tongji@appendix\appendix
\renewenvironment{appendix}{% 附录环境
  \ctexset{% 附录仍属于mainmattertrue才能正确编号成附录A的形式。
    % 因此，此处的pagestyle仍然会沿用前面设的chapter的pagestyle，而需要更改附录的页眉，即需要重新设置一下页眉。
    chapter/pagestyle={tongji@appendix@heading}% 这句用来保证章首页的页眉正确
    }
  \pagestyle{tongji@appendix@heading}% 这一句是保证附录非章首页的其他页面的页眉正确。
  \let\title\tongji@appendix@title
  \tongji@appendix}{%
  \let\title\@gobble\clearpage}

%% 个人简历
\newenvironment{resume}{%
  \tongji@chapter*{\tongji@resume@title}[\wuhao\songti\tongji@schoolname~\tongji@capply~\tongji@resume@title]
  \wuhao[1.6]
  \setlength{\parindent}{0em}
  \setlist[enumerate,1]{label=[\arabic*], labelindent=*, leftmargin=2em}
  }{\clearpage}
\newcommand{\resumesect}[1]{\vspace{2em}{\bfseries\wuhao\heiti{#1}}}

%% 可选索引：符号说明（主要符号对照表）、图索引、表索引、公式索引
% 主要符号对照表
\newenvironment{denotation}[1][2cm]{
  % 若需对照表出现在目录中则 \tongji@chapter*{\tongji@denotation@name}
  \tongji@chapter*[]{\tongji@denotation@name}[\wuhao\songti\tongji@schoolname~\tongji@capply~\tongji@denotation@name]
  \vspace*{18bp}\xiaosi[2]
  \begin{tongji@denotation}[labelwidth=#1]
  }{%
  \end{tongji@denotation}
  \clearpage
}
\newlist{tongji@denotation}{description}{1}% 基于 description 的专用列表样式
\setlist[tongji@denotation]{%
  nosep,
  font=\normalfont,
  align=left,
  leftmargin=!,% sum of the following 3 lengths
  labelindent=2em,
  labelwidth=2.5cm,
  labelsep*=0.5cm,
  itemindent=0pt,
}
% 图、表、公式索引在目录中的表现样式
\def\tongji@starttoc#1{% #1: float type, prepend type name in \listof*** entry.
  \let\oldnumberline\numberline
  \def\numberline##1{\oldnumberline{\csname #1name\endcsname\hspace{0.4em}##1}}
  \@starttoc{\csname ext@#1\endcsname}
  \let\numberline\oldnumberline}
\NewDocumentCommand\tongji@listof{s m}{
  \IfBooleanTF#1
  {% 带星 \listof* 的不加入目录
    \tongji@chapter*[]{\csname list#2name\endcsname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\csname list#2name\endcsname]
    \tongji@starttoc{#2}
    \clearpage}
  {% 不带星 \listof 加入目录
    \tongji@chapter*{\csname list#2name\endcsname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\csname list#2name\endcsname]
    \tongji@starttoc{#2}
    \clearpage}
  }
% 图索引
\RenewDocumentCommand\listoffigures{s}{\IfBooleanTF#1
  % 调用\listoffigures \listoffigures*的不同也分开定义
  {\tongji@listof*{figure}}
  {\tongji@listof{figure}}
}
% \renewcommand*\l@figure{\addvspace{6bp}\@dottedtocline{1}{0em}{4em}}
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{4em}}
\renewcommand{\@dotsep}{2}% 改变索引中点间距
% 表索引
\RenewDocumentCommand\listoftables{s}{\IfBooleanTF#1
  {\tongji@listof*{table}}
  {\tongji@listof{table}}
}
\let\l@table\l@figure
% 公式索引
  % 如果要编号最好用 equation 环境；
  % 如果是其它编号环境，请手动添加添加 \cs{equcaption}。
  % 用法：\cs{equcaption}\marg{counter}
  % \marg{counter} 指定出现在索引中的编号，一般取 \cs{theequation}。
  % 如果你是用 \pkg{amsmath} 的 \cs{tag}，那么默认是 \cs{tag} 的参数；
  % 除此之外可能需要你手工指定。
\def\ext@equation{loe}% \LaTeX\ 默认没有公式索引，此处定义自己的 \cs{listofequations}
\def\equcaption#1{% 本命令只是为了生成公式列表，所以这个 caption 是假的。
  \addcontentsline{\ext@equation}{equation}{\protect\numberline{#1}}}
\NewDocumentCommand\listofequations{s}{\IfBooleanTF#1
  {\tongji@listof*{equation}}
  {\tongji@listof{equation}}
}
\let\l@equation\l@figure

% 在模板文档结束时即装入配置文件，这样用户就能在导言区进行相应的修改。
\AtEndOfClass{\input{tongjithesis.cfg}}
\AtEndOfClass{\sloppy}

\endinput
%% End of file `tongjithesis.cls'.
