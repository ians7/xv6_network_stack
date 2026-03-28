
src/user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	c9a78793          	addi	a5,a5,-870 # cb0 <ithread_join+0x7e>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	c5450513          	addi	a0,a0,-940 # c80 <ithread_join+0x4e>
  34:	00001097          	auipc	ra,0x1
  38:	840080e7          	jalr	-1984(ra) # 874 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	442080e7          	jalr	1090(ra) # 496 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	c3050513          	addi	a0,a0,-976 # c98 <ithread_join+0x66>
  70:	00001097          	auipc	ra,0x1
  74:	804080e7          	jalr	-2044(ra) # 874 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	454080e7          	jalr	1108(ra) # 4de <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	41e080e7          	jalr	1054(ra) # 4be <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	418080e7          	jalr	1048(ra) # 4c6 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	bf250513          	addi	a0,a0,-1038 # ca8 <ithread_join+0x76>
  be:	00000097          	auipc	ra,0x0
  c2:	7b6080e7          	jalr	1974(ra) # 874 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	412080e7          	jalr	1042(ra) # 4de <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	3d4080e7          	jalr	980(ra) # 4b6 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	3d6080e7          	jalr	982(ra) # 4c6 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	3ac080e7          	jalr	940(ra) # 4a6 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	39a080e7          	jalr	922(ra) # 49e <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	380080e7          	jalr	896(ra) # 49e <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	2a6080e7          	jalr	678(ra) # 4b6 <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
    buf[i++] = c;
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 252:	711d                	addi	sp,sp,-96
 254:	ec86                	sd	ra,88(sp)
 256:	e8a2                	sd	s0,80(sp)
 258:	e4a6                	sd	s1,72(sp)
 25a:	e0ca                	sd	s2,64(sp)
 25c:	fc4e                	sd	s3,56(sp)
 25e:	f852                	sd	s4,48(sp)
 260:	f456                	sd	s5,40(sp)
 262:	f05a                	sd	s6,32(sp)
 264:	ec5e                	sd	s7,24(sp)
 266:	1080                	addi	s0,sp,96
 268:	8baa                	mv	s7,a0
 26a:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 26c:	892a                	mv	s2,a0
 26e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 270:	4aa9                	li	s5,10
 272:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 274:	8a26                	mv	s4,s1
 276:	2485                	addiw	s1,s1,1
 278:	0334d863          	bge	s1,s3,2a8 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 27c:	4605                	li	a2,1
 27e:	faf40593          	addi	a1,s0,-81
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	232080e7          	jalr	562(ra) # 4b6 <read>
    if(cc < 1)
 28c:	00a05e63          	blez	a0,2a8 <fgetstdin+0x56>
    buf[i++] = c;
 290:	faf44783          	lbu	a5,-81(s0)
 294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 298:	01578763          	beq	a5,s5,2a6 <fgetstdin+0x54>
 29c:	0905                	addi	s2,s2,1
 29e:	fd679be3          	bne	a5,s6,274 <fgetstdin+0x22>
    buf[i++] = c;
 2a2:	8a26                	mv	s4,s1
 2a4:	a011                	j	2a8 <fgetstdin+0x56>
 2a6:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 2a8:	9bd2                	add	s7,s7,s4
 2aa:	000b8023          	sb	zero,0(s7)
  return i;
}
 2ae:	8552                	mv	a0,s4
 2b0:	60e6                	ld	ra,88(sp)
 2b2:	6446                	ld	s0,80(sp)
 2b4:	64a6                	ld	s1,72(sp)
 2b6:	6906                	ld	s2,64(sp)
 2b8:	79e2                	ld	s3,56(sp)
 2ba:	7a42                	ld	s4,48(sp)
 2bc:	7aa2                	ld	s5,40(sp)
 2be:	7b02                	ld	s6,32(sp)
 2c0:	6be2                	ld	s7,24(sp)
 2c2:	6125                	addi	sp,sp,96
 2c4:	8082                	ret

