export type coord = [number, number];

export const mainDisplayArea: coord[] = [
  [80, 0],
  [560, 0],
  [560, 480],
  [80, 480],
];

export function clipMainDisplay(ctx: CanvasRenderingContext2D) {
  ctx.beginPath();
  ctx.moveTo(...mainDisplayArea[0]);
  mainDisplayArea.forEach((c) => ctx.lineTo(...c));
  ctx.clip();
}

export const safeArea: coord[] = [
  [120, 65],
  [520, 65],
  [520, 415],
  [120, 415],
];
