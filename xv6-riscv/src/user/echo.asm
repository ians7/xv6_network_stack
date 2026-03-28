
src/user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d863          	bge	a5,a0,84 <main+0x84>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	bd0a8a93          	addi	s5,s5,-1072 # c00 <ithread_join+0x4c>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	400080e7          	jalr	1024(ra) # 440 <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	09c080e7          	jalr	156(ra) # f0 <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	3dc080e7          	jalr	988(ra) # 440 <write>
    if(i + 1 < argc){
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00001597          	auipc	a1,0x1
  76:	b9658593          	addi	a1,a1,-1130 # c08 <ithread_join+0x54>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	3c4080e7          	jalr	964(ra) # 440 <write>
    }
  }
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	39a080e7          	jalr	922(ra) # 420 <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	380080e7          	jalr	896(ra) # 420 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	addi	a1,a1,1
  b2:	0785                	addi	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	addi	a0,a0,1
  da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf91                	beqz	a5,116 <strlen+0x26>
  fc:	0505                	addi	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	addi	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x10>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strlen+0x20>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1c>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x12>
  }
  return dst;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb99                	beqz	a5,15c <strchr+0x20>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1a>
  for(; *s; s++)
 14c:	0505                	addi	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xc>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfe5                	j	156 <strchr+0x1a>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	711d                	addi	sp,sp,-96
 162:	ec86                	sd	ra,88(sp)
 164:	e8a2                	sd	s0,80(sp)
 166:	e4a6                	sd	s1,72(sp)
 168:	e0ca                	sd	s2,64(sp)
 16a:	fc4e                	sd	s3,56(sp)
 16c:	f852                	sd	s4,48(sp)
 16e:	f456                	sd	s5,40(sp)
 170:	f05a                	sd	s6,32(sp)
 172:	ec5e                	sd	s7,24(sp)
 174:	1080                	addi	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17e:	4aa9                	li	s5,10
 180:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	2485                	addiw	s1,s1,1
 186:	0344d863          	bge	s1,s4,1b6 <gets+0x56>
    cc = read(0, &c, 1);
 18a:	4605                	li	a2,1
 18c:	faf40593          	addi	a1,s0,-81
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	2a6080e7          	jalr	678(ra) # 438 <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x56>
    buf[i++] = c;
 19e:	faf44783          	lbu	a5,-81(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01578763          	beq	a5,s5,1b4 <gets+0x54>
 1aa:	0905                	addi	s2,s2,1
 1ac:	fd679be3          	bne	a5,s6,182 <gets+0x22>
    buf[i++] = c;
 1b0:	89a6                	mv	s3,s1
 1b2:	a011                	j	1b6 <gets+0x56>
 1b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b6:	99de                	add	s3,s3,s7
 1b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1bc:	855e                	mv	a0,s7
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6125                	addi	sp,sp,96
 1d2:	8082                	ret

00000000000001d4 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 1d4:	711d                	addi	sp,sp,-96
 1d6:	ec86                	sd	ra,88(sp)
 1d8:	e8a2                	sd	s0,80(sp)
 1da:	e4a6                	sd	s1,72(sp)
 1dc:	e0ca                	sd	s2,64(sp)
 1de:	fc4e                	sd	s3,56(sp)
 1e0:	f852                	sd	s4,48(sp)
 1e2:	f456                	sd	s5,40(sp)
 1e4:	f05a                	sd	s6,32(sp)
 1e6:	ec5e                	sd	s7,24(sp)
 1e8:	1080                	addi	s0,sp,96
 1ea:	8baa                	mv	s7,a0
 1ec:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 1ee:	892a                	mv	s2,a0
 1f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f2:	4aa9                	li	s5,10
 1f4:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 1f6:	8a26                	mv	s4,s1
 1f8:	2485                	addiw	s1,s1,1
 1fa:	0334d863          	bge	s1,s3,22a <fgetstdin+0x56>
    cc = read(0, &c, 1);
 1fe:	4605                	li	a2,1
 200:	faf40593          	addi	a1,s0,-81
 204:	4501                	li	a0,0
 206:	00000097          	auipc	ra,0x0
 20a:	232080e7          	jalr	562(ra) # 438 <read>
    if(cc < 1)
 20e:	00a05e63          	blez	a0,22a <fgetstdin+0x56>
    buf[i++] = c;
 212:	faf44783          	lbu	a5,-81(s0)
 216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21a:	01578763          	beq	a5,s5,228 <fgetstdin+0x54>
 21e:	0905                	addi	s2,s2,1
 220:	fd679be3          	bne	a5,s6,1f6 <fgetstdin+0x22>
    buf[i++] = c;
 224:	8a26                	mv	s4,s1
 226:	a011                	j	22a <fgetstdin+0x56>
 228:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 22a:	9bd2                	add	s7,s7,s4
 22c:	000b8023          	sb	zero,0(s7)
  return i;
}
 230:	8552                	mv	a0,s4
 232:	60e6                	ld	ra,88(sp)
 234:	6446                	ld	s0,80(sp)
 236:	64a6                	ld	s1,72(sp)
 238:	6906                	ld	s2,64(sp)
 23a:	79e2                	ld	s3,56(sp)
 23c:	7a42                	ld	s4,48(sp)
 23e:	7aa2                	ld	s5,40(sp)
 240:	7b02                	ld	s6,32(sp)
 242:	6be2                	ld	s7,24(sp)
 244:	6125                	addi	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	00000097          	auipc	ra,0x0
 25a:	20a080e7          	jalr	522(ra) # 460 <open>
  if(fd < 0)
 25e:	02054663          	bltz	a0,28a <stat+0x42>
 262:	e426                	sd	s1,8(sp)
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	00000097          	auipc	ra,0x0
 26c:	210080e7          	jalr	528(ra) # 478 <fstat>
 270:	892a                	mv	s2,a0
  close(fd);
 272:	8526                	mv	a0,s1
 274:	00000097          	auipc	ra,0x0
 278:	1d4080e7          	jalr	468(ra) # 448 <close>
  return r;
 27c:	64a2                	ld	s1,8(sp)
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	6902                	ld	s2,0(sp)
 286:	6105                	addi	sp,sp,32
 288:	8082                	ret
    return -1;
 28a:	597d                	li	s2,-1
 28c:	bfcd                	j	27e <stat+0x36>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 294:	00054683          	lbu	a3,0(a0)
 298:	fd06879b          	addiw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	4625                	li	a2,9
 2a2:	02f66863          	bltu	a2,a5,2d2 <atoi+0x44>
 2a6:	872a                	mv	a4,a0
  n = 0;
 2a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2aa:	0705                	addi	a4,a4,1
 2ac:	0025179b          	slliw	a5,a0,0x2
 2b0:	9fa9                	addw	a5,a5,a0
 2b2:	0017979b          	slliw	a5,a5,0x1
 2b6:	9fb5                	addw	a5,a5,a3
 2b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2bc:	00074683          	lbu	a3,0(a4)
 2c0:	fd06879b          	addiw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	fef671e3          	bgeu	a2,a5,2aa <atoi+0x1c>
  return n;
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  n = 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <atoi+0x3e>

