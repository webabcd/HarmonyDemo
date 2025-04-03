import { TitleBar, MyLog } from '../../TitleBar';

@Entry
@Component
struct ArrayBufferDemo {
  build() {
    Column() {
      TitleBar()
      Text("代码示例结合 HiLog 日志一起看")
    }
  }
}


{
  /**
   * 1、ArrayBuffer - 内存之中的一段二进制数据，需要通过视图操作数据
   * 2、TypedArray - 视图，用于操作 ArrayBuffer 对象（注：ArrayBuffer 的长度无法改变），TypedArray 的具体类型如下
   *    Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array
   * 3、DataView - 视图，用于操作 ArrayBuffer 对象（注：ArrayBuffer 的长度无法改变），其可以通过如下方法操作 ArrayBuffer 对象
   *    setInt8/getInt8, setUint8/getUint8, setInt16/getInt16, setUint16/getUint16, setInt32/getInt32, setUint32/getUint32, setFloat32/getFloat32, setFloat64/getFloat64
   *
   * 注：ArrayBuffer 是一种固定大小的二进制缓冲区，其长度在创建时确定，之后不可修改
   */


  // 实例化 ArrayBuffer 对象，并开辟指定字节数的内存空间
  let buffer = new ArrayBuffer(32);
  // slice() - 从指定位置的数据开始复制数据到一个新的 ArrayBuffer 对象
  let buffer1 = buffer.slice(0);
  // slice() - 从第 1 个参数指定的位置的数据开始，到第 2 个参数指定的位置的数据结束（不包括本身），将此之间的数据复制到一个新的 ArrayBuffer 对象
  let buffer2 = buffer.slice(4, 8);
  // byteLength - 获取 ArrayBuffer 的字节大小
  // ArrayBuffer.isView() - 判断指定的对象是否是视图
  MyLog.d(`${buffer.byteLength}, ${buffer1.byteLength}, ${buffer2.byteLength}, ${ArrayBuffer.isView(buffer)}`);
  // 32, 32, 4, false


  // 实例化 Int32Array 视图，并指定初始数组（会自动根据这个数组创建并关联 ArrayBuffer 对象）
  let a = new Int32Array([1, 2, 3]);
  // buffer - 获取 TypedArray 关联的 ArrayBuffer 对象
  // [index] - 获取或设置 TypedArray 对象的指定位置的数据
  // length - 数据的元素个数
  // BYTES_PER_ELEMENT - 数组的每个元素的字节大小
  // Array.prototype.slice.call() - 将 TypedArray 对象转换为数组对象
  a[0] = 100;
  a[1] = 200;
  MyLog.d(`${a[0]}, ${a[1]}, ${a[2]}, ${a.length}, ${a.BYTES_PER_ELEMENT}, ${a.buffer.byteLength}, ${ArrayBuffer.isView(a)}`);
  // 100, 200, 3, 3, 4, 12, true


  // 各种 TypedArray 类型的元素占用的字节大小
  MyLog.d(`${Int8Array.BYTES_PER_ELEMENT}, ${Uint8Array.BYTES_PER_ELEMENT}, ${Int16Array.BYTES_PER_ELEMENT}, ${Uint16Array.BYTES_PER_ELEMENT}, ${Int32Array.BYTES_PER_ELEMENT}, ${Uint32Array.BYTES_PER_ELEMENT}, ${Float32Array.BYTES_PER_ELEMENT}, ${Float64Array.BYTES_PER_ELEMENT}`);
  // 1, 1, 2, 2, 4, 4, 4, 8


  // 实例化一个 TypedArray 对象，并关联指定的 ArrayBuffer 对象
  let c = new Int32Array(buffer); // 8 个元素
  // 指定需要操作的 ArrayBuffer 对象的起始索引位置，直至结尾
  let d = new Int32Array(buffer, 4); // 7 个元素
  // 指定需要操作的 ArrayBuffer 对象的起始索引位置，直至指定的长度（这个长度指的是 TypedArray 对象的元素的个数）
  let e = new Int32Array(buffer, 4, 2); // 2 个元素
  // 通过指定元素个数实例化 TypedArray 对象（会自动创建并关联 ArrayBuffer 对象）
  let f = new Int32Array(4);
  // 通过指定数组实例化 TypedArray 对象（会自动创建并关联 ArrayBuffer 对象）
  let g = new Int32Array([1, 2, 3, 4]);
  // Int32Array.of() - 通过指定数组实例化 TypedArray 对象（会自动创建并关联 ArrayBuffer 对象）
  let h = Int32Array.of(1, 2, 3, 4);
  // Int32Array.from() - 通过指定数组实例化 TypedArray 对象（会自动创建并关联 ArrayBuffer 对象）
  let i = Int32Array.from([1, 2, 3, 4]);
  MyLog.d(`${c.length}, ${d.length}, ${e.length}, ${f.length}, ${g.length}, ${h.length}, ${i.length}`);
  // 8, 7, 2, 4, 4, 4, 4


  // 对 TypedArray 的查询相关的方法与 Array 基本类似，具体用法请参见 array 的说明


  let j = new Int32Array([1, 2, 3, 4]);
  let k = new Int32Array(4);
  let l = new Int32Array(6);
  // set() - 将指定的数组复制过来
  k.set(h);
  // set() - 将指定的数组复制过来，第 2 个参数用于指定复制过来的数组从当前数组的哪个位置开始写入
  l.set(h, 2);
  MyLog.d(`${j}, ${k}, ${l}`);
  // [1, 2, 3, 4], [1, 2, 3, 4], [0, 0, 1, 2, 3, 4]


  let m = new Int32Array([1, 2, 3, 4]);
  // subarray() - 根据关联的 ArrayBuffer 对象复制一份新的且一样的 ArrayBuffer 对象
  //              subarray() 返回的新的 TypedArray 对象关联的是这个新的 ArrayBuffer 对象
  //              subarray() 返回的新的 TypedArray 对象操作的是第 1 个参数指定的位置到第 2 个参数指定的位置（不包括本身）之间的元素
  // 参数可以是负的，负的意思就是从右往左数
  let n = i.subarray(1, 3);
  // slice() - 根据第 1 个参数指定的位置到第 2 个参数指定的位置（不包括本身）之间的元素，生成一个新的 ArrayBuffer 对象
  //           slice() 返回的新的 TypedArray 对象关联的是这个新的 ArrayBuffer 对象
  //           slice() 返回的新的 TypedArray 对象操作的是整个 ArrayBuffer 对象
  // 参数可以是负的，负的意思就是从右往左数
  let o = i.slice(1, 3);
  MyLog.d(`${m}, ${n}, ${o},${ m.buffer.byteLength}, ${n.buffer.byteLength}, ${o.buffer.byteLength}`);
  // [1, 2, 3, 4], [2, 3], [2, 3], 16, 16, 8


  // 复合视图
  let p = new ArrayBuffer(24);
  // ArrayBuffer 对象的 0 - 4（不包括 4）字节由 Uint32Array 对象操作
  let q = new Uint32Array(p, 0, 1);
  // ArrayBuffer 对象的 4 - 20（不包括 20）字节由 Uint8Array 对象操作
  let r = new Uint8Array(p, 4, 16);
  // ArrayBuffer 对象的 20 - 24（不包括 24）字节由 Float32Array 对象操作
  let s = new Float32Array(p, 20, 1);


  // 实例化 DataView 对象，并关联指定的 ArrayBuffer 对象
  // 还有其他多种实例化 DataView 对象的方式，请参见上面的实例化 TypedArray 对象的说明
  // 通过 setInt8(), setUint8(), setInt16(), setUint16(), setInt32(), setUint32(), setFloat32(), setFloat64() 设置数据（第 1 个参数指定字节位置，第 2 个参数指定需要设置的值）
  // 通过 getInt8(), getUint8(), getInt16(), getUint16(), getInt32(), getUint32(), getFloat32(), getFloat64() 获取数据（第 1 个参数指定字节位置）
  let t = new DataView(buffer);
  t.setInt32(0, 100);
  t.setInt32(4, 200);
  MyLog.d(`${t.getInt32(0)}, ${t.getInt32(4)}, ${t.byteLength}, ${ArrayBuffer.isView(t)}`);
  // 100, 200, 32, true


  // 计算机硬件有两种储存数据的方式：大端字节序（big endian）和小端字节序（little endian）
  // 举例来说，数值 0x2211 使用两个字节储存，高位字节是 0x22，低位字节是 0x11
  // 大端字节序：高位字节在前，低位字节在后，即以 0x2211 形式储存，这个符合人类的习惯，所以一般都是大端字节序
  // 小端字节序：低位字节在前，高位字节在后，即以 0x1122 形式储存
  // DataView 对象的 setXXX() 方法的第 3 个参数用于指定是否使用小端字节序，默认为 false（即使用大端字节序）
  // DataView 对象的 getXXX() 方法的第 2 个参数用于指定是否使用小端字节序，默认为 false（即使用大端字节序）
}