
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	b9278793          	addi	a5,a5,-1134 # bb0 <ithread_join+0x80>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	b4c50513          	addi	a0,a0,-1204 # b80 <ithread_join+0x50>
  3c:	00000097          	auipc	ra,0x0
  40:	736080e7          	jalr	1846(ra) # 772 <printf>
  memset(data, 'a', sizeof(data));
  44:	20000613          	li	a2,512
  48:	06100593          	li	a1,97
  4c:	dc040513          	addi	a0,s0,-576
  50:	00000097          	auipc	ra,0x0
  54:	162080e7          	jalr	354(ra) # 1b2 <memset>

  for(i = 0; i < 4; i++)
  58:	4481                	li	s1,0
  5a:	4911                	li	s2,4
    if(fork() > 0)
  5c:	00000097          	auipc	ra,0x0
  60:	360080e7          	jalr	864(ra) # 3bc <fork>
  64:	00a04563          	bgtz	a0,6e <main+0x6e>
  for(i = 0; i < 4; i++)
  68:	2485                	addiw	s1,s1,1
  6a:	ff2499e3          	bne	s1,s2,5c <main+0x5c>
      break;

  printf("write %d\n", i);
  6e:	85a6                	mv	a1,s1
  70:	00001517          	auipc	a0,0x1
  74:	b2850513          	addi	a0,a0,-1240 # b98 <ithread_join+0x68>
  78:	00000097          	auipc	ra,0x0
  7c:	6fa080e7          	jalr	1786(ra) # 772 <printf>

  path[8] += i;
  80:	fc844783          	lbu	a5,-56(s0)
  84:	9fa5                	addw	a5,a5,s1
  86:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  8a:	20200593          	li	a1,514
  8e:	fc040513          	addi	a0,s0,-64
  92:	00000097          	auipc	ra,0x0
  96:	372080e7          	jalr	882(ra) # 404 <open>
  9a:	892a                	mv	s2,a0
  9c:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9e:	dc040a13          	addi	s4,s0,-576
  a2:	20000993          	li	s3,512
  a6:	864e                	mv	a2,s3
  a8:	85d2                	mv	a1,s4
  aa:	854a                	mv	a0,s2
  ac:	00000097          	auipc	ra,0x0
  b0:	338080e7          	jalr	824(ra) # 3e4 <write>
  for(i = 0; i < 20; i++)
  b4:	34fd                	addiw	s1,s1,-1
  b6:	f8e5                	bnez	s1,a6 <main+0xa6>
  close(fd);
  b8:	854a                	mv	a0,s2
  ba:	00000097          	auipc	ra,0x0
  be:	332080e7          	jalr	818(ra) # 3ec <close>

  printf("read\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	ae650513          	addi	a0,a0,-1306 # ba8 <ithread_join+0x78>
  ca:	00000097          	auipc	ra,0x0
  ce:	6a8080e7          	jalr	1704(ra) # 772 <printf>

  fd = open(path, O_RDONLY);
  d2:	4581                	li	a1,0
  d4:	fc040513          	addi	a0,s0,-64
  d8:	00000097          	auipc	ra,0x0
  dc:	32c080e7          	jalr	812(ra) # 404 <open>
  e0:	892a                	mv	s2,a0
  e2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e4:	dc040a13          	addi	s4,s0,-576
  e8:	20000993          	li	s3,512
  ec:	864e                	mv	a2,s3
  ee:	85d2                	mv	a1,s4
  f0:	854a                	mv	a0,s2
  f2:	00000097          	auipc	ra,0x0
  f6:	2ea080e7          	jalr	746(ra) # 3dc <read>
  for (i = 0; i < 20; i++)
  fa:	34fd                	addiw	s1,s1,-1
  fc:	f8e5                	bnez	s1,ec <main+0xec>
  close(fd);
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	2ec080e7          	jalr	748(ra) # 3ec <close>

  wait(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2c2080e7          	jalr	706(ra) # 3cc <wait>

  exit(0);
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	2b0080e7          	jalr	688(ra) # 3c4 <exit>

000000000000011c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  extern int main();
  main();
 124:	00000097          	auipc	ra,0x0
 128:	edc080e7          	jalr	-292(ra) # 0 <main>
  exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	296080e7          	jalr	662(ra) # 3c4 <exit>

0000000000000136 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0xa>
    ;
  return os;
}
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x20>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x20>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	60a2                	ld	ra,8(sp)
 180:	6402                	ld	s0,0(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strlen>:

uint
strlen(const char *s)
{
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cf91                	beqz	a5,1ae <strlen+0x28>
 194:	00150793          	addi	a5,a0,1
 198:	86be                	mv	a3,a5
 19a:	0785                	addi	a5,a5,1
 19c:	fff7c703          	lbu	a4,-1(a5)
 1a0:	ff65                	bnez	a4,198 <strlen+0x12>
 1a2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1a6:	60a2                	ld	ra,8(sp)
 1a8:	6402                	ld	s0,0(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  for(n = 0; s[n]; n++)
 1ae:	4501                	li	a0,0
 1b0:	bfdd                	j	1a6 <strlen+0x20>

00000000000001b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e406                	sd	ra,8(sp)
 1b6:	e022                	sd	s0,0(sp)
 1b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ba:	ca19                	beqz	a2,1d0 <memset+0x1e>
 1bc:	87aa                	mv	a5,a0
 1be:	1602                	slli	a2,a2,0x20
 1c0:	9201                	srli	a2,a2,0x20
 1c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ca:	0785                	addi	a5,a5,1
 1cc:	fee79de3          	bne	a5,a4,1c6 <memset+0x14>
  }
  return dst;
}
 1d0:	60a2                	ld	ra,8(sp)
 1d2:	6402                	ld	s0,0(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e406                	sd	ra,8(sp)
 1dc:	e022                	sd	s0,0(sp)
 1de:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	cf81                	beqz	a5,1fc <strchr+0x24>
    if(*s == c)
 1e6:	00f58763          	beq	a1,a5,1f4 <strchr+0x1c>
  for(; *s; s++)
 1ea:	0505                	addi	a0,a0,1
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	fbfd                	bnez	a5,1e6 <strchr+0xe>
      return (char*)s;
  return 0;
 1f2:	4501                	li	a0,0
}
 1f4:	60a2                	ld	ra,8(sp)
 1f6:	6402                	ld	s0,0(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  return 0;
 1fc:	4501                	li	a0,0
 1fe:	bfdd                	j	1f4 <strchr+0x1c>

0000000000000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	711d                	addi	sp,sp,-96
 202:	ec86                	sd	ra,88(sp)
 204:	e8a2                	sd	s0,80(sp)
 206:	e4a6                	sd	s1,72(sp)
 208:	e0ca                	sd	s2,64(sp)
 20a:	fc4e                	sd	s3,56(sp)
 20c:	f852                	sd	s4,48(sp)
 20e:	f456                	sd	s5,40(sp)
 210:	f05a                	sd	s6,32(sp)
 212:	ec5e                	sd	s7,24(sp)
 214:	e862                	sd	s8,16(sp)
 216:	1080                	addi	s0,sp,96
 218:	8baa                	mv	s7,a0
 21a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	892a                	mv	s2,a0
 21e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 220:	faf40b13          	addi	s6,s0,-81
 224:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 226:	8c26                	mv	s8,s1
 228:	0014899b          	addiw	s3,s1,1
 22c:	84ce                	mv	s1,s3
 22e:	0349d663          	bge	s3,s4,25a <gets+0x5a>
    cc = read(0, &c, 1);
 232:	8656                	mv	a2,s5
 234:	85da                	mv	a1,s6
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	1a4080e7          	jalr	420(ra) # 3dc <read>
    if(cc < 1)
 240:	00a05d63          	blez	a0,25a <gets+0x5a>
      break;
    buf[i++] = c;
 244:	faf44783          	lbu	a5,-81(s0)
 248:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 24c:	0905                	addi	s2,s2,1
 24e:	ff678713          	addi	a4,a5,-10
 252:	c319                	beqz	a4,258 <gets+0x58>
 254:	17cd                	addi	a5,a5,-13
 256:	fbe1                	bnez	a5,226 <gets+0x26>
    buf[i++] = c;
 258:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 25a:	9c5e                	add	s8,s8,s7
 25c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 260:	855e                	mv	a0,s7
 262:	60e6                	ld	ra,88(sp)
 264:	6446                	ld	s0,80(sp)
 266:	64a6                	ld	s1,72(sp)
 268:	6906                	ld	s2,64(sp)
 26a:	79e2                	ld	s3,56(sp)
 26c:	7a42                	ld	s4,48(sp)
 26e:	7aa2                	ld	s5,40(sp)
 270:	7b02                	ld	s6,32(sp)
 272:	6be2                	ld	s7,24(sp)
 274:	6c42                	ld	s8,16(sp)
 276:	6125                	addi	sp,sp,96
 278:	8082                	ret

000000000000027a <stat>:

int
stat(const char *n, struct stat *st)
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e04a                	sd	s2,0(sp)
 282:	1000                	addi	s0,sp,32
 284:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	4581                	li	a1,0
 288:	00000097          	auipc	ra,0x0
 28c:	17c080e7          	jalr	380(ra) # 404 <open>
  if(fd < 0)
 290:	02054663          	bltz	a0,2bc <stat+0x42>
 294:	e426                	sd	s1,8(sp)
 296:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 298:	85ca                	mv	a1,s2
 29a:	00000097          	auipc	ra,0x0
 29e:	182080e7          	jalr	386(ra) # 41c <fstat>
 2a2:	892a                	mv	s2,a0
  close(fd);
 2a4:	8526                	mv	a0,s1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	146080e7          	jalr	326(ra) # 3ec <close>
  return r;
 2ae:	64a2                	ld	s1,8(sp)
}
 2b0:	854a                	mv	a0,s2
 2b2:	60e2                	ld	ra,24(sp)
 2b4:	6442                	ld	s0,16(sp)
 2b6:	6902                	ld	s2,0(sp)
 2b8:	6105                	addi	sp,sp,32
 2ba:	8082                	ret
    return -1;
 2bc:	57fd                	li	a5,-1
 2be:	893e                	mv	s2,a5
 2c0:	bfc5                	j	2b0 <stat+0x36>

00000000000002c2 <atoi>:

int
atoi(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ca:	00054683          	lbu	a3,0(a0)
 2ce:	fd06879b          	addiw	a5,a3,-48
 2d2:	0ff7f793          	zext.b	a5,a5
 2d6:	4625                	li	a2,9
 2d8:	02f66963          	bltu	a2,a5,30a <atoi+0x48>
 2dc:	872a                	mv	a4,a0
  n = 0;
 2de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e0:	0705                	addi	a4,a4,1
 2e2:	0025179b          	slliw	a5,a0,0x2
 2e6:	9fa9                	addw	a5,a5,a0
 2e8:	0017979b          	slliw	a5,a5,0x1
 2ec:	9fb5                	addw	a5,a5,a3
 2ee:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f2:	00074683          	lbu	a3,0(a4)
 2f6:	fd06879b          	addiw	a5,a3,-48
 2fa:	0ff7f793          	zext.b	a5,a5
 2fe:	fef671e3          	bgeu	a2,a5,2e0 <atoi+0x1e>
  return n;
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
  n = 0;
 30a:	4501                	li	a0,0
 30c:	bfdd                	j	302 <atoi+0x40>

000000000000030e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 316:	02b57563          	bgeu	a0,a1,340 <memmove+0x32>
    while(n-- > 0)
 31a:	00c05f63          	blez	a2,338 <memmove+0x2a>
 31e:	1602                	slli	a2,a2,0x20
 320:	9201                	srli	a2,a2,0x20
 322:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 326:	872a                	mv	a4,a0
      *dst++ = *src++;
 328:	0585                	addi	a1,a1,1
 32a:	0705                	addi	a4,a4,1
 32c:	fff5c683          	lbu	a3,-1(a1)
 330:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 334:	fee79ae3          	bne	a5,a4,328 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
    while(n-- > 0)
 340:	fec05ce3          	blez	a2,338 <memmove+0x2a>
    dst += n;
 344:	00c50733          	add	a4,a0,a2
    src += n;
 348:	95b2                	add	a1,a1,a2
 34a:	fff6079b          	addiw	a5,a2,-1
 34e:	1782                	slli	a5,a5,0x20
 350:	9381                	srli	a5,a5,0x20
 352:	fff7c793          	not	a5,a5
 356:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 358:	15fd                	addi	a1,a1,-1
 35a:	177d                	addi	a4,a4,-1
 35c:	0005c683          	lbu	a3,0(a1)
 360:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 364:	fef71ae3          	bne	a4,a5,358 <memmove+0x4a>
 368:	bfc1                	j	338 <memmove+0x2a>

000000000000036a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 372:	c61d                	beqz	a2,3a0 <memcmp+0x36>
 374:	1602                	slli	a2,a2,0x20
 376:	9201                	srli	a2,a2,0x20
 378:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 37c:	00054783          	lbu	a5,0(a0)
 380:	0005c703          	lbu	a4,0(a1)
 384:	00e79863          	bne	a5,a4,394 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 388:	0505                	addi	a0,a0,1
    p2++;
 38a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 38c:	fed518e3          	bne	a0,a3,37c <memcmp+0x12>
  }
  return 0;
 390:	4501                	li	a0,0
 392:	a019                	j	398 <memcmp+0x2e>
      return *p1 - *p2;
 394:	40e7853b          	subw	a0,a5,a4
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	bfdd                	j	398 <memcmp+0x2e>

00000000000003a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ac:	00000097          	auipc	ra,0x0
 3b0:	f62080e7          	jalr	-158(ra) # 30e <memmove>
}
 3b4:	60a2                	ld	ra,8(sp)
 3b6:	6402                	ld	s0,0(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret

00000000000003bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3bc:	4885                	li	a7,1
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c4:	4889                	li	a7,2
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3cc:	488d                	li	a7,3
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d4:	4891                	li	a7,4
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <read>:
.global read
read:
 li a7, SYS_read
 3dc:	4895                	li	a7,5
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <write>:
.global write
write:
 li a7, SYS_write
 3e4:	48c1                	li	a7,16
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <close>:
.global close
close:
 li a7, SYS_close
 3ec:	48d5                	li	a7,21
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f4:	4899                	li	a7,6
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fc:	489d                	li	a7,7
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <open>:
.global open
open:
 li a7, SYS_open
 404:	48bd                	li	a7,15
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40c:	48c5                	li	a7,17
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 414:	48c9                	li	a7,18
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41c:	48a1                	li	a7,8
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <link>:
.global link
link:
 li a7, SYS_link
 424:	48cd                	li	a7,19
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42c:	48d1                	li	a7,20
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 434:	48a5                	li	a7,9
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <dup>:
.global dup
dup:
 li a7, SYS_dup
 43c:	48a9                	li	a7,10
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 444:	48ad                	li	a7,11
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 44c:	48b1                	li	a7,12
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 454:	48b5                	li	a7,13
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45c:	48b9                	li	a7,14
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 464:	48d9                	li	a7,22
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 46c:	48dd                	li	a7,23
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 474:	48e1                	li	a7,24
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 47c:	48e5                	li	a7,25
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <socket>:
.global socket
socket:
 li a7, SYS_socket
 484:	48e9                	li	a7,26
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <bind>:
.global bind
bind:
 li a7, SYS_bind
 48c:	48ed                	li	a7,27
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <accept>:
.global accept
accept:
 li a7, SYS_accept
 494:	48f5                	li	a7,29
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <listen>:
.global listen
listen:
 li a7, SYS_listen
 49c:	48f1                	li	a7,28
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4a4:	48f9                	li	a7,30
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	1000                	addi	s0,sp,32
 4b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b8:	4605                	li	a2,1
 4ba:	fef40593          	addi	a1,s0,-17
 4be:	00000097          	auipc	ra,0x0
 4c2:	f26080e7          	jalr	-218(ra) # 3e4 <write>
}
 4c6:	60e2                	ld	ra,24(sp)
 4c8:	6442                	ld	s0,16(sp)
 4ca:	6105                	addi	sp,sp,32
 4cc:	8082                	ret

00000000000004ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ce:	7139                	addi	sp,sp,-64
 4d0:	fc06                	sd	ra,56(sp)
 4d2:	f822                	sd	s0,48(sp)
 4d4:	f04a                	sd	s2,32(sp)
 4d6:	ec4e                	sd	s3,24(sp)
 4d8:	0080                	addi	s0,sp,64
 4da:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4dc:	cad9                	beqz	a3,572 <printint+0xa4>
 4de:	01f5d79b          	srliw	a5,a1,0x1f
 4e2:	cbc1                	beqz	a5,572 <printint+0xa4>
    neg = 1;
    x = -xx;
 4e4:	40b005bb          	negw	a1,a1
    neg = 1;
 4e8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4ea:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4ee:	86ce                	mv	a3,s3
  i = 0;
 4f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f2:	00000817          	auipc	a6,0x0
 4f6:	75e80813          	addi	a6,a6,1886 # c50 <digits>
 4fa:	88ba                	mv	a7,a4
 4fc:	0017051b          	addiw	a0,a4,1
 500:	872a                	mv	a4,a0
 502:	02c5f7bb          	remuw	a5,a1,a2
 506:	1782                	slli	a5,a5,0x20
 508:	9381                	srli	a5,a5,0x20
 50a:	97c2                	add	a5,a5,a6
 50c:	0007c783          	lbu	a5,0(a5)
 510:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 514:	87ae                	mv	a5,a1
 516:	02c5d5bb          	divuw	a1,a1,a2
 51a:	0685                	addi	a3,a3,1
 51c:	fcc7ffe3          	bgeu	a5,a2,4fa <printint+0x2c>
  if(neg)
 520:	00030c63          	beqz	t1,538 <printint+0x6a>
    buf[i++] = '-';
 524:	fd050793          	addi	a5,a0,-48
 528:	00878533          	add	a0,a5,s0
 52c:	02d00793          	li	a5,45
 530:	fef50823          	sb	a5,-16(a0)
 534:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 538:	02e05763          	blez	a4,566 <printint+0x98>
 53c:	f426                	sd	s1,40(sp)
 53e:	377d                	addiw	a4,a4,-1
 540:	00e984b3          	add	s1,s3,a4
 544:	19fd                	addi	s3,s3,-1
 546:	99ba                	add	s3,s3,a4
 548:	1702                	slli	a4,a4,0x20
 54a:	9301                	srli	a4,a4,0x20
 54c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 550:	0004c583          	lbu	a1,0(s1)
 554:	854a                	mv	a0,s2
 556:	00000097          	auipc	ra,0x0
 55a:	f56080e7          	jalr	-170(ra) # 4ac <putc>
  while(--i >= 0)
 55e:	14fd                	addi	s1,s1,-1
 560:	ff3498e3          	bne	s1,s3,550 <printint+0x82>
 564:	74a2                	ld	s1,40(sp)
}
 566:	70e2                	ld	ra,56(sp)
 568:	7442                	ld	s0,48(sp)
 56a:	7902                	ld	s2,32(sp)
 56c:	69e2                	ld	s3,24(sp)
 56e:	6121                	addi	sp,sp,64
 570:	8082                	ret
  neg = 0;
 572:	4301                	li	t1,0
 574:	bf9d                	j	4ea <printint+0x1c>

