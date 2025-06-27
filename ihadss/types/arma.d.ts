interface A3API {
    /**
     * Loads file from game filesystem.
     *
     * @param filePath - Path in game filesystem, without leading backslash
     * @param maxSize - maximum texture width (used to select Mip)
     * @returns The image as a data-url
     */
    RequestTexture(texturePath: string, maxSize: number): Promise<string>;

    /**
     * Loads file from game filesystem.
     *
     * @param filePath - same as loadFile SQF command
     * @returns The file content
     */
    RequestFile(filePath: string): Promise<string>;

    /**
     * Loads and preprocesses file from game filesystem.
     *
     * @param filePath - same as preprocessFile SQF command
     * @returns The file content
     */
    RequestPreprocessedFile(filePath: string): Promise<string>;

    // Triggers a alert() (Needs to be piped due to https://chromestatus.com/feature/5148698084376576)
    SendAlert(content: string): void;

    SendConfirm(content: string): Promise<string>;
}

declare global {
    interface Window {
        A3API?: A3API;
    }
}

export {};