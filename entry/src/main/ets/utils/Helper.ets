export class Helper {

  static enumToString<T extends Object>(e:T): string[] {
    let result: string[] = []
    Object.keys(e).forEach(key => {
      if (isNaN(Number(key))) {
        result.push(key)
      }
    });
    return result
  }

  static formatDate(date:Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  static getTimestampString(timestamp?:number): string {
    if (timestamp == undefined) {
      const now = new Date();
      return Helper.formatDate(now)
    } else {
      const now = new Date(timestamp);
      return Helper.formatDate(now)
    }
  }
}
