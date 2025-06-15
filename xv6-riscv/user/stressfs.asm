
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
  22:	b6278793          	addi	a5,a5,-1182 # b80 <ithread_join+0x7a>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	b1c50513          	addi	a0,a0,-1252 # b50 <ithread_join+0x4a>
  3c:	00000097          	auipc	ra,0x0
  40:	70e080e7          	jalr	1806(ra) # 74a <printf>
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
  74:	af850513          	addi	a0,a0,-1288 # b68 <ithread_join+0x62>
  78:	00000097          	auipc	ra,0x0
  7c:	6d2080e7          	jalr	1746(ra) # 74a <printf>

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
  c6:	ab650513          	addi	a0,a0,-1354 # b78 <ithread_join+0x72>
  ca:	00000097          	auipc	ra,0x0
  ce:	680080e7          	jalr	1664(ra) # 74a <printf>

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

0000000000000484 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 484:	1101                	addi	sp,sp,-32
 486:	ec06                	sd	ra,24(sp)
 488:	e822                	sd	s0,16(sp)
 48a:	1000                	addi	s0,sp,32
 48c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 490:	4605                	li	a2,1
 492:	fef40593          	addi	a1,s0,-17
 496:	00000097          	auipc	ra,0x0
 49a:	f4e080e7          	jalr	-178(ra) # 3e4 <write>
}
 49e:	60e2                	ld	ra,24(sp)
 4a0:	6442                	ld	s0,16(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret

00000000000004a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a6:	7139                	addi	sp,sp,-64
 4a8:	fc06                	sd	ra,56(sp)
 4aa:	f822                	sd	s0,48(sp)
 4ac:	f04a                	sd	s2,32(sp)
 4ae:	ec4e                	sd	s3,24(sp)
 4b0:	0080                	addi	s0,sp,64
 4b2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b4:	cad9                	beqz	a3,54a <printint+0xa4>
 4b6:	01f5d79b          	srliw	a5,a1,0x1f
 4ba:	cbc1                	beqz	a5,54a <printint+0xa4>
    neg = 1;
    x = -xx;
 4bc:	40b005bb          	negw	a1,a1
    neg = 1;
 4c0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4c2:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4c6:	86ce                	mv	a3,s3
  i = 0;
 4c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ca:	00000817          	auipc	a6,0x0
 4ce:	75680813          	addi	a6,a6,1878 # c20 <digits>
 4d2:	88ba                	mv	a7,a4
 4d4:	0017051b          	addiw	a0,a4,1
 4d8:	872a                	mv	a4,a0
 4da:	02c5f7bb          	remuw	a5,a1,a2
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	97c2                	add	a5,a5,a6
 4e4:	0007c783          	lbu	a5,0(a5)
 4e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ec:	87ae                	mv	a5,a1
 4ee:	02c5d5bb          	divuw	a1,a1,a2
 4f2:	0685                	addi	a3,a3,1
 4f4:	fcc7ffe3          	bgeu	a5,a2,4d2 <printint+0x2c>
  if(neg)
 4f8:	00030c63          	beqz	t1,510 <printint+0x6a>
    buf[i++] = '-';
 4fc:	fd050793          	addi	a5,a0,-48
 500:	00878533          	add	a0,a5,s0
 504:	02d00793          	li	a5,45
 508:	fef50823          	sb	a5,-16(a0)
 50c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 510:	02e05763          	blez	a4,53e <printint+0x98>
 514:	f426                	sd	s1,40(sp)
 516:	377d                	addiw	a4,a4,-1
 518:	00e984b3          	add	s1,s3,a4
 51c:	19fd                	addi	s3,s3,-1
 51e:	99ba                	add	s3,s3,a4
 520:	1702                	slli	a4,a4,0x20
 522:	9301                	srli	a4,a4,0x20
 524:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 528:	0004c583          	lbu	a1,0(s1)
 52c:	854a                	mv	a0,s2
 52e:	00000097          	auipc	ra,0x0
 532:	f56080e7          	jalr	-170(ra) # 484 <putc>
  while(--i >= 0)
 536:	14fd                	addi	s1,s1,-1
 538:	ff3498e3          	bne	s1,s3,528 <printint+0x82>
 53c:	74a2                	ld	s1,40(sp)
}
 53e:	70e2                	ld	ra,56(sp)
 540:	7442                	ld	s0,48(sp)
 542:	7902                	ld	s2,32(sp)
 544:	69e2                	ld	s3,24(sp)
 546:	6121                	addi	sp,sp,64
 548:	8082                	ret
  neg = 0;
 54a:	4301                	li	t1,0
 54c:	bf9d                	j	4c2 <printint+0x1c>

