
src/user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	002d8d93          	addi	s11,s11,2 # 1030 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	cd8a0a13          	addi	s4,s4,-808 # d10 <ithread_join+0x5a>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f8080e7          	jalr	504(ra) # 23e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	4be080e7          	jalr	1214(ra) # 53a <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	fa648493          	addi	s1,s1,-90 # 1030 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	c8250513          	addi	a0,a0,-894 # d28 <ithread_join+0x72>
  ae:	00001097          	auipc	ra,0x1
  b2:	84a080e7          	jalr	-1974(ra) # 8f8 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	c4450513          	addi	a0,a0,-956 # d18 <ithread_join+0x62>
  dc:	00001097          	auipc	ra,0x1
  e0:	81c080e7          	jalr	-2020(ra) # 8f8 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	43c080e7          	jalr	1084(ra) # 522 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	446080e7          	jalr	1094(ra) # 562 <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	412080e7          	jalr	1042(ra) # 54a <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	3da080e7          	jalr	986(ra) # 522 <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	c2a58593          	addi	a1,a1,-982 # d80 <ithread_join+0xca>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	3b8080e7          	jalr	952(ra) # 522 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	bc250513          	addi	a0,a0,-1086 # d38 <ithread_join+0x82>
 17e:	00000097          	auipc	ra,0x0
 182:	77a080e7          	jalr	1914(ra) # 8f8 <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	39a080e7          	jalr	922(ra) # 522 <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	380080e7          	jalr	896(ra) # 522 <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	addi	a1,a1,1
 1b4:	0785                	addi	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
    ;
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
    p++, q++;
 1da:	0505                	addi	a0,a0,1
 1dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	addi	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	86be                	mv	a3,a5
 204:	0785                	addi	a5,a5,1
 206:	fff7c703          	lbu	a4,-1(a5)
 20a:	ff65                	bnez	a4,202 <strlen+0x10>
 20c:	40a6853b          	subw	a0,a3,a0
 210:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ca19                	beqz	a2,238 <memset+0x1c>
 224:	87aa                	mv	a5,a0
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x12>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  for(; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if(*s == c)
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for(; *s; s++)
 24e:	0505                	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
      return (char*)s;
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	711d                	addi	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	addi	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	2485                	addiw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	addi	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	2a6080e7          	jalr	678(ra) # 53a <read>
    if(cc < 1)
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	addi	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
    buf[i++] = c;
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	addi	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 2d6:	711d                	addi	sp,sp,-96
 2d8:	ec86                	sd	ra,88(sp)
 2da:	e8a2                	sd	s0,80(sp)
 2dc:	e4a6                	sd	s1,72(sp)
 2de:	e0ca                	sd	s2,64(sp)
 2e0:	fc4e                	sd	s3,56(sp)
 2e2:	f852                	sd	s4,48(sp)
 2e4:	f456                	sd	s5,40(sp)
 2e6:	f05a                	sd	s6,32(sp)
 2e8:	ec5e                	sd	s7,24(sp)
 2ea:	1080                	addi	s0,sp,96
 2ec:	8baa                	mv	s7,a0
 2ee:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 2f0:	892a                	mv	s2,a0
 2f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f4:	4aa9                	li	s5,10
 2f6:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 2f8:	8a26                	mv	s4,s1
 2fa:	2485                	addiw	s1,s1,1
 2fc:	0334d863          	bge	s1,s3,32c <fgetstdin+0x56>
    cc = read(0, &c, 1);
 300:	4605                	li	a2,1
 302:	faf40593          	addi	a1,s0,-81
 306:	4501                	li	a0,0
 308:	00000097          	auipc	ra,0x0
 30c:	232080e7          	jalr	562(ra) # 53a <read>
    if(cc < 1)
 310:	00a05e63          	blez	a0,32c <fgetstdin+0x56>
    buf[i++] = c;
 314:	faf44783          	lbu	a5,-81(s0)
 318:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 31c:	01578763          	beq	a5,s5,32a <fgetstdin+0x54>
 320:	0905                	addi	s2,s2,1
 322:	fd679be3          	bne	a5,s6,2f8 <fgetstdin+0x22>
    buf[i++] = c;
 326:	8a26                	mv	s4,s1
 328:	a011                	j	32c <fgetstdin+0x56>
 32a:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 32c:	9bd2                	add	s7,s7,s4
 32e:	000b8023          	sb	zero,0(s7)
  return i;
}
 332:	8552                	mv	a0,s4
 334:	60e6                	ld	ra,88(sp)
 336:	6446                	ld	s0,80(sp)
 338:	64a6                	ld	s1,72(sp)
 33a:	6906                	ld	s2,64(sp)
 33c:	79e2                	ld	s3,56(sp)
 33e:	7a42                	ld	s4,48(sp)
 340:	7aa2                	ld	s5,40(sp)
 342:	7b02                	ld	s6,32(sp)
 344:	6be2                	ld	s7,24(sp)
 346:	6125                	addi	sp,sp,96
 348:	8082                	ret

000000000000034a <stat>:

int
stat(const char *n, struct stat *st)
{
 34a:	1101                	addi	sp,sp,-32
 34c:	ec06                	sd	ra,24(sp)
 34e:	e822                	sd	s0,16(sp)
 350:	e04a                	sd	s2,0(sp)
 352:	1000                	addi	s0,sp,32
 354:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 356:	4581                	li	a1,0
 358:	00000097          	auipc	ra,0x0
 35c:	20a080e7          	jalr	522(ra) # 562 <open>
  if(fd < 0)
 360:	02054663          	bltz	a0,38c <stat+0x42>
 364:	e426                	sd	s1,8(sp)
 366:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 368:	85ca                	mv	a1,s2
 36a:	00000097          	auipc	ra,0x0
 36e:	210080e7          	jalr	528(ra) # 57a <fstat>
 372:	892a                	mv	s2,a0
  close(fd);
 374:	8526                	mv	a0,s1
 376:	00000097          	auipc	ra,0x0
 37a:	1d4080e7          	jalr	468(ra) # 54a <close>
  return r;
 37e:	64a2                	ld	s1,8(sp)
}
 380:	854a                	mv	a0,s2
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	6902                	ld	s2,0(sp)
 388:	6105                	addi	sp,sp,32
 38a:	8082                	ret
    return -1;
 38c:	597d                	li	s2,-1
 38e:	bfcd                	j	380 <stat+0x36>

