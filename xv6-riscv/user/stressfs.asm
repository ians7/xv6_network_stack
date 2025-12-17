
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
  22:	bb278793          	addi	a5,a5,-1102 # bd0 <ithread_join+0x7a>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	b6c50513          	addi	a0,a0,-1172 # ba0 <ithread_join+0x4a>
  3c:	00000097          	auipc	ra,0x0
  40:	75c080e7          	jalr	1884(ra) # 798 <printf>
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
  74:	b4850513          	addi	a0,a0,-1208 # bb8 <ithread_join+0x62>
  78:	00000097          	auipc	ra,0x0
  7c:	720080e7          	jalr	1824(ra) # 798 <printf>

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
  c6:	b0650513          	addi	a0,a0,-1274 # bc8 <ithread_join+0x72>
  ca:	00000097          	auipc	ra,0x0
  ce:	6ce080e7          	jalr	1742(ra) # 798 <printf>

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

00000000000004ac <send>:
.global send
send:
 li a7, SYS_send
 4ac:	48fd                	li	a7,31
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4b4:	02000893          	li	a7,32
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4be:	02100893          	li	a7,33
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4c8:	02200893          	li	a7,34
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d2:	1101                	addi	sp,sp,-32
 4d4:	ec06                	sd	ra,24(sp)
 4d6:	e822                	sd	s0,16(sp)
 4d8:	1000                	addi	s0,sp,32
 4da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4de:	4605                	li	a2,1
 4e0:	fef40593          	addi	a1,s0,-17
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f00080e7          	jalr	-256(ra) # 3e4 <write>
}
 4ec:	60e2                	ld	ra,24(sp)
 4ee:	6442                	ld	s0,16(sp)
 4f0:	6105                	addi	sp,sp,32
 4f2:	8082                	ret

00000000000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	7139                	addi	sp,sp,-64
 4f6:	fc06                	sd	ra,56(sp)
 4f8:	f822                	sd	s0,48(sp)
 4fa:	f04a                	sd	s2,32(sp)
 4fc:	ec4e                	sd	s3,24(sp)
 4fe:	0080                	addi	s0,sp,64
 500:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 502:	cad9                	beqz	a3,598 <printint+0xa4>
 504:	01f5d79b          	srliw	a5,a1,0x1f
 508:	cbc1                	beqz	a5,598 <printint+0xa4>
    neg = 1;
    x = -xx;
 50a:	40b005bb          	negw	a1,a1
    neg = 1;
 50e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 510:	fc040993          	addi	s3,s0,-64
  neg = 0;
 514:	86ce                	mv	a3,s3
  i = 0;
 516:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 518:	00000817          	auipc	a6,0x0
 51c:	75880813          	addi	a6,a6,1880 # c70 <digits>
 520:	88ba                	mv	a7,a4
 522:	0017051b          	addiw	a0,a4,1
 526:	872a                	mv	a4,a0
 528:	02c5f7bb          	remuw	a5,a1,a2
 52c:	1782                	slli	a5,a5,0x20
 52e:	9381                	srli	a5,a5,0x20
 530:	97c2                	add	a5,a5,a6
 532:	0007c783          	lbu	a5,0(a5)
 536:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 53a:	87ae                	mv	a5,a1
 53c:	02c5d5bb          	divuw	a1,a1,a2
 540:	0685                	addi	a3,a3,1
 542:	fcc7ffe3          	bgeu	a5,a2,520 <printint+0x2c>
  if(neg)
 546:	00030c63          	beqz	t1,55e <printint+0x6a>
    buf[i++] = '-';
 54a:	fd050793          	addi	a5,a0,-48
 54e:	00878533          	add	a0,a5,s0
 552:	02d00793          	li	a5,45
 556:	fef50823          	sb	a5,-16(a0)
 55a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 55e:	02e05763          	blez	a4,58c <printint+0x98>
 562:	f426                	sd	s1,40(sp)
 564:	377d                	addiw	a4,a4,-1
 566:	00e984b3          	add	s1,s3,a4
 56a:	19fd                	addi	s3,s3,-1
 56c:	99ba                	add	s3,s3,a4
 56e:	1702                	slli	a4,a4,0x20
 570:	9301                	srli	a4,a4,0x20
 572:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 576:	0004c583          	lbu	a1,0(s1)
 57a:	854a                	mv	a0,s2
 57c:	00000097          	auipc	ra,0x0
 580:	f56080e7          	jalr	-170(ra) # 4d2 <putc>
  while(--i >= 0)
 584:	14fd                	addi	s1,s1,-1
 586:	ff3498e3          	bne	s1,s3,576 <printint+0x82>
 58a:	74a2                	ld	s1,40(sp)
}
 58c:	70e2                	ld	ra,56(sp)
 58e:	7442                	ld	s0,48(sp)
 590:	7902                	ld	s2,32(sp)
 592:	69e2                	ld	s3,24(sp)
 594:	6121                	addi	sp,sp,64
 596:	8082                	ret
  neg = 0;
 598:	4301                	li	t1,0
 59a:	bf9d                	j	510 <printint+0x1c>

