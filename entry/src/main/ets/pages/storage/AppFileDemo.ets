/*
 * 应用文件（即沙箱目录中的文件，卸载后会被清理）
 *
 * 一个沙箱目录的示例 /data/storage/el2/base/haps/entry/files
 * el1/ el2/ 代表的是当前目录区域的加密类型
 *   el1 是设备级加密区，设备开机后即可访问的数据区
 *   el2 是用户级加密区，设备开机后且首次密码解锁之后才可以访问的数据区（若不需要密码解锁，则开机后即可访问）
 * haps/entry/ 对应的 hap 的模块名，本例是 entry
 *   files - 需要永久保存的文件的目录，不卸载则不会被清理
 *   cache - 缓存目录，由系统决定清理策略（比如存储不够用时，则可能会被清理）
 *   temp - 临时目录，应用退出后即清理
 *   preferences - 用于保存应用的首选项数据的目录，不卸载则不会被清理
 *
 * resfile 对应的沙箱目录（注：resfile 中的文件在 app 第一次安装后会被复制到应用的 el1 沙箱路径中）类似如下
 * /data/storage/el1/bundle/entry/resources/resfile
 */

import { TitleBar } from '../TitleBar';
import { fileIo as fs, hash, ListFileOptions } from '@kit.CoreFileKit';
import { common, contextConstant } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS'
import { BusinessError } from '@kit.BasicServicesKit';
import { Helper } from '../../utils/Helper';

@Entry
@Component
struct AppFileDemo {

  build() {
    Column() {
      TitleBar()
      Tabs() {
        TabContent() { MySample1() }.tabBar('目录').align(Alignment.Top)
        TabContent() { MySample2() }.tabBar('文件读写').align(Alignment.Top)
        TabContent() { MySample3() }.tabBar('文件信息').align(Alignment.Top)
        TabContent() { MySample4() }.tabBar('文件管理').align(Alignment.Top)
        TabContent() { MySample5() }.tabBar('目录管理').align(Alignment.Top)
        TabContent() { MySample6() }.tabBar('列表').align(Alignment.Top)
      }
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .layoutWeight(1)
    }
  }
}

@Component
struct MySample1 {

  @State message: string = ""

  // 通过 getContext(this) 获取 context
  context = getContext(this) as common.UIAbilityContext

  aboutToAppear(): void {
    /*
     * UIAbilityContext - 上下文
     *   area - 沙箱目录的区域，可以设置为 el1 或 el2
     *     AreaMode.EL1 - 设备级加密区
     *     AreaMode.EL2 - 用户级加密区
     *   filesDir - files 目录地址
     *   cacheDir - cache 目录地址
     *   tempDir - temp 目录地址
     *   resourceDir - resfile 对应的沙箱目录（注：resfile 中的文件在 app 第一次安装后会被复制到应用的 el1 沙箱路径中）
     *   preferencesDir - preferences 目录地址
     */
    this.context.area = contextConstant.AreaMode.EL1
    this.message += `filesDir: ${this.context.filesDir}\n`
    this.message += `cacheDir: ${this.context.cacheDir}\n`
    this.message += `tempDir: ${this.context.tempDir}\n`
    this.message += `resourceDir: ${this.context.resourceDir}\n`
    this.message += `preferencesDir: ${this.context.preferencesDir}\n`

    this.context.area = contextConstant.AreaMode.EL2
    this.message += `filesDir: ${this.context.filesDir}\n`
    this.message += `cacheDir: ${this.context.cacheDir}\n`
    this.message += `tempDir: ${this.context.tempDir}\n`
    this.message += `preferencesDir: ${this.context.preferencesDir}\n`
  }

  build() {
    Column({space:10}) {
      Text(this.message)
    }
  }
}