00000000000002d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2dc:	02b57463          	bgeu	a0,a1,304 <memmove+0x2e>
    while(n-- > 0)
 2e0:	00c05f63          	blez	a2,2fe <memmove+0x28>
 2e4:	1602                	slli	a2,a2,0x20
 2e6:	9201                	srli	a2,a2,0x20
 2e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ee:	0585                	addi	a1,a1,1
 2f0:	0705                	addi	a4,a4,1
 2f2:	fff5c683          	lbu	a3,-1(a1)
 2f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fa:	fef71ae3          	bne	a4,a5,2ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
    dst += n;
 304:	00c50733          	add	a4,a0,a2
    src += n;
 308:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30a:	fec05ae3          	blez	a2,2fe <memmove+0x28>
 30e:	fff6079b          	addiw	a5,a2,-1
 312:	1782                	slli	a5,a5,0x20
 314:	9381                	srli	a5,a5,0x20
 316:	fff7c793          	not	a5,a5
 31a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31c:	15fd                	addi	a1,a1,-1
 31e:	177d                	addi	a4,a4,-1
 320:	0005c683          	lbu	a3,0(a1)
 324:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 328:	fee79ae3          	bne	a5,a4,31c <memmove+0x46>
 32c:	bfc9                	j	2fe <memmove+0x28>

000000000000032e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e422                	sd	s0,8(sp)
 332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	ca05                	beqz	a2,364 <memcmp+0x36>
 336:	fff6069b          	addiw	a3,a2,-1
 33a:	1682                	slli	a3,a3,0x20
 33c:	9281                	srli	a3,a3,0x20
 33e:	0685                	addi	a3,a3,1
 340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	addi	a0,a0,1
    p2++;
 350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x14>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x30>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <memcmp+0x30>