000000000000059c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59c:	715d                	addi	sp,sp,-80
 59e:	e486                	sd	ra,72(sp)
 5a0:	e0a2                	sd	s0,64(sp)
 5a2:	f84a                	sd	s2,48(sp)
 5a4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a6:	0005c903          	lbu	s2,0(a1)
 5aa:	1a090b63          	beqz	s2,760 <vprintf+0x1c4>
 5ae:	fc26                	sd	s1,56(sp)
 5b0:	f44e                	sd	s3,40(sp)
 5b2:	f052                	sd	s4,32(sp)
 5b4:	ec56                	sd	s5,24(sp)
 5b6:	e85a                	sd	s6,16(sp)
 5b8:	e45e                	sd	s7,8(sp)
 5ba:	8aaa                	mv	s5,a0
 5bc:	8bb2                	mv	s7,a2
 5be:	00158493          	addi	s1,a1,1
  state = 0;
 5c2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c4:	02500a13          	li	s4,37
 5c8:	4b55                	li	s6,21
 5ca:	a839                	j	5e8 <vprintf+0x4c>
        putc(fd, c);
 5cc:	85ca                	mv	a1,s2
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	f02080e7          	jalr	-254(ra) # 4d2 <putc>
 5d8:	a019                	j	5de <vprintf+0x42>
    } else if(state == '%'){
 5da:	01498d63          	beq	s3,s4,5f4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5de:	0485                	addi	s1,s1,1
 5e0:	fff4c903          	lbu	s2,-1(s1)
 5e4:	16090863          	beqz	s2,754 <vprintf+0x1b8>
    if(state == 0){
 5e8:	fe0999e3          	bnez	s3,5da <vprintf+0x3e>
      if(c == '%'){
 5ec:	ff4910e3          	bne	s2,s4,5cc <vprintf+0x30>
        state = '%';
 5f0:	89d2                	mv	s3,s4
 5f2:	b7f5                	j	5de <vprintf+0x42>
      if(c == 'd'){
 5f4:	13490563          	beq	s2,s4,71e <vprintf+0x182>
 5f8:	f9d9079b          	addiw	a5,s2,-99
 5fc:	0ff7f793          	zext.b	a5,a5
 600:	12fb6863          	bltu	s6,a5,730 <vprintf+0x194>
 604:	f9d9079b          	addiw	a5,s2,-99
 608:	0ff7f713          	zext.b	a4,a5
 60c:	12eb6263          	bltu	s6,a4,730 <vprintf+0x194>
 610:	00271793          	slli	a5,a4,0x2
 614:	00000717          	auipc	a4,0x0
 618:	60470713          	addi	a4,a4,1540 # c18 <ithread_join+0xc2>
 61c:	97ba                	add	a5,a5,a4
 61e:	439c                	lw	a5,0(a5)
 620:	97ba                	add	a5,a5,a4
 622:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 624:	008b8913          	addi	s2,s7,8
 628:	4685                	li	a3,1
 62a:	4629                	li	a2,10
 62c:	000ba583          	lw	a1,0(s7)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	ec2080e7          	jalr	-318(ra) # 4f4 <printint>
 63a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b745                	j	5de <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	ea6080e7          	jalr	-346(ra) # 4f4 <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	b751                	j	5de <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e8a080e7          	jalr	-374(ra) # 4f4 <printint>
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b7a5                	j	5de <vprintf+0x42>
 678:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 67a:	008b8793          	addi	a5,s7,8
 67e:	8c3e                	mv	s8,a5
 680:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 684:	03000593          	li	a1,48
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e48080e7          	jalr	-440(ra) # 4d2 <putc>
  putc(fd, 'x');
 692:	07800593          	li	a1,120
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	e3a080e7          	jalr	-454(ra) # 4d2 <putc>
 6a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a2:	00000b97          	auipc	s7,0x0
 6a6:	5ceb8b93          	addi	s7,s7,1486 # c70 <digits>
 6aa:	03c9d793          	srli	a5,s3,0x3c
 6ae:	97de                	add	a5,a5,s7
 6b0:	0007c583          	lbu	a1,0(a5)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e1c080e7          	jalr	-484(ra) # 4d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6be:	0992                	slli	s3,s3,0x4
 6c0:	397d                	addiw	s2,s2,-1
 6c2:	fe0914e3          	bnez	s2,6aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 6c6:	8be2                	mv	s7,s8
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	6c02                	ld	s8,0(sp)
 6cc:	bf09                	j	5de <vprintf+0x42>
        s = va_arg(ap, char*);
 6ce:	008b8993          	addi	s3,s7,8
 6d2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6d6:	02090163          	beqz	s2,6f8 <vprintf+0x15c>
        while(*s != 0){
 6da:	00094583          	lbu	a1,0(s2)
 6de:	c9a5                	beqz	a1,74e <vprintf+0x1b2>
          putc(fd, *s);
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	df0080e7          	jalr	-528(ra) # 4d2 <putc>
          s++;
 6ea:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ec:	00094583          	lbu	a1,0(s2)
 6f0:	f9e5                	bnez	a1,6e0 <vprintf+0x144>
        s = va_arg(ap, char*);
 6f2:	8bce                	mv	s7,s3
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b5e5                	j	5de <vprintf+0x42>
          s = "(null)";
 6f8:	00000917          	auipc	s2,0x0
 6fc:	4e890913          	addi	s2,s2,1256 # be0 <ithread_join+0x8a>
        while(*s != 0){
 700:	02800593          	li	a1,40
 704:	bff1                	j	6e0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 706:	008b8913          	addi	s2,s7,8
 70a:	000bc583          	lbu	a1,0(s7)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	dc2080e7          	jalr	-574(ra) # 4d2 <putc>
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b5c9                	j	5de <vprintf+0x42>
        putc(fd, c);
 71e:	02500593          	li	a1,37
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	dae080e7          	jalr	-594(ra) # 4d2 <putc>
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bd45                	j	5de <vprintf+0x42>
        putc(fd, '%');
 730:	02500593          	li	a1,37
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	d9c080e7          	jalr	-612(ra) # 4d2 <putc>
        putc(fd, c);
 73e:	85ca                	mv	a1,s2
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	d90080e7          	jalr	-624(ra) # 4d2 <putc>
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bd49                	j	5de <vprintf+0x42>
        s = va_arg(ap, char*);
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	b571                	j	5de <vprintf+0x42>
 754:	74e2                	ld	s1,56(sp)
 756:	79a2                	ld	s3,40(sp)
 758:	7a02                	ld	s4,32(sp)
 75a:	6ae2                	ld	s5,24(sp)
 75c:	6b42                	ld	s6,16(sp)
 75e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 760:	60a6                	ld	ra,72(sp)
 762:	6406                	ld	s0,64(sp)
 764:	7942                	ld	s2,48(sp)
 766:	6161                	addi	sp,sp,80
 768:	8082                	ret

000000000000076a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76a:	715d                	addi	sp,sp,-80
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	addi	s0,sp,32
 772:	e010                	sd	a2,0(s0)
 774:	e414                	sd	a3,8(s0)
 776:	e818                	sd	a4,16(s0)
 778:	ec1c                	sd	a5,24(s0)
 77a:	03043023          	sd	a6,32(s0)
 77e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	8622                	mv	a2,s0
 784:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 788:	00000097          	auipc	ra,0x0
 78c:	e14080e7          	jalr	-492(ra) # 59c <vprintf>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6161                	addi	sp,sp,80
 796:	8082                	ret

0000000000000798 <printf>:

void
printf(const char *fmt, ...)
{
 798:	711d                	addi	sp,sp,-96
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e40c                	sd	a1,8(s0)
 7a2:	e810                	sd	a2,16(s0)
 7a4:	ec14                	sd	a3,24(s0)
 7a6:	f018                	sd	a4,32(s0)
 7a8:	f41c                	sd	a5,40(s0)
 7aa:	03043823          	sd	a6,48(s0)
 7ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	00840613          	addi	a2,s0,8
 7b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ba:	85aa                	mv	a1,a0
 7bc:	4505                	li	a0,1
 7be:	00000097          	auipc	ra,0x0
 7c2:	dde080e7          	jalr	-546(ra) # 59c <vprintf>
}
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6125                	addi	sp,sp,96
 7cc:	8082                	ret

00000000000007ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ce:	1141                	addi	sp,sp,-16
 7d0:	e406                	sd	ra,8(sp)
 7d2:	e022                	sd	s0,0(sp)
 7d4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	00001797          	auipc	a5,0x1
 7de:	d367b783          	ld	a5,-714(a5) # 1510 <freep>
 7e2:	a039                	j	7f0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e7e463          	bltu	a5,a4,7ee <free+0x20>
 7ea:	00e6ea63          	bltu	a3,a4,7fe <free+0x30>
{
 7ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	fed7fae3          	bgeu	a5,a3,7e4 <free+0x16>
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e6e463          	bltu	a3,a4,7fe <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	fee7eae3          	bltu	a5,a4,7ee <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fe:	ff852583          	lw	a1,-8(a0)
 802:	6390                	ld	a2,0(a5)
 804:	02059813          	slli	a6,a1,0x20
 808:	01c85713          	srli	a4,a6,0x1c
 80c:	9736                	add	a4,a4,a3
 80e:	02e60563          	beq	a2,a4,838 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 816:	4790                	lw	a2,8(a5)
 818:	02061593          	slli	a1,a2,0x20
 81c:	01c5d713          	srli	a4,a1,0x1c
 820:	973e                	add	a4,a4,a5
 822:	02e68263          	beq	a3,a4,846 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 826:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 828:	00001717          	auipc	a4,0x1
 82c:	cef73423          	sd	a5,-792(a4) # 1510 <freep>
}
 830:	60a2                	ld	ra,8(sp)
 832:	6402                	ld	s0,0(sp)
 834:	0141                	addi	sp,sp,16
 836:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 838:	4618                	lw	a4,8(a2)
 83a:	9f2d                	addw	a4,a4,a1
 83c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	6310                	ld	a2,0(a4)
 844:	b7f9                	j	812 <free+0x44>
    p->s.size += bp->s.size;
 846:	ff852703          	lw	a4,-8(a0)
 84a:	9f31                	addw	a4,a4,a2
 84c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84e:	ff053683          	ld	a3,-16(a0)
 852:	bfd1                	j	826 <free+0x58>

0000000000000854 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 854:	7139                	addi	sp,sp,-64
 856:	fc06                	sd	ra,56(sp)
 858:	f822                	sd	s0,48(sp)
 85a:	f04a                	sd	s2,32(sp)
 85c:	ec4e                	sd	s3,24(sp)
 85e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 860:	02051993          	slli	s3,a0,0x20
 864:	0209d993          	srli	s3,s3,0x20
 868:	09bd                	addi	s3,s3,15
 86a:	0049d993          	srli	s3,s3,0x4
 86e:	2985                	addiw	s3,s3,1
 870:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 872:	00001517          	auipc	a0,0x1
 876:	c9e53503          	ld	a0,-866(a0) # 1510 <freep>
 87a:	c905                	beqz	a0,8aa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	09377a63          	bgeu	a4,s3,914 <malloc+0xc0>
 884:	f426                	sd	s1,40(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88c:	8a4e                	mv	s4,s3
 88e:	6705                	lui	a4,0x1
 890:	00e9f363          	bgeu	s3,a4,896 <malloc+0x42>
 894:	6a05                	lui	s4,0x1
 896:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 89e:	00001497          	auipc	s1,0x1
 8a2:	c7248493          	addi	s1,s1,-910 # 1510 <freep>
  if(p == (char*)-1)
 8a6:	5afd                	li	s5,-1
 8a8:	a089                	j	8ea <malloc+0x96>
 8aa:	f426                	sd	s1,40(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b2:	00001797          	auipc	a5,0x1
 8b6:	c7e78793          	addi	a5,a5,-898 # 1530 <base>
 8ba:	00001717          	auipc	a4,0x1
 8be:	c4f73b23          	sd	a5,-938(a4) # 1510 <freep>
 8c2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c8:	b7d1                	j	88c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ca:	6398                	ld	a4,0(a5)
 8cc:	e118                	sd	a4,0(a0)
 8ce:	a8b9                	j	92c <malloc+0xd8>
  hp->s.size = nu;
 8d0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d4:	0541                	addi	a0,a0,16
 8d6:	00000097          	auipc	ra,0x0
 8da:	ef8080e7          	jalr	-264(ra) # 7ce <free>
  return freep;
 8de:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8e0:	c135                	beqz	a0,944 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	03277363          	bgeu	a4,s2,90c <malloc+0xb8>
    if(p == freep)
 8ea:	6098                	ld	a4,0(s1)
 8ec:	853e                	mv	a0,a5
 8ee:	fef71ae3          	bne	a4,a5,8e2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	00000097          	auipc	ra,0x0
 8f8:	b58080e7          	jalr	-1192(ra) # 44c <sbrk>
  if(p == (char*)-1)
 8fc:	fd551ae3          	bne	a0,s5,8d0 <malloc+0x7c>
        return 0;
 900:	4501                	li	a0,0
 902:	74a2                	ld	s1,40(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	a03d                	j	938 <malloc+0xe4>
 90c:	74a2                	ld	s1,40(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 914:	fae90be3          	beq	s2,a4,8ca <malloc+0x76>
        p->s.size -= nunits;
 918:	4137073b          	subw	a4,a4,s3
 91c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91e:	02071693          	slli	a3,a4,0x20
 922:	01c6d713          	srli	a4,a3,0x1c
 926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92c:	00001717          	auipc	a4,0x1
 930:	bea73223          	sd	a0,-1052(a4) # 1510 <freep>
      return (void*)(p + 1);
 934:	01078513          	addi	a0,a5,16
  }
}
 938:	70e2                	ld	ra,56(sp)
 93a:	7442                	ld	s0,48(sp)
 93c:	7902                	ld	s2,32(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
 944:	74a2                	ld	s1,40(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	b7f5                	j	938 <malloc+0xe4>

000000000000094e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 94e:	1141                	addi	sp,sp,-16
 950:	e406                	sd	ra,8(sp)
 952:	e022                	sd	s0,0(sp)
 954:	0800                	addi	s0,sp,16
  thread_exit(status);
 956:	2501                	sext.w	a0,a0
 958:	00000097          	auipc	ra,0x0
 95c:	b24080e7          	jalr	-1244(ra) # 47c <thread_exit>
}
 960:	60a2                	ld	ra,8(sp)
 962:	6402                	ld	s0,0(sp)
 964:	0141                	addi	sp,sp,16
 966:	8082                	ret

0000000000000968 <free_stacks>:
int free_stacks() {
 968:	7179                	addi	sp,sp,-48
 96a:	f406                	sd	ra,40(sp)
 96c:	f022                	sd	s0,32(sp)
 96e:	ec26                	sd	s1,24(sp)
 970:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 972:	00001797          	auipc	a5,0x1
 976:	bae7a783          	lw	a5,-1106(a5) # 1520 <num_threads>
 97a:	04f05063          	blez	a5,9ba <free_stacks+0x52>
 97e:	e84a                	sd	s2,16(sp)
 980:	e44e                	sd	s3,8(sp)
 982:	4481                	li	s1,0
    free(stacks[i]);
 984:	00001997          	auipc	s3,0x1
 988:	b9498993          	addi	s3,s3,-1132 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 98c:	00001917          	auipc	s2,0x1
 990:	b9490913          	addi	s2,s2,-1132 # 1520 <num_threads>
    free(stacks[i]);
 994:	0009b783          	ld	a5,0(s3)
 998:	00349713          	slli	a4,s1,0x3
 99c:	97ba                	add	a5,a5,a4
 99e:	6388                	ld	a0,0(a5)
 9a0:	00000097          	auipc	ra,0x0
 9a4:	e2e080e7          	jalr	-466(ra) # 7ce <free>
  for (int i = 0; i < num_threads; i++) {
 9a8:	0485                	addi	s1,s1,1
 9aa:	00092703          	lw	a4,0(s2)
 9ae:	0004879b          	sext.w	a5,s1
 9b2:	fee7c1e3          	blt	a5,a4,994 <free_stacks+0x2c>
 9b6:	6942                	ld	s2,16(sp)
 9b8:	69a2                	ld	s3,8(sp)
  free(stacks);
 9ba:	00001497          	auipc	s1,0x1
 9be:	b5e48493          	addi	s1,s1,-1186 # 1518 <stacks>
 9c2:	6088                	ld	a0,0(s1)
 9c4:	00000097          	auipc	ra,0x0
 9c8:	e0a080e7          	jalr	-502(ra) # 7ce <free>
  stacks = 0;
 9cc:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9d0:	00001797          	auipc	a5,0x1
 9d4:	b407a823          	sw	zero,-1200(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9d8:	47a1                	li	a5,8
 9da:	00001717          	auipc	a4,0x1
 9de:	b2f72323          	sw	a5,-1242(a4) # 1500 <max_stacks>
  threads_done = 0;
 9e2:	00001797          	auipc	a5,0x1
 9e6:	b407a123          	sw	zero,-1214(a5) # 1524 <threads_done>
}
 9ea:	4501                	li	a0,0
 9ec:	70a2                	ld	ra,40(sp)
 9ee:	7402                	ld	s0,32(sp)
 9f0:	64e2                	ld	s1,24(sp)
 9f2:	6145                	addi	sp,sp,48
 9f4:	8082                	ret

00000000000009f6 <expand_num_threads>:
int expand_num_threads() {
 9f6:	1101                	addi	sp,sp,-32
 9f8:	ec06                	sd	ra,24(sp)
 9fa:	e822                	sd	s0,16(sp)
 9fc:	e426                	sd	s1,8(sp)
 9fe:	e04a                	sd	s2,0(sp)
 a00:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a02:	00001797          	auipc	a5,0x1
 a06:	afe78793          	addi	a5,a5,-1282 # 1500 <max_stacks>
 a0a:	4388                	lw	a0,0(a5)
 a0c:	0015151b          	slliw	a0,a0,0x1
 a10:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a12:	0035151b          	slliw	a0,a0,0x3
 a16:	00000097          	auipc	ra,0x0
 a1a:	e3e080e7          	jalr	-450(ra) # 854 <malloc>
 a1e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a20:	00001617          	auipc	a2,0x1
 a24:	b0062603          	lw	a2,-1280(a2) # 1520 <num_threads>
 a28:	00001497          	auipc	s1,0x1
 a2c:	af048493          	addi	s1,s1,-1296 # 1518 <stacks>
 a30:	0036161b          	slliw	a2,a2,0x3
 a34:	608c                	ld	a1,0(s1)
 a36:	00000097          	auipc	ra,0x0
 a3a:	8d8080e7          	jalr	-1832(ra) # 30e <memmove>
  free(stacks);
 a3e:	6088                	ld	a0,0(s1)
 a40:	00000097          	auipc	ra,0x0
 a44:	d8e080e7          	jalr	-626(ra) # 7ce <free>
  stacks = new_stacks;
 a48:	0124b023          	sd	s2,0(s1)
}
 a4c:	4501                	li	a0,0
 a4e:	60e2                	ld	ra,24(sp)
 a50:	6442                	ld	s0,16(sp)
 a52:	64a2                	ld	s1,8(sp)
 a54:	6902                	ld	s2,0(sp)
 a56:	6105                	addi	sp,sp,32
 a58:	8082                	ret

0000000000000a5a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a5a:	7179                	addi	sp,sp,-48
 a5c:	f406                	sd	ra,40(sp)
 a5e:	f022                	sd	s0,32(sp)
 a60:	e84a                	sd	s2,16(sp)
 a62:	e44e                	sd	s3,8(sp)
 a64:	1800                	addi	s0,sp,48
 a66:	892a                	mv	s2,a0
 a68:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a6a:	00001797          	auipc	a5,0x1
 a6e:	aae7b783          	ld	a5,-1362(a5) # 1518 <stacks>
 a72:	c3d9                	beqz	a5,af8 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a74:	00001797          	auipc	a5,0x1
 a78:	a8c7a783          	lw	a5,-1396(a5) # 1500 <max_stacks>
 a7c:	00001717          	auipc	a4,0x1
 a80:	aa472703          	lw	a4,-1372(a4) # 1520 <num_threads>
 a84:	0af71463          	bne	a4,a5,b2c <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a88:	04000713          	li	a4,64
 a8c:	08e78563          	beq	a5,a4,b16 <ithread_create+0xbc>
 a90:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a92:	00000097          	auipc	ra,0x0
 a96:	f64080e7          	jalr	-156(ra) # 9f6 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a9a:	6505                	lui	a0,0x1
 a9c:	00000097          	auipc	ra,0x0
 aa0:	db8080e7          	jalr	-584(ra) # 854 <malloc>
 aa4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 aa6:	00001717          	auipc	a4,0x1
 aaa:	a7a72703          	lw	a4,-1414(a4) # 1520 <num_threads>
 aae:	070e                	slli	a4,a4,0x3
 ab0:	00001797          	auipc	a5,0x1
 ab4:	a687b783          	ld	a5,-1432(a5) # 1518 <stacks>
 ab8:	97ba                	add	a5,a5,a4
 aba:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 abc:	00000697          	auipc	a3,0x0
 ac0:	e9268693          	addi	a3,a3,-366 # 94e <ithread_exit>
 ac4:	862a                	mv	a2,a0
 ac6:	85ce                	mv	a1,s3
 ac8:	854a                	mv	a0,s2
 aca:	00000097          	auipc	ra,0x0
 ace:	9a2080e7          	jalr	-1630(ra) # 46c <create_thread>
 ad2:	892a                	mv	s2,a0
  if (res != -1) {
 ad4:	57fd                	li	a5,-1
 ad6:	04f50d63          	beq	a0,a5,b30 <ithread_create+0xd6>
    num_threads++;
 ada:	00001717          	auipc	a4,0x1
 ade:	a4670713          	addi	a4,a4,-1466 # 1520 <num_threads>
 ae2:	431c                	lw	a5,0(a4)
 ae4:	2785                	addiw	a5,a5,1
 ae6:	c31c                	sw	a5,0(a4)
 ae8:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 aea:	854a                	mv	a0,s2
 aec:	70a2                	ld	ra,40(sp)
 aee:	7402                	ld	s0,32(sp)
 af0:	6942                	ld	s2,16(sp)
 af2:	69a2                	ld	s3,8(sp)
 af4:	6145                	addi	sp,sp,48
 af6:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 af8:	00001517          	auipc	a0,0x1
 afc:	a0852503          	lw	a0,-1528(a0) # 1500 <max_stacks>
 b00:	0035151b          	slliw	a0,a0,0x3
 b04:	00000097          	auipc	ra,0x0
 b08:	d50080e7          	jalr	-688(ra) # 854 <malloc>
 b0c:	00001797          	auipc	a5,0x1
 b10:	a0a7b623          	sd	a0,-1524(a5) # 1518 <stacks>
 b14:	b785                	j	a74 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b16:	00000517          	auipc	a0,0x0
 b1a:	0d250513          	addi	a0,a0,210 # be8 <ithread_join+0x92>
 b1e:	00000097          	auipc	ra,0x0
 b22:	c7a080e7          	jalr	-902(ra) # 798 <printf>
      return -1;
 b26:	57fd                	li	a5,-1
 b28:	893e                	mv	s2,a5
 b2a:	b7c1                	j	aea <ithread_create+0x90>
 b2c:	ec26                	sd	s1,24(sp)
 b2e:	b7b5                	j	a9a <ithread_create+0x40>
    free(stack_ptr);
 b30:	8526                	mv	a0,s1
 b32:	00000097          	auipc	ra,0x0
 b36:	c9c080e7          	jalr	-868(ra) # 7ce <free>
    stacks[num_threads] = 0;
 b3a:	00001717          	auipc	a4,0x1
 b3e:	9e672703          	lw	a4,-1562(a4) # 1520 <num_threads>
 b42:	070e                	slli	a4,a4,0x3
 b44:	00001797          	auipc	a5,0x1
 b48:	9d47b783          	ld	a5,-1580(a5) # 1518 <stacks>
 b4c:	97ba                	add	a5,a5,a4
 b4e:	0007b023          	sd	zero,0(a5)
 b52:	64e2                	ld	s1,24(sp)
 b54:	bf59                	j	aea <ithread_create+0x90>

0000000000000b56 <ithread_join>:

int ithread_join(int thread_id) {
 b56:	1101                	addi	sp,sp,-32
 b58:	ec06                	sd	ra,24(sp)
 b5a:	e822                	sd	s0,16(sp)
 b5c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b5e:	ff040793          	addi	a5,s0,-16
 b62:	ffc7859b          	addiw	a1,a5,-4
 b66:	00000097          	auipc	ra,0x0
 b6a:	90e080e7          	jalr	-1778(ra) # 474 <join_thread>
  threads_done++;
 b6e:	00001717          	auipc	a4,0x1
 b72:	9b670713          	addi	a4,a4,-1610 # 1524 <threads_done>
 b76:	431c                	lw	a5,0(a4)
 b78:	2785                	addiw	a5,a5,1
 b7a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b7c:	00001717          	auipc	a4,0x1
 b80:	9a472703          	lw	a4,-1628(a4) # 1520 <num_threads>
 b84:	00f70863          	beq	a4,a5,b94 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b88:	fec42503          	lw	a0,-20(s0)
 b8c:	60e2                	ld	ra,24(sp)
 b8e:	6442                	ld	s0,16(sp)
 b90:	6105                	addi	sp,sp,32
 b92:	8082                	ret
    free_stacks();
 b94:	00000097          	auipc	ra,0x0
 b98:	dd4080e7          	jalr	-556(ra) # 968 <free_stacks>
 b9c:	b7f5                	j	b88 <ithread_join+0x32>