0000000000000390 <atoi>:

int
atoi(const char *s)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 396:	00054683          	lbu	a3,0(a0)
 39a:	fd06879b          	addiw	a5,a3,-48
 39e:	0ff7f793          	zext.b	a5,a5
 3a2:	4625                	li	a2,9
 3a4:	02f66863          	bltu	a2,a5,3d4 <atoi+0x44>
 3a8:	872a                	mv	a4,a0
  n = 0;
 3aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ac:	0705                	addi	a4,a4,1
 3ae:	0025179b          	slliw	a5,a0,0x2
 3b2:	9fa9                	addw	a5,a5,a0
 3b4:	0017979b          	slliw	a5,a5,0x1
 3b8:	9fb5                	addw	a5,a5,a3
 3ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3be:	00074683          	lbu	a3,0(a4)
 3c2:	fd06879b          	addiw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	fef671e3          	bgeu	a2,a5,3ac <atoi+0x1c>
  return n;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  n = 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <atoi+0x3e>

00000000000003d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3de:	02b57463          	bgeu	a0,a1,406 <memmove+0x2e>
    while(n-- > 0)
 3e2:	00c05f63          	blez	a2,400 <memmove+0x28>
 3e6:	1602                	slli	a2,a2,0x20
 3e8:	9201                	srli	a2,a2,0x20
 3ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f0:	0585                	addi	a1,a1,1
 3f2:	0705                	addi	a4,a4,1
 3f4:	fff5c683          	lbu	a3,-1(a1)
 3f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fc:	fef71ae3          	bne	a4,a5,3f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
    dst += n;
 406:	00c50733          	add	a4,a0,a2
    src += n;
 40a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40c:	fec05ae3          	blez	a2,400 <memmove+0x28>
 410:	fff6079b          	addiw	a5,a2,-1
 414:	1782                	slli	a5,a5,0x20
 416:	9381                	srli	a5,a5,0x20
 418:	fff7c793          	not	a5,a5
 41c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 41e:	15fd                	addi	a1,a1,-1
 420:	177d                	addi	a4,a4,-1
 422:	0005c683          	lbu	a3,0(a1)
 426:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42a:	fee79ae3          	bne	a5,a4,41e <memmove+0x46>
 42e:	bfc9                	j	400 <memmove+0x28>