@Component
struct MySample2 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext
  filePath = this.context.filesDir + '/MySample2_test.txt'

  /*
   * open(), openSync() - 打开文件，返回 File 对象
   *   path - 需要打开的文件路径
   *   mode - 打开的方式（OpenMode 枚举）
   *     READ_ONLY - 只读
   *     WRITE_ONLY - 只写
   *     READ_WRITE - 读写
   *     CREATE - 文件不存在则创建（可通过 | 追加）
   *     TRUNC - 如果有写权限则清空文件内容（可通过 | 追加）
   *     APPEND - 以追加方式打开，后续写的内容将追加到文件末尾（可通过 | 追加）
   * close(), closeSync() - 关闭指定的文件
   *
   * File - 文件对象
   *   fd - 文件对象的文件描述符（File Descriptor，0 是 stdin，1 是 stdout，2 是 stderr）
   *   name - 文件名
   *   path - 文件路径
   *   getParent() - 父目录的路径
   */
  async openFile() {
    // 文件不存在时则创建（要保证父文件夹存在，否则会抛出异常）并打开文件，文件存在时则清空内容并打开文件
    let file = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    this.message = `fd:${file.fd}\n`
    this.message += `name:${file.name}\n`
    this.message += `path:${file.path}\n`
    this.message += `getParent:${file.getParent()}\n`
    await fs.close(file)
  }

  /*
   * write(), writeSync() - 写入文本数据，返回值为实际写入的数据的字节长度
   *   fd - 文件描述符
   *   buffer - 需要写入的文本数据
   *   options - 选项
   *     offset - 从文件的指定位置开始写入
   *     length - 需要写入的数据的字节长度
   *     encoding - 字符编码方式
   * readLines(), readLinesSync() - 逐行读取文本数据
   * readText(), readTextSync() - 读取全部文本数据
   *   filePath - 需要读取的文本文件的路径
   *   options - 选项
   *     encoding - 字符编码方式
   *
   * 注：写文件的时候要注意
   * 1、如果需要追加数据，则通过 OpenMode.APPEND 的方式打开
   * 2、如果需要重写数据，则通过 OpenMode.TRUNC 的方式打开
   * 3、用默认的打开方式写文件时，比如原来文件内容为 abcdefg 然后写入 xxx 则文件内容为 xxxdefg
   */
  async writeText() {
    let file = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    let text = `hello: ${Helper.getTimestampString()}`
    let writeLength = await fs.write(file.fd, text, {
      encoding: "utf-8",
    })
    this.message = `文件写入成功 length:${writeLength}`
    await fs.close(file)
  }
  async readText() {
    let result = await fs.readText(this.filePath, {
      encoding: "utf-8"
    })
    this.message = result
  }

  /*
   * write(), writeSync() - 写入二进制数据，返回值为实际写入的数据的字节长度
   *   fd - 文件描述符
   *   buffer - 需要写入的二进制数据
   *   options - 选项
   *     offset - 从文件的指定位置开始写入
   *     length - 需要写入的数据的字节长度
   *     encoding - 字符编码方式
   * read(), readSync() - 读取二进制文件，返回值为实际读取到的数据的字节长度
   *   fd - 文件描述符
   *   buffer - 将读取到的二进制数据写入此缓冲区
   *   options - 选项
   *     offset - 从文件的指定位置开始读取
   *     encoding - 字符编码方式
   *
   * 注：写文件的时候要注意
   * 1、如果需要追加数据，则通过 OpenMode.APPEND 的方式打开
   * 2、如果需要重写数据，则通过 OpenMode.TRUNC 的方式打开
   * 3、用默认的打开方式写文件时，比如原来文件内容为 abcdefg 然后写入 xxx 则文件内容为 xxxdefg
   */
  async writeBinary() {
    let file = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    let text = `hello: ${Helper.getTimestampString()}`
    let buffer = util.TextEncoder.create('utf-8').encodeInto(text).buffer
    let writeLength = await fs.write(file.fd, buffer, {
      offset: 0,
      length: buffer.byteLength,
      encoding: "utf-8",
    })
    this.message = `文件写入成功 length:${writeLength}`
    await fs.close(file)
  }
  async readBinary() {
    let file = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    // 实例化一个 1024 字节的缓冲区
    let buffer = new ArrayBuffer(1024);
    let readLength = await fs.read(file.fd, buffer, {
      offset: 0,
      length: buffer.byteLength
    });
    this.message = util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(buffer))
    await fs.close(file)
  }

  /*
   * createStream(), createStreamSync() - 创建文件流对象
   *   path - 文件路径
   *   mode - 创建文件流的方式
   *     r - 只读，文件需存在
   *     r+ - 可读写，文件需存在
   *     w - 只写，文件存在则清空内容，文件不存在则新建文件
   *     w+ - 可读写，文件存在则清空内容，文件不存在则新建文件
   *     a - 追加方式的只写，文件存在则写入时会追加内容，文件不存在则新建文件
   *     a+ - 追加方式的可读写，文件存在则写入时会追加内容，文件不存在则新建文件
   *   write(), writeSync() - 用流的方式写入文本数据或二进制数据，返回值为实际写入的数据的字节长度
   *     buffer - 需要写入的文本数据或二进制数据
   *     options - 选项
   *       offset - 从文件的指定位置开始写入
   *       length - 需要写入的数据的字节长度
   *       encoding - 字符编码方式
   *   read(), readSync() - 用流的方式读取二进制文件，返回值为实际读取到的数据的字节长度
   *     buffer - 将读取到的二进制数据写入此缓冲区
   *     options - 选项
   *       offset - 从文件的指定位置开始读取
   *       encoding - 字符编码方式
   *   flush(), flushSync() - 刷新文件流（即将缓冲区中的数据立即写入到目标文件中）
   *   close(), closeSync() - 关闭文件流
   */
  async writeStreamText() {
    let outputStream = await fs.createStream(this.filePath, "w+");
    let text = `hello: ${Helper.getTimestampString()}`
    let writeLength = await outputStream.write(text, {
      encoding: "utf-8",
    })
    this.message = `文件写入成功 length:${writeLength}`
    await outputStream.close();
  }
  async writeStreamBinary() {
    let outputStream = await fs.createStream(this.filePath, "w+");
    let text = `hello: ${Helper.getTimestampString()}`
    let buffer = util.TextEncoder.create('utf-8').encodeInto(text).buffer
    let writeLength = await outputStream.write(buffer, {
      offset: 0,
      length: buffer.byteLength,
      encoding: "utf-8",
    })
    this.message = `文件写入成功 length:${writeLength}`
    await outputStream.close();
  }
  async readStreamBinary() {
    let inputStream = await fs.createStream(this.filePath, 'r+');
    let buffer = new ArrayBuffer(1024);
    let readLength = await inputStream.read(buffer, {
      offset: 0,
      length: buffer.byteLength
    });
    this.message = util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(buffer))
    await inputStream.close();
  }

  /*
   * unlink(), unlinkSync() - 删除指定的文件
   */
  async deleteFile() {
    try {
      await fs.unlink(this.filePath)
      this.message = "删除成功"
    } catch (err) {
      this.message = `${err}`
    }
  }

  build() {
    Column({space:10}) {
      Button("openFile").onClick(async () => { await this.openFile() })

      Button("writeText").onClick(async () => { await this.writeText() })
      Button("readText").onClick(async () => { await this.readText() })

      Button("writeBinary").onClick(async () => { await this.writeBinary() })
      Button("readBinary").onClick(async () => { await this.readBinary() })

      Button("writeStreamText").onClick(async () => { await this.writeStreamText() })
      Button("writeStreamBinary").onClick(async () => { await this.writeStreamBinary() })
      Button("readStreamBinary").onClick(async () => { await this.readStreamBinary() })

      Button("deleteFile").onClick(async () => { await this.deleteFile() })

      Text(this.message)
    }
  }
}

