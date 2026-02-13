export type coord = [number, number];

export const mainDisplayArea: coord[] = [
  [80, 0],
  [560, 0],
  [560, 480],
  [80, 480],
];

export function clipMainDisplay(_ctx: CanvasRenderingContext2D) {
  _ctx.beginPath();
  _ctx.moveTo(...mainDisplayArea[0]);
  mainDisplayArea.forEach((c) => _ctx.lineTo(...c));
  _ctx.clip();
}

export const safeArea: coord[] = [
  [120, 65],
  [520, 65],
  [520, 415],
  [120, 415],
];
