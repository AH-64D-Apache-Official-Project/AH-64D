export const clamp = (x: number, min: number, max: number) =>
  Math.min(max, Math.max(min, x));

export const interpolate = (
  x: number,
  fromMin: number,
  fromMax: number,
  toMin: number,
  toMax: number,
) => toMin + ((x - fromMin) / (fromMax - fromMin)) * (toMax - toMin);

export function interpolateArray<T extends number[]>(key: number, arr: T[]): T {
  let upperIndex: number | null = null;
  for (let i = 0; i < arr.length; i++) {
    if (arr[i][0] > key) {
      upperIndex = i;
      break;
    }
  }

  if (upperIndex === null) {
    return arr[arr.length - 1];
  }
  if (upperIndex === 0) {
    return arr[0];
  }

  const lowerIndex = upperIndex - 1;
  const lowerRow = arr[lowerIndex];
  const upperRow = arr[upperIndex];
  const lK = lowerRow[0];
  const uK = upperRow[0];
  return lowerRow.map((l, i) => interpolate(key, lK, uK, l, upperRow[i])) as T;
}
