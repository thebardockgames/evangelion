float sinf(float);
double sin(double);
float cosf(float);
double cos(double);
float sqrtf(float);
typedef signed char s8;
typedef unsigned char u8;
typedef signed short int s16;
typedef unsigned short int u16;
typedef signed int s32;
typedef unsigned int u32;
typedef signed long long int s64;
typedef unsigned long long int u64;
typedef volatile u8 vu8;
typedef volatile u16 vu16;
typedef volatile u32 vu32;
typedef volatile u64 vu64;
typedef volatile s8 vs8;
typedef volatile s16 vs16;
typedef volatile s32 vs32;
typedef volatile s64 vs64;
typedef float f32;
typedef double f64;
typedef u32 size_t;
typedef s32 ssize_t;
typedef u32 uintptr_t;
typedef s32 intptr_t;
typedef s32 ptrdiff_t;
typedef u32 OSIntMask;
typedef u32 OSHWIntr;
extern OSIntMask osGetIntMask(void);
extern OSIntMask osSetIntMask(OSIntMask);
void osInitialize(void);
u32 osGetCount(void);
uintptr_t osVirtualToPhysical(void *);
extern u32 osDpGetStatus(void);
extern void osDpSetStatus(u32);
extern void osDpGetCounters(u32 *);
extern s32 osDpSetNextBuffer(void *, u64);
typedef s32 OSPri;
typedef s32 OSId;
typedef union
{
    struct {f32 f_odd; f32 f_even;} f;
} __OSfp;
typedef struct
{
              u64 at, v0, v1, a0, a1, a2, a3;
              u64 t0, t1, t2, t3, t4, t5, t6, t7;
              u64 s0, s1, s2, s3, s4, s5, s6, s7;
              u64 t8, t9, gp, sp, s8, ra;
              u64 lo, hi;
              u32 sr, pc, cause, badvaddr, rcp;
              u32 fpcsr;
    __OSfp fp0, fp2, fp4, fp6, fp8, fp10, fp12, fp14;
    __OSfp fp16, fp18, fp20, fp22, fp24, fp26, fp28, fp30;
} __OSThreadContext;
typedef struct
{
    u32 flag;
    u32 count;
    u64 time;
} __OSThreadprofile_s;
typedef struct OSThread_s
{
             struct OSThread_s *next;
             OSPri priority;
             struct OSThread_s **queue;
             struct OSThread_s *tlnext;
             u16 state;
             u16 flags;
             OSId id;
             int fp;
             __OSThreadprofile_s *thprof;
             __OSThreadContext context;
} OSThread;
void osCreateThread(OSThread *thread, OSId id, void (*entry)(void *),
    void *arg, void *sp, OSPri pri);
OSId osGetThreadId(OSThread *thread);
OSPri osGetThreadPri(OSThread *thread);
void osSetThreadPri(OSThread *thread, OSPri pri);
void osStartThread(OSThread *thread);
void osStopThread(OSThread *thread);
typedef u32 OSEvent;
typedef void * OSMesg;
typedef struct OSMesgQueue_s {
 OSThread *mtqueue;
 OSThread *fullqueue;
 s32 validCount;
 s32 first;
 s32 msgCount;
 OSMesg *msg;
} OSMesgQueue;
extern void osCreateMesgQueue(OSMesgQueue *, OSMesg *, s32);
extern s32 osSendMesg(OSMesgQueue *, OSMesg, s32);
extern s32 osJamMesg(OSMesgQueue *, OSMesg, s32);
extern s32 osRecvMesg(OSMesgQueue *, OSMesg *, s32);
extern void osSetEventMesg(OSEvent, OSMesgQueue *, OSMesg);
typedef struct OSTimer_str
{
    struct OSTimer_str *next;
    struct OSTimer_str *prev;
    u64 interval;
    u64 remaining;
    OSMesgQueue *mq;
    OSMesg *msg;
} OSTimer;
typedef u64 OSTime;
OSTime osGetTime(void);
void osSetTime(OSTime time);
u32 osSetTimer(OSTimer *, OSTime, u64, OSMesgQueue *, OSMesg);
typedef struct {
 u16 type;
 u8 status;
 u8 errno;
}OSContStatus;
typedef struct {
 u16 button;
 s8 stick_x;
 s8 stick_y;
 u8 errno;
} OSContPad;
typedef struct {
 void *address;
 u8 databuffer[32];
        u8 addressCrc;
 u8 dataCrc;
 u8 errno;
} OSContRamIo;
typedef struct {
 int status;
 OSMesgQueue *queue;
 int channel;
 u8 id[32];
 u8 label[32];
 int version;
 int dir_size;
 int inode_table;
 int minode_table;
 int dir_table;
 int inode_start_page;
 u8 banks;
 u8 activebank;
} OSPfs;
typedef struct {
 u32 file_size;
   u32 game_code;
   u16 company_code;
   char ext_name[4];
   char game_name[16];
} OSPfsState;
extern s32 osContInit(OSMesgQueue *, u8 *, OSContStatus *);
extern s32 osContReset(OSMesgQueue *, OSContStatus *);
extern s32 osContStartQuery(OSMesgQueue *);
extern s32 osContStartReadData(OSMesgQueue *);
extern s32 osContSetCh(u8);
extern void osContGetQuery(OSContStatus *);
extern void osContGetReadData(OSContPad *);
extern s32 osMotorInit(OSMesgQueue *, OSPfs *, int);
extern s32 osMotorStop(OSPfs *);
extern s32 osMotorStart(OSPfs *);
typedef u32 OSPageMask;
extern void osMapTLB(s32, OSPageMask, void *, u32, u32, s32);
extern void osMapTLBRdb(void);
extern void osUnmapTLB(s32);
extern void osUnmapTLBAll(void);
extern void osSetTLBASID(s32);
typedef struct
{
             u32 type;
             u32 flags;
             u64 *ucode_boot;
             u32 ucode_boot_size;
             u64 *ucode;
             u32 ucode_size;
             u64 *ucode_data;
             u32 ucode_data_size;
             u64 *dram_stack;
             u32 dram_stack_size;
             u64 *output_buff;
             u64 *output_buff_size;
             u64 *data_ptr;
             u32 data_size;
             u64 *yield_data_ptr;
             u32 yield_data_size;
} OSTask_t;
typedef union {
    OSTask_t t;
    long long int force_structure_alignment;
} OSTask;
typedef u32 OSYieldResult;
void osSpTaskLoad(OSTask *task);
void osSpTaskLoad(OSTask *task);
void osSpTaskYield(void);
OSYieldResult osSpTaskYielded(OSTask *task);
extern u64 rspF3DBootStart[], rspF3DBootEnd[];
extern u64 rspF3DStart[], rspF3DEnd[];
extern u64 rspF3DDataStart[], rspF3DDataEnd[];
extern u64 rspAspMainStart[], rspAspMainEnd[];
extern u64 rspAspMainDataStart[], rspAspMainDataEnd[];
extern void osInvalDCache(void *, size_t);
extern void osInvalICache(void *, size_t);
extern void osWritebackDCache(void *, size_t);
extern void osWritebackDCacheAll(void);
typedef struct
{
    u32 ctrl;
    u32 width;
    u32 burst;
    u32 vSync;
    u32 hSync;
    u32 leap;
    u32 hStart;
    u32 xScale;
    u32 vCurrent;
} OSViCommonRegs;
typedef struct
{
    u32 origin;
    u32 yScale;
    u32 vStart;
    u32 vBurst;
    u32 vIntr;
} OSViFieldRegs;
typedef struct
{
    u8 type;
    OSViCommonRegs comRegs;
    OSViFieldRegs fldRegs[2];
} OSViMode;
typedef struct
{
               u16 unk00;
               u16 retraceCount;
               void* buffer;
               OSViMode *unk08;
               u32 features;
               OSMesgQueue *mq;
               OSMesg *msg;
               u32 unk18;
               u32 unk1c;
               u32 unk20;
               f32 unk24;
               u16 unk28;
               u32 unk2c;
} OSViContext;
void osCreateViManager(OSPri pri);
void osViSetMode(OSViMode *mode);
void osViSetEvent(OSMesgQueue *mq, OSMesg msg, u32 retraceCount);
void osViBlack(u8 active);
void osViSetSpecialFeatures(u32 func);
void osViSwapBuffer(void *vaddr);
void osViSetYScale(f32 scale);
extern OSViMode osViModeTable[];
typedef struct {
    u32 errStatus;
    void *dramAddr;
    void *C2Addr;
    u32 sectorSize;
    u32 C1ErrNum;
    u32 C1ErrSector[4];
} __OSBlockInfo;
typedef struct {
    u32 cmdType;
    u16 transferMode;
    u16 blockNum;
    s32 sectorNum;
    uintptr_t devAddr;
    u32 bmCtlShadow;
    u32 seqCtlShadow;
    __OSBlockInfo block[2];
} __OSTranxInfo;
typedef struct OSPiHandle_s {
    struct OSPiHandle_s *next;
    u8 type;
    u8 latency;
    u8 pageSize;
    u8 relDuration;
    u8 pulse;
    u8 domain;
    u32 baseAddress;
    u32 speed;
    __OSTranxInfo transferInfo;
} OSPiHandle;
typedef struct {
    u8 type;
    uintptr_t address;
} OSPiInfo;
typedef struct {
    u16 type;
    u8 pri;
    u8 status;
    OSMesgQueue *retQueue;
} OSIoMesgHdr;
typedef struct {
             OSIoMesgHdr hdr;
             void *dramAddr;
             uintptr_t devAddr;
             size_t size;
} OSIoMesg;
s32 osPiStartDma(OSIoMesg *mb, s32 priority, s32 direction, uintptr_t devAddr, void *vAddr,
                 size_t nbytes, OSMesgQueue *mq);
