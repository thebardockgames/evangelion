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
String D_80069280_ovl3 = {306,147,281,293,184,299,242,234,168,18,0};
String D_80069298_ovl3 = {246,177,69,193,264,18,0};
String D_800692A8_ovl3 = {193,264,336,1,103,93,113,123,124,108,73,552,183,144,195,18,0};
String D_800692CC_ovl3 = {193,264,70,131,257,161,324,274,69,145,259,85,0};
String D_800692E8_ovl3 = {205,270,286,221,55,82,284,328,85,202,61,18,0};
String D_80069304_ovl3 = {54,47,78,17,16,164,328,65,37,42,113,89,24,121,109,18,0};
String D_80069328_ovl3 = {74,52,66,169,252,319,190,16,22,0};
String D_8006933C_ovl3 = {265,55,210,326,62,70,44,82,69,47,16,21,0};
String D_80069358_ovl3 = {150,224,131,128,17,16,253,23,161,324,47,80,69,0};
String D_80069374_ovl3 = {254,234,183,173,85,229,174,55,82,18,0};
String D_8006938C_ovl3 = {25,338,243,55,82,339,340,70,65,45,18,1,16,341,81,58,74,46,17,16,150,224,131,128,26,0};
String D_800693C0_ovl3 = {25,338,243,55,82,339,340,70,65,45,18,1,16,341,81,58,74,46,17,16,150,224,131,128,26,0};
String D_800693F4_ovl3 = {25,305,191,236,66,133,50,82,1,16,146,249,268,85,262,248,54,74,55,26,0};
String D_80069420_ovl3 = {25,305,191,236,66,133,50,82,1,16,146,249,268,85,262,248,54,74,55,26,0};
String D_8006944C_ovl3 = {25,102,124,103,170,17,1,16,220,186,157,63,302,210,85,249,268,26,0};
String D_80069474_ovl3 = {25,122,90,70,330,186,157,63,1,16,304,179,85,249,268,54,62,26,0};
String D_8006949C_ovl3 = {25,320,263,197,70,250,160,69,205,260,17,204,225,17,1,16,216,328,69,132,166,63,254,229,54,74,56,86,26,0};
String D_800694D8_ovl3 = {25,57,69,180,189,85,212,233,55,82,69,85,1,16,303,83,65,45,63,68,26,0};
String D_80069504_ovl3 = {25,200,70,336,1,16,220,186,157,85,209,83,71,45,45,69,68,26,0};
String D_8006952C_ovl3 = {278,305,252,69,263,328,48,336,18,0};
String D_80069540_ovl3 = {115,103,108,123,124,119,90,113,121,73,336,18,0};
String D_8006955C_ovl3 = {191,236,17,104,373,24,108,63,55,0};
String D_80069570_ovl3 = {25,102,124,103,170,26,0};
String D_80069580_ovl3 = {25,278,305,252,69,92,110,121,96,24,1,16,16,44,65,58,66,315,50,82,84,26,0};
String D_800695B0_ovl3 = {25,48,86,71,60,62,68,16,22,26,0};
String D_800695C8_ovl3 = {25,126,285,16,22,26,0};
String D_800695D8_ovl3 = {25,342,46,71,45,45,64,343,344,79,26,0};
String Unused1 = {246,32,193,264,16,119,116,92,121,0};
String Unused2 = {335,16,16,308,0};
String D_80069610_ovl3 = {25,240,263,144,195,26,0};
String D_80069620_ovl3 = {25,173,347,159,51,56,26,0};
String D_80069630_ovl3 = {25,311,295,66,437,92,110,121,96,24,338,135,16,22,26,0};
String D_80069650_ovl3 = {25,65,86,63,55,60,62,16,22,26,0};
String D_80069668_ovl3 = {25,116,104,60,58,16,22,26,0};
String D_8006967C_ovl3 = {25,246,276,208,348,45,63,16,22,26,0};
String D_80069694_ovl3 = {25,126,285,16,22,26,0};
String D_800696A4_ovl3 = {25,70,341,49,16,22,26,0};
String D_800696B4_ovl3 = {25,70,341,49,60,16,22,22,26,0};
String D_800696C8_ovl3 = {25,344,84,44,44,44,44,44,44,44,336,26,0};
u32 D_800696E4_ovl3[] = {
    0x00430085,
    0x08C9110D,
    0x194F2193,
    0x29D74ADF,
    0x5B656C29,
    0x7CAF8D33,
    0x9DF90000,
    0xA63BB77F,
};
u32 D_80069704_ovl3[] = {
    0x71418181,
    0x9203A285,
    0xB2C5C347,
    0xDBC9DC4D,
    0xE513EDD9,
    0xEE5DF723,
    0xFFE9E512,
    0xFFEFFFF9,
};
u32 D_80069724_ovl3[] = {
    0x08430845,
    0x088710C9,
    0x10CB110D,
    0x194F1951,
    0x199321D5,
    0x21D72219,
    0x2A5D0000,
    0x2A5D2A9F,
};
u32 D_80069744_ovl3[] = {
    0x81C781C7,
    0x8A079247,
    0x9A47A289,
    0xAAC9B309,
    0xBB09C349,
    0xCB8BD3CB,
    0xDBCBE40B,
    0xEC4BF48D,
};
u32 D_80069764_ovl3[] = {
    0x508158C1,
    0x61017143,
    0x798381C5,
    0x92059A45,
    0xA287B2C7,
    0xBB09C349,
    0xD389DBCB,
    0xF40BF48D,
};
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_8004FC60_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_8004FD84_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_8004FFF4_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800506AC_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800506E0_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80050B38_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80050E68_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80050F84_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800510A4_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800510C8_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800512FC_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800514E4_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80051614_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_8005196C_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80051D78_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80051EFC_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800520A4_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80052308_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80053168_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_80053F2C_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
__asm__( ".section .text\n" "    .set noat\n" "    .set noreorder\n" "    .include \"" "asm/nonmatchings/ovl3/code_000F9170" "/" "func_800540FC_ovl3" ".s\"\n" "    .set reorder\n" "    .set at\n" );