000000000000054e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54e:	715d                	addi	sp,sp,-80
 550:	e486                	sd	ra,72(sp)
 552:	e0a2                	sd	s0,64(sp)
 554:	f84a                	sd	s2,48(sp)
 556:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 558:	0005c903          	lbu	s2,0(a1)
 55c:	1a090b63          	beqz	s2,712 <vprintf+0x1c4>
 560:	fc26                	sd	s1,56(sp)
 562:	f44e                	sd	s3,40(sp)
 564:	f052                	sd	s4,32(sp)
 566:	ec56                	sd	s5,24(sp)
 568:	e85a                	sd	s6,16(sp)
 56a:	e45e                	sd	s7,8(sp)
 56c:	8aaa                	mv	s5,a0
 56e:	8bb2                	mv	s7,a2
 570:	00158493          	addi	s1,a1,1
  state = 0;
 574:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 576:	02500a13          	li	s4,37
 57a:	4b55                	li	s6,21
 57c:	a839                	j	59a <vprintf+0x4c>
        putc(fd, c);
 57e:	85ca                	mv	a1,s2
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	f02080e7          	jalr	-254(ra) # 484 <putc>
 58a:	a019                	j	590 <vprintf+0x42>
    } else if(state == '%'){
 58c:	01498d63          	beq	s3,s4,5a6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 590:	0485                	addi	s1,s1,1
 592:	fff4c903          	lbu	s2,-1(s1)
 596:	16090863          	beqz	s2,706 <vprintf+0x1b8>
    if(state == 0){
 59a:	fe0999e3          	bnez	s3,58c <vprintf+0x3e>
      if(c == '%'){
 59e:	ff4910e3          	bne	s2,s4,57e <vprintf+0x30>
        state = '%';
 5a2:	89d2                	mv	s3,s4
 5a4:	b7f5                	j	590 <vprintf+0x42>
      if(c == 'd'){
 5a6:	13490563          	beq	s2,s4,6d0 <vprintf+0x182>
 5aa:	f9d9079b          	addiw	a5,s2,-99
 5ae:	0ff7f793          	zext.b	a5,a5
 5b2:	12fb6863          	bltu	s6,a5,6e2 <vprintf+0x194>
 5b6:	f9d9079b          	addiw	a5,s2,-99
 5ba:	0ff7f713          	zext.b	a4,a5
 5be:	12eb6263          	bltu	s6,a4,6e2 <vprintf+0x194>
 5c2:	00271793          	slli	a5,a4,0x2
 5c6:	00000717          	auipc	a4,0x0
 5ca:	60270713          	addi	a4,a4,1538 # bc8 <ithread_join+0xc2>
 5ce:	97ba                	add	a5,a5,a4
 5d0:	439c                	lw	a5,0(a5)
 5d2:	97ba                	add	a5,a5,a4
 5d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	ec2080e7          	jalr	-318(ra) # 4a6 <printint>
 5ec:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b745                	j	590 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4629                	li	a2,10
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	ea6080e7          	jalr	-346(ra) # 4a6 <printint>
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b751                	j	590 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 60e:	008b8913          	addi	s2,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000ba583          	lw	a1,0(s7)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e8a080e7          	jalr	-374(ra) # 4a6 <printint>
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
 628:	b7a5                	j	590 <vprintf+0x42>
 62a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 62c:	008b8793          	addi	a5,s7,8
 630:	8c3e                	mv	s8,a5
 632:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 636:	03000593          	li	a1,48
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e48080e7          	jalr	-440(ra) # 484 <putc>
  putc(fd, 'x');
 644:	07800593          	li	a1,120
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e3a080e7          	jalr	-454(ra) # 484 <putc>
 652:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 654:	00000b97          	auipc	s7,0x0
 658:	5ccb8b93          	addi	s7,s7,1484 # c20 <digits>
 65c:	03c9d793          	srli	a5,s3,0x3c
 660:	97de                	add	a5,a5,s7
 662:	0007c583          	lbu	a1,0(a5)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e1c080e7          	jalr	-484(ra) # 484 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	397d                	addiw	s2,s2,-1
 674:	fe0914e3          	bnez	s2,65c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 678:	8be2                	mv	s7,s8
      state = 0;
 67a:	4981                	li	s3,0
 67c:	6c02                	ld	s8,0(sp)
 67e:	bf09                	j	590 <vprintf+0x42>
        s = va_arg(ap, char*);
 680:	008b8993          	addi	s3,s7,8
 684:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 688:	02090163          	beqz	s2,6aa <vprintf+0x15c>
        while(*s != 0){
 68c:	00094583          	lbu	a1,0(s2)
 690:	c9a5                	beqz	a1,700 <vprintf+0x1b2>
          putc(fd, *s);
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	df0080e7          	jalr	-528(ra) # 484 <putc>
          s++;
 69c:	0905                	addi	s2,s2,1
        while(*s != 0){
 69e:	00094583          	lbu	a1,0(s2)
 6a2:	f9e5                	bnez	a1,692 <vprintf+0x144>
        s = va_arg(ap, char*);
 6a4:	8bce                	mv	s7,s3
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b5e5                	j	590 <vprintf+0x42>
          s = "(null)";
 6aa:	00000917          	auipc	s2,0x0
 6ae:	4e690913          	addi	s2,s2,1254 # b90 <ithread_join+0x8a>
        while(*s != 0){
 6b2:	02800593          	li	a1,40
 6b6:	bff1                	j	692 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	000bc583          	lbu	a1,0(s7)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	dc2080e7          	jalr	-574(ra) # 484 <putc>
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b5c9                	j	590 <vprintf+0x42>
        putc(fd, c);
 6d0:	02500593          	li	a1,37
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	dae080e7          	jalr	-594(ra) # 484 <putc>
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bd45                	j	590 <vprintf+0x42>
        putc(fd, '%');
 6e2:	02500593          	li	a1,37
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	d9c080e7          	jalr	-612(ra) # 484 <putc>
        putc(fd, c);
 6f0:	85ca                	mv	a1,s2
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	d90080e7          	jalr	-624(ra) # 484 <putc>
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd49                	j	590 <vprintf+0x42>
        s = va_arg(ap, char*);
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	b571                	j	590 <vprintf+0x42>
 706:	74e2                	ld	s1,56(sp)
 708:	79a2                	ld	s3,40(sp)
 70a:	7a02                	ld	s4,32(sp)
 70c:	6ae2                	ld	s5,24(sp)
 70e:	6b42                	ld	s6,16(sp)
 710:	6ba2                	ld	s7,8(sp)
    }
  }
}
 712:	60a6                	ld	ra,72(sp)
 714:	6406                	ld	s0,64(sp)
 716:	7942                	ld	s2,48(sp)
 718:	6161                	addi	sp,sp,80
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	8622                	mv	a2,s0
 736:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73a:	00000097          	auipc	ra,0x0
 73e:	e14080e7          	jalr	-492(ra) # 54e <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e40c                	sd	a1,8(s0)
 754:	e810                	sd	a2,16(s0)
 756:	ec14                	sd	a3,24(s0)
 758:	f018                	sd	a4,32(s0)
 75a:	f41c                	sd	a5,40(s0)
 75c:	03043823          	sd	a6,48(s0)
 760:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	00840613          	addi	a2,s0,8
 768:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76c:	85aa                	mv	a1,a0
 76e:	4505                	li	a0,1
 770:	00000097          	auipc	ra,0x0
 774:	dde080e7          	jalr	-546(ra) # 54e <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6125                	addi	sp,sp,96
 77e:	8082                	ret

0000000000000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	1141                	addi	sp,sp,-16
 782:	e406                	sd	ra,8(sp)
 784:	e022                	sd	s0,0(sp)
 786:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 788:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	00001797          	auipc	a5,0x1
 790:	d847b783          	ld	a5,-636(a5) # 1510 <freep>
 794:	a039                	j	7a2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 796:	6398                	ld	a4,0(a5)
 798:	00e7e463          	bltu	a5,a4,7a0 <free+0x20>
 79c:	00e6ea63          	bltu	a3,a4,7b0 <free+0x30>
{
 7a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a2:	fed7fae3          	bgeu	a5,a3,796 <free+0x16>
 7a6:	6398                	ld	a4,0(a5)
 7a8:	00e6e463          	bltu	a3,a4,7b0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	fee7eae3          	bltu	a5,a4,7a0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b0:	ff852583          	lw	a1,-8(a0)
 7b4:	6390                	ld	a2,0(a5)
 7b6:	02059813          	slli	a6,a1,0x20
 7ba:	01c85713          	srli	a4,a6,0x1c
 7be:	9736                	add	a4,a4,a3
 7c0:	02e60563          	beq	a2,a4,7ea <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7c8:	4790                	lw	a2,8(a5)
 7ca:	02061593          	slli	a1,a2,0x20
 7ce:	01c5d713          	srli	a4,a1,0x1c
 7d2:	973e                	add	a4,a4,a5
 7d4:	02e68263          	beq	a3,a4,7f8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7da:	00001717          	auipc	a4,0x1
 7de:	d2f73b23          	sd	a5,-714(a4) # 1510 <freep>
}
 7e2:	60a2                	ld	ra,8(sp)
 7e4:	6402                	ld	s0,0(sp)
 7e6:	0141                	addi	sp,sp,16
 7e8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ea:	4618                	lw	a4,8(a2)
 7ec:	9f2d                	addw	a4,a4,a1
 7ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	6398                	ld	a4,0(a5)
 7f4:	6310                	ld	a2,0(a4)
 7f6:	b7f9                	j	7c4 <free+0x44>
    p->s.size += bp->s.size;
 7f8:	ff852703          	lw	a4,-8(a0)
 7fc:	9f31                	addw	a4,a4,a2
 7fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 800:	ff053683          	ld	a3,-16(a0)
 804:	bfd1                	j	7d8 <free+0x58>

0000000000000806 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 806:	7139                	addi	sp,sp,-64
 808:	fc06                	sd	ra,56(sp)
 80a:	f822                	sd	s0,48(sp)
 80c:	f04a                	sd	s2,32(sp)
 80e:	ec4e                	sd	s3,24(sp)
 810:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	02051993          	slli	s3,a0,0x20
 816:	0209d993          	srli	s3,s3,0x20
 81a:	09bd                	addi	s3,s3,15
 81c:	0049d993          	srli	s3,s3,0x4
 820:	2985                	addiw	s3,s3,1
 822:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 824:	00001517          	auipc	a0,0x1
 828:	cec53503          	ld	a0,-788(a0) # 1510 <freep>
 82c:	c905                	beqz	a0,85c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 830:	4798                	lw	a4,8(a5)
 832:	09377a63          	bgeu	a4,s3,8c6 <malloc+0xc0>
 836:	f426                	sd	s1,40(sp)
 838:	e852                	sd	s4,16(sp)
 83a:	e456                	sd	s5,8(sp)
 83c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 83e:	8a4e                	mv	s4,s3
 840:	6705                	lui	a4,0x1
 842:	00e9f363          	bgeu	s3,a4,848 <malloc+0x42>
 846:	6a05                	lui	s4,0x1
 848:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 850:	00001497          	auipc	s1,0x1
 854:	cc048493          	addi	s1,s1,-832 # 1510 <freep>
  if(p == (char*)-1)
 858:	5afd                	li	s5,-1
 85a:	a089                	j	89c <malloc+0x96>
 85c:	f426                	sd	s1,40(sp)
 85e:	e852                	sd	s4,16(sp)
 860:	e456                	sd	s5,8(sp)
 862:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 864:	00001797          	auipc	a5,0x1
 868:	ccc78793          	addi	a5,a5,-820 # 1530 <base>
 86c:	00001717          	auipc	a4,0x1
 870:	caf73223          	sd	a5,-860(a4) # 1510 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87a:	b7d1                	j	83e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	a8b9                	j	8de <malloc+0xd8>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	00000097          	auipc	ra,0x0
 88c:	ef8080e7          	jalr	-264(ra) # 780 <free>
  return freep;
 890:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 892:	c135                	beqz	a0,8f6 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 894:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 896:	4798                	lw	a4,8(a5)
 898:	03277363          	bgeu	a4,s2,8be <malloc+0xb8>
    if(p == freep)
 89c:	6098                	ld	a4,0(s1)
 89e:	853e                	mv	a0,a5
 8a0:	fef71ae3          	bne	a4,a5,894 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8a4:	8552                	mv	a0,s4
 8a6:	00000097          	auipc	ra,0x0
 8aa:	ba6080e7          	jalr	-1114(ra) # 44c <sbrk>
  if(p == (char*)-1)
 8ae:	fd551ae3          	bne	a0,s5,882 <malloc+0x7c>
        return 0;
 8b2:	4501                	li	a0,0
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
 8bc:	a03d                	j	8ea <malloc+0xe4>
 8be:	74a2                	ld	s1,40(sp)
 8c0:	6a42                	ld	s4,16(sp)
 8c2:	6aa2                	ld	s5,8(sp)
 8c4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c6:	fae90be3          	beq	s2,a4,87c <malloc+0x76>
        p->s.size -= nunits;
 8ca:	4137073b          	subw	a4,a4,s3
 8ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d0:	02071693          	slli	a3,a4,0x20
 8d4:	01c6d713          	srli	a4,a3,0x1c
 8d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8de:	00001717          	auipc	a4,0x1
 8e2:	c2a73923          	sd	a0,-974(a4) # 1510 <freep>
      return (void*)(p + 1);
 8e6:	01078513          	addi	a0,a5,16
  }
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	7902                	ld	s2,32(sp)
 8f0:	69e2                	ld	s3,24(sp)
 8f2:	6121                	addi	sp,sp,64
 8f4:	8082                	ret
 8f6:	74a2                	ld	s1,40(sp)
 8f8:	6a42                	ld	s4,16(sp)
 8fa:	6aa2                	ld	s5,8(sp)
 8fc:	6b02                	ld	s6,0(sp)
 8fe:	b7f5                	j	8ea <malloc+0xe4>

0000000000000900 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 900:	1141                	addi	sp,sp,-16
 902:	e406                	sd	ra,8(sp)
 904:	e022                	sd	s0,0(sp)
 906:	0800                	addi	s0,sp,16
  thread_exit(status);
 908:	00000097          	auipc	ra,0x0
 90c:	b74080e7          	jalr	-1164(ra) # 47c <thread_exit>
}
 910:	60a2                	ld	ra,8(sp)
 912:	6402                	ld	s0,0(sp)
 914:	0141                	addi	sp,sp,16
 916:	8082                	ret

0000000000000918 <free_stacks>:
int free_stacks() {
 918:	7179                	addi	sp,sp,-48
 91a:	f406                	sd	ra,40(sp)
 91c:	f022                	sd	s0,32(sp)
 91e:	ec26                	sd	s1,24(sp)
 920:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 922:	00001797          	auipc	a5,0x1
 926:	bfe7a783          	lw	a5,-1026(a5) # 1520 <num_threads>
 92a:	04f05063          	blez	a5,96a <free_stacks+0x52>
 92e:	e84a                	sd	s2,16(sp)
 930:	e44e                	sd	s3,8(sp)
 932:	4481                	li	s1,0
    free(stacks[i]);
 934:	00001997          	auipc	s3,0x1
 938:	be498993          	addi	s3,s3,-1052 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 93c:	00001917          	auipc	s2,0x1
 940:	be490913          	addi	s2,s2,-1052 # 1520 <num_threads>
    free(stacks[i]);
 944:	0009b783          	ld	a5,0(s3)
 948:	00349713          	slli	a4,s1,0x3
 94c:	97ba                	add	a5,a5,a4
 94e:	6388                	ld	a0,0(a5)
 950:	00000097          	auipc	ra,0x0
 954:	e30080e7          	jalr	-464(ra) # 780 <free>
  for (int i = 0; i < num_threads; i++) {
 958:	0485                	addi	s1,s1,1
 95a:	00092703          	lw	a4,0(s2)
 95e:	0004879b          	sext.w	a5,s1
 962:	fee7c1e3          	blt	a5,a4,944 <free_stacks+0x2c>
 966:	6942                	ld	s2,16(sp)
 968:	69a2                	ld	s3,8(sp)
  free(stacks);
 96a:	00001497          	auipc	s1,0x1
 96e:	bae48493          	addi	s1,s1,-1106 # 1518 <stacks>
 972:	6088                	ld	a0,0(s1)
 974:	00000097          	auipc	ra,0x0
 978:	e0c080e7          	jalr	-500(ra) # 780 <free>
  stacks = 0;
 97c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 980:	00001797          	auipc	a5,0x1
 984:	ba07a023          	sw	zero,-1120(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 988:	47a1                	li	a5,8
 98a:	00001717          	auipc	a4,0x1
 98e:	b6f72b23          	sw	a5,-1162(a4) # 1500 <max_stacks>
  threads_done = 0;
 992:	00001797          	auipc	a5,0x1
 996:	b807a923          	sw	zero,-1134(a5) # 1524 <threads_done>
}
 99a:	4501                	li	a0,0
 99c:	70a2                	ld	ra,40(sp)
 99e:	7402                	ld	s0,32(sp)
 9a0:	64e2                	ld	s1,24(sp)
 9a2:	6145                	addi	sp,sp,48
 9a4:	8082                	ret

00000000000009a6 <expand_num_threads>:
int expand_num_threads() {
 9a6:	1101                	addi	sp,sp,-32
 9a8:	ec06                	sd	ra,24(sp)
 9aa:	e822                	sd	s0,16(sp)
 9ac:	e426                	sd	s1,8(sp)
 9ae:	e04a                	sd	s2,0(sp)
 9b0:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9b2:	00001797          	auipc	a5,0x1
 9b6:	b4e78793          	addi	a5,a5,-1202 # 1500 <max_stacks>
 9ba:	4388                	lw	a0,0(a5)
 9bc:	0015151b          	slliw	a0,a0,0x1
 9c0:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9c2:	0035151b          	slliw	a0,a0,0x3
 9c6:	00000097          	auipc	ra,0x0
 9ca:	e40080e7          	jalr	-448(ra) # 806 <malloc>
 9ce:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9d0:	00001617          	auipc	a2,0x1
 9d4:	b5062603          	lw	a2,-1200(a2) # 1520 <num_threads>
 9d8:	00001497          	auipc	s1,0x1
 9dc:	b4048493          	addi	s1,s1,-1216 # 1518 <stacks>
 9e0:	0036161b          	slliw	a2,a2,0x3
 9e4:	608c                	ld	a1,0(s1)
 9e6:	00000097          	auipc	ra,0x0
 9ea:	928080e7          	jalr	-1752(ra) # 30e <memmove>
  free(stacks);
 9ee:	6088                	ld	a0,0(s1)
 9f0:	00000097          	auipc	ra,0x0
 9f4:	d90080e7          	jalr	-624(ra) # 780 <free>
  stacks = new_stacks;
 9f8:	0124b023          	sd	s2,0(s1)
}
 9fc:	4501                	li	a0,0
 9fe:	60e2                	ld	ra,24(sp)
 a00:	6442                	ld	s0,16(sp)
 a02:	64a2                	ld	s1,8(sp)
 a04:	6902                	ld	s2,0(sp)
 a06:	6105                	addi	sp,sp,32
 a08:	8082                	ret

0000000000000a0a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a0a:	7179                	addi	sp,sp,-48
 a0c:	f406                	sd	ra,40(sp)
 a0e:	f022                	sd	s0,32(sp)
 a10:	e84a                	sd	s2,16(sp)
 a12:	e44e                	sd	s3,8(sp)
 a14:	1800                	addi	s0,sp,48
 a16:	892a                	mv	s2,a0
 a18:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a1a:	00001797          	auipc	a5,0x1
 a1e:	afe7b783          	ld	a5,-1282(a5) # 1518 <stacks>
 a22:	c3d9                	beqz	a5,aa8 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a24:	00001797          	auipc	a5,0x1
 a28:	adc7a783          	lw	a5,-1316(a5) # 1500 <max_stacks>
 a2c:	00001717          	auipc	a4,0x1
 a30:	af472703          	lw	a4,-1292(a4) # 1520 <num_threads>
 a34:	0af71463          	bne	a4,a5,adc <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a38:	04000713          	li	a4,64
 a3c:	08e78563          	beq	a5,a4,ac6 <ithread_create+0xbc>
 a40:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a42:	00000097          	auipc	ra,0x0
 a46:	f64080e7          	jalr	-156(ra) # 9a6 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a4a:	6505                	lui	a0,0x1
 a4c:	00000097          	auipc	ra,0x0
 a50:	dba080e7          	jalr	-582(ra) # 806 <malloc>
 a54:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a56:	00001717          	auipc	a4,0x1
 a5a:	aca72703          	lw	a4,-1334(a4) # 1520 <num_threads>
 a5e:	070e                	slli	a4,a4,0x3
 a60:	00001797          	auipc	a5,0x1
 a64:	ab87b783          	ld	a5,-1352(a5) # 1518 <stacks>
 a68:	97ba                	add	a5,a5,a4
 a6a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a6c:	00000697          	auipc	a3,0x0
 a70:	e9468693          	addi	a3,a3,-364 # 900 <ithread_exit>
 a74:	862a                	mv	a2,a0
 a76:	85ce                	mv	a1,s3
 a78:	854a                	mv	a0,s2
 a7a:	00000097          	auipc	ra,0x0
 a7e:	9f2080e7          	jalr	-1550(ra) # 46c <create_thread>
 a82:	892a                	mv	s2,a0
  if (res != -1) {
 a84:	57fd                	li	a5,-1
 a86:	04f50d63          	beq	a0,a5,ae0 <ithread_create+0xd6>
    num_threads++;
 a8a:	00001717          	auipc	a4,0x1
 a8e:	a9670713          	addi	a4,a4,-1386 # 1520 <num_threads>
 a92:	431c                	lw	a5,0(a4)
 a94:	2785                	addiw	a5,a5,1
 a96:	c31c                	sw	a5,0(a4)
 a98:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a9a:	854a                	mv	a0,s2
 a9c:	70a2                	ld	ra,40(sp)
 a9e:	7402                	ld	s0,32(sp)
 aa0:	6942                	ld	s2,16(sp)
 aa2:	69a2                	ld	s3,8(sp)
 aa4:	6145                	addi	sp,sp,48
 aa6:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 aa8:	00001517          	auipc	a0,0x1
 aac:	a5852503          	lw	a0,-1448(a0) # 1500 <max_stacks>
 ab0:	0035151b          	slliw	a0,a0,0x3
 ab4:	00000097          	auipc	ra,0x0
 ab8:	d52080e7          	jalr	-686(ra) # 806 <malloc>
 abc:	00001797          	auipc	a5,0x1
 ac0:	a4a7be23          	sd	a0,-1444(a5) # 1518 <stacks>
 ac4:	b785                	j	a24 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 ac6:	00000517          	auipc	a0,0x0
 aca:	0d250513          	addi	a0,a0,210 # b98 <ithread_join+0x92>
 ace:	00000097          	auipc	ra,0x0
 ad2:	c7c080e7          	jalr	-900(ra) # 74a <printf>
      return -1;
 ad6:	57fd                	li	a5,-1
 ad8:	893e                	mv	s2,a5
 ada:	b7c1                	j	a9a <ithread_create+0x90>
 adc:	ec26                	sd	s1,24(sp)
 ade:	b7b5                	j	a4a <ithread_create+0x40>
    free(stack_ptr);
 ae0:	8526                	mv	a0,s1
 ae2:	00000097          	auipc	ra,0x0
 ae6:	c9e080e7          	jalr	-866(ra) # 780 <free>
    stacks[num_threads] = 0;
 aea:	00001717          	auipc	a4,0x1
 aee:	a3672703          	lw	a4,-1482(a4) # 1520 <num_threads>
 af2:	070e                	slli	a4,a4,0x3
 af4:	00001797          	auipc	a5,0x1
 af8:	a247b783          	ld	a5,-1500(a5) # 1518 <stacks>
 afc:	97ba                	add	a5,a5,a4
 afe:	0007b023          	sd	zero,0(a5)
 b02:	64e2                	ld	s1,24(sp)
 b04:	bf59                	j	a9a <ithread_create+0x90>

0000000000000b06 <ithread_join>:

int ithread_join(int thread_id) {
 b06:	1101                	addi	sp,sp,-32
 b08:	ec06                	sd	ra,24(sp)
 b0a:	e822                	sd	s0,16(sp)
 b0c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b0e:	fec40593          	addi	a1,s0,-20
 b12:	00000097          	auipc	ra,0x0
 b16:	962080e7          	jalr	-1694(ra) # 474 <join_thread>
  threads_done++;
 b1a:	00001717          	auipc	a4,0x1
 b1e:	a0a70713          	addi	a4,a4,-1526 # 1524 <threads_done>
 b22:	431c                	lw	a5,0(a4)
 b24:	2785                	addiw	a5,a5,1
 b26:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b28:	00001717          	auipc	a4,0x1
 b2c:	9f872703          	lw	a4,-1544(a4) # 1520 <num_threads>
 b30:	00f70863          	beq	a4,a5,b40 <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 b34:	fec42503          	lw	a0,-20(s0)
 b38:	60e2                	ld	ra,24(sp)
 b3a:	6442                	ld	s0,16(sp)
 b3c:	6105                	addi	sp,sp,32
 b3e:	8082                	ret
    free_stacks();
 b40:	00000097          	auipc	ra,0x0
 b44:	dd8080e7          	jalr	-552(ra) # 918 <free_stacks>
 b48:	b7f5                	j	b34 <ithread_join+0x2e>