@Component
struct MySample3 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext
  filePath = this.context.filesDir + '/MySample3_test.txt'

  async aboutToAppear() {
    let file = await fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    fs.write(file.fd, `hello: ${Helper.getTimestampString()}`, { encoding: "utf-8" })
    await fs.close(file)
  }

  /*
   * access(), accessSync() - 判断指定的文件是否存在
   */
  async access() {
    let exist = await fs.access(this.filePath, fs.AccessModeType.EXIST)
    this.message = `${exist}`
  }

  /*
   * hash.hash() - 计算指定路径的文件的哈希值（可用哈希算法有 md5, sha1, sha256）
   */
  async hash() {
    const fileHash = await hash.hash(this.filePath, 'sha256');
    this.message = fileHash
  }

  /*
   * stat(), statSync() - 获取指定路径的文件的详细信息
   *   ino - 文件标识
   *   size - 文件大小（单位：字节）
   *   atime - 上次访问文件内容时的时间戳
   *   mtime - 上次修改文件内容时的时间戳
   *   ctime - 上次修改文件状态时的时间戳
   *   isDirectory() - 是否是目录
   *   isFile() - 是否是文件
   */
  stat() {
    fs.stat(this.filePath, (err: BusinessError, stat: fs.Stat) => {
      if (err) {
        this.message = `errCode:${err.code}, errMessage:${err.message}`
      } else {
        this.message = `ino:${stat.ino}\n`
        this.message += `size:${stat.size}\n`
        this.message += `atime:${Helper.getTimestampString(stat.atime * 1000)}\n`
        this.message += `mtime:${Helper.getTimestampString(stat.mtime * 1000)}\n`
        this.message += `ctime:${Helper.getTimestampString(stat.ctime * 1000)}\n`
        this.message += `isDirectory:${stat.isDirectory()}\n`
        this.message += `isFile:${stat.isFile()}\n`
      }
    });
  }

  build() {
    Column({space:10}) {
      Button("access").onClick(async () => { await this.access() })
      Button("hash").onClick(async () => { await this.hash() })
      Button("stat").onClick(() => { this.stat() })

      Text(this.message)
    }
  }
}