00000000000002c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c6:	1101                	addi	sp,sp,-32
 2c8:	ec06                	sd	ra,24(sp)
 2ca:	e822                	sd	s0,16(sp)
 2cc:	e04a                	sd	s2,0(sp)
 2ce:	1000                	addi	s0,sp,32
 2d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d2:	4581                	li	a1,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	20a080e7          	jalr	522(ra) # 4de <open>
  if(fd < 0)
 2dc:	02054663          	bltz	a0,308 <stat+0x42>
 2e0:	e426                	sd	s1,8(sp)
 2e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e4:	85ca                	mv	a1,s2
 2e6:	00000097          	auipc	ra,0x0
 2ea:	210080e7          	jalr	528(ra) # 4f6 <fstat>
 2ee:	892a                	mv	s2,a0
  close(fd);
 2f0:	8526                	mv	a0,s1
 2f2:	00000097          	auipc	ra,0x0
 2f6:	1d4080e7          	jalr	468(ra) # 4c6 <close>
  return r;
 2fa:	64a2                	ld	s1,8(sp)
}
 2fc:	854a                	mv	a0,s2
 2fe:	60e2                	ld	ra,24(sp)
 300:	6442                	ld	s0,16(sp)
 302:	6902                	ld	s2,0(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    return -1;
 308:	597d                	li	s2,-1
 30a:	bfcd                	j	2fc <stat+0x36>

000000000000030c <atoi>:

int
atoi(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 312:	00054683          	lbu	a3,0(a0)
 316:	fd06879b          	addiw	a5,a3,-48
 31a:	0ff7f793          	zext.b	a5,a5
 31e:	4625                	li	a2,9
 320:	02f66863          	bltu	a2,a5,350 <atoi+0x44>
 324:	872a                	mv	a4,a0
  n = 0;
 326:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 328:	0705                	addi	a4,a4,1
 32a:	0025179b          	slliw	a5,a0,0x2
 32e:	9fa9                	addw	a5,a5,a0
 330:	0017979b          	slliw	a5,a5,0x1
 334:	9fb5                	addw	a5,a5,a3
 336:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 33a:	00074683          	lbu	a3,0(a4)
 33e:	fd06879b          	addiw	a5,a3,-48
 342:	0ff7f793          	zext.b	a5,a5
 346:	fef671e3          	bgeu	a2,a5,328 <atoi+0x1c>
  return n;
}
 34a:	6422                	ld	s0,8(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  n = 0;
 350:	4501                	li	a0,0
 352:	bfe5                	j	34a <atoi+0x3e>

0000000000000354 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 35a:	02b57463          	bgeu	a0,a1,382 <memmove+0x2e>
    while(n-- > 0)
 35e:	00c05f63          	blez	a2,37c <memmove+0x28>
 362:	1602                	slli	a2,a2,0x20
 364:	9201                	srli	a2,a2,0x20
 366:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 36a:	872a                	mv	a4,a0
      *dst++ = *src++;
 36c:	0585                	addi	a1,a1,1
 36e:	0705                	addi	a4,a4,1
 370:	fff5c683          	lbu	a3,-1(a1)
 374:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 378:	fef71ae3          	bne	a4,a5,36c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
    dst += n;
 382:	00c50733          	add	a4,a0,a2
    src += n;
 386:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 388:	fec05ae3          	blez	a2,37c <memmove+0x28>
 38c:	fff6079b          	addiw	a5,a2,-1
 390:	1782                	slli	a5,a5,0x20
 392:	9381                	srli	a5,a5,0x20
 394:	fff7c793          	not	a5,a5
 398:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 39a:	15fd                	addi	a1,a1,-1
 39c:	177d                	addi	a4,a4,-1
 39e:	0005c683          	lbu	a3,0(a1)
 3a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a6:	fee79ae3          	bne	a5,a4,39a <memmove+0x46>
 3aa:	bfc9                	j	37c <memmove+0x28>

00000000000003ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b2:	ca05                	beqz	a2,3e2 <memcmp+0x36>
 3b4:	fff6069b          	addiw	a3,a2,-1
 3b8:	1682                	slli	a3,a3,0x20
 3ba:	9281                	srli	a3,a3,0x20
 3bc:	0685                	addi	a3,a3,1
 3be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c0:	00054783          	lbu	a5,0(a0)
 3c4:	0005c703          	lbu	a4,0(a1)
 3c8:	00e79863          	bne	a5,a4,3d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3cc:	0505                	addi	a0,a0,1
    p2++;
 3ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d0:	fed518e3          	bne	a0,a3,3c0 <memcmp+0x14>
  }
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	a019                	j	3dc <memcmp+0x30>
      return *p1 - *p2;
 3d8:	40e7853b          	subw	a0,a5,a4
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret
  return 0;
 3e2:	4501                	li	a0,0
 3e4:	bfe5                	j	3dc <memcmp+0x30>

00000000000003e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e406                	sd	ra,8(sp)
 3ea:	e022                	sd	s0,0(sp)
 3ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ee:	00000097          	auipc	ra,0x0
 3f2:	f66080e7          	jalr	-154(ra) # 354 <memmove>
}
 3f6:	60a2                	ld	ra,8(sp)
 3f8:	6402                	ld	s0,0(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret

00000000000003fe <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 404:	00054783          	lbu	a5,0(a0)
 408:	cfbd                	beqz	a5,486 <inet_addr+0x88>
  int dots = 0;
 40a:	4801                	li	a6,0
  int digits = 0;
 40c:	4601                	li	a2,0
  int octet = 0;
 40e:	4681                	li	a3,0
  uint result = 0;
 410:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 412:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 414:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 418:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 41a:	4301                	li	t1,0
      if (octet > 255)
 41c:	0ff00e13          	li	t3,255
 420:	a015                	j	444 <inet_addr+0x46>
    } else if (*s == '.') {
 422:	07d79463          	bne	a5,t4,48a <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 426:	c625                	beqz	a2,48e <inet_addr+0x90>
 428:	07e80563          	beq	a6,t5,492 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 42c:	0085959b          	slliw	a1,a1,0x8
 430:	8ecd                	or	a3,a3,a1
 432:	0006859b          	sext.w	a1,a3
      dots++;
 436:	2805                	addiw	a6,a6,1
      digits = 0;
 438:	861a                	mv	a2,t1
      octet = 0;
 43a:	869a                	mv	a3,t1
  for (; *s; s++) {
 43c:	0505                	addi	a0,a0,1
 43e:	00054783          	lbu	a5,0(a0)
 442:	c79d                	beqz	a5,470 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 444:	fd07871b          	addiw	a4,a5,-48
 448:	0ff77713          	zext.b	a4,a4
 44c:	fce8ebe3          	bltu	a7,a4,422 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 450:	0026971b          	slliw	a4,a3,0x2
 454:	9f35                	addw	a4,a4,a3
 456:	0017171b          	slliw	a4,a4,0x1
 45a:	fd07879b          	addiw	a5,a5,-48
 45e:	00e786bb          	addw	a3,a5,a4
      digits++;
 462:	2605                	addiw	a2,a2,1
      if (octet > 255)
 464:	fcde5ce3          	bge	t3,a3,43c <inet_addr+0x3e>
        return 0;
 468:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
    return 0;
 470:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 472:	de65                	beqz	a2,46a <inet_addr+0x6c>
 474:	478d                	li	a5,3
 476:	fef81ae3          	bne	a6,a5,46a <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 47a:	0085959b          	slliw	a1,a1,0x8
 47e:	8ecd                	or	a3,a3,a1
 480:	0006851b          	sext.w	a0,a3
  return result;
 484:	b7dd                	j	46a <inet_addr+0x6c>
    return 0;
 486:	4501                	li	a0,0
 488:	b7cd                	j	46a <inet_addr+0x6c>
      return 0;
 48a:	4501                	li	a0,0
 48c:	bff9                	j	46a <inet_addr+0x6c>
        return 0;
 48e:	4501                	li	a0,0
 490:	bfe9                	j	46a <inet_addr+0x6c>
 492:	4501                	li	a0,0
 494:	bfd9                	j	46a <inet_addr+0x6c>

0000000000000496 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 496:	4885                	li	a7,1
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <exit>:
.global exit
exit:
 li a7, SYS_exit
 49e:	4889                	li	a7,2
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4a6:	488d                	li	a7,3
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ae:	4891                	li	a7,4
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <read>:
.global read
read:
 li a7, SYS_read
 4b6:	4895                	li	a7,5
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <write>:
.global write
write:
 li a7, SYS_write
 4be:	48c1                	li	a7,16
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <close>:
.global close
close:
 li a7, SYS_close
 4c6:	48d5                	li	a7,21
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ce:	4899                	li	a7,6
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4d6:	489d                	li	a7,7
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <open>:
.global open
open:
 li a7, SYS_open
 4de:	48bd                	li	a7,15
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4e6:	48c5                	li	a7,17
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ee:	48c9                	li	a7,18
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4f6:	48a1                	li	a7,8
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <link>:
.global link
link:
 li a7, SYS_link
 4fe:	48cd                	li	a7,19
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 506:	48d1                	li	a7,20
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 50e:	48a5                	li	a7,9
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <dup>:
.global dup
dup:
 li a7, SYS_dup
 516:	48a9                	li	a7,10
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 51e:	48ad                	li	a7,11
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 526:	48b1                	li	a7,12
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 52e:	48b5                	li	a7,13
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 536:	48b9                	li	a7,14
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 53e:	48d9                	li	a7,22
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 546:	48dd                	li	a7,23
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 54e:	48e1                	li	a7,24
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 556:	48e5                	li	a7,25
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <socket>:
.global socket
socket:
 li a7, SYS_socket
 55e:	48e9                	li	a7,26
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <bind>:
.global bind
bind:
 li a7, SYS_bind
 566:	48ed                	li	a7,27
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <accept>:
.global accept
accept:
 li a7, SYS_accept
 56e:	48f5                	li	a7,29
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <listen>:
.global listen
listen:
 li a7, SYS_listen
 576:	48f1                	li	a7,28
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <connect>:
.global connect
connect:
 li a7, SYS_connect
 57e:	48f9                	li	a7,30
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <send>:
.global send
send:
 li a7, SYS_send
 586:	48fd                	li	a7,31
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <recv>:
.global recv
recv:
 li a7, SYS_recv
 58e:	02000893          	li	a7,32
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 598:	02100893          	li	a7,33
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 5a2:	02200893          	li	a7,34
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ac:	1101                	addi	sp,sp,-32
 5ae:	ec06                	sd	ra,24(sp)
 5b0:	e822                	sd	s0,16(sp)
 5b2:	1000                	addi	s0,sp,32
 5b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b8:	4605                	li	a2,1
 5ba:	fef40593          	addi	a1,s0,-17
 5be:	00000097          	auipc	ra,0x0
 5c2:	f00080e7          	jalr	-256(ra) # 4be <write>
}
 5c6:	60e2                	ld	ra,24(sp)
 5c8:	6442                	ld	s0,16(sp)
 5ca:	6105                	addi	sp,sp,32
 5cc:	8082                	ret

00000000000005ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ce:	7139                	addi	sp,sp,-64
 5d0:	fc06                	sd	ra,56(sp)
 5d2:	f822                	sd	s0,48(sp)
 5d4:	f426                	sd	s1,40(sp)
 5d6:	0080                	addi	s0,sp,64
 5d8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5da:	c299                	beqz	a3,5e0 <printint+0x12>
 5dc:	0805cb63          	bltz	a1,672 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e0:	2581                	sext.w	a1,a1
  neg = 0;
 5e2:	4881                	li	a7,0
 5e4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5ea:	2601                	sext.w	a2,a2
 5ec:	00000517          	auipc	a0,0x0
 5f0:	76450513          	addi	a0,a0,1892 # d50 <digits>
 5f4:	883a                	mv	a6,a4
 5f6:	2705                	addiw	a4,a4,1
 5f8:	02c5f7bb          	remuw	a5,a1,a2
 5fc:	1782                	slli	a5,a5,0x20
 5fe:	9381                	srli	a5,a5,0x20
 600:	97aa                	add	a5,a5,a0
 602:	0007c783          	lbu	a5,0(a5)
 606:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 60a:	0005879b          	sext.w	a5,a1
 60e:	02c5d5bb          	divuw	a1,a1,a2
 612:	0685                	addi	a3,a3,1
 614:	fec7f0e3          	bgeu	a5,a2,5f4 <printint+0x26>
  if(neg)
 618:	00088c63          	beqz	a7,630 <printint+0x62>
    buf[i++] = '-';
 61c:	fd070793          	addi	a5,a4,-48
 620:	00878733          	add	a4,a5,s0
 624:	02d00793          	li	a5,45
 628:	fef70823          	sb	a5,-16(a4)
 62c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 630:	02e05c63          	blez	a4,668 <printint+0x9a>
 634:	f04a                	sd	s2,32(sp)
 636:	ec4e                	sd	s3,24(sp)
 638:	fc040793          	addi	a5,s0,-64
 63c:	00e78933          	add	s2,a5,a4
 640:	fff78993          	addi	s3,a5,-1
 644:	99ba                	add	s3,s3,a4
 646:	377d                	addiw	a4,a4,-1
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 650:	fff94583          	lbu	a1,-1(s2)
 654:	8526                	mv	a0,s1
 656:	00000097          	auipc	ra,0x0
 65a:	f56080e7          	jalr	-170(ra) # 5ac <putc>
  while(--i >= 0)
 65e:	197d                	addi	s2,s2,-1
 660:	ff3918e3          	bne	s2,s3,650 <printint+0x82>
 664:	7902                	ld	s2,32(sp)
 666:	69e2                	ld	s3,24(sp)
}
 668:	70e2                	ld	ra,56(sp)
 66a:	7442                	ld	s0,48(sp)
 66c:	74a2                	ld	s1,40(sp)
 66e:	6121                	addi	sp,sp,64
 670:	8082                	ret
    x = -xx;
 672:	40b005bb          	negw	a1,a1
    neg = 1;
 676:	4885                	li	a7,1
    x = -xx;
 678:	b7b5                	j	5e4 <printint+0x16>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	715d                	addi	sp,sp,-80
 67c:	e486                	sd	ra,72(sp)
 67e:	e0a2                	sd	s0,64(sp)
 680:	f84a                	sd	s2,48(sp)
 682:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 684:	0005c903          	lbu	s2,0(a1)
 688:	1a090a63          	beqz	s2,83c <vprintf+0x1c2>
 68c:	fc26                	sd	s1,56(sp)
 68e:	f44e                	sd	s3,40(sp)
 690:	f052                	sd	s4,32(sp)
 692:	ec56                	sd	s5,24(sp)
 694:	e85a                	sd	s6,16(sp)
 696:	e45e                	sd	s7,8(sp)
 698:	8aaa                	mv	s5,a0
 69a:	8bb2                	mv	s7,a2
 69c:	00158493          	addi	s1,a1,1
  state = 0;
 6a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6a2:	02500a13          	li	s4,37
 6a6:	4b55                	li	s6,21
 6a8:	a839                	j	6c6 <vprintf+0x4c>
        putc(fd, c);
 6aa:	85ca                	mv	a1,s2
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	efe080e7          	jalr	-258(ra) # 5ac <putc>
 6b6:	a019                	j	6bc <vprintf+0x42>
    } else if(state == '%'){
 6b8:	01498d63          	beq	s3,s4,6d2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6bc:	0485                	addi	s1,s1,1
 6be:	fff4c903          	lbu	s2,-1(s1)
 6c2:	16090763          	beqz	s2,830 <vprintf+0x1b6>
    if(state == 0){
 6c6:	fe0999e3          	bnez	s3,6b8 <vprintf+0x3e>
      if(c == '%'){
 6ca:	ff4910e3          	bne	s2,s4,6aa <vprintf+0x30>
        state = '%';
 6ce:	89d2                	mv	s3,s4
 6d0:	b7f5                	j	6bc <vprintf+0x42>
      if(c == 'd'){
 6d2:	13490463          	beq	s2,s4,7fa <vprintf+0x180>
 6d6:	f9d9079b          	addiw	a5,s2,-99
 6da:	0ff7f793          	zext.b	a5,a5
 6de:	12fb6763          	bltu	s6,a5,80c <vprintf+0x192>
 6e2:	f9d9079b          	addiw	a5,s2,-99
 6e6:	0ff7f713          	zext.b	a4,a5
 6ea:	12eb6163          	bltu	s6,a4,80c <vprintf+0x192>
 6ee:	00271793          	slli	a5,a4,0x2
 6f2:	00000717          	auipc	a4,0x0
 6f6:	60670713          	addi	a4,a4,1542 # cf8 <ithread_join+0xc6>
 6fa:	97ba                	add	a5,a5,a4
 6fc:	439c                	lw	a5,0(a5)
 6fe:	97ba                	add	a5,a5,a4
 700:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 702:	008b8913          	addi	s2,s7,8
 706:	4685                	li	a3,1
 708:	4629                	li	a2,10
 70a:	000ba583          	lw	a1,0(s7)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	ebe080e7          	jalr	-322(ra) # 5ce <printint>
 718:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b745                	j	6bc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000ba583          	lw	a1,0(s7)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	ea2080e7          	jalr	-350(ra) # 5ce <printint>
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	b751                	j	6bc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000ba583          	lw	a1,0(s7)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e86080e7          	jalr	-378(ra) # 5ce <printint>
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	b7a5                	j	6bc <vprintf+0x42>
 756:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 758:	008b8c13          	addi	s8,s7,8
 75c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 760:	03000593          	li	a1,48
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e46080e7          	jalr	-442(ra) # 5ac <putc>
  putc(fd, 'x');
 76e:	07800593          	li	a1,120
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	e38080e7          	jalr	-456(ra) # 5ac <putc>
 77c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77e:	00000b97          	auipc	s7,0x0
 782:	5d2b8b93          	addi	s7,s7,1490 # d50 <digits>
 786:	03c9d793          	srli	a5,s3,0x3c
 78a:	97de                	add	a5,a5,s7
 78c:	0007c583          	lbu	a1,0(a5)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e1a080e7          	jalr	-486(ra) # 5ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79a:	0992                	slli	s3,s3,0x4
 79c:	397d                	addiw	s2,s2,-1
 79e:	fe0914e3          	bnez	s2,786 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7a2:	8be2                	mv	s7,s8
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	6c02                	ld	s8,0(sp)
 7a8:	bf11                	j	6bc <vprintf+0x42>
        s = va_arg(ap, char*);
 7aa:	008b8993          	addi	s3,s7,8
 7ae:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7b2:	02090163          	beqz	s2,7d4 <vprintf+0x15a>
        while(*s != 0){
 7b6:	00094583          	lbu	a1,0(s2)
 7ba:	c9a5                	beqz	a1,82a <vprintf+0x1b0>
          putc(fd, *s);
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	dee080e7          	jalr	-530(ra) # 5ac <putc>
          s++;
 7c6:	0905                	addi	s2,s2,1
        while(*s != 0){
 7c8:	00094583          	lbu	a1,0(s2)
 7cc:	f9e5                	bnez	a1,7bc <vprintf+0x142>
        s = va_arg(ap, char*);
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b5ed                	j	6bc <vprintf+0x42>
          s = "(null)";
 7d4:	00000917          	auipc	s2,0x0
 7d8:	4ec90913          	addi	s2,s2,1260 # cc0 <ithread_join+0x8e>
        while(*s != 0){
 7dc:	02800593          	li	a1,40
 7e0:	bff1                	j	7bc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	000bc583          	lbu	a1,0(s7)
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	dc0080e7          	jalr	-576(ra) # 5ac <putc>
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b5d1                	j	6bc <vprintf+0x42>
        putc(fd, c);
 7fa:	02500593          	li	a1,37
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	dac080e7          	jalr	-596(ra) # 5ac <putc>
      state = 0;
 808:	4981                	li	s3,0
 80a:	bd4d                	j	6bc <vprintf+0x42>
        putc(fd, '%');
 80c:	02500593          	li	a1,37
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	d9a080e7          	jalr	-614(ra) # 5ac <putc>
        putc(fd, c);
 81a:	85ca                	mv	a1,s2
 81c:	8556                	mv	a0,s5
 81e:	00000097          	auipc	ra,0x0
 822:	d8e080e7          	jalr	-626(ra) # 5ac <putc>
      state = 0;
 826:	4981                	li	s3,0
 828:	bd51                	j	6bc <vprintf+0x42>
        s = va_arg(ap, char*);
 82a:	8bce                	mv	s7,s3
      state = 0;
 82c:	4981                	li	s3,0
 82e:	b579                	j	6bc <vprintf+0x42>
 830:	74e2                	ld	s1,56(sp)
 832:	79a2                	ld	s3,40(sp)
 834:	7a02                	ld	s4,32(sp)
 836:	6ae2                	ld	s5,24(sp)
 838:	6b42                	ld	s6,16(sp)
 83a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 83c:	60a6                	ld	ra,72(sp)
 83e:	6406                	ld	s0,64(sp)
 840:	7942                	ld	s2,48(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 846:	715d                	addi	sp,sp,-80
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e010                	sd	a2,0(s0)
 850:	e414                	sd	a3,8(s0)
 852:	e818                	sd	a4,16(s0)
 854:	ec1c                	sd	a5,24(s0)
 856:	03043023          	sd	a6,32(s0)
 85a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 85e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 862:	8622                	mv	a2,s0
 864:	00000097          	auipc	ra,0x0
 868:	e16080e7          	jalr	-490(ra) # 67a <vprintf>
}
 86c:	60e2                	ld	ra,24(sp)
 86e:	6442                	ld	s0,16(sp)
 870:	6161                	addi	sp,sp,80
 872:	8082                	ret

0000000000000874 <printf>:

void
printf(const char *fmt, ...)
{
 874:	711d                	addi	sp,sp,-96
 876:	ec06                	sd	ra,24(sp)
 878:	e822                	sd	s0,16(sp)
 87a:	1000                	addi	s0,sp,32
 87c:	e40c                	sd	a1,8(s0)
 87e:	e810                	sd	a2,16(s0)
 880:	ec14                	sd	a3,24(s0)
 882:	f018                	sd	a4,32(s0)
 884:	f41c                	sd	a5,40(s0)
 886:	03043823          	sd	a6,48(s0)
 88a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 88e:	00840613          	addi	a2,s0,8
 892:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 896:	85aa                	mv	a1,a0
 898:	4505                	li	a0,1
 89a:	00000097          	auipc	ra,0x0
 89e:	de0080e7          	jalr	-544(ra) # 67a <vprintf>
}
 8a2:	60e2                	ld	ra,24(sp)
 8a4:	6442                	ld	s0,16(sp)
 8a6:	6125                	addi	sp,sp,96
 8a8:	8082                	ret

00000000000008aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8aa:	1141                	addi	sp,sp,-16
 8ac:	e422                	sd	s0,8(sp)
 8ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	00000797          	auipc	a5,0x0
 8b8:	75c7b783          	ld	a5,1884(a5) # 1010 <freep>
 8bc:	a02d                	j	8e6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8be:	4618                	lw	a4,8(a2)
 8c0:	9f2d                	addw	a4,a4,a1
 8c2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c6:	6398                	ld	a4,0(a5)
 8c8:	6310                	ld	a2,0(a4)
 8ca:	a83d                	j	908 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8cc:	ff852703          	lw	a4,-8(a0)
 8d0:	9f31                	addw	a4,a4,a2
 8d2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d4:	ff053683          	ld	a3,-16(a0)
 8d8:	a091                	j	91c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8da:	6398                	ld	a4,0(a5)
 8dc:	00e7e463          	bltu	a5,a4,8e4 <free+0x3a>
 8e0:	00e6ea63          	bltu	a3,a4,8f4 <free+0x4a>
{
 8e4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e6:	fed7fae3          	bgeu	a5,a3,8da <free+0x30>
 8ea:	6398                	ld	a4,0(a5)
 8ec:	00e6e463          	bltu	a3,a4,8f4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f0:	fee7eae3          	bltu	a5,a4,8e4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f4:	ff852583          	lw	a1,-8(a0)
 8f8:	6390                	ld	a2,0(a5)
 8fa:	02059813          	slli	a6,a1,0x20
 8fe:	01c85713          	srli	a4,a6,0x1c
 902:	9736                	add	a4,a4,a3
 904:	fae60de3          	beq	a2,a4,8be <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 908:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 90c:	4790                	lw	a2,8(a5)
 90e:	02061593          	slli	a1,a2,0x20
 912:	01c5d713          	srli	a4,a1,0x1c
 916:	973e                	add	a4,a4,a5
 918:	fae68ae3          	beq	a3,a4,8cc <free+0x22>
    p->s.ptr = bp->s.ptr;
 91c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 91e:	00000717          	auipc	a4,0x0
 922:	6ef73923          	sd	a5,1778(a4) # 1010 <freep>
}
 926:	6422                	ld	s0,8(sp)
 928:	0141                	addi	sp,sp,16
 92a:	8082                	ret

000000000000092c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 92c:	7139                	addi	sp,sp,-64
 92e:	fc06                	sd	ra,56(sp)
 930:	f822                	sd	s0,48(sp)
 932:	f426                	sd	s1,40(sp)
 934:	ec4e                	sd	s3,24(sp)
 936:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 938:	02051493          	slli	s1,a0,0x20
 93c:	9081                	srli	s1,s1,0x20
 93e:	04bd                	addi	s1,s1,15
 940:	8091                	srli	s1,s1,0x4
 942:	0014899b          	addiw	s3,s1,1
 946:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 948:	00000517          	auipc	a0,0x0
 94c:	6c853503          	ld	a0,1736(a0) # 1010 <freep>
 950:	c915                	beqz	a0,984 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 952:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 954:	4798                	lw	a4,8(a5)
 956:	08977e63          	bgeu	a4,s1,9f2 <malloc+0xc6>
 95a:	f04a                	sd	s2,32(sp)
 95c:	e852                	sd	s4,16(sp)
 95e:	e456                	sd	s5,8(sp)
 960:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 962:	8a4e                	mv	s4,s3
 964:	0009871b          	sext.w	a4,s3
 968:	6685                	lui	a3,0x1
 96a:	00d77363          	bgeu	a4,a3,970 <malloc+0x44>
 96e:	6a05                	lui	s4,0x1
 970:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 974:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 978:	00000917          	auipc	s2,0x0
 97c:	69890913          	addi	s2,s2,1688 # 1010 <freep>
  if(p == (char*)-1)
 980:	5afd                	li	s5,-1
 982:	a091                	j	9c6 <malloc+0x9a>
 984:	f04a                	sd	s2,32(sp)
 986:	e852                	sd	s4,16(sp)
 988:	e456                	sd	s5,8(sp)
 98a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 98c:	00000797          	auipc	a5,0x0
 990:	6a478793          	addi	a5,a5,1700 # 1030 <base>
 994:	00000717          	auipc	a4,0x0
 998:	66f73e23          	sd	a5,1660(a4) # 1010 <freep>
 99c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a2:	b7c1                	j	962 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9a4:	6398                	ld	a4,0(a5)
 9a6:	e118                	sd	a4,0(a0)
 9a8:	a08d                	j	a0a <malloc+0xde>
  hp->s.size = nu;
 9aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ae:	0541                	addi	a0,a0,16
 9b0:	00000097          	auipc	ra,0x0
 9b4:	efa080e7          	jalr	-262(ra) # 8aa <free>
  return freep;
 9b8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9bc:	c13d                	beqz	a0,a22 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c0:	4798                	lw	a4,8(a5)
 9c2:	02977463          	bgeu	a4,s1,9ea <malloc+0xbe>
    if(p == freep)
 9c6:	00093703          	ld	a4,0(s2)
 9ca:	853e                	mv	a0,a5
 9cc:	fef719e3          	bne	a4,a5,9be <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 9d0:	8552                	mv	a0,s4
 9d2:	00000097          	auipc	ra,0x0
 9d6:	b54080e7          	jalr	-1196(ra) # 526 <sbrk>
  if(p == (char*)-1)
 9da:	fd5518e3          	bne	a0,s5,9aa <malloc+0x7e>
        return 0;
 9de:	4501                	li	a0,0
 9e0:	7902                	ld	s2,32(sp)
 9e2:	6a42                	ld	s4,16(sp)
 9e4:	6aa2                	ld	s5,8(sp)
 9e6:	6b02                	ld	s6,0(sp)
 9e8:	a03d                	j	a16 <malloc+0xea>
 9ea:	7902                	ld	s2,32(sp)
 9ec:	6a42                	ld	s4,16(sp)
 9ee:	6aa2                	ld	s5,8(sp)
 9f0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9f2:	fae489e3          	beq	s1,a4,9a4 <malloc+0x78>
        p->s.size -= nunits;
 9f6:	4137073b          	subw	a4,a4,s3
 9fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fc:	02071693          	slli	a3,a4,0x20
 a00:	01c6d713          	srli	a4,a3,0x1c
 a04:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a06:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a0a:	00000717          	auipc	a4,0x0
 a0e:	60a73323          	sd	a0,1542(a4) # 1010 <freep>
      return (void*)(p + 1);
 a12:	01078513          	addi	a0,a5,16
  }
}
 a16:	70e2                	ld	ra,56(sp)
 a18:	7442                	ld	s0,48(sp)
 a1a:	74a2                	ld	s1,40(sp)
 a1c:	69e2                	ld	s3,24(sp)
 a1e:	6121                	addi	sp,sp,64
 a20:	8082                	ret
 a22:	7902                	ld	s2,32(sp)
 a24:	6a42                	ld	s4,16(sp)
 a26:	6aa2                	ld	s5,8(sp)
 a28:	6b02                	ld	s6,0(sp)
 a2a:	b7f5                	j	a16 <malloc+0xea>

0000000000000a2c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 a2c:	1141                	addi	sp,sp,-16
 a2e:	e406                	sd	ra,8(sp)
 a30:	e022                	sd	s0,0(sp)
 a32:	0800                	addi	s0,sp,16
  thread_exit(status);
 a34:	2501                	sext.w	a0,a0
 a36:	00000097          	auipc	ra,0x0
 a3a:	b20080e7          	jalr	-1248(ra) # 556 <thread_exit>
}
 a3e:	60a2                	ld	ra,8(sp)
 a40:	6402                	ld	s0,0(sp)
 a42:	0141                	addi	sp,sp,16
 a44:	8082                	ret

0000000000000a46 <free_stacks>:
int free_stacks() {
 a46:	7179                	addi	sp,sp,-48
 a48:	f406                	sd	ra,40(sp)
 a4a:	f022                	sd	s0,32(sp)
 a4c:	ec26                	sd	s1,24(sp)
 a4e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 a50:	00000797          	auipc	a5,0x0
 a54:	5d07a783          	lw	a5,1488(a5) # 1020 <num_threads>
 a58:	04f05063          	blez	a5,a98 <free_stacks+0x52>
 a5c:	e84a                	sd	s2,16(sp)
 a5e:	e44e                	sd	s3,8(sp)
 a60:	4481                	li	s1,0
    free(stacks[i]);
 a62:	00000997          	auipc	s3,0x0
 a66:	5b698993          	addi	s3,s3,1462 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 a6a:	00000917          	auipc	s2,0x0
 a6e:	5b690913          	addi	s2,s2,1462 # 1020 <num_threads>
    free(stacks[i]);
 a72:	0009b783          	ld	a5,0(s3)
 a76:	00349713          	slli	a4,s1,0x3
 a7a:	97ba                	add	a5,a5,a4
 a7c:	6388                	ld	a0,0(a5)
 a7e:	00000097          	auipc	ra,0x0
 a82:	e2c080e7          	jalr	-468(ra) # 8aa <free>
  for (int i = 0; i < num_threads; i++) {
 a86:	0485                	addi	s1,s1,1
 a88:	00092703          	lw	a4,0(s2)
 a8c:	0004879b          	sext.w	a5,s1
 a90:	fee7c1e3          	blt	a5,a4,a72 <free_stacks+0x2c>
 a94:	6942                	ld	s2,16(sp)
 a96:	69a2                	ld	s3,8(sp)
  free(stacks);
 a98:	00000497          	auipc	s1,0x0
 a9c:	58048493          	addi	s1,s1,1408 # 1018 <stacks>
 aa0:	6088                	ld	a0,0(s1)
 aa2:	00000097          	auipc	ra,0x0
 aa6:	e08080e7          	jalr	-504(ra) # 8aa <free>
  stacks = 0;
 aaa:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 aae:	00000797          	auipc	a5,0x0
 ab2:	5607a923          	sw	zero,1394(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 ab6:	47a1                	li	a5,8
 ab8:	00000717          	auipc	a4,0x0
 abc:	54f72423          	sw	a5,1352(a4) # 1000 <max_stacks>
  threads_done = 0;
 ac0:	00000797          	auipc	a5,0x0
 ac4:	5607a223          	sw	zero,1380(a5) # 1024 <threads_done>
}
 ac8:	4501                	li	a0,0
 aca:	70a2                	ld	ra,40(sp)
 acc:	7402                	ld	s0,32(sp)
 ace:	64e2                	ld	s1,24(sp)
 ad0:	6145                	addi	sp,sp,48
 ad2:	8082                	ret

0000000000000ad4 <expand_num_threads>:
int expand_num_threads() {
 ad4:	1101                	addi	sp,sp,-32
 ad6:	ec06                	sd	ra,24(sp)
 ad8:	e822                	sd	s0,16(sp)
 ada:	e426                	sd	s1,8(sp)
 adc:	e04a                	sd	s2,0(sp)
 ade:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 ae0:	00000797          	auipc	a5,0x0
 ae4:	52078793          	addi	a5,a5,1312 # 1000 <max_stacks>
 ae8:	4388                	lw	a0,0(a5)
 aea:	0015151b          	slliw	a0,a0,0x1
 aee:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 af0:	0035151b          	slliw	a0,a0,0x3
 af4:	00000097          	auipc	ra,0x0
 af8:	e38080e7          	jalr	-456(ra) # 92c <malloc>
 afc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 afe:	00000617          	auipc	a2,0x0
 b02:	52262603          	lw	a2,1314(a2) # 1020 <num_threads>
 b06:	00000497          	auipc	s1,0x0
 b0a:	51248493          	addi	s1,s1,1298 # 1018 <stacks>
 b0e:	0036161b          	slliw	a2,a2,0x3
 b12:	608c                	ld	a1,0(s1)
 b14:	00000097          	auipc	ra,0x0
 b18:	840080e7          	jalr	-1984(ra) # 354 <memmove>
  free(stacks);
 b1c:	6088                	ld	a0,0(s1)
 b1e:	00000097          	auipc	ra,0x0
 b22:	d8c080e7          	jalr	-628(ra) # 8aa <free>
  stacks = new_stacks;
 b26:	0124b023          	sd	s2,0(s1)
}
 b2a:	4501                	li	a0,0
 b2c:	60e2                	ld	ra,24(sp)
 b2e:	6442                	ld	s0,16(sp)
 b30:	64a2                	ld	s1,8(sp)
 b32:	6902                	ld	s2,0(sp)
 b34:	6105                	addi	sp,sp,32
 b36:	8082                	ret

0000000000000b38 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 b38:	7179                	addi	sp,sp,-48
 b3a:	f406                	sd	ra,40(sp)
 b3c:	f022                	sd	s0,32(sp)
 b3e:	e84a                	sd	s2,16(sp)
 b40:	e44e                	sd	s3,8(sp)
 b42:	1800                	addi	s0,sp,48
 b44:	892a                	mv	s2,a0
 b46:	89ae                	mv	s3,a1
  if (stacks == 0) {
 b48:	00000797          	auipc	a5,0x0
 b4c:	4d07b783          	ld	a5,1232(a5) # 1018 <stacks>
 b50:	c3d9                	beqz	a5,bd6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 b52:	00000797          	auipc	a5,0x0
 b56:	4ae7a783          	lw	a5,1198(a5) # 1000 <max_stacks>
 b5a:	00000717          	auipc	a4,0x0
 b5e:	4c672703          	lw	a4,1222(a4) # 1020 <num_threads>
 b62:	0af71363          	bne	a4,a5,c08 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 b66:	04000713          	li	a4,64
 b6a:	08e78563          	beq	a5,a4,bf4 <ithread_create+0xbc>
 b6e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 b70:	00000097          	auipc	ra,0x0
 b74:	f64080e7          	jalr	-156(ra) # ad4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 b78:	6505                	lui	a0,0x1
 b7a:	00000097          	auipc	ra,0x0
 b7e:	db2080e7          	jalr	-590(ra) # 92c <malloc>
 b82:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 b84:	00000717          	auipc	a4,0x0
 b88:	49c72703          	lw	a4,1180(a4) # 1020 <num_threads>
 b8c:	070e                	slli	a4,a4,0x3
 b8e:	00000797          	auipc	a5,0x0
 b92:	48a7b783          	ld	a5,1162(a5) # 1018 <stacks>
 b96:	97ba                	add	a5,a5,a4
 b98:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b9a:	00000697          	auipc	a3,0x0
 b9e:	e9268693          	addi	a3,a3,-366 # a2c <ithread_exit>
 ba2:	862a                	mv	a2,a0
 ba4:	85ce                	mv	a1,s3
 ba6:	854a                	mv	a0,s2
 ba8:	00000097          	auipc	ra,0x0
 bac:	99e080e7          	jalr	-1634(ra) # 546 <create_thread>
 bb0:	892a                	mv	s2,a0
  if (res != -1) {
 bb2:	57fd                	li	a5,-1
 bb4:	04f50c63          	beq	a0,a5,c0c <ithread_create+0xd4>
    num_threads++;
 bb8:	00000717          	auipc	a4,0x0
 bbc:	46870713          	addi	a4,a4,1128 # 1020 <num_threads>
 bc0:	431c                	lw	a5,0(a4)
 bc2:	2785                	addiw	a5,a5,1
 bc4:	c31c                	sw	a5,0(a4)
 bc6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 bc8:	854a                	mv	a0,s2
 bca:	70a2                	ld	ra,40(sp)
 bcc:	7402                	ld	s0,32(sp)
 bce:	6942                	ld	s2,16(sp)
 bd0:	69a2                	ld	s3,8(sp)
 bd2:	6145                	addi	sp,sp,48
 bd4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 bd6:	00000517          	auipc	a0,0x0
 bda:	42a52503          	lw	a0,1066(a0) # 1000 <max_stacks>
 bde:	0035151b          	slliw	a0,a0,0x3
 be2:	00000097          	auipc	ra,0x0
 be6:	d4a080e7          	jalr	-694(ra) # 92c <malloc>
 bea:	00000797          	auipc	a5,0x0
 bee:	42a7b723          	sd	a0,1070(a5) # 1018 <stacks>
 bf2:	b785                	j	b52 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 bf4:	00000517          	auipc	a0,0x0
 bf8:	0d450513          	addi	a0,a0,212 # cc8 <ithread_join+0x96>
 bfc:	00000097          	auipc	ra,0x0
 c00:	c78080e7          	jalr	-904(ra) # 874 <printf>
      return -1;
 c04:	597d                	li	s2,-1
 c06:	b7c9                	j	bc8 <ithread_create+0x90>
 c08:	ec26                	sd	s1,24(sp)
 c0a:	b7bd                	j	b78 <ithread_create+0x40>
    free(stack_ptr);
 c0c:	8526                	mv	a0,s1
 c0e:	00000097          	auipc	ra,0x0
 c12:	c9c080e7          	jalr	-868(ra) # 8aa <free>
    stacks[num_threads] = 0;
 c16:	00000717          	auipc	a4,0x0
 c1a:	40a72703          	lw	a4,1034(a4) # 1020 <num_threads>
 c1e:	070e                	slli	a4,a4,0x3
 c20:	00000797          	auipc	a5,0x0
 c24:	3f87b783          	ld	a5,1016(a5) # 1018 <stacks>
 c28:	97ba                	add	a5,a5,a4
 c2a:	0007b023          	sd	zero,0(a5)
 c2e:	64e2                	ld	s1,24(sp)
 c30:	bf61                	j	bc8 <ithread_create+0x90>

0000000000000c32 <ithread_join>:

int ithread_join(int thread_id) {
 c32:	1101                	addi	sp,sp,-32
 c34:	ec06                	sd	ra,24(sp)
 c36:	e822                	sd	s0,16(sp)
 c38:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 c3a:	ff040793          	addi	a5,s0,-16
 c3e:	ffc7859b          	addiw	a1,a5,-4
 c42:	00000097          	auipc	ra,0x0
 c46:	90c080e7          	jalr	-1780(ra) # 54e <join_thread>
  threads_done++;
 c4a:	00000717          	auipc	a4,0x0
 c4e:	3da70713          	addi	a4,a4,986 # 1024 <threads_done>
 c52:	431c                	lw	a5,0(a4)
 c54:	2785                	addiw	a5,a5,1
 c56:	0007869b          	sext.w	a3,a5
 c5a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 c5c:	00000797          	auipc	a5,0x0
 c60:	3c47a783          	lw	a5,964(a5) # 1020 <num_threads>
 c64:	00d78863          	beq	a5,a3,c74 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 c68:	fec42503          	lw	a0,-20(s0)
 c6c:	60e2                	ld	ra,24(sp)
 c6e:	6442                	ld	s0,16(sp)
 c70:	6105                	addi	sp,sp,32
 c72:	8082                	ret
    free_stacks();
 c74:	00000097          	auipc	ra,0x0
 c78:	dd2080e7          	jalr	-558(ra) # a46 <free_stacks>
 c7c:	b7f5                	j	c68 <ithread_join+0x36>
