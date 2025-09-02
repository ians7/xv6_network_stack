
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
  40:	75e080e7          	jalr	1886(ra) # 79a <printf>
  memset(data, 'a', sizeof(data));
  44:	20000613          	li	a2,512
  48:	06100593          	li	a1,97
  4c:	dc040513          	addi	a0,s0,-576
  50:	00000097          	auipc	ra,0x0
  54:	164080e7          	jalr	356(ra) # 1b4 <memset>

  for(i = 0; i < 4; i++)
  58:	4481                	li	s1,0
  5a:	4911                	li	s2,4
    if(fork() > 0)
  5c:	00000097          	auipc	ra,0x0
  60:	372080e7          	jalr	882(ra) # 3ce <fork>
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
  7c:	722080e7          	jalr	1826(ra) # 79a <printf>

  path[8] += i;
  80:	fc844783          	lbu	a5,-56(s0)
  84:	9fa5                	addw	a5,a5,s1
  86:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  8a:	20200593          	li	a1,514
  8e:	fc040513          	addi	a0,s0,-64
  92:	00000097          	auipc	ra,0x0
  96:	384080e7          	jalr	900(ra) # 416 <open>
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
  b0:	34a080e7          	jalr	842(ra) # 3f6 <write>
  for(i = 0; i < 20; i++)
  b4:	34fd                	addiw	s1,s1,-1
  b6:	f8e5                	bnez	s1,a6 <main+0xa6>
  close(fd);
  b8:	854a                	mv	a0,s2
  ba:	00000097          	auipc	ra,0x0
  be:	344080e7          	jalr	836(ra) # 3fe <close>

  printf("read\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	b0650513          	addi	a0,a0,-1274 # bc8 <ithread_join+0x72>
  ca:	00000097          	auipc	ra,0x0
  ce:	6d0080e7          	jalr	1744(ra) # 79a <printf>

  fd = open(path, O_RDONLY);
  d2:	4581                	li	a1,0
  d4:	fc040513          	addi	a0,s0,-64
  d8:	00000097          	auipc	ra,0x0
  dc:	33e080e7          	jalr	830(ra) # 416 <open>
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
  f6:	2fc080e7          	jalr	764(ra) # 3ee <read>
  for (i = 0; i < 20; i++)
  fa:	34fd                	addiw	s1,s1,-1
  fc:	f8e5                	bnez	s1,ec <main+0xec>
  close(fd);
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	2fe080e7          	jalr	766(ra) # 3fe <close>

  wait(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2d4080e7          	jalr	724(ra) # 3de <wait>

  exit(0);
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	2c2080e7          	jalr	706(ra) # 3d6 <exit>

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
 132:	2a8080e7          	jalr	680(ra) # 3d6 <exit>

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
 192:	cf99                	beqz	a5,1b0 <strlen+0x2a>
 194:	0505                	addi	a0,a0,1
 196:	87aa                	mv	a5,a0
 198:	86be                	mv	a3,a5
 19a:	0785                	addi	a5,a5,1
 19c:	fff7c703          	lbu	a4,-1(a5)
 1a0:	ff65                	bnez	a4,198 <strlen+0x12>
 1a2:	40a6853b          	subw	a0,a3,a0
 1a6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a8:	60a2                	ld	ra,8(sp)
 1aa:	6402                	ld	s0,0(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  for(n = 0; s[n]; n++)
 1b0:	4501                	li	a0,0
 1b2:	bfdd                	j	1a8 <strlen+0x22>

00000000000001b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1bc:	ca19                	beqz	a2,1d2 <memset+0x1e>
 1be:	87aa                	mv	a5,a0
 1c0:	1602                	slli	a2,a2,0x20
 1c2:	9201                	srli	a2,a2,0x20
 1c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	addi	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x14>
  }
  return dst;
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strchr>:

char*
strchr(const char *s, char c)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	cf81                	beqz	a5,1fe <strchr+0x24>
    if(*s == c)
 1e8:	00f58763          	beq	a1,a5,1f6 <strchr+0x1c>
  for(; *s; s++)
 1ec:	0505                	addi	a0,a0,1
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbfd                	bnez	a5,1e8 <strchr+0xe>
      return (char*)s;
  return 0;
 1f4:	4501                	li	a0,0
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  return 0;
 1fe:	4501                	li	a0,0
 200:	bfdd                	j	1f6 <strchr+0x1c>

0000000000000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	7159                	addi	sp,sp,-112
 204:	f486                	sd	ra,104(sp)
 206:	f0a2                	sd	s0,96(sp)
 208:	eca6                	sd	s1,88(sp)
 20a:	e8ca                	sd	s2,80(sp)
 20c:	e4ce                	sd	s3,72(sp)
 20e:	e0d2                	sd	s4,64(sp)
 210:	fc56                	sd	s5,56(sp)
 212:	f85a                	sd	s6,48(sp)
 214:	f45e                	sd	s7,40(sp)
 216:	f062                	sd	s8,32(sp)
 218:	ec66                	sd	s9,24(sp)
 21a:	e86a                	sd	s10,16(sp)
 21c:	1880                	addi	s0,sp,112
 21e:	8caa                	mv	s9,a0
 220:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	892a                	mv	s2,a0
 224:	4481                	li	s1,0
    cc = read(0, &c, 1);
 226:	f9f40b13          	addi	s6,s0,-97
 22a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 22c:	4ba9                	li	s7,10
 22e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 230:	8d26                	mv	s10,s1
 232:	0014899b          	addiw	s3,s1,1
 236:	84ce                	mv	s1,s3
 238:	0349d763          	bge	s3,s4,266 <gets+0x64>
    cc = read(0, &c, 1);
 23c:	8656                	mv	a2,s5
 23e:	85da                	mv	a1,s6
 240:	4501                	li	a0,0
 242:	00000097          	auipc	ra,0x0
 246:	1ac080e7          	jalr	428(ra) # 3ee <read>
    if(cc < 1)
 24a:	00a05e63          	blez	a0,266 <gets+0x64>
    buf[i++] = c;
 24e:	f9f44783          	lbu	a5,-97(s0)
 252:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 256:	01778763          	beq	a5,s7,264 <gets+0x62>
 25a:	0905                	addi	s2,s2,1
 25c:	fd879ae3          	bne	a5,s8,230 <gets+0x2e>
    buf[i++] = c;
 260:	8d4e                	mv	s10,s3
 262:	a011                	j	266 <gets+0x64>
 264:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 266:	9d66                	add	s10,s10,s9
 268:	000d0023          	sb	zero,0(s10)
  return buf;
}
 26c:	8566                	mv	a0,s9
 26e:	70a6                	ld	ra,104(sp)
 270:	7406                	ld	s0,96(sp)
 272:	64e6                	ld	s1,88(sp)
 274:	6946                	ld	s2,80(sp)
 276:	69a6                	ld	s3,72(sp)
 278:	6a06                	ld	s4,64(sp)
 27a:	7ae2                	ld	s5,56(sp)
 27c:	7b42                	ld	s6,48(sp)
 27e:	7ba2                	ld	s7,40(sp)
 280:	7c02                	ld	s8,32(sp)
 282:	6ce2                	ld	s9,24(sp)
 284:	6d42                	ld	s10,16(sp)
 286:	6165                	addi	sp,sp,112
 288:	8082                	ret

000000000000028a <stat>:

int
stat(const char *n, struct stat *st)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec06                	sd	ra,24(sp)
 28e:	e822                	sd	s0,16(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
 294:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	4581                	li	a1,0
 298:	00000097          	auipc	ra,0x0
 29c:	17e080e7          	jalr	382(ra) # 416 <open>
  if(fd < 0)
 2a0:	02054663          	bltz	a0,2cc <stat+0x42>
 2a4:	e426                	sd	s1,8(sp)
 2a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a8:	85ca                	mv	a1,s2
 2aa:	00000097          	auipc	ra,0x0
 2ae:	184080e7          	jalr	388(ra) # 42e <fstat>
 2b2:	892a                	mv	s2,a0
  close(fd);
 2b4:	8526                	mv	a0,s1
 2b6:	00000097          	auipc	ra,0x0
 2ba:	148080e7          	jalr	328(ra) # 3fe <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x36>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d8:	00054683          	lbu	a3,0(a0)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	4625                	li	a2,9
 2e6:	02f66963          	bltu	a2,a5,318 <atoi+0x48>
 2ea:	872a                	mv	a4,a0
  n = 0;
 2ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ee:	0705                	addi	a4,a4,1
 2f0:	0025179b          	slliw	a5,a0,0x2
 2f4:	9fa9                	addw	a5,a5,a0
 2f6:	0017979b          	slliw	a5,a5,0x1
 2fa:	9fb5                	addw	a5,a5,a3
 2fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 300:	00074683          	lbu	a3,0(a4)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	fef671e3          	bgeu	a2,a5,2ee <atoi+0x1e>
  return n;
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  n = 0;
 318:	4501                	li	a0,0
 31a:	bfdd                	j	310 <atoi+0x40>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 324:	02b57563          	bgeu	a0,a1,34e <memmove+0x32>
    while(n-- > 0)
 328:	00c05f63          	blez	a2,346 <memmove+0x2a>
 32c:	1602                	slli	a2,a2,0x20
 32e:	9201                	srli	a2,a2,0x20
 330:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 334:	872a                	mv	a4,a0
      *dst++ = *src++;
 336:	0585                	addi	a1,a1,1
 338:	0705                	addi	a4,a4,1
 33a:	fff5c683          	lbu	a3,-1(a1)
 33e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
    dst += n;
 34e:	00c50733          	add	a4,a0,a2
    src += n;
 352:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 354:	fec059e3          	blez	a2,346 <memmove+0x2a>
 358:	fff6079b          	addiw	a5,a2,-1
 35c:	1782                	slli	a5,a5,0x20
 35e:	9381                	srli	a5,a5,0x20
 360:	fff7c793          	not	a5,a5
 364:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 366:	15fd                	addi	a1,a1,-1
 368:	177d                	addi	a4,a4,-1
 36a:	0005c683          	lbu	a3,0(a1)
 36e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 372:	fef71ae3          	bne	a4,a5,366 <memmove+0x4a>
 376:	bfc1                	j	346 <memmove+0x2a>

0000000000000378 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 380:	ca0d                	beqz	a2,3b2 <memcmp+0x3a>
 382:	fff6069b          	addiw	a3,a2,-1
 386:	1682                	slli	a3,a3,0x20
 388:	9281                	srli	a3,a3,0x20
 38a:	0685                	addi	a3,a3,1
 38c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 38e:	00054783          	lbu	a5,0(a0)
 392:	0005c703          	lbu	a4,0(a1)
 396:	00e79863          	bne	a5,a4,3a6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 39a:	0505                	addi	a0,a0,1
    p2++;
 39c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39e:	fed518e3          	bne	a0,a3,38e <memcmp+0x16>
  }
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	a019                	j	3aa <memcmp+0x32>
      return *p1 - *p2;
 3a6:	40e7853b          	subw	a0,a5,a4
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfdd                	j	3aa <memcmp+0x32>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	00000097          	auipc	ra,0x0
 3c2:	f5e080e7          	jalr	-162(ra) # 31c <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 476:	48d9                	li	a7,22
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 47e:	48dd                	li	a7,23
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 486:	48e1                	li	a7,24
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 48e:	48e5                	li	a7,25
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <socket>:
.global socket
socket:
 li a7, SYS_socket
 496:	48e9                	li	a7,26
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <bind>:
.global bind
bind:
 li a7, SYS_bind
 49e:	48ed                	li	a7,27
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4a6:	48f5                	li	a7,29
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <listen>:
.global listen
listen:
 li a7, SYS_listen
 4ae:	48f1                	li	a7,28
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4b6:	48f9                	li	a7,30
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <send>:
.global send
send:
 li a7, SYS_send
 4be:	48fd                	li	a7,31
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4c6:	02000893          	li	a7,32
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4d0:	02100893          	li	a7,33
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4da:	02200893          	li	a7,34
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e4:	1101                	addi	sp,sp,-32
 4e6:	ec06                	sd	ra,24(sp)
 4e8:	e822                	sd	s0,16(sp)
 4ea:	1000                	addi	s0,sp,32
 4ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f0:	4605                	li	a2,1
 4f2:	fef40593          	addi	a1,s0,-17
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f00080e7          	jalr	-256(ra) # 3f6 <write>
}
 4fe:	60e2                	ld	ra,24(sp)
 500:	6442                	ld	s0,16(sp)
 502:	6105                	addi	sp,sp,32
 504:	8082                	ret