@Component
struct MySample4 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext
  filesDir = this.context.filesDir

  /*
   * copyFile(), copyFileSync() - 复制文件
   *   src - 源文件的地址或文件描述符
   *   dest - 目标文件的地址或文件描述符
   *   mode - 文件的覆盖方式（只支持 0 代表完全覆盖）
   */
  async copyFile() {
    let file1Path = this.filesDir + '/MySample4_test1.txt'
    let file2Path = this.filesDir + '/MySample4_test2.txt'
    let file1 = await fs.open(file1Path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    await fs.close(file1)
    await fs.copyFile(file1Path, file2Path, 0);
  }

  /*
   * moveFile(), moveFileSync() - 移动文件
   *   src - 源文件的地址
   *   dest - 目标文件的地址
   *   mode - 文件的移动方式
   *     0 代表同名时强制覆盖
   *     1 代表同名时抛出异常
   */
  async moveFile() {
    let file3Path = this.filesDir + '/MySample4_test3.txt'
    let file4Path = this.filesDir + '/MySample4_test4.txt'
    let file3 = await fs.open(file3Path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    await fs.close(file3)
    await fs.moveFile(file3Path, file4Path, 0);
  }

  /*
   * rename(), renameSync() - 文件重命名
   */
  async renameFile() {
    let file5Path = this.filesDir + '/MySample4_test5.txt'
    let file6Path = this.filesDir + '/MySample4_test6.txt'
    let file5 = await fs.open(file5Path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    await fs.close(file5)
    await fs.rename(file5Path, file6Path);
  }

  /*
   * truncate(), truncateSync() - 删除文件内容
   *   file - 文件的地址或文件描述符
   *   len - 文件内容删除后（从文件的尾部开始删除），文件需要保留的字节数（默认值为 0）
   *
   */
  async truncateFile() {
    let file7Path = this.filesDir + '/MySample4_test7.txt'
    let file7 = await fs.open(file7Path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    await fs.write(file7.fd, "0123456789")
    await fs.close(file7)

    let r1 = await fs.readText(file7Path)
    this.message = `文件内容：${r1}\n` // 结果是 0123456789

    fs.truncate(file7Path, 6)
    let r2 = await fs.readText(file7Path)
    this.message += `文件内容（truncate 之后，文件还有 6 个字节）：${r2}\n` // 结果是 012345

    fs.truncate(file7Path)
    let r3 = await fs.readText(file7Path)
    this.message += `文件内容（truncate 之后，文件还有 0 个字节）：${r3}\n` // 结果是空
  }

  /*
   * unlink(), unlinkSync() - 删除指定的文件
   */
  async deleteFile() {
    try {
      let file8Path = this.filesDir + '/MySample4_test8.txt'
      let file8 = await fs.open(file8Path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
      await fs.close(file8)
      await fs.unlink(file8Path)
      this.message = "删除成功"
    } catch (err) {
      this.message = `${err}`
    }
  }

  build() {
    Column({space:10}) {
      Button("copyFile").onClick(async () => { await this.copyFile() })
      Button("moveFile").onClick(async () => { await this.moveFile() })
      Button("renameFile").onClick(async () => { await this.renameFile() })
      Button("truncateFile").onClick(async () => { await this.truncateFile() })
      Button("deleteFile").onClick(async () => { await this.deleteFile() })

      Text(this.message)
    }
  }
}

@Component
struct MySample5 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext
  filesDir = this.context.filesDir

  /*
   * mkdir(), mkdirSync() - 创建文件夹
   *   path - 文件夹路径
   *   recursion - 是否允许创建多层级目录（默认值为 false 当创建多层级目录时会抛出异常）
   */
  async createDir() {
    let dirPath = this.filesDir + "/dir1/dir2";
    await fs.mkdir(dirPath, true)

    let filePath = dirPath + '/MySample5_test.txt'
    let file = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC)
    await fs.write(file.fd, `hello: ${Helper.getTimestampString()}`)
    await fs.close(file)
  }

  /*
   * copyDir(), copyDirSync() - 复制文件夹
   *   src - 源文件夹
   *   dest - 目标文件夹
   *   mode - 复制文件夹过程中的文件覆盖方式
   *     0 发现同名文件，则抛出异常
   *     1 发现同名文件，则强制覆盖
   */
  async copyDir() {
    await this.createDir()
    let dirPath = this.filesDir + "/dir1/dir2";
    let dirPath3 = this.filesDir + "/dir3";
    await fs.mkdir(dirPath3)
    await fs.copyDir(dirPath, dirPath3, 1)
  }

  /*
   * moveDir(), moveDirSync() - 移动文件夹
   *   src - 源文件夹
   *   dest - 目标文件夹
   *   mode - 覆盖方式
   *     0 发现同名非空文件夹，则抛出异常
   *     1 发现同名文件，则抛出异常
   *     2 发现同名文件，则强制覆盖
   *     3 发现同名非空文件夹，则先清空
   */
  async moveDir() {
    await this.createDir()
    let dirPath = this.filesDir + "/dir1/dir2";
    let dirPath4 = this.filesDir + "/dir4";
    await fs.mkdir(dirPath4)
    await fs.moveDir(dirPath, dirPath4, 3)
  }

  /*
   * rename(), renameSync() - 文件夹重命名
   */
  async renameDir() {
    await this.createDir()
    let dirPath = this.filesDir + "/dir1/dir2";
    let dirPath5 = this.filesDir + "/dir1/dir5";
    await fs.rename(dirPath, dirPath5)
  }

  /*
   * rmdir(), rmdirSync() - 删除指定的文件夹
   */
  async deleteDir() {
    let dirPath = this.filesDir + "/dir1";
    await fs.rmdir(dirPath)
  }

  build() {
    Column({space:10}) {
      Button("createDir").onClick(async () => { await this.createDir() })
      Button("copyDir").onClick(async () => { await this.copyDir() })
      Button("moveDir").onClick(async () => { await this.moveDir() })
      Button("renameDir").onClick(async () => { await this.renameDir() })
      Button("deleteDir").onClick(async () => { await this.deleteDir() })

      Text(this.message)
    }
  }
}

@Component
struct MySample6 {

  @State message: string = ""

  context = getContext(this) as common.UIAbilityContext
  filesDir = this.context.filesDir

  /*
   * listFile(), listFileSync() - 获取指定目录下的文件列表和文件夹列表
   *   path - 目录
   *   options - 选项（一个 ListFileOptions 对象）
   *     recursion - 是否需要递归子目录
   *     listNum - 列出的数据的最大数量（默认值为 0 会列出所有数据）
   *     filter - 过滤器（一个 Filter 对象）
   *       suffix - 后缀名匹配，比如 [".png", ".jpg", ".txt"]
   *       displayName - 文件名匹配，比如 ["prefix1*", "prefix2*"]
   *       fileSizeOver - 文件大小匹配，只返回文件大小大于此值的数据
   *       lastModifiedAfter - 最近修改时间戳匹配，只返回大于等于此值的数据
   */
  async getFileList() {
    this.message = ""
    let listFileOption: ListFileOptions = {
      recursion: true,
      listNum: 0,
      filter: {
        // suffix: [".png", ".jpg", ".txt"],
        // displayName: ["prefix1*", "prefix2*"],
        // fileSizeOver: 0,
        // lastModifiedAfter: new Date(0).getTime()
      }
    };
    let files = await fs.listFile(this.filesDir, listFileOption)
    for (let i = 0; i < files.length; i++) {
      this.message += `${files[i]}\n`
    }
  }

  build() {
    Column({space:10}) {
      Button("列表").onClick(async () => {
        await this.getFileList()
      })

      Text(this.message)
    }
  }
}