void osCreatePiManager(OSPri pri, OSMesgQueue *cmdQ, OSMesg *cmdBuf, s32 cmdMsgCnt);
OSMesgQueue *osPiGetCmdQueue(void);
s32 osPiWriteIo(uintptr_t devAddr, u32 data);
s32 osPiReadIo(uintptr_t devAddr, u32 *data);
s32 osPiRawStartDma(s32 dir, u32 cart_addr, void *dram_addr, size_t size);
s32 osEPiRawStartDma(OSPiHandle *piHandle, s32 dir, u32 cart_addr, void *dram_addr, size_t size);
extern OSPiHandle *osCartRomInit(void);
extern OSPiHandle *osLeoDiskInit(void);
extern OSPiHandle *osDriveRomInit(void);
extern s32 osEPiDeviceType(OSPiHandle *, OSPiInfo *);
extern s32 osEPiRawWriteIo(OSPiHandle *, u32 , u32);
extern s32 osEPiRawReadIo(OSPiHandle *, u32 , u32 *);
extern s32 osEPiWriteIo(OSPiHandle *, u32 , u32 );
extern s32 osEPiReadIo(OSPiHandle *, u32 , u32 *);
extern s32 osEPiStartDma(OSPiHandle *, OSIoMesg *, s32);
extern s32 osEPiLinkHandle(OSPiHandle *);
OSThread *__osGetCurrFaultedThread(void);
typedef struct {
 short ob[3];
 unsigned short flag;
 short tc[2];
 unsigned char cn[4];
} Vtx_t;
typedef struct {
 short ob[3];
 unsigned short flag;
 short tc[2];
 signed char n[3];
 unsigned char a;
} Vtx_tn;
typedef union {
    Vtx_t v;
    Vtx_tn n;
    long long int force_structure_alignment;
} Vtx;
typedef struct {
  void *SourceImagePointer;
  void *TlutPointer;
  short Stride;
  short SubImageWidth;
  short SubImageHeight;
  char SourceImageType;
  char SourceImageBitSize;
  short SourceImageOffsetS;
  short SourceImageOffsetT;
  char dummy[4];
} uSprite_t;
typedef union {
  uSprite_t s;
  long long int force_structure_allignment[3];
} uSprite;
typedef struct {
 unsigned char flag;
 unsigned char v[3];
} Tri;
typedef s32 Mtx_t[4][4];
typedef union {
    Mtx_t m;
    long long int force_structure_alignment;
} Mtx;
typedef struct {
 short vscale[4];
 short vtrans[4];
} Vp_t;
typedef union {
    Vp_t vp;
    long long int force_structure_alignment;
} Vp;
typedef struct {
  unsigned char col[3];
  char pad1;
  unsigned char colc[3];
  char pad2;
  signed char dir[3];
  char pad3;
} Light_t;
typedef struct {
  unsigned char col[3];
  char pad1;
  unsigned char colc[3];
  char pad2;
} Ambient_t;
typedef struct {
  int x1,y1,x2,y2;
} Hilite_t;
typedef union {
    Light_t l;
    long long int force_structure_alignment[2];
} Light;
typedef union {
    Ambient_t l;
    long long int force_structure_alignment[1];
} Ambient;
typedef struct {
    Ambient a;
    Light l[7];
} Lightsn;
typedef struct {
    Ambient a;
    Light l[1];
} Lights0;
typedef struct {
    Ambient a;
    Light l[1];
} Lights1;
typedef struct {
    Ambient a;
    Light l[2];
} Lights2;
typedef struct {
    Ambient a;
    Light l[3];
} Lights3;
typedef struct {
    Ambient a;
    Light l[4];
} Lights4;
typedef struct {
    Ambient a;
    Light l[5];
} Lights5;
typedef struct {
    Ambient a;
    Light l[6];
} Lights6;
typedef struct {
    Ambient a;
    Light l[7];
} Lights7;
typedef struct {
    Light l[2];
} LookAt;
typedef union {
    Hilite_t h;
    long int force_structure_alignment[4];
} Hilite;
void guPerspectiveF(float mf[4][4], u16 *perspNorm, float fovy, float aspect,
                    float near, float far, float scale);