0000000000000506 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 506:	7139                	addi	sp,sp,-64
 508:	fc06                	sd	ra,56(sp)
 50a:	f822                	sd	s0,48(sp)
 50c:	f426                	sd	s1,40(sp)
 50e:	f04a                	sd	s2,32(sp)
 510:	ec4e                	sd	s3,24(sp)
 512:	0080                	addi	s0,sp,64
 514:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 516:	c299                	beqz	a3,51c <printint+0x16>
 518:	0805c063          	bltz	a1,598 <printint+0x92>
  neg = 0;
 51c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 51e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 522:	869a                	mv	a3,t1
  i = 0;
 524:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 526:	00000817          	auipc	a6,0x0
 52a:	74a80813          	addi	a6,a6,1866 # c70 <digits>
 52e:	88be                	mv	a7,a5
 530:	0017851b          	addiw	a0,a5,1
 534:	87aa                	mv	a5,a0
 536:	02c5f73b          	remuw	a4,a1,a2
 53a:	1702                	slli	a4,a4,0x20
 53c:	9301                	srli	a4,a4,0x20
 53e:	9742                	add	a4,a4,a6
 540:	00074703          	lbu	a4,0(a4)
 544:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 548:	872e                	mv	a4,a1
 54a:	02c5d5bb          	divuw	a1,a1,a2
 54e:	0685                	addi	a3,a3,1
 550:	fcc77fe3          	bgeu	a4,a2,52e <printint+0x28>
  if(neg)
 554:	000e0c63          	beqz	t3,56c <printint+0x66>
    buf[i++] = '-';
 558:	fd050793          	addi	a5,a0,-48
 55c:	00878533          	add	a0,a5,s0
 560:	02d00793          	li	a5,45
 564:	fef50823          	sb	a5,-16(a0)
 568:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 56c:	fff7899b          	addiw	s3,a5,-1
 570:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 574:	fff4c583          	lbu	a1,-1(s1)
 578:	854a                	mv	a0,s2
 57a:	00000097          	auipc	ra,0x0
 57e:	f6a080e7          	jalr	-150(ra) # 4e4 <putc>
  while(--i >= 0)
 582:	39fd                	addiw	s3,s3,-1
 584:	14fd                	addi	s1,s1,-1
 586:	fe09d7e3          	bgez	s3,574 <printint+0x6e>
}
 58a:	70e2                	ld	ra,56(sp)
 58c:	7442                	ld	s0,48(sp)
 58e:	74a2                	ld	s1,40(sp)
 590:	7902                	ld	s2,32(sp)
 592:	69e2                	ld	s3,24(sp)
 594:	6121                	addi	sp,sp,64
 596:	8082                	ret
    x = -xx;
 598:	40b005bb          	negw	a1,a1
    neg = 1;
 59c:	4e05                	li	t3,1
    x = -xx;
 59e:	b741                	j	51e <printint+0x18>

