#ifndef FZA_AH64_UFD_HEADERS_UFD_MACROS_HPP
#define FZA_AH64_UFD_HEADERS_UFD_MACROS_HPP

#define UFD_CHAR_WIDTH_VEC 0.064
#define UFD_CHAR_WIDTH (1/35)
#define UFD_CHAR_HEIGHT 0.1

#define UFD_LINE(N) \
class Line##N : Line0 \
{ \
    sourceIndex = N; \
    pos[] = {{0, N*UFD_CHAR_HEIGHT}, 1}; \
    right[] = {{UFD_CHAR_WIDTH_VEC, N*UFD_CHAR_HEIGHT}, 1}; \
    down[] = {{0, (N +1)*UFD_CHAR_HEIGHT}, 1}; \
}

#endif
