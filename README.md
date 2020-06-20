同济 $\LaTeX{}$ 大论文模板
======

为了**简化大论文的排版工作**，决心采用LaTeX进行论文撰写。
感谢校友 marquistj13 的 [TongjiThesis 模版](https://github.com/marquistj13/TongjiThesis)。

本 README 记录了自己在 $\LaTeX$ 方面踩过的坑，以及按照自己的思路进行的调整。

因为自己的 $\LaTeX$ 知识水平太低，对主要宏包的运用可谓 NAIVE，身边也没有人能传授排版的经验，最终也只能做了一点微小的工作。

但学到了一项新技能也足以让人感到 EXCITED！

# 主要改动 CHANGES

因为模板调整与论文撰写同时进行，而自己的大论文放在了 private repo 中，所以这个仓库是粗暴地把我所采用样式相关文件复制了出来而已。
也即：丢失了调整过程的步骤，没有 commit 历史可供参考。

> 以下称同济大学研究生院的《同济大学学位论文写作示例（2017）》与《同济大学研究生学位论文写作规范（试行）（2017）》为“校方模版”；
> 称 marquistj13 的 TongjiThesis 模版为“原模版”。

本节总述了本模板相较于原模版的修改。
部分修改较繁琐、或需要展开说明，则在后续独立一节详述。

## 手动安装模板文件

手动安装了 `.cls`、`.sty` 等模板所用的文件，从而方便了分章节编译、方便了多项目使用同一模板。

主要步骤是：
1. 用 cmd 命令 `kpsewhich --var-value=TEXMFHOME` 得知路径 `X:/xxx/texmf`
2. 在其中继续创建 3 层文件夹 `tex/latex/tongjithesis/`，
3. 把 `.cls` 和 `.sty` 文件放进文件夹 `tongjithesis/`。

具体参见 [处理（改良）](#%e5%a4%84%e7%90%86%e6%94%b9%e8%89%af) 一节。

## 封面布局格式调整

微调了封面的布局。
但是校方模板中也有不少含糊，所以最终效果必有纰漏。

1. 校方模版中校徽都不舍得提供向量图。

   借用了 [关于Logo #20](https://github.com/marquistj13/TongjiThesis/issues/20) 中 [chennanzhang](https://github.com/chennanzhang) 用宏包 `Tikz` 绘制的学校 Logo。

   不过，其中的距离尺寸都是手动测量的，与校方模板终归有偏差。
   原 `\includegraphics` 仍予以保留。

2. 各个元素之间的间距没有出确定值，只是大概的“换一行”、“空半行”。

3. 封面内容的行距被 Word 的“对齐到网格”控制，导致展示的样式与本模板有偏差。

   比如申请人个人信息表格的行距明显不是单倍，根据目测调整为 1.75 倍。

4. 申请人个人信息表格要求“左侧缩进 4.5 字符”，竟然是相对于一个文本框、并不是页面位置。
   于是也只能通过目测，设置表格为居中。

5. 申请人个人信息表格首列分散对齐，采用了 `array` 宏包的 `W{s}{width}` 生成一个相当于 `\makebox` 的列。
   * 分散对齐，普遍采用 `\makebox[width][s]{...text...}` 命令。
   * 删除了原本的 `\tongji@put@title{}` 方案。
     + 每一行重复出现，显得臃肿，故类比添加数学环境到列的方法，将此命令添加到列定义中，失败。
     + 初见令我混乱，比如 `\hb@xt@` 语法生僻。
   * 尝试 `ragged2e` 时，命令 `\justifying` 使得首列宽度错误，且此宏包已经无人维护，故放弃。

6. 从 `.cfg` 文件中删除了首列文字配置，删除了分隔符冒号。
   * 主要处于代码美观简介考虑，因为“姓名”、“学号”和“指导教师”等文字并不会复用，所以没必要用变量替代。
   * 冒号作为分隔符，可以在列定义的时候用 `>{：}l` 语法插入右列，不需要单独一列 `c` 放置。
     + 插入左列（首列）会导致列宽不等，没有深究原因。

所以，封面的排版完全依赖自己的朴素的审美观，不能保证符合要求。
但起码，已经尽力使得中英文封面对应对象对齐。

在新的校方模板中，封面 `electronic` 和 `secret` 选项均已失去了意义；
但考虑到日后万一又加了回来，故不做删除、予以保留。

此外，尝试采用`CTeX` 提供的 `\zihao{}` 命令，但是发现反而没有原模版的旧命令好用。
因为校方模版许多地方要求同时更改字号和行距，旧命令可以很方便地执行。

## 封面与书脊页

把中文封面、英文封面和书脊统一到一个新命令 `\makecover` 中。
它的必需参数就是 `cover.tex` 的文件位置，并且接受一个星号（asterisk）以控制是否生成书脊。

`\makecover{../pages/cover}`

中英文封面加上原创性声明和授权书页面，在 `frontmatter` 之前，页面布局由 `\AtBeginDocument{}` 中的 `\pagestyle{tongji@empty}` 和 `\pagenumbering{roman}` 控制，即在 PDF 中采用**小写罗马字母**页码（文件中不会打印编号，只有电子书签）。

从而，可以与它们之后的 `\frontmatter` （含中文摘要、英文摘要和目录）的**大写罗马字母**页码有所区分。

为中文封面和英文封面添加了 PDF 书签。

## 书脊页

新 `\bookspine` 命令生成形如校方模版的带边框的书脊页面，并且放到 `\makecover` 中，可被自动调用。
边框 `\framebox` 内的盒子 `\makebox` 尺寸不宜撑满 `\textheight`，因为若如此做，考虑到 frame 的尺寸，会在书脊页之前产生额外的空白页面。

原 `\shuji` 命令不删除，因为要用它生成**真**书脊（没有边框的样式）。
因为没有边框，所以也不需要用 `\newgeometry` 生成页边距很小的版面了。

特别地，书脊中使用了字形旋转机制。
然而，最初在排版时就发现，旋转后的基线对齐是有问题的。
实际上，这个问题是 `XeLaTeX` 的底层问题。

![](https://i.stack.imgur.com/vbiGK.png)

* [Adjust position of vertical text for better alignment](https://sourceforge.net/p/xetex/bugs/164/)
* [XeTeX 是如何旋转字形的，是否实现有误？](https://github.com/CTeX-org/forum/issues/93)

通过目测，认为偏移大概是半个字符；
现在可以得知，汉字旋转后，以行基线 baseline 居中对齐。
所以，手动加入 `\hspace{0.5em}` 使其居中。
然而，经过测量发现，对齐还是有问题。

经过测试，`\hspace{0.65em}` 始得汉字基本处于 framebox 的中央。
猜测是跟仿宋字体的宽高比 $0.7$ 有关。
四号字高度是 $14.0$ pt（$1.00$ em），即 frame 的横向尺寸。
四号字显示宽度为 $0.7 \times 14 = 9.8$ pt（$0.70$ em），所以反转后基线左、右侧各 $4.9$ pt。
则汉字轴线到右侧 frame 的距离依然是四号字高度 $14.0$ pt。
则为了使得汉字轴线在 frame 居中，左侧需要填充的偏移距离是 $14.0-4.9=9.1$ pt（$0.65$ em）。

不过，如果同时出现旋转和非旋转的字体，那么这个偏移问题还是没有解决。
最明显的例子，就是标题中的汉字旋转后，与英文字母或模板中的 $\LaTeX{}$ 符号，有明显的上下偏移。
需要独立调用书脊的命令 `\bookspine[]` 输入标题参数（定义时可选参数要用 `[]` 输入），并且用 `\raisebox{-0.35em}{eng text}` 手动移动英文部分的对齐。
![](https://i.stack.imgur.com/UrLrp.png)
> 基线与底线的偏移量与字体相关，比如中易宋体 SimSun 基线与底线偏移 $36/256$，而思源宋体 Source Sans 基线与底线偏移 $120/1000$。

## 声明页

原创性声明和授权书页面从 `\makecover` 中移除，现在需要手动执行。

并利用宏包 `{pdfpages}` 使其可以接收一个 PDF 扫描件替换电子版。

* `\makeauthorizationpage[../pages/scan.pdf]% 可导入扫描页`
* `\makedeclarepage 不导入扫描页则生成电子版`

```latex
\makeauthorizationpage% 生成电子版授权书
\makedeclarepage[../data/scandecl.pdf]% 插入扫描版的《原创声明》PDF文件
```

## PDF 元数据

用 `\hypersetup{\pdftitle={}}` 把文档的元数据写入 PDF 文件的属性。

标题、作者等元数据都写在 `cover.tex` 之中、在 `\makecover` 时读取，所以在此之后才能执行 PDF 元数据写入。

## 紧凑布局模式

仅为了自己写大纲用的，创建了一套更加紧凑的布局。
原本命名为 `draft` 草稿选项，但是发现这是个冲突的选项。
考虑到 `electronic` 也是个没有用的选项，于是就合并了。

具体使用方法是：
1. 开启文档类型中的一个新增的参数 `electronic=true`，它会使得原本的多处 `\cleardoublepage` 变为 `\clearpage`。
2. 使用 `\makecover*{}` 则不生成书脊，或覆盖封面页面 `\begin{titlepage}\chncover\end{titlepage}` 连英文封面也不产生。
3. 不调用`\makeauthorizationpage` 或 `\makedeclarepage`，即不生成声明页面。
4. 后续部分根据要求取舍，比如索引、致谢等。

> 这些特殊页面的生成命令的解耦就是为了能够更加自由的控制。
> 当然，代价就是新使用者可能会觉得麻烦。

## 索引修复

修复了索引命令（`\listof...`）加星号（asterisk）之后，仍然出现在目录页面的错误。

## 交叉引用命令

交叉引用时，前缀与编号之间通常建议用不中断空格 `~` 连接，以避免不良的分行，打断了“图”、“表”、“第”等前缀词、编号数字和可能的后缀“节”、“章”。

```latex
% 交叉引用的命令
\newcommand*{\reftab}[1]{\tablename~\ref{#1}}
\newcommand*{\reffig}[1]{\figurename~\ref{#1}}
\newcommand*{\refalg}[1]{\ALG@name~\ref{#1}}
\newcommand*{\reflst}[1]{\lstlistingname~\ref{#1}}
\newcommand*{\refequ}[1]{\equationname（\ref{#1}）}
\newcommand*{\refsec}[1]{第~\ref{#1}~节}
\newcommand*{\refcha}[1]{第~\ref{#1}~章}
```

比如说，`见\refsec{}。` 可以直接生成“见第~X.X~节。”这样的语句。
而且，好处是 VS Code 依然识别这个命令是 `\ref`，可以自动联想到 label。

为了配合它的使用，还在 VS Code 中制定了一个 `tjref` 的 snippet。

```json
"TJ Ref with Prefix": {
  "prefix": "tjref",
  "body": [
    "\\ref${1|tab,fig,sec,cha,alg,lst,equ|}{$1:$2}"
  ],
  "description": "TJ Ref with Prefix"
},
```

但是此时发现，这个功能直接用 snippet 完成仿佛更加合适、灵巧。
因此又放弃了这些命令。

附上取而代之的 snippet。

```json
"Ref with Prefix": {
	"prefix": "pref",
	"body": [
		"${1|第,图,表,公式,算法,代码|}~\\ref{$0}${2|~,所示,~节,~章|}"
	],
	"description": "Ref with Prefix"
},
```

## 模板结构调整

按照 [clsguide](http://texdoc.net/texmf-dist/doc/latex/base/clsguide.pdf) 的理解，宏包 package 是更加具有通用性的文件，而 cls 类文件仅仅对一类文档有用。
所以，按照自己的思路重新调整了cls和sty文件。

* `.cls` 旨在满足**基本要求**：

  《同济大学学位论文写作规范》等校方模版的要求，学术论文习惯（例如三线表格）。

* `.sty` 提供**扩展工具**：

  此类并不是每个人都需要，完全可以注释、删除掉。

比如原本 `.cls` 中有细致地美化了脚注 `\footnote` 命令。
因为下划线、脚注并不常用，而且校方模版中也没有样式说明，所以移入了 `.sty` 文件。

同理，表格类宏包和设置（比如跨页长表格）基本都从 `.cls` 移至 `.sty`；
`.cls` 文件中只有基本的三线表格实现。
特殊环境（算法环境，源代码环境）也放入了 `.sty` 文件。

实际上，本模板的 `tongjithesis.sty` 文件完全可以祛除。

尽量将相关的设置集中在一处，便于调整。

注释掉若干没有工作的宏包。在确定其工作机理和生效位置前，暂不删除。

删除了部分过时的注释。

## 章节样式设置

出于个人审美，章节名称中的数字编号比汉字小一号。

> 以前 CAD 课的要求“数字要比汉字小一号”，算是一个纪念画图日子的小彩蛋。

章节名称中的数字字体可利用宏包 `{fontspec}` 控制，将原 `romantitle` 布尔型选项改为可以三选一的 `titlenum` 选项：
* `\rmfamily`
* `\sffamily`
* `SimHei`

具体可见 [章节标题样式设置](#%E7%AB%A0%E8%8A%82%E6%A0%87%E9%A2%98%E6%A0%B7%E5%BC%8F%E8%AE%BE%E7%BD%AE) 一节的内容。

开启了 `\paragraph` 和 `\subparagraph` 即 4、5 级层次。

## 优化 PDF 电子书签

用 `bookmark` 宏包提供了更方便地生成电子书签。
相比原模版的 `hyperref` 宏包方法，主要优势在于：
1. 可以避免跳转不准的问题，即不需要 `\phantomsection`。
2. 只需要编译一次也能产生正确的电子书签。

值得一提，完整的文档依然需要两次编译，才能：
1. 生成目录；
2. 写入正确的 PDF 页码，即封面小写罗马字母、其他前文大写罗马字母、正文和后文阿拉伯数字。

## URL 链接的样式

通常输入网址的方法有：
1. 默认启用 `url` 宏包，命令`\url{URL}` 直接显示网址，单击打开该网址。
2. 启用 `hyperref` 宏包，命令`\href{URL}{text}` 显示 text，但是单机之后打开 URL 网址。

前者可以在导言区定义 `\urlstyle{xx}`，其中 `xx` 从以下四种默认样式中选择，仅仅更改字体。
* tt 使用等宽字体
* rm 使用衬线字体
* sf 使用非衬线字体
* same 跟上文字体保持一致

如果不满足于仅仅修改字体，可以用命令 `\def\UrlFont{\ttfamily}` 设置更多样式

后者的样式定义，则在 `{text}` 中指定即可。

本模板新定义了命令 `\colorurl`，用于展示 URL。

## 圆圈序号
之前一直困于多级列表与段落的样式过于重合，想寻找中文中常用的、更多的序号样式。
整理脚注的时候，也发现圆圈样式的实现很特别，所以就找到了一篇关于 [带圈数字](https://stone-zeng.github.io/2019-02-09-circled-numbers/) 的实现教程，将部分成果吸纳进了这个模板。
> 也是为了跟老板编的教材保持一致。

1. 传统方法是利用 `pifont` 宏包，它封装了很多PostScript 字体。这也是原模板采用的美化方法。
2. 一个更加灵活的方法，是用大名鼎鼎的 `Tikz` 宏包绘制一个圆形。
   1. 最初找到的是 [LaTeX 工作室](https://www.latexstudio.net/archives/1571.html) 的方案。

   2. 更好的方案是 [StackExchange](https://tex.stackexchange.com/questions/7032/good-way-to-make-textcircled-numbers#) 的方案。相比前者，有两个优势：
      1. 用 `[baseline=(char.base)]` 定位，而不是手动的 $0.7ex$ 上下调整。
      2. 评论区建议了 `\DeclareRobustCommand` 定义。

```latex
% 方案 1 利用 Tikz
\newcommand*{\circled}[1]{\lower.7ex\hbox{\tikz\draw (0pt, 0pt) circle (.5em) node {\makebox[1em][c]{\small #1}};}}
\robustify{\circled}% 依赖于 pkg{etoolbox} 的命令
% 方案 2 利用 Tikz
\newcommand*\circled[1]{\tikz[baseline=(char.base)]{\node[shape=circle,draw,inner sep=2pt] (char) {#1};}}
```

此外，还有提到用 `addfontfeatures{Annotation=2}` 等，但是没有成功。

最终的成果，运用到了 3 处：
1. 脚注的序号现在是一个三选一的命令了，可以选择 **pifont** 或者 **圆圈** 或者 **无修饰**。
2. subparagraph 的序号现在是圆圈数字了。
3. 行内列表的编号。


## 列表样式

利用 `{enumitem}` 宏包预定义了有序列表、无序列表和关键词列表的样式，包括缩进、标签样式和对齐。
还定义了两种行内列表，即不会换行的水平列表。

* inline 是用 “(1)”进行编号的。

* inlinecn 是用“第一”进行编号的。

  + 用到了 `ctex` 的一个汉化特性命令 `\chinese`，从而将数字以中文数字形式输出。

特别地，简历页面有序列表形式预设为 `[1].` 。

## 表格样式

默认的表格内容环境是 `tabular`，其大小是根据内容变化的。

如果表格较多的情况下，统一表格尺寸可能更加美观。原生命令是 `tabular*` 环境，然而其功能较弱。

所以，用宏包 `{tabularx}` 的 `tabularx` 表格环境实现固定宽度的表格。
其提供了 `l c r p` 之外的对齐样式 `X`，会平均分配列宽，列内默认左对齐。

此外，利用宏包 `{array}` 在 `.sty` 中新定义了三种列对齐方式：
* `a{1}` 左对齐
* `s{1}` 居中
* `d{1}` 右对齐

> 记忆方法：左手键盘按键的左、中、右方向。

这三种对齐方式的必需参数为列宽分配权重。
例如 `\begin{tabularx}{16cm}{a{0.75}s{1}d{1.25}X}` 意义是：
第一列左对齐，中列居中，第三列右对齐，且按照 $3:4:5:4$ 的比例分配总计 $16cm$ 的列宽。
* 注意，**权重之和必须等于总列数**，比如该例中 $0.75+1+1.25+1=4$。

## 横置页面
宏包 `{lscape}` 和 `{pdflscape}` 可以产生内容横置的页面。区别是后者会把页面旋转，方便阅读。

此外，宏包 `{rotating}` 可以产生特定的图片或表格环境。

## 下划线

原生的下划线命令 `\underline` 是不能换行的，很多时候不方便使用。
通常，采用 `{ulem}` 宏包提供的下划线更加使用，还有波浪线等多种样式可以选择。

在 `{ulem}` 宏包基础上，还有针对中文汉字的 `{xeCJKfntef}` 宏包可用。
它增加了对汉字的识别能力，可以在标点符号处自动断开。
原模版的 `{CJKfntef}` 已经失效。

## 新增环境类型：算法（伪代码）

采用宏包 `{algorithms}`，它其实是两个宏包 `{algorithm}` 与 `{algorithmic}` 的合集，是最基础的算法排版宏包。

* 前者类似于 `table` 环境，控制算法框为一个浮动体，从而控制其页面位置、组织跨页、添加 caption 和 label 等。

* 后者类似于 `tabular` 环境，生成算法内容。

宏包 `{algorithm}` 文档 <http://mirrors.rit.edu/CTAN/macros/latex/contrib/algorithms/algorithms.pdf>。

## 新增环境类型：源代码

用 `lstlisting` 环境展示源代码。

用 `\lstset{}` 的方式统一设置了布局、对齐、边框和标题位置等通用格式。

用 `\lstdefinelanguage{NewLanguageName}[dialect]{BasedLanguage}{key=value}` 的方法，扩展了 Python 的关键词列表，并据其继续包装了一个可供自定义的语言；同理，把 `OpenBrIM` 设定为一个语言。


可用 `lstdefinestyle={}` 以值对的方式定义样式，即关键词、字符串等不同类型代码的高亮颜色、字体样式等：
1. 基础样式 `monocolor` 是只有黑白，依靠字体区分关键词；
2. 样式 `colored` 是基本的配色方案，可以不依靠宏包 `{color}` 使用，也可以把其中“注释”类型的绿色改为深绿色，以求美观；
3. 针对扩展过后的 Python 建成了一个相对色彩丰富的样式 `colorEX`。

> 不能把 `OpenBrIM` 建立在 XML 之上，否则 tag 不能正常显示 `identifierstyle` 样式。
> 原因是：`listings` 宏包的 XML 语言尚未完成。

所以针对需要的 `OpenBrIM`，特意完成了相关的环境定义：
1. 通用的 `XML` 语言，包括：

   1. tag 用 identifier 实现高亮，
   2. attribute key 用`空格`和`=`作为前后边界定义，高亮形式为 `keyworldstyle`，
   3. attribute value 定义为字符串，
   4. text 信息定义为没有格式的字符串。

2. 仿照 Firefox 浏览器的样式，定义了 `XML` 的高亮格式。

   参照 <https://tex.stackexchange.com/questions/10255/xml-syntax-highlighting> 。

3. 专用 `ParamML` 语言。

   因为通用的 `XML` 在高亮属性的键时，会把作为分界符的`=`一起高亮，效果不甚满意。
   所以，没有从 `XML` 继承定义 `ParamML`，而是重新定义了一种语言及其配套的高亮（仿照OpenBrIM平台样式）。

重定义 `\lstlistingname` 和 `\lstlistlistingname` 以更改环境名。

用 `\lstlistoflisting` 可以生成一个代码索引，类似于 `list of tables` 之类。
* 设置了 `nolol` 的代码不会进入索引。
* 可用下面的命令更改对齐和样式：
  `\renewcommand\l@lstlisting[2]{\@dottedtocline{1}{0em}{2em}{\lstlistingname~#1}{#2}} `。
* 定制了 `listings` 索引页面的页眉、页脚样式。

值得一提的是，在代码块中设置 `name=` 而不设置 `caption=`，则代码索引中就不出现这一项编号了、但仍保留 name。
或许代码不需要全部罗列，那么这可能是更好的解决方案——只有关键代码给出 name 并列入索引。

宏包 `{Listings}` 文档 <http://texdoc.net/texmf-dist/doc/latex/listings/listings.pdf>。

## 页面布置

学校的版面设置要求是“上、下 2.54cm，左、右 3.17cm，页眉、页脚 2.0cm，装订线 0 cm”。
然而，宏包 `{geometry}` 中的参数定义方式和 MS Office Word 有区别。

有两套处理思路：

* 在原模板的基础上，微调尺寸参数。

  ```ini
  ignoreall,
  top=30.34mm,
  headsep=4.94mm,
  headheight=24.81mm,
  bottom=25.4mm,
  footskip=5.4mm,
  ```

* 打开 `includehead` 选项。

  ```ini
  includehead=true,
  top=20.00mm,
  headheight=5.4mm,
  includefoot=false,
  bottom=25.4mm,
  footskip=5.4mm,
  ```

详细解释见 [页面尺寸、页眉页脚尺寸](#geometry-%e9%a1%b5%e9%9d%a2%e5%b0%ba%e5%af%b8%e9%a1%b5%e7%9c%89%e9%a1%b5%e8%84%9a%e5%b0%ba%e5%af%b8) 一节。

## 伪粗体字体复制产生乱码

如果按照原模版中，设置了 `AutoFakeBold=1.2` 会导致从 PDF 中复制加粗的字体时变为乱码。

原因解释见刘海洋在[知乎](https://www.zhihu.com/question/59597144) 的回答。

这个问题在多个学校的论文模版中都有反应，解决方案在 <https://www.zhihu.com/question/32207411>。
最简单的方式是在 `xeCJK` 宏包选项中关闭伪粗体，即 `AutoFakeBold=false`。

此外，在 `CTeX` 的项目主页 issue [xeCJK: 部分汉字的伪粗体在 PDF 文件中无法拷贝或拷贝出异常内容 #353](https://github.com/CTeX-org/ctex-kit/issues/353) 提出，这个问题还与字体选择有关。
Adobe、Fandol、思源黑体/宋体是可以正确复制的，而方正、华文的字体都会出错。

```latex
% 选用 Adobe 字体
\documentclass[fontset=windows]{ctexbook}
% 或者依次手动设定 Adobe 字体
\setCJKmainfont[AutoFakeBold,ItalicFont=AdobeKaitiStd-Regular]{AdobeSongStd-Light}
\setCJKsansfont[AutoFakeBold]{AdobeHeitiStd-Regular}
\setCJKmonofont{AdobeFangsongStd-Regular}

% 选用 Fandol 字体 （缺少生僻字，慎用）
\documentclass[fontset=fandol]{ctexbook}
% 或者依次手动设定 Fandol 字体
\setCJKmainfont[AutoFakeBold]{FandolSong}
\setCJKsansfont[AutoFakeBold]{FandolHei}
\setCJKmonofont{FandolFang}
```

上述字体不一定在系统中安装了，采用前需要确认一下本机的字体库。

按照 `xeCJK` 文档给出的方法，可以用 `fc-list > fontlist.txt` 命令把所有字体的信息输入到一个 `fontlist.txt` 的文本文件中，每一行冒号之前的部分就是字体族名。

特别地，针对中文字体，可以用 `fc-list -f "%{family}\n" :lang=zh > zhfont.txt` 查看。

## 移除 amssymb 包
在更新了 Tex Live 2020 之后，发现了 ```Command `\Bbbk' already defined.``` 的报错。

原因是 `XeLaTeX` 与 `amsfont` 中有了重复定义。
查阅 AMS 宏包，发现 `amssymb` 只是提供了部分数学字符的粗体、而且可以被标准的 `bm` 宏包取代。
故将其移除，仅保留 `amsmath`。

* 未经验证的方案：

  需要把宏包的调用移至 `ctex` 之前，即可避免出错。

## 微分符号

根据 [这篇帖子](https://liam.page/2017/05/01/the-correct-way-to-use-differential-operator/) 为微积分中的 $d$ 符号设定了“左侧有间距、直立体”的命令 `\dif`。

# Geometry 页面尺寸、页眉页脚尺寸

## 页眉尺寸
校方模板页眉部分设置有3个参数：
* 页边距 25.4mm
* 页眉顶端距离 20mm
* 正文距离页眉底端 0.7行、即 14bp

如果按照原 $\LaTeX$ 模板的设置，那么页眉**底缘横线**的位置距离纸张顶部 $top-headsep=20mm$。

```ini
top=25.4mm,
headheight=20mm,
headsep=5.4mm,
```

所以跟校方模板的要求相差一个页眉行高。

在默认设置（`includehead` 和 `includefoot` 选项都是 false）情况下，
若要求排版效果跟校方模版的样本（而不是跟其描述内容）一致，需要如下设置。

```ini
top=30.34mm,
headsep=4.94mm,
headheight=24.81mm,
```

其中，`top` 需要加上 0.7行的高度。
$top = 2.54cm + 0.7*20bp = 25.4mm + 14*(25.4mm/72) = 30.34mm$

用 `headsep` 把页眉“顶”上去。
$headsep = 0.7*20bp = 4.94mm$。

`headheight` 计算页眉行行底到页面上边缘距离，需要页眉顶端距离是加上页眉的行高：
$headheight = 20mm + 10.5bp*1.3 = 24.81mm$。

## 页脚设置
校方模板页脚（页码）部分设置有2个参数：
* 页边距 25.4mm
* 页脚底端距离 20mm

`\footskip` 指的是 baseline of last line of text and baseline of footer 的距离。
按照要求，正好就是页边距减去页码边距 $25.4mm - 20.0mm = 5.4mm$。

## 更加优雅的方案

但是如上处理，发现页眉相关尺寸参数比较“奇怪”，可能回给后续修改者带来困惑。
一个稍微清晰的方案是打开页眉的 `includehead` 选项。

```ini
includehead=true,
top=20.00mm,
headheight=5.4mm,
includefoot=false,
bottom=25.4mm,
footskip=5.4mm,
```

这其实是因为不同的测量点。

## 吐槽

页码是五号字，即 $10.5/72*25.4 = 3.70mm$ 左右。
所以说，这样的设置留给页码上边缘和正文下边缘的距离不足 2mm。

校方模板中，这个“紧凑”的边距并不明显，是因为最后一行如果行距不够的情况，会排入下一页；
从而相当于空出了将近一行的距离，正文底线到页底的边距可能超过 $25.4mm + 20bp = 3cm$；
换句话说，如果全用正文字体多填充几页，就很容易发现这个边距其实挺小的。

页眉部分同理，在 word 中控制“页面上边距 2.54cm，页眉 2.0cm”并且多用正文填充几页，也可以发现，页眉、分割线和正文会挤在一起。

校方的“模板”有的细节经不起推敲，自己取舍吧。

# 章节标题样式设置

## 状况描述

按照手册，`format={}` 可以统一设置整个标题的格式。

最初，发现 `\heiti` 命令对章节编号数字不起作用，仍旧是有衬线字体。
这与校方模版有出入。

在之后的调整中，发现删除 `nameformat=\relax`，`numberformat=\relax` 等语句，会使得章节编号和标题内容字体大小不一。

## 答疑

参考 <https://github.com/CTeX-org/ctex-kit/issues/210> 与 <https://github.com/CTeX-org/ctex-kit/issues/422> 的回答。

> （`\ctexset{}`） 对标题字体的控制，除了 `format` 选项之外，还有 `nameformat`、`numberformat` 和 `titleformat`。
>
> 这三个选项都在 `format` 之后起作用。
> 这里改字号对 chapter 标题无效，是因为它的 nameformat 和 `titleformat` 默认值都是 `\huge\bfseries`，里面的 `\huge` 会覆盖你设置的 `\zihao{4}`。
>
> 需要先清空 `nameformat` 和 `titleformat` 的设置：

```latex
\documentclass[zihao=-4]{ctexbook}
\ctexset{
    chapter/format      = \zihao{4}\bfseries,
    chapter/nameformat  = {},
    chapter/titleformat = {},
    section/format      = \zihao{4},
}
```

> 两种不同排版方案的实现方法不统一，优先级的问题。
>
> `scheme=chinese` 时，章节标题统一由 `format` 给出，而 `nameformat` 与 `titleformat` 为空。
>
> `scheme=plain` 时，章节标题分别由 `nameformat` 与 `titleformat` 给出，而 `format` 为空。这是因为在 LaTeX2e 标准文档类里，「Chapter XX」是用 `\huge` 字号，而标题内容则是用 `\Huge` 字号。
>
> 简单解决方法：`scheme=plain` 时，根据需要清空 `nameformat` 或 `titleformat。`

```latex
\documentclass[scheme=plain]{ctexbook}
\ctexset{
  chapter={
    format=\small,
    titleformat={},
  }
}
```

此外，在 <https://github.com/CTeX-org/ctex-kit/issues/422> 的后续回答中，提到中英文字体不同。

> mohuangrui： 请教一下，对于章节标题，是否可能通过 `format` 实现 中文 调用 `\sffamily` 而 英文和数字 调用 `\rmfamily`？
>
> RuixiZhang42：可以用 `\heiti` 这样的命令，因为只作用于 CJK 文字上。不过这样西文跟中文不太协调，建议谨慎使用
>
> muzimuzhi：字体切换功能，是利用了 xetex 引擎的 char class 机制。粗暴理解，把所有字符按中西文分类，遇到「中-西」边界就切换到西文字体，遇到「西-中」边界就切换到中文字体。[1, Sec. 3] 里有一个简单的例子。
>
> muzimuzhi：zepinglee 提供的建议是正确且有效的。更一般的方案是，通过 `fontspec` 和 `xeCJK` 的 `\new[CJK]fontfamily` 命令，分别定义中西字体切换命令，然后一起使用。

```latex
% def
\newfontfamily\useSomeEnFont{<font name 1>}
\newCJKfontfamily\useSomeEnFont{<font name 2>}
% use
\normalfont\useSomeEnFont\useSomeEnFont
```

## 处理

在 `ctexset` 中，章节标题在不同 schema 下已经有默认值，如果不取消则会继承，所以如果要定制章节标题样式，需要记得取消默认设置。
  * 通常，`\section` 以下的默认设置均为空（`={}`），比较省心。

对于，ctex 的中文字体命令调用了的还是 xeCJK，其**只**对 CJK 中日韩文字有效果，而对英文和数字不起效果。所以采用 `ctex` 提供的 `\songti`，`\heiti` 等命令均不会影响英文字母和数字的字体。

如果必要调整字体，可以用宏包 `{fontspec}` 处理。

1. 最简单的方法是，直接设置全文的 `\sffamily` 字体为黑体，即添加 `\setsansfont{SimHei}` 一句。

   * 然而，黑体作为面向中文的字体，显示字母和数字并不美观。
   * 尤其明显地，章节编号的分隔符（.号）变为全角宽度。

2. 如果放弃“黑体”，可以选择“雅黑”等针对中英文混排优化过的无衬线字体。

3. 然而，即使在 MS Office 中，常用的处理方案也是用有衬线字体。

   * 这也是更加美观的选择。

最终，删除了原 `romantitle` 布尔型选项，仿照 `degreetype` 新增了名为 `titlenum` 的三选一方案（意为 *title* *num*ber）。

* 默认值 `rmtitlenum` 即采用 Times New Roman 衬线字体（`\rmfamily`）；

* 可以选择 `sftitlenum` 即无衬线的半角字体（`\sffamily`）；

* 可以选择 `heititlenum` 校方模版要求的黑体（`SimHei`，不是 `\heiti`），

> 说实话，个人认为黑体数字编号确实不如衬线字体好看；
> 而且分割号（实心圆点）是全角字符，也有点别扭。

## 节外生枝

有时候标题 `第1章` 或 `（1）` 中数字并不居中。

如果前后字体不一样，例如 `nameformat` 与 `numberformat` 分别选用无衬线和衬线字体，或者进行中英文混排时，
好像会触发 `xeCJK` 的 `CJKecglue` 设置，使其自动追加空格。

所以，设置 `numberformat={}`，统一在 `nameformat` 中设置格式。
可以在 `ctexset={chapter/name={第\,,章}}` 中的“第”字之后手动加一个六分之一小空格 `\,` 以规避 `xeCJK` 自作主张的小聪明。

## 强迫症的补完

`ctex` 提供的章节标题命令最小是 `\subparagraph`、即5级标题，形如“x.x.x.x.x.x”共6个数字。

出于强迫症考虑，把所有的样式都统一定义了。

1. 开启 5 级标题编号：

   1. 必须设置章节编号深度 `\setcounter{secnumdepth}=5`。

   2. 可以在 `\LoadClass` 时，为 `ctex` 添加上 `sub4section` 选项（没有true/false值）。但是默认效果不好，还是需要详细设置。

2. 样式定义，方法同 `section` 等，不再赘述。

   * paragraph （4级）形如 `（1） 段落名`。
      + 样式延续各级 section：黑体、顶格。
      + 编号不含上级，仅为全角括号与一个阿拉伯数字。

   * subparagraph （5级）形如 `① 子段落名`。
      + 样式同正文，宋体，缩进2字符。
      + 编号是圆圈数字。

以前就觉得 `paragraph` 和 `subparagraph` 的等级太详细了、且样式上跟列表环境有相似。
曾用字体（黑体、楷体）以示与正文列表的宋体字体区分，但仍然不尽人意。

现在，编号方式向老板编写的教材中的编号习惯看齐，应该没有问题了吧？

> 区别在于 paragraph 等级我仍然采用了黑体字体，老板用的是正文宋体字体了。

# 分章节编译问题

**前排提示**：
这项修改纯属本人对于文件夹的某种奇怪强迫症而已，望同学们不要模仿——这项功能毫无意义。

分章节独立编译常用宏包是 `{subfiles}` 和 `{standalone}` 两个。
前者更加简单；后者提供了更多的控制选项，代价是更复杂一些。

宏包 `{subfiles}` 文档 <http://ctan.math.washington.edu/tex-archive/macros/latex/contrib/subfiles/subfiles.pdf>。

## 状况描述

如果把章节 .tex 文档放到另一个文件夹中，则宏包、参考文献和图片的路径相对位置是不同的。
会编译报错，比如找不到文件。

## 答疑

可以把 main.tex 文件也放到一个子文件夹内，则 `\documentclass{}` 和 `\usepackage{}` 的都可以采用 `../xxx` 的相对路径。

## 处理
### 项目目录结构处理

调整过后的文档结构示意如下。

```
..  % 主文件夹 Master Folder
|-- appendix\ % 附录
    |-- appendix.tex % 附录章节，可以在一个.tex文件中分\chapter，也可以每章一个.tex文件。
|-- body\ % 正文
    |-- chapter1.tex % 单独章节
    |-- chapter2.tex
|-- code\ % 存放代码，用于algorithm和listing环境引用。
|-- figure\ % 各类图片
    |-- fig1,2,...[png|pdf|eps|...]
|-- pages\ % 格式化的页面
    |-- abstract.tex % 摘要，以{environment}形式
    |-- acknowledge.tex % 致谢，以{environment}形式
    |-- cover.tex % 封面信息，填表
    |-- denotation.tex % 符号对照表，以{environment}形式（description列表）
    |-- resume.tex % 个人简历，以{environment}形式
|-- main\
    |-- Thesis.tex % 组装成完整的论文
|-- ref\
    |-- references.bib % 参考文献
|-- THEME\ % 用于存放模板样式文件
    |-- tongjithesis.cls % class文件
    |-- tongjithesis.sty % package文件
    |-- tongjithesis.cfg % 配置 configuration 文件
```

于是，主文件和单独章节文件可以引用相同的相对路径，就可以分章节编译的目的。

### 在主文件 main.tex 中的调整

各种路径都要先用`../`回到上一层、然后再指定平级目录、最后指定文件。
虽然这种操作不是很常见，但是相比正常路径，也就多了`../`这一步，算是可以接受。

```latex
\documentclass[bibtype=numeric]{../THEME/tongjithesis} % 1. 文档类型
\usepackage{../THEME/tongjithesis} % 2. 宏包
\begin{document}
  ...
  \subfile{../body/chapter.tex} % 3. 章节文件
\end{document}
```

### 在子文件 chapter.tex 中的调整

子文件中按照 subfile 的要求即可，不需要 \usepackage，然后用{document}环境包围正文代码。

```latex
\documentclass[../main/BMS_BIM.tex]{subfiles} % 1. 文档类型选项
\begin{document}
  ...
\end{document}
```

### 在模板文件中的调整

为了避免如下的报错提醒，

```
You have requested document class `../THEME/tongjithesis',
           but the document class provides `tongjithesis'.
```

可以在模板文件中修改 `.cls` 和 `.sty` 引用名。
```latex
\ProvidesClass{../THEME/tongjithesis}
\ProvidesPackage{../THEME/tongjithesis}
```

## 处理（改良）

手动安装 `.cls` 和 `.sty` 文件到系统，即可避免这些问题。

方法参考：[手动安装 sty 和 cls 文件](https://zhuanlan.zhihu.com/p/113124407)

### 主要步骤

1. 打开终端

   * Windows 上的 cmd.exe 或 PowerShell.exe，
   * macOS 上的 Terminal.app 。

2. 输入 `kpsewhich --var-value=TEXMFHOME`，按回车，得到一个路径，比如说 `X:/xxx/texmf` 。

   1. 打开这个路径（文件夹）。
   2. 如果路径中的某一层或几层文件夹不存在，就创建它们。
   3. 最后会位于 `texmf/` 文件夹。

3. 在 `texmf/` 中继续创建两层文件夹 `tex/latex/`，
   把现在的路径为 `X:/xxx/texmf/tex/latex/` 。

4. 在 `latex/` 文件夹中创建一个文件夹，名称任选（例如为 `my-pkg/`）。
   名称其实不关键，只是用于管理文件罢了。

5. 把 `xxx.cls` 和 `xxx.sty` 文件放进文件夹 `my-pkg/`。
   最终完整路径形如：
   * `X:/xx/texmf/tex/latex/my-pkg/xxx.cls`
   * `X:/xx/texmf/tex/latex/my-pkg/xxx.sty`

结束。

现在，本机任何位置的 `.tex` 文件都可以取用这些类文件（`xxx.cls`）和宏包（`xxx.sty`）。

### 讨论

* 命令 `kpsewhich` 是 $\TeX Live$ 命令，用法参看 `texlive-en.pdf`；如果是其他发行版，需要另行找资料。
* 「安装」在 `TEXMFHOME` 中的文件，只有（登陆操作系统的）当前用户可以使用。
  + 如果希望为所有用户「安装」，可以把第二步中的 TEXMFHOME 替换为 TEXMFLOCAL。
  + 此时，还需要第七步：以管理员权限在终端执行 `texhash` 命令。
* 变量 `TEXMFHOME` 的值（第二步中得到的路径）可以修改，还可以包括多个路径。
* 变量 `TEXMFHOME` 储存的每一个路径，都要满足特定的目录结构要求，称为 TDS (TeX Directory Structure)。有时也叫做 texmf 树。在步骤介绍中，
  + `tex/latex/` 两层目录是 TDS 强制的，表示【这是 latex 格式的宏包文件】。
  + `my-pkg/` 一层，体现的是包名（package name），可以任取。有多个包时，可以在 `tex/latex/` 下建立多个文件夹。
* 可以用符号链接的方式把宏文件（包括但不限于 sty, cls, tex, def 等）加到 TDS 的特定子目录中。符号链接能进一步提高宏文件的可维护性。

# 宏包 gb7714 报错

## 状况描述

报错提醒如下。

```
Package xkeyval Error: `gbnamefmt` undefined in families `blx@opt@pre`.
% 其中`gbnamefmt`也可会是`urldate`等其他信息
...
\blx@processoptions
```

## 答疑

需要手动更新适用于中文文献的宏包，本次即 `biblatex-gb7714-2015`。

根据 [宏包 gb7714](https://github.com/hushidong/biblatex-gb7714-2015) 的说明文档：

> 最简单的方法是从本项目源码中下载
> gb7714-2015.bbx, gb7714-2015ay.bbx, gb7714-2015.cbx, gb7714-2015ay.cbx 四个文件
> 放到你要编译的主文档所在目录，如果需要使用gbk编码，则还需复制 gb7714-2015-gbk.def 文件。
> 对于已经安装的用户需要更新到最新版，则可以下载这些文件替换系统已经安装的文件。

## 处理

下载四个文件，并替换 `$TexLive$/texmf-dist/tex/latex.biblatex-gb7714-2015/` 文件夹内原有内容。
* gb7714-2015.bbx
* gb7714-2015ay.bbx
* gb7714-2015.cbx
* gb7714-2015ay.cbx

原README也指出了这个问题。
此外，如下论坛帖也有详细说明。
https://blog.genkun.me/post/xjtu-undergraduate-thesis/

# Biber 版本错误

## 状况描述

报错提醒如下。

```
ERROR - Error: Found biblatex control file version 3.4, expected version 3.5.
This means that your biber (2.12) and biblatex (3.11) versions are incompatible.
See compat matrix in biblatex or biber PDF documentation.
```

本项目编译时(2019年3月)，TexLive 提供的的最新版本 biber 2.1 与 biblatex 3.12 不能兼容。

其官方论坛也承认了这个bug，且唯一办法就是 (downgrade biber)[https://bugs.archlinux.org/task/60844]。

## 答疑

根据biblatex.pdf的Table.1说明，下载了biber2.1并覆盖到 $TexLive安装$\bin\win32下。（GT的电脑是 c:\Program Files\texlive\2018\bin\win32 ）

> 可在cmd中用 `where biber` 查询biber的位置，也可以搜索biber.exe 定位。

### biber历史版本下载

https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/2.11/

# 公式索引

$\LaTeX$ 原生没有“公式索引”这样的命令，所以是从清华的模板中学到的命令。

因为公式数量庞大，所以罗列所有公式通常不是什么好的决定。
所以清华方法只会把指定公式列入索引。

他们定义了一个新命令 `\equcaption{}` 用来标定重要公式，然后 `\listofequations` 只列出这些被标记的公式。
通常，建议用 `amsmath` 宏包提供的 `\tag` 命令一起使用。

# 电子书签

目录和电子书签不同，许多章节不会加入目录，但是为了方便通常会加入电子书签，以便跳转。

* 【目录】
  是会被打印出来的目录，包括 `mainmatter` 和 `backmatter`。
  在文档中由 `\tableofcontents` 命令生成，由 `titletoc` 宏包控制样式。

* 【PDF电子书签】
  是用 PDF 阅读器打开的电子版文件才出现的目录，可以更全面。

## 添加目录项

通常的章节命令会自动加入目录，不赘述。

为了把不编号章节同时加入目录和 PDF 电子书签，需要在章节标题命令**之后**手动添加 `\addcontentsline{ext}{depth}{title}` 命令。

* 第一个参数 `ext` 表示加入目录或者索引。
  可选为：
  - 目录 `toc` (table of contents)，
  - 图片索引 `lof` (list of figures)，
  - 表格索引 `lot` (list of tables)。

* 第二个参数 `depth` 表示添加后的等级（层次、或称深度），比如 `part`、`chapter`、`section`等；

* 第三个参数 `title` 表示它在目录 / 索引中的展示的标题名字。

## 制作电子书签

原模版的 PDF 书签采用 `hyperref` 宏包的 `\pdfbookmark[level]{text}{name}` 命令，为 PDF 文档生成与文档目录部分内容和结构相同的书签。

使用方法可以参考 <https://zhuanlan.zhihu.com/p/59655379> 一文，需要控制书签所在的层次、书签的标题、书签的跳转目标三个参数。
同样，这个命令与必须跟随在章节标题命令**之后**。

然而，直接手动添加的书签，经常跳转目标不准确。
如果要正确跳转，先 `\phantomsection` 产生一个虚假的章节，之后添加 `\pdfbookmark`。
而且，这种方式需要编译两次才能出现电子书签。

## 自定义的命令

正如开始所说，章节在文章目录 `TOC` 和 PDF 电子书签中的应当分离控制。
比如封面、目录本身、授权页面等不出现在目录，但最好出现在电子书签。

原模版借鉴了清华模版，采用了带有的四个参数自定义**章**标题命令 `\tongji@chapter{s o m o}`，从而更加自由灵活地控制目录和书签的展示行为。

* 第一个是星号参数 `s`，用于提醒此新命令与原生命令的必须区别，不会实际更改目录或者电子书签的内容或格式。

* 第二个是可选参数 `o`，表示 `[tocline]`，是出现在目录中的条目。
  + 如果有、且为空 `[]`，则此章节不出现在目录中；
  + 如果有、且不为空 `[mark]`，则在电子书签中显示为 `mark`；
  + 如果没有，表示在电子书签中显示 `{title}`。

* 第三个是必需参数 `m`，表示 `{title}`，即章标题 `\chapter{}` 括号中的内容。

* 第四个是可选参数 `o`，表示 `[header]`，即页眉出现的标题。
  + 如果有，则成为页眉；
  + 如果没有，则取 `{title}`作为页眉。

总结来说，
第一个参数要求必须以 `\tongji@chapter*` 的形式生成章节并进入电子书签；
第三个参数是必需的章标题名字；
第二、四个参数是其它相关位置显示的名字，且区分了无参数、有空参数、有非空参数三种情况。

几个用法举例。

1. 中文摘要

   `\tongji@chapter*[]{\cabstractname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\cabstractname] `

    | 参数  | 内容                          | 解释                   |
    | :---: | :---------------------------- | :--------------------- |
    |   s   | `*`                           | 确认带星号             |
    |   o   | `[]`                          | 有且为空，不出现在目录 |
    |   m   | `{\cabstractname}`            | “摘要”二字             |
    |   o   | `[\wuhao ... \cabstractname]` | 摘要的页眉             |

   英文摘要、目录同理。

2. 致谢

   `\tongji@chapter*[\tongji@ackname]{\tongji@ackname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\tongji@ackname]`

    | 参数  | 内容                           | 解释                                                            |
    | :---: | :----------------------------- | :-------------------------------------------------------------- |
    |   s   | `*`                            | 确认带星号                                                      |
    |   o   | `[\tongji@ackname]`            | 有且不为空，出现在目录中显示 `\tongji@ackname` 对应的“致谢”二字 |
    |   m   | `{\tongji@ackname}`            | “致谢”二字                                                      |
    |   o   | `[\wuhao ... \tongji@ackname]` | 致谢的页眉                                                      |

3. 不带星号的 `\listof`

   `\tongji@chapter*{\csname list#2name\endcsname}[\wuhao\songti\tongji@schoolname~\tongji@capply~\csname list#2name\endcsname]`

    | 参数  | 内容                             | 解释                            |
    | :---: | :------------------------------- | :------------------------------ |
    |   s   |                                  | 确认带星号                      |
    |   o   |                                  | 没有，在目录显示 `m` 参数的文字 |
    |   m   | `{\csname list#2name\endcsname}` | 对应的“索引”名字                |
    |   o   | `[\wuhao ... \endcsname]`        | 索引的页眉                      |

    正文的章节都是这种类型。

## 优化电子书签

<https://zhuanlan.zhihu.com/p/66434387> 指出，在 `hyperref` 宏包的用户手册中，针对 PDF 书签的功能，也推荐用户使用 `bookmark` 宏包（见 `hyperref` 手册 4.1.1 节末尾），而不再推荐用 `hyperref` 了。

* 如果是已经 `\addcontentsline` 而加入了 `toc` 的项目，会自动进入电子书签；
* 如果是不在 `toc` 中的章节，在其章节命令 `\chapter*{}` 之后用 `\bookmark[dest=\HyperLocalCurrentHref, level=]{title}` 设定其在电子书签中的级别和标题内容即可。

从而，在 `\NewDocumentCommand\tongji@chapter` 中不再需要 `\phantomsection` 了。

不过，如果要为封面、授权说明和原创性声明添加电子书签，还是需要 `\phantomsection`，因为它们中原本不含有章节命令，无法被定位。

值得注意，这并不意味着可以不用加载 `hyperref` 宏包。
`hyperref` 宏包提供了全面的超链接功能，`bookmark` 应该理解为其一个扩展。
比如，默认的超链接都有一个红色矩形框包裹，需要在 `hyperref` 的设置中 `colorlinks=false` 以禁用；此外，PDF 文件的小写罗马字母、大写罗马字母和阿拉伯数字页码仍然需要编译两次才能正确显示。

# To be continued 遗留问题

## 用ltxdoc包生成dtx文件

这个需要对整个模板工程有全局的统筹，工作量太大，估计必要分工协作才行。
只能留给后面有心的同学吧。

## 封面样式

* 顶部标签影响竖向布局

  中文封面中，如果最上方添加了“打印时删除”“电子版”或者“保密”的标签字样时候，原本的 `\parbox` 的 24bp 的高度设置会被改变。
  与不添加这些标签字样相比，相差了 12bp 的高度。

  尝试更改字体的行间距，无效。

  原理仍有待探究。

  现在的解决方法是把中文封面的段落盒子高度增加为 `\parbox[t][36bp][t]{\textwidth}{...}`；
  而英文封面中没有这些元素，用 `\vspace*{24bp}` 跳过。
  则两种封面的其他元素可以顺利对齐。

* 封面表格 `Underfull \hbox` 提醒

  中文封面的申请人信息表格，第一、二行“姓名”、“学号”因为字数太少，会有 `Underfull \hbox` 的提醒。
  所以在 `.cfg` 文件中两个汉字之间手动加入了 `\hfill` 命令用于扩充，并取消了这两行原本的 `\tongji@put@title{}` 命令。

  + 当然，如果是有副导师的情况，则“所在院系”“学科门类”等四字列仍然会有 `Underfull` 的提醒，所以不必担心。

## 分章节编译产生的问题

分章节的编译方法好像没有产生太大的好处，而且在使用过程中还遇到了更多的问题。

* 必须 magic comment

  需要在章文件开头添加 `% !TEX program = xelatex` 才能使 `latexmk` 顺利编译单独章节，否则会调用默认的 `pdflatex` 编译。

  可以在章文件开头添加 `% !TeX root = ../Main/final.tex` 使得 `latexmk` 自动进行根目录的编译。


* 表格中字号错误

  单章编译时，表格字号不是在 `.cls` 中定义的字号（五号），而是成为正文字号；
  然而，如果回到整合的文件编译，则不会出现这种状况，表格文字被顺利的缩小为五号。

TODO：对于分章节编译，需要盖棺论定。
等到论文写完，对比过程中分章节编译的优劣势。
因为 `latexmk` 好像可以加速编译，所以如果单章节的编译与总编译的时间相差不多，那么分章节的优势可能就仅在于“方便分章节检查”这样的了——然而有同步、有电子书签的情况下，也没那么大优势。

# 原版说明文件

* [README.md](https://github.com/marquistj13/TongjiThesis/blob/master/README.md)

* [CHANGES.LOG](https://github.com/marquistj13/TongjiThesis/blob/master/changes.md)