00000000000005a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a0:	715d                	addi	sp,sp,-80
 5a2:	e486                	sd	ra,72(sp)
 5a4:	e0a2                	sd	s0,64(sp)
 5a6:	f84a                	sd	s2,48(sp)
 5a8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5aa:	0005c903          	lbu	s2,0(a1)
 5ae:	1a090a63          	beqz	s2,762 <vprintf+0x1c2>
 5b2:	fc26                	sd	s1,56(sp)
 5b4:	f44e                	sd	s3,40(sp)
 5b6:	f052                	sd	s4,32(sp)
 5b8:	ec56                	sd	s5,24(sp)
 5ba:	e85a                	sd	s6,16(sp)
 5bc:	e45e                	sd	s7,8(sp)
 5be:	8aaa                	mv	s5,a0
 5c0:	8bb2                	mv	s7,a2
 5c2:	00158493          	addi	s1,a1,1
  state = 0;
 5c6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c8:	02500a13          	li	s4,37
 5cc:	4b55                	li	s6,21
 5ce:	a839                	j	5ec <vprintf+0x4c>
        putc(fd, c);
 5d0:	85ca                	mv	a1,s2
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	f10080e7          	jalr	-240(ra) # 4e4 <putc>
 5dc:	a019                	j	5e2 <vprintf+0x42>
    } else if(state == '%'){
 5de:	01498d63          	beq	s3,s4,5f8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5e2:	0485                	addi	s1,s1,1
 5e4:	fff4c903          	lbu	s2,-1(s1)
 5e8:	16090763          	beqz	s2,756 <vprintf+0x1b6>
    if(state == 0){
 5ec:	fe0999e3          	bnez	s3,5de <vprintf+0x3e>
      if(c == '%'){
 5f0:	ff4910e3          	bne	s2,s4,5d0 <vprintf+0x30>
        state = '%';
 5f4:	89d2                	mv	s3,s4
 5f6:	b7f5                	j	5e2 <vprintf+0x42>
      if(c == 'd'){
 5f8:	13490463          	beq	s2,s4,720 <vprintf+0x180>
 5fc:	f9d9079b          	addiw	a5,s2,-99
 600:	0ff7f793          	zext.b	a5,a5
 604:	12fb6763          	bltu	s6,a5,732 <vprintf+0x192>
 608:	f9d9079b          	addiw	a5,s2,-99
 60c:	0ff7f713          	zext.b	a4,a5
 610:	12eb6163          	bltu	s6,a4,732 <vprintf+0x192>
 614:	00271793          	slli	a5,a4,0x2
 618:	00000717          	auipc	a4,0x0
 61c:	60070713          	addi	a4,a4,1536 # c18 <ithread_join+0xc2>
 620:	97ba                	add	a5,a5,a4
 622:	439c                	lw	a5,0(a5)
 624:	97ba                	add	a5,a5,a4
 626:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	ed0080e7          	jalr	-304(ra) # 506 <printint>
 63e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 640:	4981                	li	s3,0
 642:	b745                	j	5e2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	eb4080e7          	jalr	-332(ra) # 506 <printint>
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b751                	j	5e2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 660:	008b8913          	addi	s2,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000ba583          	lw	a1,0(s7)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e98080e7          	jalr	-360(ra) # 506 <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b7a5                	j	5e2 <vprintf+0x42>
 67c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 67e:	008b8c13          	addi	s8,s7,8
 682:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 686:	03000593          	li	a1,48
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e58080e7          	jalr	-424(ra) # 4e4 <putc>
  putc(fd, 'x');
 694:	07800593          	li	a1,120
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e4a080e7          	jalr	-438(ra) # 4e4 <putc>
 6a2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a4:	00000b97          	auipc	s7,0x0
 6a8:	5ccb8b93          	addi	s7,s7,1484 # c70 <digits>
 6ac:	03c9d793          	srli	a5,s3,0x3c
 6b0:	97de                	add	a5,a5,s7
 6b2:	0007c583          	lbu	a1,0(a5)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e2c080e7          	jalr	-468(ra) # 4e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c0:	0992                	slli	s3,s3,0x4
 6c2:	397d                	addiw	s2,s2,-1
 6c4:	fe0914e3          	bnez	s2,6ac <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6c8:	8be2                	mv	s7,s8
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	6c02                	ld	s8,0(sp)
 6ce:	bf11                	j	5e2 <vprintf+0x42>
        s = va_arg(ap, char*);
 6d0:	008b8993          	addi	s3,s7,8
 6d4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6d8:	02090163          	beqz	s2,6fa <vprintf+0x15a>
        while(*s != 0){
 6dc:	00094583          	lbu	a1,0(s2)
 6e0:	c9a5                	beqz	a1,750 <vprintf+0x1b0>
          putc(fd, *s);
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e00080e7          	jalr	-512(ra) # 4e4 <putc>
          s++;
 6ec:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ee:	00094583          	lbu	a1,0(s2)
 6f2:	f9e5                	bnez	a1,6e2 <vprintf+0x142>
        s = va_arg(ap, char*);
 6f4:	8bce                	mv	s7,s3
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b5ed                	j	5e2 <vprintf+0x42>
          s = "(null)";
 6fa:	00000917          	auipc	s2,0x0
 6fe:	4e690913          	addi	s2,s2,1254 # be0 <ithread_join+0x8a>
        while(*s != 0){
 702:	02800593          	li	a1,40
 706:	bff1                	j	6e2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 708:	008b8913          	addi	s2,s7,8
 70c:	000bc583          	lbu	a1,0(s7)
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	dd2080e7          	jalr	-558(ra) # 4e4 <putc>
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b5d1                	j	5e2 <vprintf+0x42>
        putc(fd, c);
 720:	02500593          	li	a1,37
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	dbe080e7          	jalr	-578(ra) # 4e4 <putc>
      state = 0;
 72e:	4981                	li	s3,0
 730:	bd4d                	j	5e2 <vprintf+0x42>
        putc(fd, '%');
 732:	02500593          	li	a1,37
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	dac080e7          	jalr	-596(ra) # 4e4 <putc>
        putc(fd, c);
 740:	85ca                	mv	a1,s2
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	da0080e7          	jalr	-608(ra) # 4e4 <putc>
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bd51                	j	5e2 <vprintf+0x42>
        s = va_arg(ap, char*);
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	b579                	j	5e2 <vprintf+0x42>
 756:	74e2                	ld	s1,56(sp)
 758:	79a2                	ld	s3,40(sp)
 75a:	7a02                	ld	s4,32(sp)
 75c:	6ae2                	ld	s5,24(sp)
 75e:	6b42                	ld	s6,16(sp)
 760:	6ba2                	ld	s7,8(sp)
    }
  }
}
 762:	60a6                	ld	ra,72(sp)
 764:	6406                	ld	s0,64(sp)
 766:	7942                	ld	s2,48(sp)
 768:	6161                	addi	sp,sp,80
 76a:	8082                	ret

000000000000076c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76c:	715d                	addi	sp,sp,-80
 76e:	ec06                	sd	ra,24(sp)
 770:	e822                	sd	s0,16(sp)
 772:	1000                	addi	s0,sp,32
 774:	e010                	sd	a2,0(s0)
 776:	e414                	sd	a3,8(s0)
 778:	e818                	sd	a4,16(s0)
 77a:	ec1c                	sd	a5,24(s0)
 77c:	03043023          	sd	a6,32(s0)
 780:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	8622                	mv	a2,s0
 786:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78a:	00000097          	auipc	ra,0x0
 78e:	e16080e7          	jalr	-490(ra) # 5a0 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6161                	addi	sp,sp,80
 798:	8082                	ret

000000000000079a <printf>:

void
printf(const char *fmt, ...)
{
 79a:	711d                	addi	sp,sp,-96
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e40c                	sd	a1,8(s0)
 7a4:	e810                	sd	a2,16(s0)
 7a6:	ec14                	sd	a3,24(s0)
 7a8:	f018                	sd	a4,32(s0)
 7aa:	f41c                	sd	a5,40(s0)
 7ac:	03043823          	sd	a6,48(s0)
 7b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	00840613          	addi	a2,s0,8
 7b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7bc:	85aa                	mv	a1,a0
 7be:	4505                	li	a0,1
 7c0:	00000097          	auipc	ra,0x0
 7c4:	de0080e7          	jalr	-544(ra) # 5a0 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6125                	addi	sp,sp,96
 7ce:	8082                	ret

00000000000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	1141                	addi	sp,sp,-16
 7d2:	e406                	sd	ra,8(sp)
 7d4:	e022                	sd	s0,0(sp)
 7d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	00001797          	auipc	a5,0x1
 7e0:	d347b783          	ld	a5,-716(a5) # 1510 <freep>
 7e4:	a02d                	j	80e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e6:	4618                	lw	a4,8(a2)
 7e8:	9f2d                	addw	a4,a4,a1
 7ea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	6310                	ld	a2,0(a4)
 7f2:	a83d                	j	830 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f4:	ff852703          	lw	a4,-8(a0)
 7f8:	9f31                	addw	a4,a4,a2
 7fa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fc:	ff053683          	ld	a3,-16(a0)
 800:	a091                	j	844 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	6398                	ld	a4,0(a5)
 804:	00e7e463          	bltu	a5,a4,80c <free+0x3c>
 808:	00e6ea63          	bltu	a3,a4,81c <free+0x4c>
{
 80c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	fed7fae3          	bgeu	a5,a3,802 <free+0x32>
 812:	6398                	ld	a4,0(a5)
 814:	00e6e463          	bltu	a3,a4,81c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	fee7eae3          	bltu	a5,a4,80c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 81c:	ff852583          	lw	a1,-8(a0)
 820:	6390                	ld	a2,0(a5)
 822:	02059813          	slli	a6,a1,0x20
 826:	01c85713          	srli	a4,a6,0x1c
 82a:	9736                	add	a4,a4,a3
 82c:	fae60de3          	beq	a2,a4,7e6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 834:	4790                	lw	a2,8(a5)
 836:	02061593          	slli	a1,a2,0x20
 83a:	01c5d713          	srli	a4,a1,0x1c
 83e:	973e                	add	a4,a4,a5
 840:	fae68ae3          	beq	a3,a4,7f4 <free+0x24>
    p->s.ptr = bp->s.ptr;
 844:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 846:	00001717          	auipc	a4,0x1
 84a:	ccf73523          	sd	a5,-822(a4) # 1510 <freep>
}
 84e:	60a2                	ld	ra,8(sp)
 850:	6402                	ld	s0,0(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret

0000000000000856 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f04a                	sd	s2,32(sp)
 85e:	ec4e                	sd	s3,24(sp)
 860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	02051993          	slli	s3,a0,0x20
 866:	0209d993          	srli	s3,s3,0x20
 86a:	09bd                	addi	s3,s3,15
 86c:	0049d993          	srli	s3,s3,0x4
 870:	2985                	addiw	s3,s3,1
 872:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 874:	00001517          	auipc	a0,0x1
 878:	c9c53503          	ld	a0,-868(a0) # 1510 <freep>
 87c:	c905                	beqz	a0,8ac <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	09377a63          	bgeu	a4,s3,916 <malloc+0xc0>
 886:	f426                	sd	s1,40(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88e:	8a4e                	mv	s4,s3
 890:	6705                	lui	a4,0x1
 892:	00e9f363          	bgeu	s3,a4,898 <malloc+0x42>
 896:	6a05                	lui	s4,0x1
 898:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a0:	00001497          	auipc	s1,0x1
 8a4:	c7048493          	addi	s1,s1,-912 # 1510 <freep>
  if(p == (char*)-1)
 8a8:	5afd                	li	s5,-1
 8aa:	a089                	j	8ec <malloc+0x96>
 8ac:	f426                	sd	s1,40(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b4:	00001797          	auipc	a5,0x1
 8b8:	c7c78793          	addi	a5,a5,-900 # 1530 <base>
 8bc:	00001717          	auipc	a4,0x1
 8c0:	c4f73a23          	sd	a5,-940(a4) # 1510 <freep>
 8c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ca:	b7d1                	j	88e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	e118                	sd	a4,0(a0)
 8d0:	a8b9                	j	92e <malloc+0xd8>
  hp->s.size = nu;
 8d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d6:	0541                	addi	a0,a0,16
 8d8:	00000097          	auipc	ra,0x0
 8dc:	ef8080e7          	jalr	-264(ra) # 7d0 <free>
  return freep;
 8e0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8e2:	c135                	beqz	a0,946 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e6:	4798                	lw	a4,8(a5)
 8e8:	03277363          	bgeu	a4,s2,90e <malloc+0xb8>
    if(p == freep)
 8ec:	6098                	ld	a4,0(s1)
 8ee:	853e                	mv	a0,a5
 8f0:	fef71ae3          	bne	a4,a5,8e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	00000097          	auipc	ra,0x0
 8fa:	b68080e7          	jalr	-1176(ra) # 45e <sbrk>
  if(p == (char*)-1)
 8fe:	fd551ae3          	bne	a0,s5,8d2 <malloc+0x7c>
        return 0;
 902:	4501                	li	a0,0
 904:	74a2                	ld	s1,40(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
 90c:	a03d                	j	93a <malloc+0xe4>
 90e:	74a2                	ld	s1,40(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 916:	fae90be3          	beq	s2,a4,8cc <malloc+0x76>
        p->s.size -= nunits;
 91a:	4137073b          	subw	a4,a4,s3
 91e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 920:	02071693          	slli	a3,a4,0x20
 924:	01c6d713          	srli	a4,a3,0x1c
 928:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92e:	00001717          	auipc	a4,0x1
 932:	bea73123          	sd	a0,-1054(a4) # 1510 <freep>
      return (void*)(p + 1);
 936:	01078513          	addi	a0,a5,16
  }
}
 93a:	70e2                	ld	ra,56(sp)
 93c:	7442                	ld	s0,48(sp)
 93e:	7902                	ld	s2,32(sp)
 940:	69e2                	ld	s3,24(sp)
 942:	6121                	addi	sp,sp,64
 944:	8082                	ret
 946:	74a2                	ld	s1,40(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
 94e:	b7f5                	j	93a <malloc+0xe4>

0000000000000950 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 950:	1141                	addi	sp,sp,-16
 952:	e406                	sd	ra,8(sp)
 954:	e022                	sd	s0,0(sp)
 956:	0800                	addi	s0,sp,16
  thread_exit(status);
 958:	2501                	sext.w	a0,a0
 95a:	00000097          	auipc	ra,0x0
 95e:	b34080e7          	jalr	-1228(ra) # 48e <thread_exit>
}
 962:	60a2                	ld	ra,8(sp)
 964:	6402                	ld	s0,0(sp)
 966:	0141                	addi	sp,sp,16
 968:	8082                	ret

000000000000096a <free_stacks>:
int free_stacks() {
 96a:	7179                	addi	sp,sp,-48
 96c:	f406                	sd	ra,40(sp)
 96e:	f022                	sd	s0,32(sp)
 970:	ec26                	sd	s1,24(sp)
 972:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 974:	00001797          	auipc	a5,0x1
 978:	bac7a783          	lw	a5,-1108(a5) # 1520 <num_threads>
 97c:	04f05063          	blez	a5,9bc <free_stacks+0x52>
 980:	e84a                	sd	s2,16(sp)
 982:	e44e                	sd	s3,8(sp)
 984:	4481                	li	s1,0
    free(stacks[i]);
 986:	00001997          	auipc	s3,0x1
 98a:	b9298993          	addi	s3,s3,-1134 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 98e:	00001917          	auipc	s2,0x1
 992:	b9290913          	addi	s2,s2,-1134 # 1520 <num_threads>
    free(stacks[i]);
 996:	0009b783          	ld	a5,0(s3)
 99a:	00349713          	slli	a4,s1,0x3
 99e:	97ba                	add	a5,a5,a4
 9a0:	6388                	ld	a0,0(a5)
 9a2:	00000097          	auipc	ra,0x0
 9a6:	e2e080e7          	jalr	-466(ra) # 7d0 <free>
  for (int i = 0; i < num_threads; i++) {
 9aa:	0485                	addi	s1,s1,1
 9ac:	00092703          	lw	a4,0(s2)
 9b0:	0004879b          	sext.w	a5,s1
 9b4:	fee7c1e3          	blt	a5,a4,996 <free_stacks+0x2c>
 9b8:	6942                	ld	s2,16(sp)
 9ba:	69a2                	ld	s3,8(sp)
  free(stacks);
 9bc:	00001497          	auipc	s1,0x1
 9c0:	b5c48493          	addi	s1,s1,-1188 # 1518 <stacks>
 9c4:	6088                	ld	a0,0(s1)
 9c6:	00000097          	auipc	ra,0x0
 9ca:	e0a080e7          	jalr	-502(ra) # 7d0 <free>
  stacks = 0;
 9ce:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9d2:	00001797          	auipc	a5,0x1
 9d6:	b407a723          	sw	zero,-1202(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9da:	47a1                	li	a5,8
 9dc:	00001717          	auipc	a4,0x1
 9e0:	b2f72223          	sw	a5,-1244(a4) # 1500 <max_stacks>
  threads_done = 0;
 9e4:	00001797          	auipc	a5,0x1
 9e8:	b407a023          	sw	zero,-1216(a5) # 1524 <threads_done>
}
 9ec:	4501                	li	a0,0
 9ee:	70a2                	ld	ra,40(sp)
 9f0:	7402                	ld	s0,32(sp)
 9f2:	64e2                	ld	s1,24(sp)
 9f4:	6145                	addi	sp,sp,48
 9f6:	8082                	ret

00000000000009f8 <expand_num_threads>:
int expand_num_threads() {
 9f8:	1101                	addi	sp,sp,-32
 9fa:	ec06                	sd	ra,24(sp)
 9fc:	e822                	sd	s0,16(sp)
 9fe:	e426                	sd	s1,8(sp)
 a00:	e04a                	sd	s2,0(sp)
 a02:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a04:	00001797          	auipc	a5,0x1
 a08:	afc78793          	addi	a5,a5,-1284 # 1500 <max_stacks>
 a0c:	4388                	lw	a0,0(a5)
 a0e:	0015151b          	slliw	a0,a0,0x1
 a12:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a14:	0035151b          	slliw	a0,a0,0x3
 a18:	00000097          	auipc	ra,0x0
 a1c:	e3e080e7          	jalr	-450(ra) # 856 <malloc>
 a20:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a22:	00001617          	auipc	a2,0x1
 a26:	afe62603          	lw	a2,-1282(a2) # 1520 <num_threads>
 a2a:	00001497          	auipc	s1,0x1
 a2e:	aee48493          	addi	s1,s1,-1298 # 1518 <stacks>
 a32:	0036161b          	slliw	a2,a2,0x3
 a36:	608c                	ld	a1,0(s1)
 a38:	00000097          	auipc	ra,0x0
 a3c:	8e4080e7          	jalr	-1820(ra) # 31c <memmove>
  free(stacks);
 a40:	6088                	ld	a0,0(s1)
 a42:	00000097          	auipc	ra,0x0
 a46:	d8e080e7          	jalr	-626(ra) # 7d0 <free>
  stacks = new_stacks;
 a4a:	0124b023          	sd	s2,0(s1)
}
 a4e:	4501                	li	a0,0
 a50:	60e2                	ld	ra,24(sp)
 a52:	6442                	ld	s0,16(sp)
 a54:	64a2                	ld	s1,8(sp)
 a56:	6902                	ld	s2,0(sp)
 a58:	6105                	addi	sp,sp,32
 a5a:	8082                	ret

0000000000000a5c <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a5c:	7179                	addi	sp,sp,-48
 a5e:	f406                	sd	ra,40(sp)
 a60:	f022                	sd	s0,32(sp)
 a62:	e84a                	sd	s2,16(sp)
 a64:	e44e                	sd	s3,8(sp)
 a66:	1800                	addi	s0,sp,48
 a68:	892a                	mv	s2,a0
 a6a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a6c:	00001797          	auipc	a5,0x1
 a70:	aac7b783          	ld	a5,-1364(a5) # 1518 <stacks>
 a74:	c3d9                	beqz	a5,afa <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a76:	00001797          	auipc	a5,0x1
 a7a:	a8a7a783          	lw	a5,-1398(a5) # 1500 <max_stacks>
 a7e:	00001717          	auipc	a4,0x1
 a82:	aa272703          	lw	a4,-1374(a4) # 1520 <num_threads>
 a86:	0af71363          	bne	a4,a5,b2c <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a8a:	04000713          	li	a4,64
 a8e:	08e78563          	beq	a5,a4,b18 <ithread_create+0xbc>
 a92:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a94:	00000097          	auipc	ra,0x0
 a98:	f64080e7          	jalr	-156(ra) # 9f8 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a9c:	6505                	lui	a0,0x1
 a9e:	00000097          	auipc	ra,0x0
 aa2:	db8080e7          	jalr	-584(ra) # 856 <malloc>
 aa6:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 aa8:	00001717          	auipc	a4,0x1
 aac:	a7872703          	lw	a4,-1416(a4) # 1520 <num_threads>
 ab0:	070e                	slli	a4,a4,0x3
 ab2:	00001797          	auipc	a5,0x1
 ab6:	a667b783          	ld	a5,-1434(a5) # 1518 <stacks>
 aba:	97ba                	add	a5,a5,a4
 abc:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 abe:	00000697          	auipc	a3,0x0
 ac2:	e9268693          	addi	a3,a3,-366 # 950 <ithread_exit>
 ac6:	862a                	mv	a2,a0
 ac8:	85ce                	mv	a1,s3
 aca:	854a                	mv	a0,s2
 acc:	00000097          	auipc	ra,0x0
 ad0:	9b2080e7          	jalr	-1614(ra) # 47e <create_thread>
 ad4:	892a                	mv	s2,a0
  if (res != -1) {
 ad6:	57fd                	li	a5,-1
 ad8:	04f50c63          	beq	a0,a5,b30 <ithread_create+0xd4>
    num_threads++;
 adc:	00001717          	auipc	a4,0x1
 ae0:	a4470713          	addi	a4,a4,-1468 # 1520 <num_threads>
 ae4:	431c                	lw	a5,0(a4)
 ae6:	2785                	addiw	a5,a5,1
 ae8:	c31c                	sw	a5,0(a4)
 aea:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 aec:	854a                	mv	a0,s2
 aee:	70a2                	ld	ra,40(sp)
 af0:	7402                	ld	s0,32(sp)
 af2:	6942                	ld	s2,16(sp)
 af4:	69a2                	ld	s3,8(sp)
 af6:	6145                	addi	sp,sp,48
 af8:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 afa:	00001517          	auipc	a0,0x1
 afe:	a0652503          	lw	a0,-1530(a0) # 1500 <max_stacks>
 b02:	0035151b          	slliw	a0,a0,0x3
 b06:	00000097          	auipc	ra,0x0
 b0a:	d50080e7          	jalr	-688(ra) # 856 <malloc>
 b0e:	00001797          	auipc	a5,0x1
 b12:	a0a7b523          	sd	a0,-1526(a5) # 1518 <stacks>
 b16:	b785                	j	a76 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b18:	00000517          	auipc	a0,0x0
 b1c:	0d050513          	addi	a0,a0,208 # be8 <ithread_join+0x92>
 b20:	00000097          	auipc	ra,0x0
 b24:	c7a080e7          	jalr	-902(ra) # 79a <printf>
      return -1;
 b28:	597d                	li	s2,-1
 b2a:	b7c9                	j	aec <ithread_create+0x90>
 b2c:	ec26                	sd	s1,24(sp)
 b2e:	b7bd                	j	a9c <ithread_create+0x40>
    free(stack_ptr);
 b30:	8526                	mv	a0,s1
 b32:	00000097          	auipc	ra,0x0
 b36:	c9e080e7          	jalr	-866(ra) # 7d0 <free>
    stacks[num_threads] = 0;
 b3a:	00001717          	auipc	a4,0x1
 b3e:	9e672703          	lw	a4,-1562(a4) # 1520 <num_threads>
 b42:	070e                	slli	a4,a4,0x3
 b44:	00001797          	auipc	a5,0x1
 b48:	9d47b783          	ld	a5,-1580(a5) # 1518 <stacks>
 b4c:	97ba                	add	a5,a5,a4
 b4e:	0007b023          	sd	zero,0(a5)
 b52:	64e2                	ld	s1,24(sp)
 b54:	bf61                	j	aec <ithread_create+0x90>

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
 b6a:	920080e7          	jalr	-1760(ra) # 486 <join_thread>
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
 b98:	dd6080e7          	jalr	-554(ra) # 96a <free_stacks>
 b9c:	b7f5                	j	b88 <ithread_join+0x32>