void guPerspective(Mtx *m, u16 *perspNorm, float fovy, float aspect, float near,
                   float far, float scale);
void guOrtho(Mtx *m, float left, float right, float bottom, float top,
             float near, float far, float scale);
void guTranslate(Mtx *m, float x, float y, float z);
void guRotate(Mtx *m, float a, float x, float y, float z);
void guScale(Mtx *m, float x, float y, float z);
void guMtxF2L(float mf[4][4], Mtx *m);
void guMtxIdent(Mtx *m);
void guMtxIdentF(float mf[4][4]);
void guMtxL2F(float mf[4][4], Mtx *m);
void guNormalize(float *, float *, float *);
void guAlign(Mtx *m, float a, float x, float y, float z);
void guRotateRPY(Mtx *m, float r, float p, float y);
void guLookAtReflect (Mtx *m, LookAt *l, float xEye, float yEye, float zEye,
                    float xAt, float yAt, float zAt,
                    float xUp, float yUp, float zUp);
typedef struct {
 int cmd:8;
 unsigned int par:8;
 unsigned int len:16;
 uintptr_t addr;
} Gdma;
typedef struct {
  int cmd:8;
  int pad:24;
  Tri tri;
} Gtri;
typedef struct {
  int cmd:8;
  int pad1:24;
  int pad2:24;
  unsigned char param:8;
} Gpopmtx;
typedef struct {
  int cmd:8;
  int pad0:8;
  int mw_index:8;
  int number:8;
  int pad1:8;
  int base:24;
} Gsegment;
typedef struct {
  int cmd:8;
  int pad0:8;
  int sft:8;
  int len:8;
  unsigned int data:32;
} GsetothermodeL;
typedef struct {
  int cmd:8;
  int pad0:8;
  int sft:8;
  int len:8;
  unsigned int data:32;
} GsetothermodeH;
typedef struct {
  unsigned char cmd;
  unsigned char lodscale;
  unsigned char tile;
  unsigned char on;
  unsigned short s;
  unsigned short t;
} Gtexture;
typedef struct {
  int cmd:8;
  int pad:24;
  Tri line;
} Gline3D;
typedef struct {
  int cmd:8;
  int pad1:24;
  short int pad2;
  short int scale;
} Gperspnorm;
typedef struct {
                int cmd:8;
                unsigned int fmt:3;
                unsigned int siz:2;
                unsigned int pad:7;
                unsigned int wd:12;
                uintptr_t dram;
} Gsetimg;
typedef struct {
  int cmd:8;
  unsigned int muxs0:24;
  unsigned int muxs1:32;
} Gsetcombine;
typedef struct {
  int cmd:8;
  unsigned char pad;
  unsigned char prim_min_level;
  unsigned char prim_level;
  unsigned long color;
} Gsetcolor;
typedef struct {
  int cmd:8;
  int x0:10;
  int x0frac:2;
  int y0:10;
  int y0frac:2;
  unsigned int pad:8;
  int x1:10;
  int x1frac:2;
  int y1:10;
  int y1frac:2;
} Gfillrect;
typedef struct {
  int cmd:8;
  unsigned int fmt:3;
  unsigned int siz:2;
  unsigned int pad0:1;
  unsigned int line:9;
  unsigned int tmem:9;
  unsigned int pad1:5;
  unsigned int tile:3;
  unsigned int palette:4;
  unsigned int ct:1;
  unsigned int mt:1;
  unsigned int maskt:4;
  unsigned int shiftt:4;
  unsigned int cs:1;
  unsigned int ms:1;
  unsigned int masks:4;
  unsigned int shifts:4;
} Gsettile;
typedef struct {
  int cmd:8;
  unsigned int sl:12;
  unsigned int tl:12;
  int pad:5;
  unsigned int tile:3;
  unsigned int sh:12;
  unsigned int th:12;
} Gloadtile;
typedef Gloadtile Gloadblock;
typedef Gloadtile Gsettilesize;
typedef Gloadtile Gloadtlut;
typedef struct {
  unsigned int cmd:8;
  unsigned int xl:12;
  unsigned int yl:12;
  unsigned int pad1:5;
  unsigned int tile:3;
  unsigned int xh:12;
  unsigned int yh:12;
  unsigned int s:16;
  unsigned int t:16;
  unsigned int dsdx:16;
  unsigned int dtdy:16;
} Gtexrect;
typedef struct {
    unsigned long w0;
    unsigned long w1;
    unsigned long w2;
    unsigned long w3;
} TexRect;
typedef struct {
 uintptr_t w0;
 uintptr_t w1;
} Gwords;
typedef union {
 Gwords words;
 long long int force_structure_alignment;
} Gfx;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int gain:16;
    unsigned int addr;
} Aadpcm;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int gain:16;
    unsigned int addr;
} Apolef;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int pad1:16;
    unsigned int addr;
} Aenvelope;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:8;
    unsigned int dmem:16;
    unsigned int pad2:16;
    unsigned int count:16;
} Aclearbuff;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:8;
    unsigned int pad2:16;
    unsigned int inL:16;
    unsigned int inR:16;
} Ainterleave;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:24;
    unsigned int addr;
} Aloadbuff;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int pad1:16;
    unsigned int addr;
} Aenvmixer;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int gain:16;
    unsigned int dmemi:16;
    unsigned int dmemo:16;
} Amixer;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int dmem2:16;
    unsigned int addr;
} Apan;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int pitch:16;
    unsigned int addr;
} Aresample;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int pad1:16;
    unsigned int addr;
} Areverb;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:24;
    unsigned int addr;
} Asavebuff;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:24;
    unsigned int pad2:2;
    unsigned int number:4;
    unsigned int base:24;
} Asegment;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int dmemin:16;
    unsigned int dmemout:16;
    unsigned int count:16;
} Asetbuff;
typedef struct {
    unsigned int cmd:8;
    unsigned int flags:8;
    unsigned int vol:16;
    unsigned int voltgt:16;
    unsigned int volrate:16;
} Asetvol;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:8;
    unsigned int dmemin:16;
    unsigned int dmemout:16;
    unsigned int count:16;
} Admemmove;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:8;
    unsigned int count:16;
    unsigned int addr;
} Aloadadpcm;
typedef struct {
    unsigned int cmd:8;
    unsigned int pad1:8;
    unsigned int pad2:16;
    unsigned int addr;
} Asetloop;
typedef struct {
    uintptr_t w0;
    uintptr_t w1;
} Awords;
typedef union {
    Awords words;
    long long int force_union_align;
} Acmd;
typedef short ADPCM_STATE[16];
typedef short POLEF_STATE[4];
typedef short RESAMPLE_STATE[16];
typedef short ENVMIX_STATE[40];
extern s32 osEepromProbe(OSMesgQueue *);
extern s32 osEepromRead(OSMesgQueue *, u8, u8 *);
extern s32 osEepromWrite(OSMesgQueue *, u8, u8 *);
extern s32 osEepromLongRead(OSMesgQueue *, u8, u8 *, int);
extern s32 osEepromLongWrite(OSMesgQueue *, u8, u8 *, int);
extern void bcopy(const void *, void *, size_t);
extern void bzero(void *, size_t);
extern u32 osAiGetStatus(void);
extern u32 osAiGetLength(void);
extern s32 osAiSetFrequency(u32);
extern s32 osAiSetNextBuffer(void *, u32);
typedef struct
{
    u8 *offset;
    s32 len;
} ALSeqData;
typedef struct
{
    s16 revision;
    s16 seqCount;
    ALSeqData seqArray[1];
} ALSeqFile;
void alSeqFileNew(ALSeqFile *f, u8 *base);
extern u32 osTvType;
extern u32 osRomBase;
extern u32 osResetType;
extern u32 osMemSize;
extern u8 osAppNmiBuffer[64];
__asm__(".include \"include/labels.inc\"\n");
typedef struct {
    u16 *str;
    s8 wdSpacing;
    s8 htSpacing;
    u8 p3;
    u8 p4;
} FontParams;
typedef struct {
    u32 _000;
    u32 _004;
    u32 _008;
    u32 _00C;
    u32 _010;
    u32 _014;
    u32 _018;
    u32 _01C;
    u32 _020;
    u32 _024;
    u32 _028;
    u8 _02C;
    u8 _02D;
    u8 _02E;
    u8 unk2F;
} UnkStruct80036494_0C_00;
typedef struct {
    UnkStruct80036494_0C_00 *unk0;
    u32 _004;
    u32 _008;
    u32 _00C;
    u32 _010;
    u32 unk14;
    u32 _018;
    u16 unk1C;
} UnkStruct80036494_0C;
typedef struct {
    u32 _000;
    u32 _004;
    u32 _008;
    UnkStruct80036494_0C *unkC;
} UnkStruct80036494;
typedef struct {
    s16 *angelName;
    s16 *machineType;
    s16 *description;
} MissionText;
extern u8 D_800D3BC0,
          D_800D3BC1,
          D_800D3BC2,
          D_800D3BC3,
          D_800D3BC4,
          D_800D3BC5,
          D_800D3BC6;
