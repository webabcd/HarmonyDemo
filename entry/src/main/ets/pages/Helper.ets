export class Helper {

  static enumToString<T extends  Object>(e:T): string[] {
    let result: string[] = []
    Object.keys(e).forEach(key => {
      if (isNaN(Number(key))) {
        result.push(key)
      }
    });
    return result
  }
}