0000000000000368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 370:	00000097          	auipc	ra,0x0
 374:	f66080e7          	jalr	-154(ra) # 2d6 <memmove>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 386:	00054783          	lbu	a5,0(a0)
 38a:	cfbd                	beqz	a5,408 <inet_addr+0x88>
  int dots = 0;
 38c:	4801                	li	a6,0
  int digits = 0;
 38e:	4601                	li	a2,0
  int octet = 0;
 390:	4681                	li	a3,0
  uint result = 0;
 392:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 394:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 396:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 39a:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 39c:	4301                	li	t1,0
      if (octet > 255)
 39e:	0ff00e13          	li	t3,255
 3a2:	a015                	j	3c6 <inet_addr+0x46>
    } else if (*s == '.') {
 3a4:	07d79463          	bne	a5,t4,40c <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 3a8:	c625                	beqz	a2,410 <inet_addr+0x90>
 3aa:	07e80563          	beq	a6,t5,414 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 3ae:	0085959b          	slliw	a1,a1,0x8
 3b2:	8ecd                	or	a3,a3,a1
 3b4:	0006859b          	sext.w	a1,a3
      dots++;
 3b8:	2805                	addiw	a6,a6,1
      digits = 0;
 3ba:	861a                	mv	a2,t1
      octet = 0;
 3bc:	869a                	mv	a3,t1
  for (; *s; s++) {
 3be:	0505                	addi	a0,a0,1
 3c0:	00054783          	lbu	a5,0(a0)
 3c4:	c79d                	beqz	a5,3f2 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 3c6:	fd07871b          	addiw	a4,a5,-48
 3ca:	0ff77713          	zext.b	a4,a4
 3ce:	fce8ebe3          	bltu	a7,a4,3a4 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 3d2:	0026971b          	slliw	a4,a3,0x2
 3d6:	9f35                	addw	a4,a4,a3
 3d8:	0017171b          	slliw	a4,a4,0x1
 3dc:	fd07879b          	addiw	a5,a5,-48
 3e0:	00e786bb          	addw	a3,a5,a4
      digits++;
 3e4:	2605                	addiw	a2,a2,1
      if (octet > 255)
 3e6:	fcde5ce3          	bge	t3,a3,3be <inet_addr+0x3e>
        return 0;
 3ea:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
    return 0;
 3f2:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 3f4:	de65                	beqz	a2,3ec <inet_addr+0x6c>
 3f6:	478d                	li	a5,3
 3f8:	fef81ae3          	bne	a6,a5,3ec <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 3fc:	0085959b          	slliw	a1,a1,0x8
 400:	8ecd                	or	a3,a3,a1
 402:	0006851b          	sext.w	a0,a3
  return result;
 406:	b7dd                	j	3ec <inet_addr+0x6c>
    return 0;
 408:	4501                	li	a0,0
 40a:	b7cd                	j	3ec <inet_addr+0x6c>
      return 0;
 40c:	4501                	li	a0,0
 40e:	bff9                	j	3ec <inet_addr+0x6c>
        return 0;
 410:	4501                	li	a0,0
 412:	bfe9                	j	3ec <inet_addr+0x6c>
 414:	4501                	li	a0,0
 416:	bfd9                	j	3ec <inet_addr+0x6c>

0000000000000418 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 418:	4885                	li	a7,1
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exit>:
.global exit
exit:
 li a7, SYS_exit
 420:	4889                	li	a7,2
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <wait>:
.global wait
wait:
 li a7, SYS_wait
 428:	488d                	li	a7,3
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 430:	4891                	li	a7,4
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <read>:
.global read
read:
 li a7, SYS_read
 438:	4895                	li	a7,5
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <write>:
.global write
write:
 li a7, SYS_write
 440:	48c1                	li	a7,16
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <close>:
.global close
close:
 li a7, SYS_close
 448:	48d5                	li	a7,21
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <kill>:
.global kill
kill:
 li a7, SYS_kill
 450:	4899                	li	a7,6
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <exec>:
.global exec
exec:
 li a7, SYS_exec
 458:	489d                	li	a7,7
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <open>:
.global open
open:
 li a7, SYS_open
 460:	48bd                	li	a7,15
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 468:	48c5                	li	a7,17
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 470:	48c9                	li	a7,18
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 478:	48a1                	li	a7,8
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <link>:
.global link
link:
 li a7, SYS_link
 480:	48cd                	li	a7,19
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 488:	48d1                	li	a7,20
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 490:	48a5                	li	a7,9
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <dup>:
.global dup
dup:
 li a7, SYS_dup
 498:	48a9                	li	a7,10
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a0:	48ad                	li	a7,11
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a8:	48b1                	li	a7,12
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b0:	48b5                	li	a7,13
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b8:	48b9                	li	a7,14
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 4c0:	48d9                	li	a7,22
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 4c8:	48dd                	li	a7,23
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4d0:	48e1                	li	a7,24
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4d8:	48e5                	li	a7,25
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4e0:	48e9                	li	a7,26
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4e8:	48ed                	li	a7,27
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4f0:	48f5                	li	a7,29
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <listen>:
.global listen
listen:
 li a7, SYS_listen
 4f8:	48f1                	li	a7,28
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <connect>:
.global connect
connect:
 li a7, SYS_connect
 500:	48f9                	li	a7,30
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <send>:
.global send
send:
 li a7, SYS_send
 508:	48fd                	li	a7,31
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <recv>:
.global recv
recv:
 li a7, SYS_recv
 510:	02000893          	li	a7,32
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 51a:	02100893          	li	a7,33
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 524:	02200893          	li	a7,34
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52e:	1101                	addi	sp,sp,-32
 530:	ec06                	sd	ra,24(sp)
 532:	e822                	sd	s0,16(sp)
 534:	1000                	addi	s0,sp,32
 536:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 53a:	4605                	li	a2,1
 53c:	fef40593          	addi	a1,s0,-17
 540:	00000097          	auipc	ra,0x0
 544:	f00080e7          	jalr	-256(ra) # 440 <write>
}
 548:	60e2                	ld	ra,24(sp)
 54a:	6442                	ld	s0,16(sp)
 54c:	6105                	addi	sp,sp,32
 54e:	8082                	ret

0000000000000550 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	7139                	addi	sp,sp,-64
 552:	fc06                	sd	ra,56(sp)
 554:	f822                	sd	s0,48(sp)
 556:	f426                	sd	s1,40(sp)
 558:	0080                	addi	s0,sp,64
 55a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55c:	c299                	beqz	a3,562 <printint+0x12>
 55e:	0805cb63          	bltz	a1,5f4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 562:	2581                	sext.w	a1,a1
  neg = 0;
 564:	4881                	li	a7,0
 566:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 56c:	2601                	sext.w	a2,a2
 56e:	00000517          	auipc	a0,0x0
 572:	73250513          	addi	a0,a0,1842 # ca0 <digits>
 576:	883a                	mv	a6,a4
 578:	2705                	addiw	a4,a4,1
 57a:	02c5f7bb          	remuw	a5,a1,a2
 57e:	1782                	slli	a5,a5,0x20
 580:	9381                	srli	a5,a5,0x20
 582:	97aa                	add	a5,a5,a0
 584:	0007c783          	lbu	a5,0(a5)
 588:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 58c:	0005879b          	sext.w	a5,a1
 590:	02c5d5bb          	divuw	a1,a1,a2
 594:	0685                	addi	a3,a3,1
 596:	fec7f0e3          	bgeu	a5,a2,576 <printint+0x26>
  if(neg)
 59a:	00088c63          	beqz	a7,5b2 <printint+0x62>
    buf[i++] = '-';
 59e:	fd070793          	addi	a5,a4,-48
 5a2:	00878733          	add	a4,a5,s0
 5a6:	02d00793          	li	a5,45
 5aa:	fef70823          	sb	a5,-16(a4)
 5ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b2:	02e05c63          	blez	a4,5ea <printint+0x9a>
 5b6:	f04a                	sd	s2,32(sp)
 5b8:	ec4e                	sd	s3,24(sp)
 5ba:	fc040793          	addi	a5,s0,-64
 5be:	00e78933          	add	s2,a5,a4
 5c2:	fff78993          	addi	s3,a5,-1
 5c6:	99ba                	add	s3,s3,a4
 5c8:	377d                	addiw	a4,a4,-1
 5ca:	1702                	slli	a4,a4,0x20
 5cc:	9301                	srli	a4,a4,0x20
 5ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d2:	fff94583          	lbu	a1,-1(s2)
 5d6:	8526                	mv	a0,s1
 5d8:	00000097          	auipc	ra,0x0
 5dc:	f56080e7          	jalr	-170(ra) # 52e <putc>
  while(--i >= 0)
 5e0:	197d                	addi	s2,s2,-1
 5e2:	ff3918e3          	bne	s2,s3,5d2 <printint+0x82>
 5e6:	7902                	ld	s2,32(sp)
 5e8:	69e2                	ld	s3,24(sp)
}
 5ea:	70e2                	ld	ra,56(sp)
 5ec:	7442                	ld	s0,48(sp)
 5ee:	74a2                	ld	s1,40(sp)
 5f0:	6121                	addi	sp,sp,64
 5f2:	8082                	ret
    x = -xx;
 5f4:	40b005bb          	negw	a1,a1
    neg = 1;
 5f8:	4885                	li	a7,1
    x = -xx;
 5fa:	b7b5                	j	566 <printint+0x16>