extern f32 D_800D3BD8, D_800D3BDC, D_800D3BE0;
UnkStruct80036494 *func_80036494_ovl3(u16, s32, s32);
UnkStruct80036494 *func_80036304_ovl3(u16 arg0);
void func_80037BDC_ovl3(u16 *, int, int, s16, int);
typedef u16 String[];
typedef struct {
                u16 *str;
                u16 p1;
                u16 p2;
                u16 p3;
                u16 p4;
                u8 p5;
                u8 p6;
                u8 p7;
                u8 p8;
                u8 p9;
                u8 p10;
                u16 pad;
} TextParams_ovl7;
String D_80040F10_ovl7 = {1,25,406,77,86,65,52,45,336,16,26,0};
String D_80040F28_ovl7 = {1,16,25,51,344,45,344,203,17,16,551,86,65,550,85,1,16,16,16,55,83,71,45,45,69,47,84,47,80,65,45,69,26,0};
String D_80040F6C_ovl7 = {1,25,342,46,71,336,16,45,45,64,343,344,79,26,0};
String D_80040F8C_ovl7 = {278,305,216,137,148,182,167,163,271,242,69,231,191,1,54,58,307,230,69,193,264,172,173,123,114,106,108,0};
String D_80040FC4_ovl7 = {25,103,91,106,108,88,123,24,124,26,0};
String D_80040FDC_ovl7 = {57,69,151,232,291,333,158,283,142,66,62,1,16,16,159,270,107,104,108,48,184,84,83,62,45,58,18,0};
String D_80041014_ovl7 = {332,227,314,143,69,165,83,44,81,18,0};
String D_8004102C_ovl7 = {311,16,16,16,16,295,16,20,0};
String D_80041040_ovl7 = {103,91,106,108,88,123,24,124,0};
String D_80041054_ovl7 = {220,186,157,0};
String D_8004105C_ovl7 = {150,224,131,128,85,39,37,274,66,1,240,81,188,76,17,16,455,456,1,39,37,69,149,270,85,545,532,55,82,18,0};
String D_8004109C_ovl7 = {1,25,423,424,70,318,418,52,83,62,45,58,69,79,26,0};
String D_800410BC_ovl7 = {1,25,16,336,16,490,47,66,68,26,0};
String D_800410D4_ovl7 = {246,34,193,264,69,213,322,48,147,281,52,83,17,0};
String D_800410F0_ovl7 = {217,173,55,82,220,186,157,64,277,186,157,18,0};
String D_8004110C_ovl7 = {1,193,264,66,287,83,82,0};
String D_8004111C_ovl7 = {1,220,186,157,64,277,186,157,17,0};
String D_80041130_ovl7 = {1,57,69,307,317,65,196,18,0};
String D_80041144_ovl7 = {1,345,346,17,16,193,264,70,187,331,171,48,0};
String D_80041160_ovl7 = {1,408,289,323,85,266,136,54,17,16,241,199,77,66,232,181,18,0};
String D_80041184_ovl7 = {1,54,47,54,17,16,533,534,229,183,78,203,153,69,313,247,18,0};
String D_800411A8_ovl7 = {1,193,264,85,265,55,66,70,17,0};
String D_800411BC_ovl7 = {1,29,242,521,324,252,69,100,88,66,243,55,82,0};
String D_800411D8_ovl7 = {1,29,261,271,203,69,140,216,183,173,54,47,65,45,18,0};
String D_800411F8_ovl7 = {1,57,69,496,66,70,17,0};
String D_80041208_ovl7 = {1,102,124,103,64,88,104,94,69,151,522,65,0};
String D_80041224_ovl7 = {1,523,524,525,124,48,526,319,64,65,82,18,0};
String D_80041240_ovl7 = {246,34,193,264,90,104,119,113,91,121,0};
String D_80041258_ovl7 = {220,186,157,16,19,16,277,186,157,0};
String D_8004126C_ovl7 = {38,547,37,16,29,242,69,193,264,66,1,243,55,82,271,203,140,216,183,173,1,66,79,82,193,264,69,335,308,18,0};
String D_800412AC_ovl7 = {16,16,358,153,359,250,360,361,362,363,1,16,16,16,16,16,16,16,16,16,16,16,16,47,80,69,364,365,366,63,0};
String D_800412EC_ovl7 = {16,16,139,367,274,297,66,17,16,16,16,16,16,1,16,16,16,16,16,385,47,69,132,48,147,281,52,83,58,18,0};
String D_8004132C_ovl7 = {369,370,69,371,372,17,16,111,373,24,124,374,0};
String D_80041348_ovl7 = {16,16,193,264,64,147,281,18,16,16,16,0};
String D_80041360_ovl7 = {25,382,287,70,378,52,86,26,0};
String D_80041374_ovl7 = {37,375,28,34,16,69,319,549,85,211,50,17,1,193,264,376,377,69,378,379,85,380,82,99,124,109,381,18,0};
String D_800413B0_ovl7 = {1,25,382,287,47,336,16,57,69,203,70,230,383,16,16,16,16,16,1,16,16,16,16,16,16,57,69,78,69,48,384,46,62,54,74,344,79,26,0};
String D_80041400_ovl7 = {25,38,547,37,16,387,388,389,294,26,0};
String D_80041418_ovl7 = {358,153,359,139,367,66,217,173,55,82,277,186,157,18,0};
String D_80041438_ovl7 = {277,186,157,16,136,185,144,195,0};
String D_8004144C_ovl7 = {376,377,232,181,64,343,46,58,48,336,18,0};
String D_80041464_ovl7 = {193,264,17,16,394,137,144,195,16,22,0};
String D_8004147C_ovl7 = {246,35,193,264,101,124,440,121,113,530,124,0};
String D_80041494_ovl7 = {277,186,157,0};
String D_8004149C_ovl7 = {531,98,531,252,63,69,193,264,69,1,335,308,18,0};
String D_800414B8_ovl7 = {16,246,28,27,193,264,17,16,16,16,16,16,1,16,57,69,399,400,65,299,242,70,273,280,64,54,62,0};
String D_800414F0_ovl7 = {90,124,109,401,223,169,69,17,16,16,16,16,1,16,16,16,16,16,16,16,16,16,16,16,402,403,404,405,223,66,217,345,18,0};
String D_80041534_ovl7 = {16,305,242,406,64,110,121,113,305,297,66,16,16,16,16,16,16,16,16,16,16,1,16,16,16,16,16,16,407,136,55,82,78,69,64,343,84,83,82,18,0};
String D_80041588_ovl7 = {1,408,409,169,289,323,78,410,372,65,54,18,0};
String D_800415A4_ovl7 = {116,101,108,70,272,300,235,174,387,375,28,34,85,290,329,18,0};
String D_800415C8_ovl7 = {411,412,32,27,95,123,413,274,69,16,16,16,16,16,16,1,16,16,16,16,16,16,16,16,238,198,414,70,58,59,415,66,398,416,18,0};
String D_80041610_ovl7 = {1,116,101,108,70,17,16,37,42,113,89,24,121,109,417,400,0};
String D_80041634_ovl7 = {1,30,157,69,38,547,37,63,254,234,193,264,85,0};
String D_80041650_ovl7 = {1,16,16,211,50,199,77,82,201,85,351,418,18,16,16,0};
String D_80041670_ovl7 = {1,544,391,70,16,27,542,27,27,27,27,28,543,17,0};
String D_80041690_ovl7 = {1,16,423,424,70,159,425,82,69,47,336,18,0};
String D_800416AC_ovl7 = {246,28,27,193,264,101,527,97,89,92,121,0};
String D_800416C4_ovl7 = {38,547,37,16,238,157,0};
String D_800416D4_ovl7 = {38,547,37,16,30,157,66,79,82,1,193,264,69,211,50,199,77,17,1,455,456,335,308,18,0};
String D_80041708_ovl7 = {1,191,236,70,478,201,66,232,181,18,0};
String D_80041720_ovl7 = {1,25,79,49,341,60,58,65,17,16,102,124,103,26,0};
String D_80041740_ovl7 = {38,547,37,192,186,157,48,535,240,52,83,82,18,0};
String D_8004175C_ovl7 = {38,547,37,192,186,157,16,159,270,431,432,0};
String D_80041774_ovl7 = {1,431,432,70,17,16,313,247,65,45,64,343,84,83,58,336,18,0};
String D_80041798_ovl7 = {1,16,16,16,16,16,16,16,16,16,16,16,16,54,47,54,17,1,16,16,273,280,102,124,97,123,98,119,113,48,338,260,17,0};
String D_800417DC_ovl7 = {1,242,274,66,437,92,110,121,96,24,338,135,16,22,22,0};
String D_800417FC_ovl7 = {1,25,431,432,252,199,17,16,74,52,47,193,264,16,22,21,26,0};
String D_80041820_ovl7 = {193,264,66,438,439,80,83,58,38,547,37,192,186,157,18,0};
String D_80041840_ovl7 = {1,25,192,186,157,70,345,203,442,85,413,62,436,443,17,0};
String D_80041860_ovl7 = {1,311,295,85,246,28,30,193,264,64,444,300,55,82,26,0};
String D_80041880_ovl7 = {38,547,37,192,186,157,69,449,66,17,16,16,16,16,16,16,16,16,16,1,16,16,16,16,16,16,16,287,83,82,277,186,157,64,330,186,157,18,0};
String D_800418D0_ovl7 = {1,16,25,376,445,85,440,116,24,441,119,98,66,446,81,447,46,448,26,0};
String D_800418F8_ovl7 = {246,28,30,193,264,528,121,529,89,92,121,0};
String D_80041910_ovl7 = {220,186,157,0};
String D_80041918_ovl7 = {440,116,24,441,119,98,66,79,82,1,193,264,69,335,308,18,0};
String D_8004193C_ovl7 = {16,16,385,69,449,72,83,78,65,49,1,16,16,16,16,16,16,16,246,28,31,193,264,48,345,83,58,18,0};
String D_80041978_ovl7 = {408,289,323,85,210,66,335,308,85,460,75,82,122,90,18,0};
String D_80041998_ovl7 = {246,28,31,193,264,454,121,92,121,0};
String D_800419AC_ovl7 = {220,186,157,0};
String D_800419B4_ovl7 = {103,93,113,123,124,108,223,73,1,193,264,85,208,217,17,16,455,456,1,335,308,18,0};
String D_800419E4_ovl7 = {1,402,403,404,405,223,66,246,28,32,193,264,217,345,18,0};
String D_80041A04_ovl7 = {1,399,400,65,457,85,458,459,58,74,74,17,0};
String D_80041A20_ovl7 = {1,16,270,47,65,45,193,264,18,16,16,16,0};
String D_80041A3C_ovl7 = {1,115,103,108,123,124,119,90,113,121,66,62,17,0};
String D_80041A58_ovl7 = {1,193,264,69,335,308,85,460,75,82,277,186,157,18,0};
String D_80041A78_ovl7 = {1,57,69,203,17,16,275,69,461,48,336,18,0};
String D_80041A94_ovl7 = {1,193,264,69,227,339,183,173,16,21,0};
String D_80041AAC_ovl7 = {1,88,104,94,69,462,463,464,465,48,466,66,273,279,16,22,0};
String D_80041AD0_ovl7 = {1,51,69,74,74,63,70,336,18,0};
String D_80041AE4_ovl7 = {330,186,157,17,1,400,217,328,115,103,108,123,124,119,90,113,121,468,63,0};
String D_80041B0C_ovl7 = {1,193,264,85,469,344,18,16,0};
String D_80041B20_ovl7 = {1,254,173,336,18,0};
String D_80041B2C_ovl7 = {1,54,47,54,17,16,37,42,113,89,24,121,109,66,0};
String D_80041B4C_ovl7 = {1,16,70,470,47,83,62,54,74,344,18,16,16,0};
String D_80041B68_ovl7 = {1,25,47,74,84,86,17,16,122,90,26,0};
String D_80041B80_ovl7 = {1,25,109,98,531,85,185,81,62,472,85,193,46,26,0};
String D_80041BA0_ovl7 = {330,186,157,17,1,123,124,96,471,104,69,472,85,210,66,55,82,18,0};
String D_80041BC8_ovl7 = {246,28,32,193,264,88,119,92,121,0};
String D_80041BDC_ovl7 = {330,186,157,0};
String D_80041BE4_ovl7 = {123,124,96,471,104,69,472,66,79,82,17,1,402,403,404,405,223,69,193,264,69,1,335,308,18,0};
String D_80041C18_ovl7 = {1,246,28,33,193,264,64,69,236,45,66,79,81,17,0};
String D_80041C38_ovl7 = {1,475,476,64,65,60,58,246,30,228,267,162,198,17,0};
String D_80041C58_ovl7 = {1,57,69,461,477,85,478,61,77,82,102,124,103,336,18,0};
String D_80041C78_ovl7 = {1,32,479,480,121,109,122,124,16,481,94,482,121,18,0};
String D_80041C98_ovl7 = {1,25,483,70,45,45,68,26,0};
String D_80041CAC_ovl7 = {1,25,94,482,121,63,45,45,79,18,16,258,102,124,103,170,26,0};
String D_80041CD0_ovl7 = {1,32,479,480,121,109,122,124,16,102,124,97,123,107,104,108,18,0};
String D_80041CF4_ovl7 = {1,100,88,69,484,485,78,65,54,66,17,1,102,124,97,123,55,82,94,482,121,0};
String D_80041D20_ovl7 = {1,51,69,486,282,70,45,60,58,45,336,18,0};
String D_80041D3C_ovl7 = {1,102,124,103,70,17,0};
String D_80041D4C_ovl7 = {1,94,482,121,66,243,54,62,127,227,85,487,46,336,0};
String D_80041D6C_ovl7 = {1,488,327,85,489,77,62,45,60,58,336,18,0};
String D_80041D88_ovl7 = {1,273,280,17,16,38,547,37,277,186,157,159,270,16,22,21,0};
String D_80041DAC_ovl7 = {1,45,60,58,45,490,48,491,82,69,47,336,18,0};
String D_80041DC8_ovl7 = {277,186,157,85,491,82,69,70,1,32,479,480,121,109,122,124,16,481,94,482,121,18,0};
String D_80041DF8_ovl7 = {1,57,54,62,417,178,69,102,546,336,18,0};
String D_80041E10_ovl7 = {246,28,34,193,264,373,492,120,104,0};
String D_80041E24_ovl7 = {220,186,157,0};
String D_80041E2C_ovl7 = {94,482,121,69,231,179,136,66,44,82,1,277,186,157,69,493,494,17,16,455,456,1,335,308,18,0};
String D_80041E60_ovl7 = {1,25,538,539,69,203,48,322,58,26,0};
String D_80041E78_ovl7 = {1,417,178,69,193,264,70,335,308,54,58,18,0};
String D_80041E94_ovl7 = {454,24,122,70,17,1,176,69,417,349,311,495,85,248,232,55,82,496,0};
String D_80041EBC_ovl7 = {1,40,38,41,43,305,297,69,254,234,540,541,85,499,82,18,0};
String D_80041EE0_ovl7 = {1,25,500,70,385,78,501,75,74,56,86,79,26,0};
String D_80041EFC_ovl7 = {1,25,500,70,170,58,415,66,502,46,79,344,26,0};
String D_80041F18_ovl7 = {236,205,66,79,82,40,38,41,43,73,69,16,16,16,16,1,16,16,16,16,16,16,16,16,16,16,310,183,173,48,144,195,52,83,58,18,16,16,0};
String D_80041F68_ovl7 = {1,16,25,341,70,81,417,178,69,259,70,16,16,16,1,16,16,16,16,16,16,16,16,16,16,271,470,230,153,59,60,58,65,336,26,0};
String D_80041FB0_ovl7 = {1,127,238,69,496,17,16,250,505,506,66,507,52,83,58,0};
String D_80041FD0_ovl7 = {1,88,104,94,64,277,186,157,18,0};
String D_80041FE4_ovl7 = {1,508,509,205,382,510,244,59,60,58,88,104,94,48,336,0};
String D_80042004_ovl7 = {1,511,17,16,311,487,77,82,336,18,0};
String D_8004201C_ovl7 = {236,553,205,402,504,0};
String D_80042028_ovl7 = {277,186,157,0};
String D_80042030_ovl7 = {103,93,113,123,124,108,223,69,1,236,553,205,402,504,69,173,245,18,0};
String D_80042058_ovl7 = {1,25,536,76,513,425,537,346,69,38,547,37,26,0};
String D_80042074_ovl7 = {25,341,70,81,17,16,512,66,70,512,85,16,16,16,16,16,16,16,1,16,16,16,16,16,16,16,16,78,60,62,231,55,513,425,59,65,26,0};
String D_800420C0_ovl7 = {1,25,38,547,37,102,120,24,516,336,26,0};
String D_800420D8_ovl7 = {1,25,151,232,54,62,45,58,69,336,26,0};
String D_800420F0_ovl7 = {1,25,526,518,335,308,336,16,68,336,26,0};
String D_80042108_ovl7 = {38,547,37,102,120,24,516,0};
String D_80042118_ovl7 = {277,186,157,0};
String D_80042120_ovl7 = {238,62,69,38,547,37,102,120,24,516,69,1,335,308,18,0};
String D_80042140_ovl7 = {335,308,54,58,70,518,69,336,16,16,16,16,16,16,16,16,1,16,16,16,16,16,38,547,37,102,120,24,516,48,298,149,16,22,0};
String D_80042188_ovl7 = {1,25,38,547,37,102,120,24,516,336,16,149,270,533,144,16,22,22,26,0};
String D_800421B0_ovl7 = {1,25,51,336,16,51,83,48,277,186,157,16,22,21,26,0};
String D_800421D0_ovl7 = {25,102,124,103,170,336,277,186,157,48,336,1,88,104,94,48,336,88,104,94,48,24,26,0};
String D_80042200_ovl7 = {57,69,203,336,0};
String D_8004220C_ovl7 = {220,186,157,48,326,415,223,48,82,336,18,0};
TextParams_ovl7 D_80042224_ovl7[] = {
    {&D_80040F8C_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00F0, 0x04, 0x02, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80040FC4_ovl7, 0x00A0, 0x00AF, 0x010E, 0x021C, 0x04, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80040FDC_ovl7, 0x00A0, 0x008F, 0x001E, 0x00F0, 0x04, 0x04, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041014_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x04, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004102C_ovl7, 0x0017, 0x0018, 0x001E, 0x005A, 0x04, 0x09, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041040_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x04, 0x09, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041054_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x04, 0x09, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_8004105C_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x04, 0x09, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_8004109C_ovl7, 0x00A0, 0x00AF, 0x012C, 0x0186, 0x04, 0x63, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800410BC_ovl7, 0x00A0, 0x00AF, 0x0186, 0x0384, 0x04, 0x63, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800410D4_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0096, 0x05, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800410F0_ovl7, 0x00A0, 0x00AF, 0x0096, 0x012C, 0x05, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004110C_ovl7, 0x00A0, 0x008F, 0x001E, 0x0064, 0x05, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004111C_ovl7, 0x00A0, 0x008F, 0x0064, 0x00B4, 0x05, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041130_ovl7, 0x00A0, 0x008F, 0x001E, 0x00A0, 0x05, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041144_ovl7, 0x00A0, 0x008F, 0x001E, 0x008C, 0x05, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041160_ovl7, 0x00A0, 0x008F, 0x008C, 0x00FA, 0x05, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041184_ovl7, 0x00A0, 0x008F, 0x00FA, 0x0190, 0x05, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800411A8_ovl7, 0x00A0, 0x008F, 0x001E, 0x0096, 0x05, 0x0B, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800411BC_ovl7, 0x00A0, 0x008F, 0x0096, 0x012C, 0x05, 0x0B, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800411D8_ovl7, 0x00A0, 0x008F, 0x001E, 0x0096, 0x05, 0x0C, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800411F8_ovl7, 0x00A0, 0x008F, 0x0096, 0x012C, 0x05, 0x0C, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041208_ovl7, 0x00A0, 0x008F, 0x001E, 0x0096, 0x05, 0x0D, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041224_ovl7, 0x00A0, 0x008F, 0x0096, 0x012C, 0x05, 0x0D, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041240_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x05, 0x0E, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041258_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x05, 0x0E, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_8004126C_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x05, 0x0E, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800412AC_ovl7, 0x00A0, 0x00AF, 0x003C, 0x00B4, 0x06, 0x01, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_800412EC_ovl7, 0x00A0, 0x00AF, 0x00B4, 0x01E0, 0x06, 0x01, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_8004132C_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0064, 0x06, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041348_ovl7, 0x00A0, 0x00AF, 0x0064, 0x00BE, 0x06, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041374_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x06, 0x03, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041360_ovl7, 0x00A0, 0x00AF, 0x00B4, 0x0104, 0x06, 0x03, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_800413B0_ovl7, 0x00A0, 0x008F, 0x003C, 0x00FA, 0x06, 0x04, 0xFC, 0x00, 0x02, 0x02, 0x0000},
    {&D_80041400_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00FA, 0x06, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041418_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0096, 0x06, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041438_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x06, 0x0A, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004144C_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x06, 0x0E, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041464_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x06, 0x0F, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004147C_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x06, 0x11, 0xFB, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041494_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x06, 0x11, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_8004149C_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x06, 0x11, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800414B8_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x07, 0x01, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_800414F0_ovl7, 0x00A0, 0x00AF, 0x0082, 0x00E6, 0x07, 0x01, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041534_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00D2, 0x07, 0x02, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041588_ovl7, 0x00A0, 0x008F, 0x001E, 0x0096, 0x07, 0x03, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800415A4_ovl7, 0x00A0, 0x00AF, 0x001E, 0x005A, 0x07, 0x04, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_800415C8_ovl7, 0x00A0, 0x00AF, 0x005A, 0x00B4, 0x07, 0x04, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041610_ovl7, 0x00A0, 0x008F, 0x001E, 0x0064, 0x07, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041634_ovl7, 0x00A0, 0x008F, 0x0064, 0x00A0, 0x07, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041650_ovl7, 0x00A0, 0x008F, 0x00A0, 0x010E, 0x07, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041670_ovl7, 0x00A0, 0x008F, 0x001E, 0x0096, 0x07, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041690_ovl7, 0x00A0, 0x008F, 0x0096, 0x0118, 0x07, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800416AC_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x07, 0x0A, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800416C4_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x07, 0x0A, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800416D4_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x07, 0x0A, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041708_ovl7, 0x00A0, 0x008F, 0x001E, 0x00B4, 0x07, 0x63, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041720_ovl7, 0x00A0, 0x008F, 0x012C, 0x01A4, 0x07, 0x63, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041740_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x08, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004175C_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00A0, 0x08, 0x05, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041774_ovl7, 0x00A0, 0x008F, 0x001E, 0x0078, 0x08, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041798_ovl7, 0x00A0, 0x008F, 0x0078, 0x00D2, 0x08, 0x07, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_800417DC_ovl7, 0x00A0, 0x008F, 0x00D2, 0x012C, 0x08, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800417FC_ovl7, 0x00A0, 0x008F, 0x003C, 0x00A0, 0x08, 0x08, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041820_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00B4, 0x08, 0x0A, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041840_ovl7, 0x00A0, 0x008F, 0x003C, 0x0096, 0x08, 0x0C, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041860_ovl7, 0x00A0, 0x008F, 0x0096, 0x00FA, 0x08, 0x0C, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041880_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0096, 0x08, 0x12, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_800418D0_ovl7, 0x00A0, 0x008F, 0x0005, 0x0064, 0x08, 0x13, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_800418F8_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x08, 0x14, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041910_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x08, 0x14, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041918_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x08, 0x14, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_8004193C_ovl7, 0x00A0, 0x00AF, 0x003C, 0x00DC, 0x09, 0x01, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041978_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00BE, 0x09, 0x08, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041998_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x09, 0x0D, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800419AC_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x09, 0x0D, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800419B4_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x09, 0x0D, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_800419E4_ovl7, 0x00A0, 0x008F, 0x001E, 0x0082, 0x0A, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041A04_ovl7, 0x00A0, 0x008F, 0x0082, 0x00E6, 0x0A, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041A20_ovl7, 0x00A0, 0x008F, 0x00E6, 0x0154, 0x0A, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041A3C_ovl7, 0x00A0, 0x008F, 0x001E, 0x0078, 0x0A, 0x03, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041A58_ovl7, 0x00A0, 0x008F, 0x0078, 0x00D2, 0x0A, 0x03, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041A78_ovl7, 0x00A0, 0x008F, 0x00D2, 0x0118, 0x0A, 0x03, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041A94_ovl7, 0x00A0, 0x008F, 0x001E, 0x00A0, 0x0A, 0x04, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041AAC_ovl7, 0x00A0, 0x008F, 0x001E, 0x0078, 0x0A, 0x05, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041AD0_ovl7, 0x00A0, 0x008F, 0x0078, 0x00DC, 0x0A, 0x05, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041AE4_ovl7, 0x00A0, 0x008F, 0x001E, 0x006E, 0x0A, 0x06, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041B0C_ovl7, 0x00A0, 0x008F, 0x006E, 0x00BE, 0x0A, 0x06, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041B20_ovl7, 0x00A0, 0x008F, 0x001E, 0x005A, 0x0A, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041B2C_ovl7, 0x00A0, 0x008F, 0x001E, 0x0064, 0x0A, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041B4C_ovl7, 0x00A0, 0x008F, 0x0064, 0x00A0, 0x0A, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041B68_ovl7, 0x00A0, 0x008F, 0x001E, 0x0050, 0x0A, 0x09, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041B80_ovl7, 0x00A0, 0x008F, 0x0050, 0x00A0, 0x0A, 0x09, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041BA0_ovl7, 0x00A0, 0x00AF, 0x001E, 0x00A0, 0x0A, 0x0B, 0xFC, 0x00, 0x02, 0x01, 0x0000},
    {&D_80041BC8_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x0A, 0x0D, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041BDC_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x0A, 0x0D, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041BE4_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x0A, 0x0D, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041C18_ovl7, 0x00A0, 0x008F, 0x001E, 0x0082, 0x0B, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041C38_ovl7, 0x00A0, 0x008F, 0x0082, 0x00E6, 0x0B, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041C58_ovl7, 0x00A0, 0x008F, 0x00E6, 0x014A, 0x0B, 0x01, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041C78_ovl7, 0x00A0, 0x008F, 0x001E, 0x0096, 0x0B, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041C98_ovl7, 0x00A0, 0x008F, 0x0168, 0x01F4, 0x0B, 0x02, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041CAC_ovl7, 0x00A0, 0x008F, 0x003C, 0x00BE, 0x0B, 0x03, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041CD0_ovl7, 0x00A0, 0x008F, 0x001E, 0x0078, 0x0B, 0x06, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041CF4_ovl7, 0x00A0, 0x008F, 0x0078, 0x00D2, 0x0B, 0x06, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041D20_ovl7, 0x00A0, 0x008F, 0x00D2, 0x012C, 0x0B, 0x06, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041D3C_ovl7, 0x00A0, 0x008F, 0x001E, 0x0064, 0x0B, 0x07, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041D4C_ovl7, 0x00A0, 0x008F, 0x001E, 0x00D2, 0x0B, 0x08, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041D6C_ovl7, 0x00A0, 0x008F, 0x001E, 0x0082, 0x0B, 0x09, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041D88_ovl7, 0x00A0, 0x008F, 0x001E, 0x0064, 0x0B, 0x0C, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041DAC_ovl7, 0x00A0, 0x008F, 0x001E, 0x0082, 0x0B, 0x0D, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041DC8_ovl7, 0x00A0, 0x00AF, 0x001E, 0x005A, 0x0B, 0x0E, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041DF8_ovl7, 0x00A0, 0x00AF, 0x005A, 0x00A0, 0x0B, 0x0E, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041E10_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x0B, 0x0F, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041E24_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x0B, 0x0F, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041E2C_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x0B, 0x0F, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80041E60_ovl7, 0x00A0, 0x008F, 0x003C, 0x00DC, 0x0C, 0x01, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041E78_ovl7, 0x00A0, 0x008F, 0x001E, 0x00BE, 0x0C, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041E94_ovl7, 0x00A0, 0x008F, 0x00BE, 0x0154, 0x0C, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041EBC_ovl7, 0x00A0, 0x008F, 0x0154, 0x01EA, 0x0C, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041EE0_ovl7, 0x00A0, 0x008F, 0x003C, 0x00BE, 0x0C, 0x03, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041EFC_ovl7, 0x00A0, 0x008F, 0x003C, 0x00B4, 0x0C, 0x04, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80041F68_ovl7, 0x00A0, 0x008F, 0x003C, 0x00DC, 0x0C, 0x09, 0xFC, 0x00, 0x02, 0x02, 0x0000},
    {&D_80041FB0_ovl7, 0x00A0, 0x008F, 0x003C, 0x008C, 0x0C, 0x0B, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041FD0_ovl7, 0x00A0, 0x008F, 0x008C, 0x0120, 0x0C, 0x0B, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041FE4_ovl7, 0x00A0, 0x008F, 0x0120, 0x0190, 0x0C, 0x0B, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80042004_ovl7, 0x00A0, 0x008F, 0x0190, 0x01EA, 0x0C, 0x0B, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004201C_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x0C, 0x1C, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80042028_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x0C, 0x1C, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80042030_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x0C, 0x1C, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80042058_ovl7, 0x00A0, 0x008F, 0x003C, 0x0172, 0x0D, 0x01, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80042074_ovl7, 0x00A0, 0x008F, 0x0096, 0x0172, 0x0D, 0x02, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_800420C0_ovl7, 0x00A0, 0x008F, 0x001E, 0x0046, 0x0D, 0x09, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_800420D8_ovl7, 0x00A0, 0x008F, 0x0046, 0x0136, 0x0D, 0x09, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_800420F0_ovl7, 0x00A0, 0x008F, 0x001E, 0x0082, 0x0D, 0x0D, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80042108_ovl7, 0x006C, 0x0018, 0x001E, 0x005A, 0x0D, 0x0E, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80042118_ovl7, 0x006C, 0x0034, 0x001E, 0x005A, 0x0D, 0x0E, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80042120_ovl7, 0x006C, 0x0050, 0x001E, 0x005A, 0x0D, 0x0E, 0xFC, 0x00, 0x02, 0x03, 0x0000},
    {&D_80042140_ovl7, 0x00A0, 0x00AF, 0x0014, 0x00DC, 0x0E, 0x02, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80042188_ovl7, 0x00A0, 0x008F, 0x001E, 0x00B4, 0x0E, 0x07, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_800421B0_ovl7, 0x00A0, 0x008F, 0x001E, 0x00B4, 0x0E, 0x0C, 0xFC, 0x00, 0x03, 0x02, 0x0000},
    {&D_80042200_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x0E, 0x0F, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_8004220C_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0082, 0x0E, 0x10, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    {&D_80041F18_ovl7, 0x00A0, 0x00AF, 0x001E, 0x0384, 0x0C, 0x06, 0xFC, 0x00, 0x03, 0x01, 0x0000},
    { (void *)0, 0x00A0, 0x008F, 0x001E, 0x005A, 0x0E, 0x00, 0xFC, 0x00, 0x02, 0x02, 0x0000},
};
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80025E20_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026284_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026560_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026664_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026768_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_800267DC_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_8002691C_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026934_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026954_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026AA4_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026CA8_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026D30_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80026F88_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80027018_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_800270A4_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_800273F4_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80027510_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80027610_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80027B90_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80027FA8_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028024_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028084_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_800287D0_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
void func_80028AFC_ovl7(void) {
}
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028B04_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028C40_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028CE0_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028D88_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028DC8_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80028EBC_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029034_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029170_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029314_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_800294A4_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029698_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029B50_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029D34_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_80029EBC_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_8002A0F4_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_8002A1C0_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl7/code_175860" "/" "func_8002A2F8_ovl7" ".s\"\n" "    .set reorder\n" "    .set at\n" );