0000000000000576 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 576:	715d                	addi	sp,sp,-80
 578:	e486                	sd	ra,72(sp)
 57a:	e0a2                	sd	s0,64(sp)
 57c:	f84a                	sd	s2,48(sp)
 57e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 580:	0005c903          	lbu	s2,0(a1)
 584:	1a090b63          	beqz	s2,73a <vprintf+0x1c4>
 588:	fc26                	sd	s1,56(sp)
 58a:	f44e                	sd	s3,40(sp)
 58c:	f052                	sd	s4,32(sp)
 58e:	ec56                	sd	s5,24(sp)
 590:	e85a                	sd	s6,16(sp)
 592:	e45e                	sd	s7,8(sp)
 594:	8aaa                	mv	s5,a0
 596:	8bb2                	mv	s7,a2
 598:	00158493          	addi	s1,a1,1
  state = 0;
 59c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 59e:	02500a13          	li	s4,37
 5a2:	4b55                	li	s6,21
 5a4:	a839                	j	5c2 <vprintf+0x4c>
        putc(fd, c);
 5a6:	85ca                	mv	a1,s2
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	f02080e7          	jalr	-254(ra) # 4ac <putc>
 5b2:	a019                	j	5b8 <vprintf+0x42>
    } else if(state == '%'){
 5b4:	01498d63          	beq	s3,s4,5ce <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5b8:	0485                	addi	s1,s1,1
 5ba:	fff4c903          	lbu	s2,-1(s1)
 5be:	16090863          	beqz	s2,72e <vprintf+0x1b8>
    if(state == 0){
 5c2:	fe0999e3          	bnez	s3,5b4 <vprintf+0x3e>
      if(c == '%'){
 5c6:	ff4910e3          	bne	s2,s4,5a6 <vprintf+0x30>
        state = '%';
 5ca:	89d2                	mv	s3,s4
 5cc:	b7f5                	j	5b8 <vprintf+0x42>
      if(c == 'd'){
 5ce:	13490563          	beq	s2,s4,6f8 <vprintf+0x182>
 5d2:	f9d9079b          	addiw	a5,s2,-99
 5d6:	0ff7f793          	zext.b	a5,a5
 5da:	12fb6863          	bltu	s6,a5,70a <vprintf+0x194>
 5de:	f9d9079b          	addiw	a5,s2,-99
 5e2:	0ff7f713          	zext.b	a4,a5
 5e6:	12eb6263          	bltu	s6,a4,70a <vprintf+0x194>
 5ea:	00271793          	slli	a5,a4,0x2
 5ee:	00000717          	auipc	a4,0x0
 5f2:	60a70713          	addi	a4,a4,1546 # bf8 <ithread_join+0xc8>
 5f6:	97ba                	add	a5,a5,a4
 5f8:	439c                	lw	a5,0(a5)
 5fa:	97ba                	add	a5,a5,a4
 5fc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	ec2080e7          	jalr	-318(ra) # 4ce <printint>
 614:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 616:	4981                	li	s3,0
 618:	b745                	j	5b8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	ea6080e7          	jalr	-346(ra) # 4ce <printint>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b751                	j	5b8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000ba583          	lw	a1,0(s7)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e8a080e7          	jalr	-374(ra) # 4ce <printint>
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	b7a5                	j	5b8 <vprintf+0x42>
 652:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 654:	008b8793          	addi	a5,s7,8
 658:	8c3e                	mv	s8,a5
 65a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65e:	03000593          	li	a1,48
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	e48080e7          	jalr	-440(ra) # 4ac <putc>
  putc(fd, 'x');
 66c:	07800593          	li	a1,120
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e3a080e7          	jalr	-454(ra) # 4ac <putc>
 67a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67c:	00000b97          	auipc	s7,0x0
 680:	5d4b8b93          	addi	s7,s7,1492 # c50 <digits>
 684:	03c9d793          	srli	a5,s3,0x3c
 688:	97de                	add	a5,a5,s7
 68a:	0007c583          	lbu	a1,0(a5)
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e1c080e7          	jalr	-484(ra) # 4ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 698:	0992                	slli	s3,s3,0x4
 69a:	397d                	addiw	s2,s2,-1
 69c:	fe0914e3          	bnez	s2,684 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 6a0:	8be2                	mv	s7,s8
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	6c02                	ld	s8,0(sp)
 6a6:	bf09                	j	5b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 6a8:	008b8993          	addi	s3,s7,8
 6ac:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6b0:	02090163          	beqz	s2,6d2 <vprintf+0x15c>
        while(*s != 0){
 6b4:	00094583          	lbu	a1,0(s2)
 6b8:	c9a5                	beqz	a1,728 <vprintf+0x1b2>
          putc(fd, *s);
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	df0080e7          	jalr	-528(ra) # 4ac <putc>
          s++;
 6c4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	f9e5                	bnez	a1,6ba <vprintf+0x144>
        s = va_arg(ap, char*);
 6cc:	8bce                	mv	s7,s3
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b5e5                	j	5b8 <vprintf+0x42>
          s = "(null)";
 6d2:	00000917          	auipc	s2,0x0
 6d6:	4ee90913          	addi	s2,s2,1262 # bc0 <ithread_join+0x90>
        while(*s != 0){
 6da:	02800593          	li	a1,40
 6de:	bff1                	j	6ba <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	000bc583          	lbu	a1,0(s7)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	dc2080e7          	jalr	-574(ra) # 4ac <putc>
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b5c9                	j	5b8 <vprintf+0x42>
        putc(fd, c);
 6f8:	02500593          	li	a1,37
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	dae080e7          	jalr	-594(ra) # 4ac <putc>
      state = 0;
 706:	4981                	li	s3,0
 708:	bd45                	j	5b8 <vprintf+0x42>
        putc(fd, '%');
 70a:	02500593          	li	a1,37
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	d9c080e7          	jalr	-612(ra) # 4ac <putc>
        putc(fd, c);
 718:	85ca                	mv	a1,s2
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	d90080e7          	jalr	-624(ra) # 4ac <putc>
      state = 0;
 724:	4981                	li	s3,0
 726:	bd49                	j	5b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b571                	j	5b8 <vprintf+0x42>
 72e:	74e2                	ld	s1,56(sp)
 730:	79a2                	ld	s3,40(sp)
 732:	7a02                	ld	s4,32(sp)
 734:	6ae2                	ld	s5,24(sp)
 736:	6b42                	ld	s6,16(sp)
 738:	6ba2                	ld	s7,8(sp)
    }
  }
}
 73a:	60a6                	ld	ra,72(sp)
 73c:	6406                	ld	s0,64(sp)
 73e:	7942                	ld	s2,48(sp)
 740:	6161                	addi	sp,sp,80
 742:	8082                	ret

0000000000000744 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 744:	715d                	addi	sp,sp,-80
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e010                	sd	a2,0(s0)
 74e:	e414                	sd	a3,8(s0)
 750:	e818                	sd	a4,16(s0)
 752:	ec1c                	sd	a5,24(s0)
 754:	03043023          	sd	a6,32(s0)
 758:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	8622                	mv	a2,s0
 75e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 762:	00000097          	auipc	ra,0x0
 766:	e14080e7          	jalr	-492(ra) # 576 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6161                	addi	sp,sp,80
 770:	8082                	ret

0000000000000772 <printf>:

void
printf(const char *fmt, ...)
{
 772:	711d                	addi	sp,sp,-96
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	e40c                	sd	a1,8(s0)
 77c:	e810                	sd	a2,16(s0)
 77e:	ec14                	sd	a3,24(s0)
 780:	f018                	sd	a4,32(s0)
 782:	f41c                	sd	a5,40(s0)
 784:	03043823          	sd	a6,48(s0)
 788:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	00840613          	addi	a2,s0,8
 790:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 794:	85aa                	mv	a1,a0
 796:	4505                	li	a0,1
 798:	00000097          	auipc	ra,0x0
 79c:	dde080e7          	jalr	-546(ra) # 576 <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret

00000000000007a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e406                	sd	ra,8(sp)
 7ac:	e022                	sd	s0,0(sp)
 7ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	00001797          	auipc	a5,0x1
 7b8:	d5c7b783          	ld	a5,-676(a5) # 1510 <freep>
 7bc:	a039                	j	7ca <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	6398                	ld	a4,0(a5)
 7c0:	00e7e463          	bltu	a5,a4,7c8 <free+0x20>
 7c4:	00e6ea63          	bltu	a3,a4,7d8 <free+0x30>
{
 7c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	fed7fae3          	bgeu	a5,a3,7be <free+0x16>
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e6e463          	bltu	a3,a4,7d8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	fee7eae3          	bltu	a5,a4,7c8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d8:	ff852583          	lw	a1,-8(a0)
 7dc:	6390                	ld	a2,0(a5)
 7de:	02059813          	slli	a6,a1,0x20
 7e2:	01c85713          	srli	a4,a6,0x1c
 7e6:	9736                	add	a4,a4,a3
 7e8:	02e60563          	beq	a2,a4,812 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7f0:	4790                	lw	a2,8(a5)
 7f2:	02061593          	slli	a1,a2,0x20
 7f6:	01c5d713          	srli	a4,a1,0x1c
 7fa:	973e                	add	a4,a4,a5
 7fc:	02e68263          	beq	a3,a4,820 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 800:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 802:	00001717          	auipc	a4,0x1
 806:	d0f73723          	sd	a5,-754(a4) # 1510 <freep>
}
 80a:	60a2                	ld	ra,8(sp)
 80c:	6402                	ld	s0,0(sp)
 80e:	0141                	addi	sp,sp,16
 810:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 812:	4618                	lw	a4,8(a2)
 814:	9f2d                	addw	a4,a4,a1
 816:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	6310                	ld	a2,0(a4)
 81e:	b7f9                	j	7ec <free+0x44>
    p->s.size += bp->s.size;
 820:	ff852703          	lw	a4,-8(a0)
 824:	9f31                	addw	a4,a4,a2
 826:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 828:	ff053683          	ld	a3,-16(a0)
 82c:	bfd1                	j	800 <free+0x58>

000000000000082e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82e:	7139                	addi	sp,sp,-64
 830:	fc06                	sd	ra,56(sp)
 832:	f822                	sd	s0,48(sp)
 834:	f04a                	sd	s2,32(sp)
 836:	ec4e                	sd	s3,24(sp)
 838:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83a:	02051993          	slli	s3,a0,0x20
 83e:	0209d993          	srli	s3,s3,0x20
 842:	09bd                	addi	s3,s3,15
 844:	0049d993          	srli	s3,s3,0x4
 848:	2985                	addiw	s3,s3,1
 84a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 84c:	00001517          	auipc	a0,0x1
 850:	cc453503          	ld	a0,-828(a0) # 1510 <freep>
 854:	c905                	beqz	a0,884 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	09377a63          	bgeu	a4,s3,8ee <malloc+0xc0>
 85e:	f426                	sd	s1,40(sp)
 860:	e852                	sd	s4,16(sp)
 862:	e456                	sd	s5,8(sp)
 864:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 866:	8a4e                	mv	s4,s3
 868:	6705                	lui	a4,0x1
 86a:	00e9f363          	bgeu	s3,a4,870 <malloc+0x42>
 86e:	6a05                	lui	s4,0x1
 870:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 874:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 878:	00001497          	auipc	s1,0x1
 87c:	c9848493          	addi	s1,s1,-872 # 1510 <freep>
  if(p == (char*)-1)
 880:	5afd                	li	s5,-1
 882:	a089                	j	8c4 <malloc+0x96>
 884:	f426                	sd	s1,40(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 88c:	00001797          	auipc	a5,0x1
 890:	ca478793          	addi	a5,a5,-860 # 1530 <base>
 894:	00001717          	auipc	a4,0x1
 898:	c6f73e23          	sd	a5,-900(a4) # 1510 <freep>
 89c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a2:	b7d1                	j	866 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a4:	6398                	ld	a4,0(a5)
 8a6:	e118                	sd	a4,0(a0)
 8a8:	a8b9                	j	906 <malloc+0xd8>
  hp->s.size = nu;
 8aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ae:	0541                	addi	a0,a0,16
 8b0:	00000097          	auipc	ra,0x0
 8b4:	ef8080e7          	jalr	-264(ra) # 7a8 <free>
  return freep;
 8b8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ba:	c135                	beqz	a0,91e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	03277363          	bgeu	a4,s2,8e6 <malloc+0xb8>
    if(p == freep)
 8c4:	6098                	ld	a4,0(s1)
 8c6:	853e                	mv	a0,a5
 8c8:	fef71ae3          	bne	a4,a5,8bc <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8cc:	8552                	mv	a0,s4
 8ce:	00000097          	auipc	ra,0x0
 8d2:	b7e080e7          	jalr	-1154(ra) # 44c <sbrk>
  if(p == (char*)-1)
 8d6:	fd551ae3          	bne	a0,s5,8aa <malloc+0x7c>
        return 0;
 8da:	4501                	li	a0,0
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	a03d                	j	912 <malloc+0xe4>
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ee:	fae90be3          	beq	s2,a4,8a4 <malloc+0x76>
        p->s.size -= nunits;
 8f2:	4137073b          	subw	a4,a4,s3
 8f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f8:	02071693          	slli	a3,a4,0x20
 8fc:	01c6d713          	srli	a4,a3,0x1c
 900:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 902:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 906:	00001717          	auipc	a4,0x1
 90a:	c0a73523          	sd	a0,-1014(a4) # 1510 <freep>
      return (void*)(p + 1);
 90e:	01078513          	addi	a0,a5,16
  }
}
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	7902                	ld	s2,32(sp)
 918:	69e2                	ld	s3,24(sp)
 91a:	6121                	addi	sp,sp,64
 91c:	8082                	ret
 91e:	74a2                	ld	s1,40(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	b7f5                	j	912 <malloc+0xe4>

0000000000000928 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 928:	1141                	addi	sp,sp,-16
 92a:	e406                	sd	ra,8(sp)
 92c:	e022                	sd	s0,0(sp)
 92e:	0800                	addi	s0,sp,16
  thread_exit(status);
 930:	2501                	sext.w	a0,a0
 932:	00000097          	auipc	ra,0x0
 936:	b4a080e7          	jalr	-1206(ra) # 47c <thread_exit>
}
 93a:	60a2                	ld	ra,8(sp)
 93c:	6402                	ld	s0,0(sp)
 93e:	0141                	addi	sp,sp,16
 940:	8082                	ret

0000000000000942 <free_stacks>:
int free_stacks() {
 942:	7179                	addi	sp,sp,-48
 944:	f406                	sd	ra,40(sp)
 946:	f022                	sd	s0,32(sp)
 948:	ec26                	sd	s1,24(sp)
 94a:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 94c:	00001797          	auipc	a5,0x1
 950:	bd47a783          	lw	a5,-1068(a5) # 1520 <num_threads>
 954:	04f05063          	blez	a5,994 <free_stacks+0x52>
 958:	e84a                	sd	s2,16(sp)
 95a:	e44e                	sd	s3,8(sp)
 95c:	4481                	li	s1,0
    free(stacks[i]);
 95e:	00001997          	auipc	s3,0x1
 962:	bba98993          	addi	s3,s3,-1094 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 966:	00001917          	auipc	s2,0x1
 96a:	bba90913          	addi	s2,s2,-1094 # 1520 <num_threads>
    free(stacks[i]);
 96e:	0009b783          	ld	a5,0(s3)
 972:	00349713          	slli	a4,s1,0x3
 976:	97ba                	add	a5,a5,a4
 978:	6388                	ld	a0,0(a5)
 97a:	00000097          	auipc	ra,0x0
 97e:	e2e080e7          	jalr	-466(ra) # 7a8 <free>
  for (int i = 0; i < num_threads; i++) {
 982:	0485                	addi	s1,s1,1
 984:	00092703          	lw	a4,0(s2)
 988:	0004879b          	sext.w	a5,s1
 98c:	fee7c1e3          	blt	a5,a4,96e <free_stacks+0x2c>
 990:	6942                	ld	s2,16(sp)
 992:	69a2                	ld	s3,8(sp)
  free(stacks);
 994:	00001497          	auipc	s1,0x1
 998:	b8448493          	addi	s1,s1,-1148 # 1518 <stacks>
 99c:	6088                	ld	a0,0(s1)
 99e:	00000097          	auipc	ra,0x0
 9a2:	e0a080e7          	jalr	-502(ra) # 7a8 <free>
  stacks = 0;
 9a6:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9aa:	00001797          	auipc	a5,0x1
 9ae:	b607ab23          	sw	zero,-1162(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9b2:	47a1                	li	a5,8
 9b4:	00001717          	auipc	a4,0x1
 9b8:	b4f72623          	sw	a5,-1204(a4) # 1500 <max_stacks>
  threads_done = 0;
 9bc:	00001797          	auipc	a5,0x1
 9c0:	b607a423          	sw	zero,-1176(a5) # 1524 <threads_done>
}
 9c4:	4501                	li	a0,0
 9c6:	70a2                	ld	ra,40(sp)
 9c8:	7402                	ld	s0,32(sp)
 9ca:	64e2                	ld	s1,24(sp)
 9cc:	6145                	addi	sp,sp,48
 9ce:	8082                	ret

00000000000009d0 <expand_num_threads>:
int expand_num_threads() {
 9d0:	1101                	addi	sp,sp,-32
 9d2:	ec06                	sd	ra,24(sp)
 9d4:	e822                	sd	s0,16(sp)
 9d6:	e426                	sd	s1,8(sp)
 9d8:	e04a                	sd	s2,0(sp)
 9da:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9dc:	00001797          	auipc	a5,0x1
 9e0:	b2478793          	addi	a5,a5,-1244 # 1500 <max_stacks>
 9e4:	4388                	lw	a0,0(a5)
 9e6:	0015151b          	slliw	a0,a0,0x1
 9ea:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9ec:	0035151b          	slliw	a0,a0,0x3
 9f0:	00000097          	auipc	ra,0x0
 9f4:	e3e080e7          	jalr	-450(ra) # 82e <malloc>
 9f8:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9fa:	00001617          	auipc	a2,0x1
 9fe:	b2662603          	lw	a2,-1242(a2) # 1520 <num_threads>
 a02:	00001497          	auipc	s1,0x1
 a06:	b1648493          	addi	s1,s1,-1258 # 1518 <stacks>
 a0a:	0036161b          	slliw	a2,a2,0x3
 a0e:	608c                	ld	a1,0(s1)
 a10:	00000097          	auipc	ra,0x0
 a14:	8fe080e7          	jalr	-1794(ra) # 30e <memmove>
  free(stacks);
 a18:	6088                	ld	a0,0(s1)
 a1a:	00000097          	auipc	ra,0x0
 a1e:	d8e080e7          	jalr	-626(ra) # 7a8 <free>
  stacks = new_stacks;
 a22:	0124b023          	sd	s2,0(s1)
}
 a26:	4501                	li	a0,0
 a28:	60e2                	ld	ra,24(sp)
 a2a:	6442                	ld	s0,16(sp)
 a2c:	64a2                	ld	s1,8(sp)
 a2e:	6902                	ld	s2,0(sp)
 a30:	6105                	addi	sp,sp,32
 a32:	8082                	ret

0000000000000a34 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a34:	7179                	addi	sp,sp,-48
 a36:	f406                	sd	ra,40(sp)
 a38:	f022                	sd	s0,32(sp)
 a3a:	e84a                	sd	s2,16(sp)
 a3c:	e44e                	sd	s3,8(sp)
 a3e:	1800                	addi	s0,sp,48
 a40:	892a                	mv	s2,a0
 a42:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a44:	00001797          	auipc	a5,0x1
 a48:	ad47b783          	ld	a5,-1324(a5) # 1518 <stacks>
 a4c:	c3d9                	beqz	a5,ad2 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a4e:	00001797          	auipc	a5,0x1
 a52:	ab27a783          	lw	a5,-1358(a5) # 1500 <max_stacks>
 a56:	00001717          	auipc	a4,0x1
 a5a:	aca72703          	lw	a4,-1334(a4) # 1520 <num_threads>
 a5e:	0af71463          	bne	a4,a5,b06 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a62:	04000713          	li	a4,64
 a66:	08e78563          	beq	a5,a4,af0 <ithread_create+0xbc>
 a6a:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a6c:	00000097          	auipc	ra,0x0
 a70:	f64080e7          	jalr	-156(ra) # 9d0 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a74:	6505                	lui	a0,0x1
 a76:	00000097          	auipc	ra,0x0
 a7a:	db8080e7          	jalr	-584(ra) # 82e <malloc>
 a7e:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a80:	00001717          	auipc	a4,0x1
 a84:	aa072703          	lw	a4,-1376(a4) # 1520 <num_threads>
 a88:	070e                	slli	a4,a4,0x3
 a8a:	00001797          	auipc	a5,0x1
 a8e:	a8e7b783          	ld	a5,-1394(a5) # 1518 <stacks>
 a92:	97ba                	add	a5,a5,a4
 a94:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a96:	00000697          	auipc	a3,0x0
 a9a:	e9268693          	addi	a3,a3,-366 # 928 <ithread_exit>
 a9e:	862a                	mv	a2,a0
 aa0:	85ce                	mv	a1,s3
 aa2:	854a                	mv	a0,s2
 aa4:	00000097          	auipc	ra,0x0
 aa8:	9c8080e7          	jalr	-1592(ra) # 46c <create_thread>
 aac:	892a                	mv	s2,a0
  if (res != -1) {
 aae:	57fd                	li	a5,-1
 ab0:	04f50d63          	beq	a0,a5,b0a <ithread_create+0xd6>
    num_threads++;
 ab4:	00001717          	auipc	a4,0x1
 ab8:	a6c70713          	addi	a4,a4,-1428 # 1520 <num_threads>
 abc:	431c                	lw	a5,0(a4)
 abe:	2785                	addiw	a5,a5,1
 ac0:	c31c                	sw	a5,0(a4)
 ac2:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ac4:	854a                	mv	a0,s2
 ac6:	70a2                	ld	ra,40(sp)
 ac8:	7402                	ld	s0,32(sp)
 aca:	6942                	ld	s2,16(sp)
 acc:	69a2                	ld	s3,8(sp)
 ace:	6145                	addi	sp,sp,48
 ad0:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ad2:	00001517          	auipc	a0,0x1
 ad6:	a2e52503          	lw	a0,-1490(a0) # 1500 <max_stacks>
 ada:	0035151b          	slliw	a0,a0,0x3
 ade:	00000097          	auipc	ra,0x0
 ae2:	d50080e7          	jalr	-688(ra) # 82e <malloc>
 ae6:	00001797          	auipc	a5,0x1
 aea:	a2a7b923          	sd	a0,-1486(a5) # 1518 <stacks>
 aee:	b785                	j	a4e <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 af0:	00000517          	auipc	a0,0x0
 af4:	0d850513          	addi	a0,a0,216 # bc8 <ithread_join+0x98>
 af8:	00000097          	auipc	ra,0x0
 afc:	c7a080e7          	jalr	-902(ra) # 772 <printf>
      return -1;
 b00:	57fd                	li	a5,-1
 b02:	893e                	mv	s2,a5
 b04:	b7c1                	j	ac4 <ithread_create+0x90>
 b06:	ec26                	sd	s1,24(sp)
 b08:	b7b5                	j	a74 <ithread_create+0x40>
    free(stack_ptr);
 b0a:	8526                	mv	a0,s1
 b0c:	00000097          	auipc	ra,0x0
 b10:	c9c080e7          	jalr	-868(ra) # 7a8 <free>
    stacks[num_threads] = 0;
 b14:	00001717          	auipc	a4,0x1
 b18:	a0c72703          	lw	a4,-1524(a4) # 1520 <num_threads>
 b1c:	070e                	slli	a4,a4,0x3
 b1e:	00001797          	auipc	a5,0x1
 b22:	9fa7b783          	ld	a5,-1542(a5) # 1518 <stacks>
 b26:	97ba                	add	a5,a5,a4
 b28:	0007b023          	sd	zero,0(a5)
 b2c:	64e2                	ld	s1,24(sp)
 b2e:	bf59                	j	ac4 <ithread_create+0x90>

0000000000000b30 <ithread_join>:

int ithread_join(int thread_id) {
 b30:	1101                	addi	sp,sp,-32
 b32:	ec06                	sd	ra,24(sp)
 b34:	e822                	sd	s0,16(sp)
 b36:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b38:	ff040793          	addi	a5,s0,-16
 b3c:	ffc7859b          	addiw	a1,a5,-4
 b40:	00000097          	auipc	ra,0x0
 b44:	934080e7          	jalr	-1740(ra) # 474 <join_thread>
  threads_done++;
 b48:	00001717          	auipc	a4,0x1
 b4c:	9dc70713          	addi	a4,a4,-1572 # 1524 <threads_done>
 b50:	431c                	lw	a5,0(a4)
 b52:	2785                	addiw	a5,a5,1
 b54:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b56:	00001717          	auipc	a4,0x1
 b5a:	9ca72703          	lw	a4,-1590(a4) # 1520 <num_threads>
 b5e:	00f70863          	beq	a4,a5,b6e <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b62:	fec42503          	lw	a0,-20(s0)
 b66:	60e2                	ld	ra,24(sp)
 b68:	6442                	ld	s0,16(sp)
 b6a:	6105                	addi	sp,sp,32
 b6c:	8082                	ret
    free_stacks();
 b6e:	00000097          	auipc	ra,0x0
 b72:	dd4080e7          	jalr	-556(ra) # 942 <free_stacks>
 b76:	b7f5                	j	b62 <ithread_join+0x32>