00000000000005fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fc:	715d                	addi	sp,sp,-80
 5fe:	e486                	sd	ra,72(sp)
 600:	e0a2                	sd	s0,64(sp)
 602:	f84a                	sd	s2,48(sp)
 604:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c903          	lbu	s2,0(a1)
 60a:	1a090a63          	beqz	s2,7be <vprintf+0x1c2>
 60e:	fc26                	sd	s1,56(sp)
 610:	f44e                	sd	s3,40(sp)
 612:	f052                	sd	s4,32(sp)
 614:	ec56                	sd	s5,24(sp)
 616:	e85a                	sd	s6,16(sp)
 618:	e45e                	sd	s7,8(sp)
 61a:	8aaa                	mv	s5,a0
 61c:	8bb2                	mv	s7,a2
 61e:	00158493          	addi	s1,a1,1
  state = 0;
 622:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 624:	02500a13          	li	s4,37
 628:	4b55                	li	s6,21
 62a:	a839                	j	648 <vprintf+0x4c>
        putc(fd, c);
 62c:	85ca                	mv	a1,s2
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	efe080e7          	jalr	-258(ra) # 52e <putc>
 638:	a019                	j	63e <vprintf+0x42>
    } else if(state == '%'){
 63a:	01498d63          	beq	s3,s4,654 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 63e:	0485                	addi	s1,s1,1
 640:	fff4c903          	lbu	s2,-1(s1)
 644:	16090763          	beqz	s2,7b2 <vprintf+0x1b6>
    if(state == 0){
 648:	fe0999e3          	bnez	s3,63a <vprintf+0x3e>
      if(c == '%'){
 64c:	ff4910e3          	bne	s2,s4,62c <vprintf+0x30>
        state = '%';
 650:	89d2                	mv	s3,s4
 652:	b7f5                	j	63e <vprintf+0x42>
      if(c == 'd'){
 654:	13490463          	beq	s2,s4,77c <vprintf+0x180>
 658:	f9d9079b          	addiw	a5,s2,-99
 65c:	0ff7f793          	zext.b	a5,a5
 660:	12fb6763          	bltu	s6,a5,78e <vprintf+0x192>
 664:	f9d9079b          	addiw	a5,s2,-99
 668:	0ff7f713          	zext.b	a4,a5
 66c:	12eb6163          	bltu	s6,a4,78e <vprintf+0x192>
 670:	00271793          	slli	a5,a4,0x2
 674:	00000717          	auipc	a4,0x0
 678:	5d470713          	addi	a4,a4,1492 # c48 <ithread_join+0x94>
 67c:	97ba                	add	a5,a5,a4
 67e:	439c                	lw	a5,0(a5)
 680:	97ba                	add	a5,a5,a4
 682:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b8913          	addi	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	ebe080e7          	jalr	-322(ra) # 550 <printint>
 69a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b745                	j	63e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	ea2080e7          	jalr	-350(ra) # 550 <printint>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b751                	j	63e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e86080e7          	jalr	-378(ra) # 550 <printint>
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b7a5                	j	63e <vprintf+0x42>
 6d8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6da:	008b8c13          	addi	s8,s7,8
 6de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e2:	03000593          	li	a1,48
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e46080e7          	jalr	-442(ra) # 52e <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e38080e7          	jalr	-456(ra) # 52e <putc>
 6fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 700:	00000b97          	auipc	s7,0x0
 704:	5a0b8b93          	addi	s7,s7,1440 # ca0 <digits>
 708:	03c9d793          	srli	a5,s3,0x3c
 70c:	97de                	add	a5,a5,s7
 70e:	0007c583          	lbu	a1,0(a5)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e1a080e7          	jalr	-486(ra) # 52e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	slli	s3,s3,0x4
 71e:	397d                	addiw	s2,s2,-1
 720:	fe0914e3          	bnez	s2,708 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 724:	8be2                	mv	s7,s8
      state = 0;
 726:	4981                	li	s3,0
 728:	6c02                	ld	s8,0(sp)
 72a:	bf11                	j	63e <vprintf+0x42>
        s = va_arg(ap, char*);
 72c:	008b8993          	addi	s3,s7,8
 730:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 734:	02090163          	beqz	s2,756 <vprintf+0x15a>
        while(*s != 0){
 738:	00094583          	lbu	a1,0(s2)
 73c:	c9a5                	beqz	a1,7ac <vprintf+0x1b0>
          putc(fd, *s);
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	dee080e7          	jalr	-530(ra) # 52e <putc>
          s++;
 748:	0905                	addi	s2,s2,1
        while(*s != 0){
 74a:	00094583          	lbu	a1,0(s2)
 74e:	f9e5                	bnez	a1,73e <vprintf+0x142>
        s = va_arg(ap, char*);
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	b5ed                	j	63e <vprintf+0x42>
          s = "(null)";
 756:	00000917          	auipc	s2,0x0
 75a:	4ba90913          	addi	s2,s2,1210 # c10 <ithread_join+0x5c>
        while(*s != 0){
 75e:	02800593          	li	a1,40
 762:	bff1                	j	73e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 764:	008b8913          	addi	s2,s7,8
 768:	000bc583          	lbu	a1,0(s7)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	dc0080e7          	jalr	-576(ra) # 52e <putc>
 776:	8bca                	mv	s7,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	b5d1                	j	63e <vprintf+0x42>
        putc(fd, c);
 77c:	02500593          	li	a1,37
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	dac080e7          	jalr	-596(ra) # 52e <putc>
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bd4d                	j	63e <vprintf+0x42>
        putc(fd, '%');
 78e:	02500593          	li	a1,37
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	d9a080e7          	jalr	-614(ra) # 52e <putc>
        putc(fd, c);
 79c:	85ca                	mv	a1,s2
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	d8e080e7          	jalr	-626(ra) # 52e <putc>
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bd51                	j	63e <vprintf+0x42>
        s = va_arg(ap, char*);
 7ac:	8bce                	mv	s7,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b579                	j	63e <vprintf+0x42>
 7b2:	74e2                	ld	s1,56(sp)
 7b4:	79a2                	ld	s3,40(sp)
 7b6:	7a02                	ld	s4,32(sp)
 7b8:	6ae2                	ld	s5,24(sp)
 7ba:	6b42                	ld	s6,16(sp)
 7bc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7be:	60a6                	ld	ra,72(sp)
 7c0:	6406                	ld	s0,64(sp)
 7c2:	7942                	ld	s2,48(sp)
 7c4:	6161                	addi	sp,sp,80
 7c6:	8082                	ret

00000000000007c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c8:	715d                	addi	sp,sp,-80
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	e010                	sd	a2,0(s0)
 7d2:	e414                	sd	a3,8(s0)
 7d4:	e818                	sd	a4,16(s0)
 7d6:	ec1c                	sd	a5,24(s0)
 7d8:	03043023          	sd	a6,32(s0)
 7dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e4:	8622                	mv	a2,s0
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e16080e7          	jalr	-490(ra) # 5fc <vprintf>
}
 7ee:	60e2                	ld	ra,24(sp)
 7f0:	6442                	ld	s0,16(sp)
 7f2:	6161                	addi	sp,sp,80
 7f4:	8082                	ret

00000000000007f6 <printf>:

void
printf(const char *fmt, ...)
{
 7f6:	711d                	addi	sp,sp,-96
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e40c                	sd	a1,8(s0)
 800:	e810                	sd	a2,16(s0)
 802:	ec14                	sd	a3,24(s0)
 804:	f018                	sd	a4,32(s0)
 806:	f41c                	sd	a5,40(s0)
 808:	03043823          	sd	a6,48(s0)
 80c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 810:	00840613          	addi	a2,s0,8
 814:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 818:	85aa                	mv	a1,a0
 81a:	4505                	li	a0,1
 81c:	00000097          	auipc	ra,0x0
 820:	de0080e7          	jalr	-544(ra) # 5fc <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6125                	addi	sp,sp,96
 82a:	8082                	ret

000000000000082c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82c:	1141                	addi	sp,sp,-16
 82e:	e422                	sd	s0,8(sp)
 830:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 832:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	00000797          	auipc	a5,0x0
 83a:	7da7b783          	ld	a5,2010(a5) # 1010 <freep>
 83e:	a02d                	j	868 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 840:	4618                	lw	a4,8(a2)
 842:	9f2d                	addw	a4,a4,a1
 844:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	6310                	ld	a2,0(a4)
 84c:	a83d                	j	88a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84e:	ff852703          	lw	a4,-8(a0)
 852:	9f31                	addw	a4,a4,a2
 854:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 856:	ff053683          	ld	a3,-16(a0)
 85a:	a091                	j	89e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	6398                	ld	a4,0(a5)
 85e:	00e7e463          	bltu	a5,a4,866 <free+0x3a>
 862:	00e6ea63          	bltu	a3,a4,876 <free+0x4a>
{
 866:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	fed7fae3          	bgeu	a5,a3,85c <free+0x30>
 86c:	6398                	ld	a4,0(a5)
 86e:	00e6e463          	bltu	a3,a4,876 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	fee7eae3          	bltu	a5,a4,866 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 876:	ff852583          	lw	a1,-8(a0)
 87a:	6390                	ld	a2,0(a5)
 87c:	02059813          	slli	a6,a1,0x20
 880:	01c85713          	srli	a4,a6,0x1c
 884:	9736                	add	a4,a4,a3
 886:	fae60de3          	beq	a2,a4,840 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88e:	4790                	lw	a2,8(a5)
 890:	02061593          	slli	a1,a2,0x20
 894:	01c5d713          	srli	a4,a1,0x1c
 898:	973e                	add	a4,a4,a5
 89a:	fae68ae3          	beq	a3,a4,84e <free+0x22>
    p->s.ptr = bp->s.ptr;
 89e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a0:	00000717          	auipc	a4,0x0
 8a4:	76f73823          	sd	a5,1904(a4) # 1010 <freep>
}
 8a8:	6422                	ld	s0,8(sp)
 8aa:	0141                	addi	sp,sp,16
 8ac:	8082                	ret

00000000000008ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ae:	7139                	addi	sp,sp,-64
 8b0:	fc06                	sd	ra,56(sp)
 8b2:	f822                	sd	s0,48(sp)
 8b4:	f426                	sd	s1,40(sp)
 8b6:	ec4e                	sd	s3,24(sp)
 8b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051493          	slli	s1,a0,0x20
 8be:	9081                	srli	s1,s1,0x20
 8c0:	04bd                	addi	s1,s1,15
 8c2:	8091                	srli	s1,s1,0x4
 8c4:	0014899b          	addiw	s3,s1,1
 8c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	74653503          	ld	a0,1862(a0) # 1010 <freep>
 8d2:	c915                	beqz	a0,906 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	08977e63          	bgeu	a4,s1,974 <malloc+0xc6>
 8dc:	f04a                	sd	s2,32(sp)
 8de:	e852                	sd	s4,16(sp)
 8e0:	e456                	sd	s5,8(sp)
 8e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e4:	8a4e                	mv	s4,s3
 8e6:	0009871b          	sext.w	a4,s3
 8ea:	6685                	lui	a3,0x1
 8ec:	00d77363          	bgeu	a4,a3,8f2 <malloc+0x44>
 8f0:	6a05                	lui	s4,0x1
 8f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fa:	00000917          	auipc	s2,0x0
 8fe:	71690913          	addi	s2,s2,1814 # 1010 <freep>
  if(p == (char*)-1)
 902:	5afd                	li	s5,-1
 904:	a091                	j	948 <malloc+0x9a>
 906:	f04a                	sd	s2,32(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90e:	00000797          	auipc	a5,0x0
 912:	72278793          	addi	a5,a5,1826 # 1030 <base>
 916:	00000717          	auipc	a4,0x0
 91a:	6ef73d23          	sd	a5,1786(a4) # 1010 <freep>
 91e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 920:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 924:	b7c1                	j	8e4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 926:	6398                	ld	a4,0(a5)
 928:	e118                	sd	a4,0(a0)
 92a:	a08d                	j	98c <malloc+0xde>
  hp->s.size = nu;
 92c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 930:	0541                	addi	a0,a0,16
 932:	00000097          	auipc	ra,0x0
 936:	efa080e7          	jalr	-262(ra) # 82c <free>
  return freep;
 93a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93e:	c13d                	beqz	a0,9a4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 942:	4798                	lw	a4,8(a5)
 944:	02977463          	bgeu	a4,s1,96c <malloc+0xbe>
    if(p == freep)
 948:	00093703          	ld	a4,0(s2)
 94c:	853e                	mv	a0,a5
 94e:	fef719e3          	bne	a4,a5,940 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 952:	8552                	mv	a0,s4
 954:	00000097          	auipc	ra,0x0
 958:	b54080e7          	jalr	-1196(ra) # 4a8 <sbrk>
  if(p == (char*)-1)
 95c:	fd5518e3          	bne	a0,s5,92c <malloc+0x7e>
        return 0;
 960:	4501                	li	a0,0
 962:	7902                	ld	s2,32(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
 96a:	a03d                	j	998 <malloc+0xea>
 96c:	7902                	ld	s2,32(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 974:	fae489e3          	beq	s1,a4,926 <malloc+0x78>
        p->s.size -= nunits;
 978:	4137073b          	subw	a4,a4,s3
 97c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97e:	02071693          	slli	a3,a4,0x20
 982:	01c6d713          	srli	a4,a3,0x1c
 986:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 988:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98c:	00000717          	auipc	a4,0x0
 990:	68a73223          	sd	a0,1668(a4) # 1010 <freep>
      return (void*)(p + 1);
 994:	01078513          	addi	a0,a5,16
  }
}
 998:	70e2                	ld	ra,56(sp)
 99a:	7442                	ld	s0,48(sp)
 99c:	74a2                	ld	s1,40(sp)
 99e:	69e2                	ld	s3,24(sp)
 9a0:	6121                	addi	sp,sp,64
 9a2:	8082                	ret
 9a4:	7902                	ld	s2,32(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	b7f5                	j	998 <malloc+0xea>

00000000000009ae <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 9ae:	1141                	addi	sp,sp,-16
 9b0:	e406                	sd	ra,8(sp)
 9b2:	e022                	sd	s0,0(sp)
 9b4:	0800                	addi	s0,sp,16
  thread_exit(status);
 9b6:	2501                	sext.w	a0,a0
 9b8:	00000097          	auipc	ra,0x0
 9bc:	b20080e7          	jalr	-1248(ra) # 4d8 <thread_exit>
}
 9c0:	60a2                	ld	ra,8(sp)
 9c2:	6402                	ld	s0,0(sp)
 9c4:	0141                	addi	sp,sp,16
 9c6:	8082                	ret

00000000000009c8 <free_stacks>:
int free_stacks() {
 9c8:	7179                	addi	sp,sp,-48
 9ca:	f406                	sd	ra,40(sp)
 9cc:	f022                	sd	s0,32(sp)
 9ce:	ec26                	sd	s1,24(sp)
 9d0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9d2:	00000797          	auipc	a5,0x0
 9d6:	64e7a783          	lw	a5,1614(a5) # 1020 <num_threads>
 9da:	04f05063          	blez	a5,a1a <free_stacks+0x52>
 9de:	e84a                	sd	s2,16(sp)
 9e0:	e44e                	sd	s3,8(sp)
 9e2:	4481                	li	s1,0
    free(stacks[i]);
 9e4:	00000997          	auipc	s3,0x0
 9e8:	63498993          	addi	s3,s3,1588 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9ec:	00000917          	auipc	s2,0x0
 9f0:	63490913          	addi	s2,s2,1588 # 1020 <num_threads>
    free(stacks[i]);
 9f4:	0009b783          	ld	a5,0(s3)
 9f8:	00349713          	slli	a4,s1,0x3
 9fc:	97ba                	add	a5,a5,a4
 9fe:	6388                	ld	a0,0(a5)
 a00:	00000097          	auipc	ra,0x0
 a04:	e2c080e7          	jalr	-468(ra) # 82c <free>
  for (int i = 0; i < num_threads; i++) {
 a08:	0485                	addi	s1,s1,1
 a0a:	00092703          	lw	a4,0(s2)
 a0e:	0004879b          	sext.w	a5,s1
 a12:	fee7c1e3          	blt	a5,a4,9f4 <free_stacks+0x2c>
 a16:	6942                	ld	s2,16(sp)
 a18:	69a2                	ld	s3,8(sp)
  free(stacks);
 a1a:	00000497          	auipc	s1,0x0
 a1e:	5fe48493          	addi	s1,s1,1534 # 1018 <stacks>
 a22:	6088                	ld	a0,0(s1)
 a24:	00000097          	auipc	ra,0x0
 a28:	e08080e7          	jalr	-504(ra) # 82c <free>
  stacks = 0;
 a2c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a30:	00000797          	auipc	a5,0x0
 a34:	5e07a823          	sw	zero,1520(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a38:	47a1                	li	a5,8
 a3a:	00000717          	auipc	a4,0x0
 a3e:	5cf72323          	sw	a5,1478(a4) # 1000 <max_stacks>
  threads_done = 0;
 a42:	00000797          	auipc	a5,0x0
 a46:	5e07a123          	sw	zero,1506(a5) # 1024 <threads_done>
}
 a4a:	4501                	li	a0,0
 a4c:	70a2                	ld	ra,40(sp)
 a4e:	7402                	ld	s0,32(sp)
 a50:	64e2                	ld	s1,24(sp)
 a52:	6145                	addi	sp,sp,48
 a54:	8082                	ret

0000000000000a56 <expand_num_threads>:
int expand_num_threads() {
 a56:	1101                	addi	sp,sp,-32
 a58:	ec06                	sd	ra,24(sp)
 a5a:	e822                	sd	s0,16(sp)
 a5c:	e426                	sd	s1,8(sp)
 a5e:	e04a                	sd	s2,0(sp)
 a60:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a62:	00000797          	auipc	a5,0x0
 a66:	59e78793          	addi	a5,a5,1438 # 1000 <max_stacks>
 a6a:	4388                	lw	a0,0(a5)
 a6c:	0015151b          	slliw	a0,a0,0x1
 a70:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a72:	0035151b          	slliw	a0,a0,0x3
 a76:	00000097          	auipc	ra,0x0
 a7a:	e38080e7          	jalr	-456(ra) # 8ae <malloc>
 a7e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a80:	00000617          	auipc	a2,0x0
 a84:	5a062603          	lw	a2,1440(a2) # 1020 <num_threads>
 a88:	00000497          	auipc	s1,0x0
 a8c:	59048493          	addi	s1,s1,1424 # 1018 <stacks>
 a90:	0036161b          	slliw	a2,a2,0x3
 a94:	608c                	ld	a1,0(s1)
 a96:	00000097          	auipc	ra,0x0
 a9a:	840080e7          	jalr	-1984(ra) # 2d6 <memmove>
  free(stacks);
 a9e:	6088                	ld	a0,0(s1)
 aa0:	00000097          	auipc	ra,0x0
 aa4:	d8c080e7          	jalr	-628(ra) # 82c <free>
  stacks = new_stacks;
 aa8:	0124b023          	sd	s2,0(s1)
}
 aac:	4501                	li	a0,0
 aae:	60e2                	ld	ra,24(sp)
 ab0:	6442                	ld	s0,16(sp)
 ab2:	64a2                	ld	s1,8(sp)
 ab4:	6902                	ld	s2,0(sp)
 ab6:	6105                	addi	sp,sp,32
 ab8:	8082                	ret

0000000000000aba <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 aba:	7179                	addi	sp,sp,-48
 abc:	f406                	sd	ra,40(sp)
 abe:	f022                	sd	s0,32(sp)
 ac0:	e84a                	sd	s2,16(sp)
 ac2:	e44e                	sd	s3,8(sp)
 ac4:	1800                	addi	s0,sp,48
 ac6:	892a                	mv	s2,a0
 ac8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 aca:	00000797          	auipc	a5,0x0
 ace:	54e7b783          	ld	a5,1358(a5) # 1018 <stacks>
 ad2:	c3d9                	beqz	a5,b58 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 ad4:	00000797          	auipc	a5,0x0
 ad8:	52c7a783          	lw	a5,1324(a5) # 1000 <max_stacks>
 adc:	00000717          	auipc	a4,0x0
 ae0:	54472703          	lw	a4,1348(a4) # 1020 <num_threads>
 ae4:	0af71363          	bne	a4,a5,b8a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 ae8:	04000713          	li	a4,64
 aec:	08e78563          	beq	a5,a4,b76 <ithread_create+0xbc>
 af0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 af2:	00000097          	auipc	ra,0x0
 af6:	f64080e7          	jalr	-156(ra) # a56 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 afa:	6505                	lui	a0,0x1
 afc:	00000097          	auipc	ra,0x0
 b00:	db2080e7          	jalr	-590(ra) # 8ae <malloc>
 b04:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 b06:	00000717          	auipc	a4,0x0
 b0a:	51a72703          	lw	a4,1306(a4) # 1020 <num_threads>
 b0e:	070e                	slli	a4,a4,0x3
 b10:	00000797          	auipc	a5,0x0
 b14:	5087b783          	ld	a5,1288(a5) # 1018 <stacks>
 b18:	97ba                	add	a5,a5,a4
 b1a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b1c:	00000697          	auipc	a3,0x0
 b20:	e9268693          	addi	a3,a3,-366 # 9ae <ithread_exit>
 b24:	862a                	mv	a2,a0
 b26:	85ce                	mv	a1,s3
 b28:	854a                	mv	a0,s2
 b2a:	00000097          	auipc	ra,0x0
 b2e:	99e080e7          	jalr	-1634(ra) # 4c8 <create_thread>
 b32:	892a                	mv	s2,a0
  if (res != -1) {
 b34:	57fd                	li	a5,-1
 b36:	04f50c63          	beq	a0,a5,b8e <ithread_create+0xd4>
    num_threads++;
 b3a:	00000717          	auipc	a4,0x0
 b3e:	4e670713          	addi	a4,a4,1254 # 1020 <num_threads>
 b42:	431c                	lw	a5,0(a4)
 b44:	2785                	addiw	a5,a5,1
 b46:	c31c                	sw	a5,0(a4)
 b48:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b4a:	854a                	mv	a0,s2
 b4c:	70a2                	ld	ra,40(sp)
 b4e:	7402                	ld	s0,32(sp)
 b50:	6942                	ld	s2,16(sp)
 b52:	69a2                	ld	s3,8(sp)
 b54:	6145                	addi	sp,sp,48
 b56:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b58:	00000517          	auipc	a0,0x0
 b5c:	4a852503          	lw	a0,1192(a0) # 1000 <max_stacks>
 b60:	0035151b          	slliw	a0,a0,0x3
 b64:	00000097          	auipc	ra,0x0
 b68:	d4a080e7          	jalr	-694(ra) # 8ae <malloc>
 b6c:	00000797          	auipc	a5,0x0
 b70:	4aa7b623          	sd	a0,1196(a5) # 1018 <stacks>
 b74:	b785                	j	ad4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b76:	00000517          	auipc	a0,0x0
 b7a:	0a250513          	addi	a0,a0,162 # c18 <ithread_join+0x64>
 b7e:	00000097          	auipc	ra,0x0
 b82:	c78080e7          	jalr	-904(ra) # 7f6 <printf>
      return -1;
 b86:	597d                	li	s2,-1
 b88:	b7c9                	j	b4a <ithread_create+0x90>
 b8a:	ec26                	sd	s1,24(sp)
 b8c:	b7bd                	j	afa <ithread_create+0x40>
    free(stack_ptr);
 b8e:	8526                	mv	a0,s1
 b90:	00000097          	auipc	ra,0x0
 b94:	c9c080e7          	jalr	-868(ra) # 82c <free>
    stacks[num_threads] = 0;
 b98:	00000717          	auipc	a4,0x0
 b9c:	48872703          	lw	a4,1160(a4) # 1020 <num_threads>
 ba0:	070e                	slli	a4,a4,0x3
 ba2:	00000797          	auipc	a5,0x0
 ba6:	4767b783          	ld	a5,1142(a5) # 1018 <stacks>
 baa:	97ba                	add	a5,a5,a4
 bac:	0007b023          	sd	zero,0(a5)
 bb0:	64e2                	ld	s1,24(sp)
 bb2:	bf61                	j	b4a <ithread_create+0x90>

0000000000000bb4 <ithread_join>:

int ithread_join(int thread_id) {
 bb4:	1101                	addi	sp,sp,-32
 bb6:	ec06                	sd	ra,24(sp)
 bb8:	e822                	sd	s0,16(sp)
 bba:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 bbc:	ff040793          	addi	a5,s0,-16
 bc0:	ffc7859b          	addiw	a1,a5,-4
 bc4:	00000097          	auipc	ra,0x0
 bc8:	90c080e7          	jalr	-1780(ra) # 4d0 <join_thread>
  threads_done++;
 bcc:	00000717          	auipc	a4,0x0
 bd0:	45870713          	addi	a4,a4,1112 # 1024 <threads_done>
 bd4:	431c                	lw	a5,0(a4)
 bd6:	2785                	addiw	a5,a5,1
 bd8:	0007869b          	sext.w	a3,a5
 bdc:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bde:	00000797          	auipc	a5,0x0
 be2:	4427a783          	lw	a5,1090(a5) # 1020 <num_threads>
 be6:	00d78863          	beq	a5,a3,bf6 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 bea:	fec42503          	lw	a0,-20(s0)
 bee:	60e2                	ld	ra,24(sp)
 bf0:	6442                	ld	s0,16(sp)
 bf2:	6105                	addi	sp,sp,32
 bf4:	8082                	ret
    free_stacks();
 bf6:	00000097          	auipc	ra,0x0
 bfa:	dd2080e7          	jalr	-558(ra) # 9c8 <free_stacks>
 bfe:	b7f5                	j	bea <ithread_join+0x36>