0000000000000430 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 436:	ca05                	beqz	a2,466 <memcmp+0x36>
 438:	fff6069b          	addiw	a3,a2,-1
 43c:	1682                	slli	a3,a3,0x20
 43e:	9281                	srli	a3,a3,0x20
 440:	0685                	addi	a3,a3,1
 442:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 444:	00054783          	lbu	a5,0(a0)
 448:	0005c703          	lbu	a4,0(a1)
 44c:	00e79863          	bne	a5,a4,45c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 450:	0505                	addi	a0,a0,1
    p2++;
 452:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 454:	fed518e3          	bne	a0,a3,444 <memcmp+0x14>
  }
  return 0;
 458:	4501                	li	a0,0
 45a:	a019                	j	460 <memcmp+0x30>
      return *p1 - *p2;
 45c:	40e7853b          	subw	a0,a5,a4
}
 460:	6422                	ld	s0,8(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  return 0;
 466:	4501                	li	a0,0
 468:	bfe5                	j	460 <memcmp+0x30>

000000000000046a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 472:	00000097          	auipc	ra,0x0
 476:	f66080e7          	jalr	-154(ra) # 3d8 <memmove>
}
 47a:	60a2                	ld	ra,8(sp)
 47c:	6402                	ld	s0,0(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret

0000000000000482 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 482:	1141                	addi	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 488:	00054783          	lbu	a5,0(a0)
 48c:	cfbd                	beqz	a5,50a <inet_addr+0x88>
  int dots = 0;
 48e:	4801                	li	a6,0
  int digits = 0;
 490:	4601                	li	a2,0
  int octet = 0;
 492:	4681                	li	a3,0
  uint result = 0;
 494:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 496:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 498:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 49c:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 49e:	4301                	li	t1,0
      if (octet > 255)
 4a0:	0ff00e13          	li	t3,255
 4a4:	a015                	j	4c8 <inet_addr+0x46>
    } else if (*s == '.') {
 4a6:	07d79463          	bne	a5,t4,50e <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 4aa:	c625                	beqz	a2,512 <inet_addr+0x90>
 4ac:	07e80563          	beq	a6,t5,516 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 4b0:	0085959b          	slliw	a1,a1,0x8
 4b4:	8ecd                	or	a3,a3,a1
 4b6:	0006859b          	sext.w	a1,a3
      dots++;
 4ba:	2805                	addiw	a6,a6,1
      digits = 0;
 4bc:	861a                	mv	a2,t1
      octet = 0;
 4be:	869a                	mv	a3,t1
  for (; *s; s++) {
 4c0:	0505                	addi	a0,a0,1
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	c79d                	beqz	a5,4f4 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 4c8:	fd07871b          	addiw	a4,a5,-48
 4cc:	0ff77713          	zext.b	a4,a4
 4d0:	fce8ebe3          	bltu	a7,a4,4a6 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 4d4:	0026971b          	slliw	a4,a3,0x2
 4d8:	9f35                	addw	a4,a4,a3
 4da:	0017171b          	slliw	a4,a4,0x1
 4de:	fd07879b          	addiw	a5,a5,-48
 4e2:	00e786bb          	addw	a3,a5,a4
      digits++;
 4e6:	2605                	addiw	a2,a2,1
      if (octet > 255)
 4e8:	fcde5ce3          	bge	t3,a3,4c0 <inet_addr+0x3e>
        return 0;
 4ec:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 4ee:	6422                	ld	s0,8(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret
    return 0;
 4f4:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 4f6:	de65                	beqz	a2,4ee <inet_addr+0x6c>
 4f8:	478d                	li	a5,3
 4fa:	fef81ae3          	bne	a6,a5,4ee <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 4fe:	0085959b          	slliw	a1,a1,0x8
 502:	8ecd                	or	a3,a3,a1
 504:	0006851b          	sext.w	a0,a3
  return result;
 508:	b7dd                	j	4ee <inet_addr+0x6c>
    return 0;
 50a:	4501                	li	a0,0
 50c:	b7cd                	j	4ee <inet_addr+0x6c>
      return 0;
 50e:	4501                	li	a0,0
 510:	bff9                	j	4ee <inet_addr+0x6c>
        return 0;
 512:	4501                	li	a0,0
 514:	bfe9                	j	4ee <inet_addr+0x6c>
 516:	4501                	li	a0,0
 518:	bfd9                	j	4ee <inet_addr+0x6c>

000000000000051a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51a:	4885                	li	a7,1
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <exit>:
.global exit
exit:
 li a7, SYS_exit
 522:	4889                	li	a7,2
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <wait>:
.global wait
wait:
 li a7, SYS_wait
 52a:	488d                	li	a7,3
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 532:	4891                	li	a7,4
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <read>:
.global read
read:
 li a7, SYS_read
 53a:	4895                	li	a7,5
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <write>:
.global write
write:
 li a7, SYS_write
 542:	48c1                	li	a7,16
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <close>:
.global close
close:
 li a7, SYS_close
 54a:	48d5                	li	a7,21
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <kill>:
.global kill
kill:
 li a7, SYS_kill
 552:	4899                	li	a7,6
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <exec>:
.global exec
exec:
 li a7, SYS_exec
 55a:	489d                	li	a7,7
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <open>:
.global open
open:
 li a7, SYS_open
 562:	48bd                	li	a7,15
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56a:	48c5                	li	a7,17
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 572:	48c9                	li	a7,18
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57a:	48a1                	li	a7,8
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <link>:
.global link
link:
 li a7, SYS_link
 582:	48cd                	li	a7,19
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58a:	48d1                	li	a7,20
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 592:	48a5                	li	a7,9
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <dup>:
.global dup
dup:
 li a7, SYS_dup
 59a:	48a9                	li	a7,10
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a2:	48ad                	li	a7,11
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5aa:	48b1                	li	a7,12
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b2:	48b5                	li	a7,13
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ba:	48b9                	li	a7,14
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 5c2:	48d9                	li	a7,22
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 5ca:	48dd                	li	a7,23
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 5d2:	48e1                	li	a7,24
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 5da:	48e5                	li	a7,25
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <socket>:
.global socket
socket:
 li a7, SYS_socket
 5e2:	48e9                	li	a7,26
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <bind>:
.global bind
bind:
 li a7, SYS_bind
 5ea:	48ed                	li	a7,27
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <accept>:
.global accept
accept:
 li a7, SYS_accept
 5f2:	48f5                	li	a7,29
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <listen>:
.global listen
listen:
 li a7, SYS_listen
 5fa:	48f1                	li	a7,28
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <connect>:
.global connect
connect:
 li a7, SYS_connect
 602:	48f9                	li	a7,30
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <send>:
.global send
send:
 li a7, SYS_send
 60a:	48fd                	li	a7,31
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <recv>:
.global recv
recv:
 li a7, SYS_recv
 612:	02000893          	li	a7,32
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 61c:	02100893          	li	a7,33
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 626:	02200893          	li	a7,34
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 630:	1101                	addi	sp,sp,-32
 632:	ec06                	sd	ra,24(sp)
 634:	e822                	sd	s0,16(sp)
 636:	1000                	addi	s0,sp,32
 638:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 63c:	4605                	li	a2,1
 63e:	fef40593          	addi	a1,s0,-17
 642:	00000097          	auipc	ra,0x0
 646:	f00080e7          	jalr	-256(ra) # 542 <write>
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	6105                	addi	sp,sp,32
 650:	8082                	ret

0000000000000652 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 652:	7139                	addi	sp,sp,-64
 654:	fc06                	sd	ra,56(sp)
 656:	f822                	sd	s0,48(sp)
 658:	f426                	sd	s1,40(sp)
 65a:	0080                	addi	s0,sp,64
 65c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65e:	c299                	beqz	a3,664 <printint+0x12>
 660:	0805cb63          	bltz	a1,6f6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 664:	2581                	sext.w	a1,a1
  neg = 0;
 666:	4881                	li	a7,0
 668:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66e:	2601                	sext.w	a2,a2
 670:	00000517          	auipc	a0,0x0
 674:	77050513          	addi	a0,a0,1904 # de0 <digits>
 678:	883a                	mv	a6,a4
 67a:	2705                	addiw	a4,a4,1
 67c:	02c5f7bb          	remuw	a5,a1,a2
 680:	1782                	slli	a5,a5,0x20
 682:	9381                	srli	a5,a5,0x20
 684:	97aa                	add	a5,a5,a0
 686:	0007c783          	lbu	a5,0(a5)
 68a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68e:	0005879b          	sext.w	a5,a1
 692:	02c5d5bb          	divuw	a1,a1,a2
 696:	0685                	addi	a3,a3,1
 698:	fec7f0e3          	bgeu	a5,a2,678 <printint+0x26>
  if(neg)
 69c:	00088c63          	beqz	a7,6b4 <printint+0x62>
    buf[i++] = '-';
 6a0:	fd070793          	addi	a5,a4,-48
 6a4:	00878733          	add	a4,a5,s0
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05c63          	blez	a4,6ec <printint+0x9a>
 6b8:	f04a                	sd	s2,32(sp)
 6ba:	ec4e                	sd	s3,24(sp)
 6bc:	fc040793          	addi	a5,s0,-64
 6c0:	00e78933          	add	s2,a5,a4
 6c4:	fff78993          	addi	s3,a5,-1
 6c8:	99ba                	add	s3,s3,a4
 6ca:	377d                	addiw	a4,a4,-1
 6cc:	1702                	slli	a4,a4,0x20
 6ce:	9301                	srli	a4,a4,0x20
 6d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d4:	fff94583          	lbu	a1,-1(s2)
 6d8:	8526                	mv	a0,s1
 6da:	00000097          	auipc	ra,0x0
 6de:	f56080e7          	jalr	-170(ra) # 630 <putc>
  while(--i >= 0)
 6e2:	197d                	addi	s2,s2,-1
 6e4:	ff3918e3          	bne	s2,s3,6d4 <printint+0x82>
 6e8:	7902                	ld	s2,32(sp)
 6ea:	69e2                	ld	s3,24(sp)
}
 6ec:	70e2                	ld	ra,56(sp)
 6ee:	7442                	ld	s0,48(sp)
 6f0:	74a2                	ld	s1,40(sp)
 6f2:	6121                	addi	sp,sp,64
 6f4:	8082                	ret
    x = -xx;
 6f6:	40b005bb          	negw	a1,a1
    neg = 1;
 6fa:	4885                	li	a7,1
    x = -xx;
 6fc:	b7b5                	j	668 <printint+0x16>

00000000000006fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fe:	715d                	addi	sp,sp,-80
 700:	e486                	sd	ra,72(sp)
 702:	e0a2                	sd	s0,64(sp)
 704:	f84a                	sd	s2,48(sp)
 706:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 708:	0005c903          	lbu	s2,0(a1)
 70c:	1a090a63          	beqz	s2,8c0 <vprintf+0x1c2>
 710:	fc26                	sd	s1,56(sp)
 712:	f44e                	sd	s3,40(sp)
 714:	f052                	sd	s4,32(sp)
 716:	ec56                	sd	s5,24(sp)
 718:	e85a                	sd	s6,16(sp)
 71a:	e45e                	sd	s7,8(sp)
 71c:	8aaa                	mv	s5,a0
 71e:	8bb2                	mv	s7,a2
 720:	00158493          	addi	s1,a1,1
  state = 0;
 724:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 726:	02500a13          	li	s4,37
 72a:	4b55                	li	s6,21
 72c:	a839                	j	74a <vprintf+0x4c>
        putc(fd, c);
 72e:	85ca                	mv	a1,s2
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	efe080e7          	jalr	-258(ra) # 630 <putc>
 73a:	a019                	j	740 <vprintf+0x42>
    } else if(state == '%'){
 73c:	01498d63          	beq	s3,s4,756 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 740:	0485                	addi	s1,s1,1
 742:	fff4c903          	lbu	s2,-1(s1)
 746:	16090763          	beqz	s2,8b4 <vprintf+0x1b6>
    if(state == 0){
 74a:	fe0999e3          	bnez	s3,73c <vprintf+0x3e>
      if(c == '%'){
 74e:	ff4910e3          	bne	s2,s4,72e <vprintf+0x30>
        state = '%';
 752:	89d2                	mv	s3,s4
 754:	b7f5                	j	740 <vprintf+0x42>
      if(c == 'd'){
 756:	13490463          	beq	s2,s4,87e <vprintf+0x180>
 75a:	f9d9079b          	addiw	a5,s2,-99
 75e:	0ff7f793          	zext.b	a5,a5
 762:	12fb6763          	bltu	s6,a5,890 <vprintf+0x192>
 766:	f9d9079b          	addiw	a5,s2,-99
 76a:	0ff7f713          	zext.b	a4,a5
 76e:	12eb6163          	bltu	s6,a4,890 <vprintf+0x192>
 772:	00271793          	slli	a5,a4,0x2
 776:	00000717          	auipc	a4,0x0
 77a:	61270713          	addi	a4,a4,1554 # d88 <ithread_join+0xd2>
 77e:	97ba                	add	a5,a5,a4
 780:	439c                	lw	a5,0(a5)
 782:	97ba                	add	a5,a5,a4
 784:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 786:	008b8913          	addi	s2,s7,8
 78a:	4685                	li	a3,1
 78c:	4629                	li	a2,10
 78e:	000ba583          	lw	a1,0(s7)
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	ebe080e7          	jalr	-322(ra) # 652 <printint>
 79c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b745                	j	740 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a2:	008b8913          	addi	s2,s7,8
 7a6:	4681                	li	a3,0
 7a8:	4629                	li	a2,10
 7aa:	000ba583          	lw	a1,0(s7)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	ea2080e7          	jalr	-350(ra) # 652 <printint>
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b751                	j	740 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4641                	li	a2,16
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e86080e7          	jalr	-378(ra) # 652 <printint>
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b7a5                	j	740 <vprintf+0x42>
 7da:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7dc:	008b8c13          	addi	s8,s7,8
 7e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e4:	03000593          	li	a1,48
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	e46080e7          	jalr	-442(ra) # 630 <putc>
  putc(fd, 'x');
 7f2:	07800593          	li	a1,120
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	e38080e7          	jalr	-456(ra) # 630 <putc>
 800:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 802:	00000b97          	auipc	s7,0x0
 806:	5deb8b93          	addi	s7,s7,1502 # de0 <digits>
 80a:	03c9d793          	srli	a5,s3,0x3c
 80e:	97de                	add	a5,a5,s7
 810:	0007c583          	lbu	a1,0(a5)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	e1a080e7          	jalr	-486(ra) # 630 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 81e:	0992                	slli	s3,s3,0x4
 820:	397d                	addiw	s2,s2,-1
 822:	fe0914e3          	bnez	s2,80a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 826:	8be2                	mv	s7,s8
      state = 0;
 828:	4981                	li	s3,0
 82a:	6c02                	ld	s8,0(sp)
 82c:	bf11                	j	740 <vprintf+0x42>
        s = va_arg(ap, char*);
 82e:	008b8993          	addi	s3,s7,8
 832:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 836:	02090163          	beqz	s2,858 <vprintf+0x15a>
        while(*s != 0){
 83a:	00094583          	lbu	a1,0(s2)
 83e:	c9a5                	beqz	a1,8ae <vprintf+0x1b0>
          putc(fd, *s);
 840:	8556                	mv	a0,s5
 842:	00000097          	auipc	ra,0x0
 846:	dee080e7          	jalr	-530(ra) # 630 <putc>
          s++;
 84a:	0905                	addi	s2,s2,1
        while(*s != 0){
 84c:	00094583          	lbu	a1,0(s2)
 850:	f9e5                	bnez	a1,840 <vprintf+0x142>
        s = va_arg(ap, char*);
 852:	8bce                	mv	s7,s3
      state = 0;
 854:	4981                	li	s3,0
 856:	b5ed                	j	740 <vprintf+0x42>
          s = "(null)";
 858:	00000917          	auipc	s2,0x0
 85c:	4f890913          	addi	s2,s2,1272 # d50 <ithread_join+0x9a>
        while(*s != 0){
 860:	02800593          	li	a1,40
 864:	bff1                	j	840 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 866:	008b8913          	addi	s2,s7,8
 86a:	000bc583          	lbu	a1,0(s7)
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	dc0080e7          	jalr	-576(ra) # 630 <putc>
 878:	8bca                	mv	s7,s2
      state = 0;
 87a:	4981                	li	s3,0
 87c:	b5d1                	j	740 <vprintf+0x42>
        putc(fd, c);
 87e:	02500593          	li	a1,37
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	dac080e7          	jalr	-596(ra) # 630 <putc>
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bd4d                	j	740 <vprintf+0x42>
        putc(fd, '%');
 890:	02500593          	li	a1,37
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	d9a080e7          	jalr	-614(ra) # 630 <putc>
        putc(fd, c);
 89e:	85ca                	mv	a1,s2
 8a0:	8556                	mv	a0,s5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	d8e080e7          	jalr	-626(ra) # 630 <putc>
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd51                	j	740 <vprintf+0x42>
        s = va_arg(ap, char*);
 8ae:	8bce                	mv	s7,s3
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b579                	j	740 <vprintf+0x42>
 8b4:	74e2                	ld	s1,56(sp)
 8b6:	79a2                	ld	s3,40(sp)
 8b8:	7a02                	ld	s4,32(sp)
 8ba:	6ae2                	ld	s5,24(sp)
 8bc:	6b42                	ld	s6,16(sp)
 8be:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8c0:	60a6                	ld	ra,72(sp)
 8c2:	6406                	ld	s0,64(sp)
 8c4:	7942                	ld	s2,48(sp)
 8c6:	6161                	addi	sp,sp,80
 8c8:	8082                	ret

00000000000008ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ca:	715d                	addi	sp,sp,-80
 8cc:	ec06                	sd	ra,24(sp)
 8ce:	e822                	sd	s0,16(sp)
 8d0:	1000                	addi	s0,sp,32
 8d2:	e010                	sd	a2,0(s0)
 8d4:	e414                	sd	a3,8(s0)
 8d6:	e818                	sd	a4,16(s0)
 8d8:	ec1c                	sd	a5,24(s0)
 8da:	03043023          	sd	a6,32(s0)
 8de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e6:	8622                	mv	a2,s0
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e16080e7          	jalr	-490(ra) # 6fe <vprintf>
}
 8f0:	60e2                	ld	ra,24(sp)
 8f2:	6442                	ld	s0,16(sp)
 8f4:	6161                	addi	sp,sp,80
 8f6:	8082                	ret

00000000000008f8 <printf>:

void
printf(const char *fmt, ...)
{
 8f8:	711d                	addi	sp,sp,-96
 8fa:	ec06                	sd	ra,24(sp)
 8fc:	e822                	sd	s0,16(sp)
 8fe:	1000                	addi	s0,sp,32
 900:	e40c                	sd	a1,8(s0)
 902:	e810                	sd	a2,16(s0)
 904:	ec14                	sd	a3,24(s0)
 906:	f018                	sd	a4,32(s0)
 908:	f41c                	sd	a5,40(s0)
 90a:	03043823          	sd	a6,48(s0)
 90e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 912:	00840613          	addi	a2,s0,8
 916:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 91a:	85aa                	mv	a1,a0
 91c:	4505                	li	a0,1
 91e:	00000097          	auipc	ra,0x0
 922:	de0080e7          	jalr	-544(ra) # 6fe <vprintf>
}
 926:	60e2                	ld	ra,24(sp)
 928:	6442                	ld	s0,16(sp)
 92a:	6125                	addi	sp,sp,96
 92c:	8082                	ret

000000000000092e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92e:	1141                	addi	sp,sp,-16
 930:	e422                	sd	s0,8(sp)
 932:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 934:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	00000797          	auipc	a5,0x0
 93c:	6d87b783          	ld	a5,1752(a5) # 1010 <freep>
 940:	a02d                	j	96a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 942:	4618                	lw	a4,8(a2)
 944:	9f2d                	addw	a4,a4,a1
 946:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 94a:	6398                	ld	a4,0(a5)
 94c:	6310                	ld	a2,0(a4)
 94e:	a83d                	j	98c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 950:	ff852703          	lw	a4,-8(a0)
 954:	9f31                	addw	a4,a4,a2
 956:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 958:	ff053683          	ld	a3,-16(a0)
 95c:	a091                	j	9a0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95e:	6398                	ld	a4,0(a5)
 960:	00e7e463          	bltu	a5,a4,968 <free+0x3a>
 964:	00e6ea63          	bltu	a3,a4,978 <free+0x4a>
{
 968:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96a:	fed7fae3          	bgeu	a5,a3,95e <free+0x30>
 96e:	6398                	ld	a4,0(a5)
 970:	00e6e463          	bltu	a3,a4,978 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 974:	fee7eae3          	bltu	a5,a4,968 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 978:	ff852583          	lw	a1,-8(a0)
 97c:	6390                	ld	a2,0(a5)
 97e:	02059813          	slli	a6,a1,0x20
 982:	01c85713          	srli	a4,a6,0x1c
 986:	9736                	add	a4,a4,a3
 988:	fae60de3          	beq	a2,a4,942 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 98c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 990:	4790                	lw	a2,8(a5)
 992:	02061593          	slli	a1,a2,0x20
 996:	01c5d713          	srli	a4,a1,0x1c
 99a:	973e                	add	a4,a4,a5
 99c:	fae68ae3          	beq	a3,a4,950 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9a0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9a2:	00000717          	auipc	a4,0x0
 9a6:	66f73723          	sd	a5,1646(a4) # 1010 <freep>
}
 9aa:	6422                	ld	s0,8(sp)
 9ac:	0141                	addi	sp,sp,16
 9ae:	8082                	ret

00000000000009b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b0:	7139                	addi	sp,sp,-64
 9b2:	fc06                	sd	ra,56(sp)
 9b4:	f822                	sd	s0,48(sp)
 9b6:	f426                	sd	s1,40(sp)
 9b8:	ec4e                	sd	s3,24(sp)
 9ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9bc:	02051493          	slli	s1,a0,0x20
 9c0:	9081                	srli	s1,s1,0x20
 9c2:	04bd                	addi	s1,s1,15
 9c4:	8091                	srli	s1,s1,0x4
 9c6:	0014899b          	addiw	s3,s1,1
 9ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9cc:	00000517          	auipc	a0,0x0
 9d0:	64453503          	ld	a0,1604(a0) # 1010 <freep>
 9d4:	c915                	beqz	a0,a08 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	08977e63          	bgeu	a4,s1,a76 <malloc+0xc6>
 9de:	f04a                	sd	s2,32(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9e6:	8a4e                	mv	s4,s3
 9e8:	0009871b          	sext.w	a4,s3
 9ec:	6685                	lui	a3,0x1
 9ee:	00d77363          	bgeu	a4,a3,9f4 <malloc+0x44>
 9f2:	6a05                	lui	s4,0x1
 9f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9fc:	00000917          	auipc	s2,0x0
 a00:	61490913          	addi	s2,s2,1556 # 1010 <freep>
  if(p == (char*)-1)
 a04:	5afd                	li	s5,-1
 a06:	a091                	j	a4a <malloc+0x9a>
 a08:	f04a                	sd	s2,32(sp)
 a0a:	e852                	sd	s4,16(sp)
 a0c:	e456                	sd	s5,8(sp)
 a0e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a10:	00001797          	auipc	a5,0x1
 a14:	82078793          	addi	a5,a5,-2016 # 1230 <base>
 a18:	00000717          	auipc	a4,0x0
 a1c:	5ef73c23          	sd	a5,1528(a4) # 1010 <freep>
 a20:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a22:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a26:	b7c1                	j	9e6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a28:	6398                	ld	a4,0(a5)
 a2a:	e118                	sd	a4,0(a0)
 a2c:	a08d                	j	a8e <malloc+0xde>
  hp->s.size = nu;
 a2e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a32:	0541                	addi	a0,a0,16
 a34:	00000097          	auipc	ra,0x0
 a38:	efa080e7          	jalr	-262(ra) # 92e <free>
  return freep;
 a3c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a40:	c13d                	beqz	a0,aa6 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a44:	4798                	lw	a4,8(a5)
 a46:	02977463          	bgeu	a4,s1,a6e <malloc+0xbe>
    if(p == freep)
 a4a:	00093703          	ld	a4,0(s2)
 a4e:	853e                	mv	a0,a5
 a50:	fef719e3          	bne	a4,a5,a42 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a54:	8552                	mv	a0,s4
 a56:	00000097          	auipc	ra,0x0
 a5a:	b54080e7          	jalr	-1196(ra) # 5aa <sbrk>
  if(p == (char*)-1)
 a5e:	fd5518e3          	bne	a0,s5,a2e <malloc+0x7e>
        return 0;
 a62:	4501                	li	a0,0
 a64:	7902                	ld	s2,32(sp)
 a66:	6a42                	ld	s4,16(sp)
 a68:	6aa2                	ld	s5,8(sp)
 a6a:	6b02                	ld	s6,0(sp)
 a6c:	a03d                	j	a9a <malloc+0xea>
 a6e:	7902                	ld	s2,32(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a76:	fae489e3          	beq	s1,a4,a28 <malloc+0x78>
        p->s.size -= nunits;
 a7a:	4137073b          	subw	a4,a4,s3
 a7e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a80:	02071693          	slli	a3,a4,0x20
 a84:	01c6d713          	srli	a4,a3,0x1c
 a88:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a8a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a8e:	00000717          	auipc	a4,0x0
 a92:	58a73123          	sd	a0,1410(a4) # 1010 <freep>
      return (void*)(p + 1);
 a96:	01078513          	addi	a0,a5,16
  }
}
 a9a:	70e2                	ld	ra,56(sp)
 a9c:	7442                	ld	s0,48(sp)
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	69e2                	ld	s3,24(sp)
 aa2:	6121                	addi	sp,sp,64
 aa4:	8082                	ret
 aa6:	7902                	ld	s2,32(sp)
 aa8:	6a42                	ld	s4,16(sp)
 aaa:	6aa2                	ld	s5,8(sp)
 aac:	6b02                	ld	s6,0(sp)
 aae:	b7f5                	j	a9a <malloc+0xea>

0000000000000ab0 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 ab0:	1141                	addi	sp,sp,-16
 ab2:	e406                	sd	ra,8(sp)
 ab4:	e022                	sd	s0,0(sp)
 ab6:	0800                	addi	s0,sp,16
  thread_exit(status);
 ab8:	2501                	sext.w	a0,a0
 aba:	00000097          	auipc	ra,0x0
 abe:	b20080e7          	jalr	-1248(ra) # 5da <thread_exit>
}
 ac2:	60a2                	ld	ra,8(sp)
 ac4:	6402                	ld	s0,0(sp)
 ac6:	0141                	addi	sp,sp,16
 ac8:	8082                	ret

0000000000000aca <free_stacks>:
int free_stacks() {
 aca:	7179                	addi	sp,sp,-48
 acc:	f406                	sd	ra,40(sp)
 ace:	f022                	sd	s0,32(sp)
 ad0:	ec26                	sd	s1,24(sp)
 ad2:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 ad4:	00000797          	auipc	a5,0x0
 ad8:	54c7a783          	lw	a5,1356(a5) # 1020 <num_threads>
 adc:	04f05063          	blez	a5,b1c <free_stacks+0x52>
 ae0:	e84a                	sd	s2,16(sp)
 ae2:	e44e                	sd	s3,8(sp)
 ae4:	4481                	li	s1,0
    free(stacks[i]);
 ae6:	00000997          	auipc	s3,0x0
 aea:	53298993          	addi	s3,s3,1330 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 aee:	00000917          	auipc	s2,0x0
 af2:	53290913          	addi	s2,s2,1330 # 1020 <num_threads>
    free(stacks[i]);
 af6:	0009b783          	ld	a5,0(s3)
 afa:	00349713          	slli	a4,s1,0x3
 afe:	97ba                	add	a5,a5,a4
 b00:	6388                	ld	a0,0(a5)
 b02:	00000097          	auipc	ra,0x0
 b06:	e2c080e7          	jalr	-468(ra) # 92e <free>
  for (int i = 0; i < num_threads; i++) {
 b0a:	0485                	addi	s1,s1,1
 b0c:	00092703          	lw	a4,0(s2)
 b10:	0004879b          	sext.w	a5,s1
 b14:	fee7c1e3          	blt	a5,a4,af6 <free_stacks+0x2c>
 b18:	6942                	ld	s2,16(sp)
 b1a:	69a2                	ld	s3,8(sp)
  free(stacks);
 b1c:	00000497          	auipc	s1,0x0
 b20:	4fc48493          	addi	s1,s1,1276 # 1018 <stacks>
 b24:	6088                	ld	a0,0(s1)
 b26:	00000097          	auipc	ra,0x0
 b2a:	e08080e7          	jalr	-504(ra) # 92e <free>
  stacks = 0;
 b2e:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b32:	00000797          	auipc	a5,0x0
 b36:	4e07a723          	sw	zero,1262(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b3a:	47a1                	li	a5,8
 b3c:	00000717          	auipc	a4,0x0
 b40:	4cf72223          	sw	a5,1220(a4) # 1000 <max_stacks>
  threads_done = 0;
 b44:	00000797          	auipc	a5,0x0
 b48:	4e07a023          	sw	zero,1248(a5) # 1024 <threads_done>
}
 b4c:	4501                	li	a0,0
 b4e:	70a2                	ld	ra,40(sp)
 b50:	7402                	ld	s0,32(sp)
 b52:	64e2                	ld	s1,24(sp)
 b54:	6145                	addi	sp,sp,48
 b56:	8082                	ret

0000000000000b58 <expand_num_threads>:
int expand_num_threads() {
 b58:	1101                	addi	sp,sp,-32
 b5a:	ec06                	sd	ra,24(sp)
 b5c:	e822                	sd	s0,16(sp)
 b5e:	e426                	sd	s1,8(sp)
 b60:	e04a                	sd	s2,0(sp)
 b62:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b64:	00000797          	auipc	a5,0x0
 b68:	49c78793          	addi	a5,a5,1180 # 1000 <max_stacks>
 b6c:	4388                	lw	a0,0(a5)
 b6e:	0015151b          	slliw	a0,a0,0x1
 b72:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b74:	0035151b          	slliw	a0,a0,0x3
 b78:	00000097          	auipc	ra,0x0
 b7c:	e38080e7          	jalr	-456(ra) # 9b0 <malloc>
 b80:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 b82:	00000617          	auipc	a2,0x0
 b86:	49e62603          	lw	a2,1182(a2) # 1020 <num_threads>
 b8a:	00000497          	auipc	s1,0x0
 b8e:	48e48493          	addi	s1,s1,1166 # 1018 <stacks>
 b92:	0036161b          	slliw	a2,a2,0x3
 b96:	608c                	ld	a1,0(s1)
 b98:	00000097          	auipc	ra,0x0
 b9c:	840080e7          	jalr	-1984(ra) # 3d8 <memmove>
  free(stacks);
 ba0:	6088                	ld	a0,0(s1)
 ba2:	00000097          	auipc	ra,0x0
 ba6:	d8c080e7          	jalr	-628(ra) # 92e <free>
  stacks = new_stacks;
 baa:	0124b023          	sd	s2,0(s1)
}
 bae:	4501                	li	a0,0
 bb0:	60e2                	ld	ra,24(sp)
 bb2:	6442                	ld	s0,16(sp)
 bb4:	64a2                	ld	s1,8(sp)
 bb6:	6902                	ld	s2,0(sp)
 bb8:	6105                	addi	sp,sp,32
 bba:	8082                	ret

0000000000000bbc <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 bbc:	7179                	addi	sp,sp,-48
 bbe:	f406                	sd	ra,40(sp)
 bc0:	f022                	sd	s0,32(sp)
 bc2:	e84a                	sd	s2,16(sp)
 bc4:	e44e                	sd	s3,8(sp)
 bc6:	1800                	addi	s0,sp,48
 bc8:	892a                	mv	s2,a0
 bca:	89ae                	mv	s3,a1
  if (stacks == 0) {
 bcc:	00000797          	auipc	a5,0x0
 bd0:	44c7b783          	ld	a5,1100(a5) # 1018 <stacks>
 bd4:	c3d9                	beqz	a5,c5a <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 bd6:	00000797          	auipc	a5,0x0
 bda:	42a7a783          	lw	a5,1066(a5) # 1000 <max_stacks>
 bde:	00000717          	auipc	a4,0x0
 be2:	44272703          	lw	a4,1090(a4) # 1020 <num_threads>
 be6:	0af71363          	bne	a4,a5,c8c <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 bea:	04000713          	li	a4,64
 bee:	08e78563          	beq	a5,a4,c78 <ithread_create+0xbc>
 bf2:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 bf4:	00000097          	auipc	ra,0x0
 bf8:	f64080e7          	jalr	-156(ra) # b58 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 bfc:	6505                	lui	a0,0x1
 bfe:	00000097          	auipc	ra,0x0
 c02:	db2080e7          	jalr	-590(ra) # 9b0 <malloc>
 c06:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c08:	00000717          	auipc	a4,0x0
 c0c:	41872703          	lw	a4,1048(a4) # 1020 <num_threads>
 c10:	070e                	slli	a4,a4,0x3
 c12:	00000797          	auipc	a5,0x0
 c16:	4067b783          	ld	a5,1030(a5) # 1018 <stacks>
 c1a:	97ba                	add	a5,a5,a4
 c1c:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 c1e:	00000697          	auipc	a3,0x0
 c22:	e9268693          	addi	a3,a3,-366 # ab0 <ithread_exit>
 c26:	862a                	mv	a2,a0
 c28:	85ce                	mv	a1,s3
 c2a:	854a                	mv	a0,s2
 c2c:	00000097          	auipc	ra,0x0
 c30:	99e080e7          	jalr	-1634(ra) # 5ca <create_thread>
 c34:	892a                	mv	s2,a0
  if (res != -1) {
 c36:	57fd                	li	a5,-1
 c38:	04f50c63          	beq	a0,a5,c90 <ithread_create+0xd4>
    num_threads++;
 c3c:	00000717          	auipc	a4,0x0
 c40:	3e470713          	addi	a4,a4,996 # 1020 <num_threads>
 c44:	431c                	lw	a5,0(a4)
 c46:	2785                	addiw	a5,a5,1
 c48:	c31c                	sw	a5,0(a4)
 c4a:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c4c:	854a                	mv	a0,s2
 c4e:	70a2                	ld	ra,40(sp)
 c50:	7402                	ld	s0,32(sp)
 c52:	6942                	ld	s2,16(sp)
 c54:	69a2                	ld	s3,8(sp)
 c56:	6145                	addi	sp,sp,48
 c58:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c5a:	00000517          	auipc	a0,0x0
 c5e:	3a652503          	lw	a0,934(a0) # 1000 <max_stacks>
 c62:	0035151b          	slliw	a0,a0,0x3
 c66:	00000097          	auipc	ra,0x0
 c6a:	d4a080e7          	jalr	-694(ra) # 9b0 <malloc>
 c6e:	00000797          	auipc	a5,0x0
 c72:	3aa7b523          	sd	a0,938(a5) # 1018 <stacks>
 c76:	b785                	j	bd6 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 c78:	00000517          	auipc	a0,0x0
 c7c:	0e050513          	addi	a0,a0,224 # d58 <ithread_join+0xa2>
 c80:	00000097          	auipc	ra,0x0
 c84:	c78080e7          	jalr	-904(ra) # 8f8 <printf>
      return -1;
 c88:	597d                	li	s2,-1
 c8a:	b7c9                	j	c4c <ithread_create+0x90>
 c8c:	ec26                	sd	s1,24(sp)
 c8e:	b7bd                	j	bfc <ithread_create+0x40>
    free(stack_ptr);
 c90:	8526                	mv	a0,s1
 c92:	00000097          	auipc	ra,0x0
 c96:	c9c080e7          	jalr	-868(ra) # 92e <free>
    stacks[num_threads] = 0;
 c9a:	00000717          	auipc	a4,0x0
 c9e:	38672703          	lw	a4,902(a4) # 1020 <num_threads>
 ca2:	070e                	slli	a4,a4,0x3
 ca4:	00000797          	auipc	a5,0x0
 ca8:	3747b783          	ld	a5,884(a5) # 1018 <stacks>
 cac:	97ba                	add	a5,a5,a4
 cae:	0007b023          	sd	zero,0(a5)
 cb2:	64e2                	ld	s1,24(sp)
 cb4:	bf61                	j	c4c <ithread_create+0x90>

0000000000000cb6 <ithread_join>:

int ithread_join(int thread_id) {
 cb6:	1101                	addi	sp,sp,-32
 cb8:	ec06                	sd	ra,24(sp)
 cba:	e822                	sd	s0,16(sp)
 cbc:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 cbe:	ff040793          	addi	a5,s0,-16
 cc2:	ffc7859b          	addiw	a1,a5,-4
 cc6:	00000097          	auipc	ra,0x0
 cca:	90c080e7          	jalr	-1780(ra) # 5d2 <join_thread>
  threads_done++;
 cce:	00000717          	auipc	a4,0x0
 cd2:	35670713          	addi	a4,a4,854 # 1024 <threads_done>
 cd6:	431c                	lw	a5,0(a4)
 cd8:	2785                	addiw	a5,a5,1
 cda:	0007869b          	sext.w	a3,a5
 cde:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ce0:	00000797          	auipc	a5,0x0
 ce4:	3407a783          	lw	a5,832(a5) # 1020 <num_threads>
 ce8:	00d78863          	beq	a5,a3,cf8 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 cec:	fec42503          	lw	a0,-20(s0)
 cf0:	60e2                	ld	ra,24(sp)
 cf2:	6442                	ld	s0,16(sp)
 cf4:	6105                	addi	sp,sp,32
 cf6:	8082                	ret
    free_stacks();
 cf8:	00000097          	auipc	ra,0x0
 cfc:	dd2080e7          	jalr	-558(ra) # aca <free_stacks>
 d00:	b7f5                	j	cec <ithread_join+0x36>
