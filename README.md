最开始需要新建一个conda环境

```bash
conda create -n word2vec python=3.8
conda activate word2vec
```

然后安装一下所需要的库

```bash
pip install numpy
pip install scipy
pip install gensim
pip install jieba
```

首先下载一下数据集[zhwiki-20230701-pages-articles.xml.bz2](https://dumps.wikimedia.org/zhwiki/20230701/zhwiki-20230701-pages-articles.xml.bz2)，为了方便后续操作，这里需要把他转成`txt`格式的

以下是转化的文件`transform_to_txt.py`

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 修改后的代码如下：
import logging
import os.path
import sys

from gensim.corpora import WikiCorpus

if __name__ == '__main__':

    program = os.path.basename(sys.argv[0])
    logger = logging.getLogger(program)
    logging.basicConfig(format='%(asctime)s: %(levelname)s: %(message)s')
    logging.root.setLevel(level=logging.INFO)
    logger.info("running %s" % ' '.join(sys.argv))
    # check and process input arguments
    if len(sys.argv) < 3:
        print(globals()['__doc__'] % locals())
        sys.exit(1)
    inp, outp = sys.argv[1:3]
    space = ""
    i = 0
    output = open(outp, 'w', encoding='utf-8')
    # wiki = WikiCorpus(inp, lemmatize=False, dictionary={})
    wiki = WikiCorpus(inp, dictionary={})
    for text in wiki.get_texts():
        s = space.join(text)
        # s = s.decode('utf8') + "\n"
        s = s.encode('utf8').decode('utf8') + "\n"
        output.write(s)
        i = i + 1
        if (i % 10000 == 0):
            logger.info("Saved " + str(i) + " articles")
    output.close()
    logger.info("Finished Saved " + str(i) + " articles")
```

然后将刚刚下载的数据集和此`Python`文件放在同一个目录下，并且用命令行跳转到这个目录，然后执行

```tex
python transform_to_txt.py zhwiki-20230701-pages-articles.xml.bz2 wiki.zh.text
```

其中，第一个参数是`Python`的文件名，第二个是要处理的数据文件名，第三个是要输出的文件名

转换完之后就生成了一个txt文件

![image-20230704195428973](https://s1.ax1x.com/2023/07/04/pCs7rX8.png)

直接浏览，可以看出这里面全是繁体字，所以下面需要把繁体转换成简体

![image-20230704195605355](https://s1.ax1x.com/2023/07/04/pCs760g.png)

首先需要下载这个[转换工具](https://github.com/BYVoid/OpenCC/wiki/Download)，**记住要下载预编译的**。

然后解压后放在一个能记住的位置，例如我是

```tex
G:\Lab\DeepLearning\OpenCC\share\opencc
```

然后把文件夹中的`bin`目录配置到系统环境`path`里

![屏幕截图 2023-07-04 202744](https://s1.ax1x.com/2023/07/04/pCsblqO.png)

最后验证一下是否配置成功

```bash
opencc --help
```

![屏幕截图 2023-07-04 201226](https://s1.ax1x.com/2023/07/04/pCsHFNd.png)

然后就可以转换啦，用`cmd`跳转到`wiki.zh.text`文件所在的目录，在命令行输入

```bash
opencc -i wiki.zh.text -o test_zh.txt -c G:\Lab\DeepLearning\OpenCC\share\opencc\t2s.json
```

`wiki.zh.text`是待转换的繁体文本，`test_zh.txt`是输出的简体文本，`t2s.json`表示繁体转简体，其中这个需要换成自己的地址（**地址不要有空格**）

![image-20230704203004637](https://s1.ax1x.com/2023/07/04/pCsbmGR.png)

等一会就好了

![image-20230704203155840](https://s1.ax1x.com/2023/07/04/pCsbtJA.png)

然后就全部成了简体了，使用word2vec工具需要做的最后一步是分词

分词使用`jieba`这个库来解决，以下是分词的文件`participle.py`

```python
import codecs

import jieba
import jieba.analyse


def cut_words(sentence):
    # print sentence
    return " ".join(jieba.cut(sentence)).encode('utf-8')


f = codecs.open('test_zh.txt', 'r', encoding="utf8")
target = codecs.open("zh.jian.wiki.seg_1.5G.txt", 'w', encoding="utf8")
print('open files')
line_num = 1
line = f.readline()
while line:
    print('---- processing ', line_num, ' article----------------')
    line_seg = " ".join(jieba.cut(line))
    target.writelines(line_seg)
    line_num = line_num + 1
    line = f.readline()
f.close()
target.close()
exit()
while line:
    curr = []
    for oneline in line:
        # print(oneline)
        curr.append(oneline)
    after_cut = map(cut_words, curr)
    target.writelines(after_cut)
    print('saved', line_num, 'articles')
    exit()
    line = f.readline1()
f.close()
target.close()
```

其中，这一句是配置需要分词的文件`test_zh.txt`

```python
f = codecs.open('test_zh.txt', 'r', encoding="utf8")
```

这一句是配置需要输出的文件`zh.jian.wiki.seg_1.5G.txt`

```python
target = codecs.open("zh.jian.wiki.seg_1.5G.txt", 'w', encoding="utf8")
```

将`participle.py`文件和上面输出的简体文本`test_zh.txt`放在同一个目录，用`cmd`（跳转到对应目录后输入`python Testjieba.py`）或者`Pycharm`直接运行`participle.py`文件

**PS：无论是`cmd`还是`Pycharm`，记得切换到`word2vec`环境**

经过将近一个多小时的时间，终于跑完了

![屏幕截图 2023-07-04 192329](https://s1.ax1x.com/2023/07/04/pCsb6ij.png)

接下来就是正式使用word2vec的时候了，以下是使用word2vec的文件`word2vec_model.py`

```python
import logging
import multiprocessing
import os.path
import sys

from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

if __name__ == '__main__':

    program = os.path.basename(sys.argv[0])
    logger = logging.getLogger(program)
    logging.basicConfig(format='%(asctime)s: %(levelname)s: %(message)s')
    logging.root.setLevel(level=logging.INFO)
    logger.info("running %s" % ' '.join(sys.argv))
    # check and process input arguments
    if len(sys.argv) < 4:
        print(globals()['__doc__'] % locals())
        sys.exit(1)
    inp, outp1, outp2 = sys.argv[1:4]
    model = Word2Vec(LineSentence(inp), size=400, window=5, min_count=5, workers=multiprocessing.cpu_count())
    model.save(outp1)
    model.wv.save_word2vec_format(outp2, binary=False)
```

将上文分好词的文件`zh.jian.wiki.seg_1.5G.txt`与`word2vec_model.py`文件也是放到同一个目录下，然后在`cmd`中执行

```bash
python word2vec_model.py zh.jian.wiki.seg_1.5G.txt wiki.zh.text.model wiki.zh.text.vector
```

其中，`wiki.zh.text.model`是生成的模型（同样记得切换环境）

![image-20230704205047579](https://s1.ax1x.com/2023/07/04/pCsqmTg.png)

可能会报这个错，原因可能是`gensim`的版本的差异。

这样把下面这句的`size`改成`vector_size`即可

源代码：

```python
model = Word2Vec(LineSentence(inp), size=400, window=5, min_count=5, workers=multiprocessing.cpu_count())
```

新代码：

```python
model = Word2Vec(LineSentence(inp), vector_size=400, window=5, min_count=5, workers=multiprocessing.cpu_count())
```

然后就可以漫长的等待了！

![image-20230704205435161](https://s1.ax1x.com/2023/07/04/pCsqB11.png)

 经过一段时间后，模型保存成功了！

![屏幕截图 2023-07-04 212910](https://s1.ax1x.com/2023/07/04/pCsO3ZT.png)

最后测试一下模型

测试文件`testModel.py`如下

```python
from gensim.models import Word2Vec

en_wiki_word2vec_model = Word2Vec.load('wiki.zh.text.model')

testwords = ['苹果', '数学', '学术', '白痴', '篮球']
for i in range(5):
    res = en_wiki_word2vec_model.wv.most_similar(testwords[i])
    print(testwords[i])
    print(res)
```

继续在同一个目录执行`testModel.py`文件，得到如下结果

![image-20230705101212390](https://s1.ax1x.com/2023/07/05/pCyEdl6.png)
