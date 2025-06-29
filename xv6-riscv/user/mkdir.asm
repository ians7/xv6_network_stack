
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	374080e7          	jalr	884(ra) # 39c <mkdir>
  30:	02054a63          	bltz	a0,64 <main+0x64>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2f8080e7          	jalr	760(ra) # 334 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	a9858593          	addi	a1,a1,-1384 # ae0 <ithread_join+0x52>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	652080e7          	jalr	1618(ra) # 6a4 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2d8080e7          	jalr	728(ra) # 334 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  64:	6090                	ld	a2,0(s1)
  66:	00001597          	auipc	a1,0x1
  6a:	a9258593          	addi	a1,a1,-1390 # af8 <ithread_join+0x6a>
  6e:	4509                	li	a0,2
  70:	00000097          	auipc	ra,0x0
  74:	634080e7          	jalr	1588(ra) # 6a4 <fprintf>
      break;
  78:	b7c9                	j	3a <main+0x3a>

000000000000007a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	00000097          	auipc	ra,0x0
  86:	f7e080e7          	jalr	-130(ra) # 0 <main>
  exit(0);
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	2a8080e7          	jalr	680(ra) # 334 <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9c:	87aa                	mv	a5,a0
  9e:	0585                	addi	a1,a1,1
  a0:	0785                	addi	a5,a5,1
  a2:	fff5c703          	lbu	a4,-1(a1)
  a6:	fee78fa3          	sb	a4,-1(a5)
  aa:	fb75                	bnez	a4,9e <strcpy+0xa>
    ;
  return os;
}
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb91                	beqz	a5,d4 <strcmp+0x20>
  c2:	0005c703          	lbu	a4,0(a1)
  c6:	00f71763          	bne	a4,a5,d4 <strcmp+0x20>
    p++, q++;
  ca:	0505                	addi	a0,a0,1
  cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbe5                	bnez	a5,c2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf99                	beqz	a5,10e <strlen+0x2a>
  f2:	0505                	addi	a0,a0,1
  f4:	87aa                	mv	a5,a0
  f6:	86be                	mv	a3,a5
  f8:	0785                	addi	a5,a5,1
  fa:	fff7c703          	lbu	a4,-1(a5)
  fe:	ff65                	bnez	a4,f6 <strlen+0x12>
 100:	40a6853b          	subw	a0,a3,a0
 104:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 106:	60a2                	ld	ra,8(sp)
 108:	6402                	ld	s0,0(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret
  for(n = 0; s[n]; n++)
 10e:	4501                	li	a0,0
 110:	bfdd                	j	106 <strlen+0x22>

0000000000000112 <memset>:

void*
memset(void *dst, int c, uint n)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 11a:	ca19                	beqz	a2,130 <memset+0x1e>
 11c:	87aa                	mv	a5,a0
 11e:	1602                	slli	a2,a2,0x20
 120:	9201                	srli	a2,a2,0x20
 122:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 126:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 12a:	0785                	addi	a5,a5,1
 12c:	fee79de3          	bne	a5,a4,126 <memset+0x14>
  }
  return dst;
}
 130:	60a2                	ld	ra,8(sp)
 132:	6402                	ld	s0,0(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strchr>:

char*
strchr(const char *s, char c)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 140:	00054783          	lbu	a5,0(a0)
 144:	cf81                	beqz	a5,15c <strchr+0x24>
    if(*s == c)
 146:	00f58763          	beq	a1,a5,154 <strchr+0x1c>
  for(; *s; s++)
 14a:	0505                	addi	a0,a0,1
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbfd                	bnez	a5,146 <strchr+0xe>
      return (char*)s;
  return 0;
 152:	4501                	li	a0,0
}
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfdd                	j	154 <strchr+0x1c>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	7159                	addi	sp,sp,-112
 162:	f486                	sd	ra,104(sp)
 164:	f0a2                	sd	s0,96(sp)
 166:	eca6                	sd	s1,88(sp)
 168:	e8ca                	sd	s2,80(sp)
 16a:	e4ce                	sd	s3,72(sp)
 16c:	e0d2                	sd	s4,64(sp)
 16e:	fc56                	sd	s5,56(sp)
 170:	f85a                	sd	s6,48(sp)
 172:	f45e                	sd	s7,40(sp)
 174:	f062                	sd	s8,32(sp)
 176:	ec66                	sd	s9,24(sp)
 178:	e86a                	sd	s10,16(sp)
 17a:	1880                	addi	s0,sp,112
 17c:	8caa                	mv	s9,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
 184:	f9f40b13          	addi	s6,s0,-97
 188:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18a:	4ba9                	li	s7,10
 18c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 18e:	8d26                	mv	s10,s1
 190:	0014899b          	addiw	s3,s1,1
 194:	84ce                	mv	s1,s3
 196:	0349d763          	bge	s3,s4,1c4 <gets+0x64>
    cc = read(0, &c, 1);
 19a:	8656                	mv	a2,s5
 19c:	85da                	mv	a1,s6
 19e:	4501                	li	a0,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	1ac080e7          	jalr	428(ra) # 34c <read>
    if(cc < 1)
 1a8:	00a05e63          	blez	a0,1c4 <gets+0x64>
    buf[i++] = c;
 1ac:	f9f44783          	lbu	a5,-97(s0)
 1b0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b4:	01778763          	beq	a5,s7,1c2 <gets+0x62>
 1b8:	0905                	addi	s2,s2,1
 1ba:	fd879ae3          	bne	a5,s8,18e <gets+0x2e>
    buf[i++] = c;
 1be:	8d4e                	mv	s10,s3
 1c0:	a011                	j	1c4 <gets+0x64>
 1c2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1c4:	9d66                	add	s10,s10,s9
 1c6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1ca:	8566                	mv	a0,s9
 1cc:	70a6                	ld	ra,104(sp)
 1ce:	7406                	ld	s0,96(sp)
 1d0:	64e6                	ld	s1,88(sp)
 1d2:	6946                	ld	s2,80(sp)
 1d4:	69a6                	ld	s3,72(sp)
 1d6:	6a06                	ld	s4,64(sp)
 1d8:	7ae2                	ld	s5,56(sp)
 1da:	7b42                	ld	s6,48(sp)
 1dc:	7ba2                	ld	s7,40(sp)
 1de:	7c02                	ld	s8,32(sp)
 1e0:	6ce2                	ld	s9,24(sp)
 1e2:	6d42                	ld	s10,16(sp)
 1e4:	6165                	addi	sp,sp,112
 1e6:	8082                	ret

00000000000001e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e8:	1101                	addi	sp,sp,-32
 1ea:	ec06                	sd	ra,24(sp)
 1ec:	e822                	sd	s0,16(sp)
 1ee:	e04a                	sd	s2,0(sp)
 1f0:	1000                	addi	s0,sp,32
 1f2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	4581                	li	a1,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	17e080e7          	jalr	382(ra) # 374 <open>
  if(fd < 0)
 1fe:	02054663          	bltz	a0,22a <stat+0x42>
 202:	e426                	sd	s1,8(sp)
 204:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 206:	85ca                	mv	a1,s2
 208:	00000097          	auipc	ra,0x0
 20c:	184080e7          	jalr	388(ra) # 38c <fstat>
 210:	892a                	mv	s2,a0
  close(fd);
 212:	8526                	mv	a0,s1
 214:	00000097          	auipc	ra,0x0
 218:	148080e7          	jalr	328(ra) # 35c <close>
  return r;
 21c:	64a2                	ld	s1,8(sp)
}
 21e:	854a                	mv	a0,s2
 220:	60e2                	ld	ra,24(sp)
 222:	6442                	ld	s0,16(sp)
 224:	6902                	ld	s2,0(sp)
 226:	6105                	addi	sp,sp,32
 228:	8082                	ret
    return -1;
 22a:	597d                	li	s2,-1
 22c:	bfcd                	j	21e <stat+0x36>

000000000000022e <atoi>:

int
atoi(const char *s)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 236:	00054683          	lbu	a3,0(a0)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	4625                	li	a2,9
 244:	02f66963          	bltu	a2,a5,276 <atoi+0x48>
 248:	872a                	mv	a4,a0
  n = 0;
 24a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24c:	0705                	addi	a4,a4,1
 24e:	0025179b          	slliw	a5,a0,0x2
 252:	9fa9                	addw	a5,a5,a0
 254:	0017979b          	slliw	a5,a5,0x1
 258:	9fb5                	addw	a5,a5,a3
 25a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25e:	00074683          	lbu	a3,0(a4)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	fef671e3          	bgeu	a2,a5,24c <atoi+0x1e>
  return n;
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
  n = 0;
 276:	4501                	li	a0,0
 278:	bfdd                	j	26e <atoi+0x40>

000000000000027a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e406                	sd	ra,8(sp)
 27e:	e022                	sd	s0,0(sp)
 280:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 282:	02b57563          	bgeu	a0,a1,2ac <memmove+0x32>
    while(n-- > 0)
 286:	00c05f63          	blez	a2,2a4 <memmove+0x2a>
 28a:	1602                	slli	a2,a2,0x20
 28c:	9201                	srli	a2,a2,0x20
 28e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 292:	872a                	mv	a4,a0
      *dst++ = *src++;
 294:	0585                	addi	a1,a1,1
 296:	0705                	addi	a4,a4,1
 298:	fff5c683          	lbu	a3,-1(a1)
 29c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
    dst += n;
 2ac:	00c50733          	add	a4,a0,a2
    src += n;
 2b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b2:	fec059e3          	blez	a2,2a4 <memmove+0x2a>
 2b6:	fff6079b          	addiw	a5,a2,-1
 2ba:	1782                	slli	a5,a5,0x20
 2bc:	9381                	srli	a5,a5,0x20
 2be:	fff7c793          	not	a5,a5
 2c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c4:	15fd                	addi	a1,a1,-1
 2c6:	177d                	addi	a4,a4,-1
 2c8:	0005c683          	lbu	a3,0(a1)
 2cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d0:	fef71ae3          	bne	a4,a5,2c4 <memmove+0x4a>
 2d4:	bfc1                	j	2a4 <memmove+0x2a>

00000000000002d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2de:	ca0d                	beqz	a2,310 <memcmp+0x3a>
 2e0:	fff6069b          	addiw	a3,a2,-1
 2e4:	1682                	slli	a3,a3,0x20
 2e6:	9281                	srli	a3,a3,0x20
 2e8:	0685                	addi	a3,a3,1
 2ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00e79863          	bne	a5,a4,304 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2f8:	0505                	addi	a0,a0,1
    p2++;
 2fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fc:	fed518e3          	bne	a0,a3,2ec <memcmp+0x16>
  }
  return 0;
 300:	4501                	li	a0,0
 302:	a019                	j	308 <memcmp+0x32>
      return *p1 - *p2;
 304:	40e7853b          	subw	a0,a5,a4
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  return 0;
 310:	4501                	li	a0,0
 312:	bfdd                	j	308 <memcmp+0x32>

0000000000000314 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31c:	00000097          	auipc	ra,0x0
 320:	f5e080e7          	jalr	-162(ra) # 27a <memmove>
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32c:	4885                	li	a7,1
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exit>:
.global exit
exit:
 li a7, SYS_exit
 334:	4889                	li	a7,2
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <wait>:
.global wait
wait:
 li a7, SYS_wait
 33c:	488d                	li	a7,3
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 344:	4891                	li	a7,4
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <read>:
.global read
read:
 li a7, SYS_read
 34c:	4895                	li	a7,5
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <write>:
.global write
write:
 li a7, SYS_write
 354:	48c1                	li	a7,16
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <close>:
.global close
close:
 li a7, SYS_close
 35c:	48d5                	li	a7,21
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <kill>:
.global kill
kill:
 li a7, SYS_kill
 364:	4899                	li	a7,6
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exec>:
.global exec
exec:
 li a7, SYS_exec
 36c:	489d                	li	a7,7
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <open>:
.global open
open:
 li a7, SYS_open
 374:	48bd                	li	a7,15
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37c:	48c5                	li	a7,17
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 384:	48c9                	li	a7,18
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38c:	48a1                	li	a7,8
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <link>:
.global link
link:
 li a7, SYS_link
 394:	48cd                	li	a7,19
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39c:	48d1                	li	a7,20
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a4:	48a5                	li	a7,9
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ac:	48a9                	li	a7,10
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b4:	48ad                	li	a7,11
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3bc:	48b1                	li	a7,12
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c4:	48b5                	li	a7,13
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3cc:	48b9                	li	a7,14
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3d4:	48d9                	li	a7,22
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3dc:	48dd                	li	a7,23
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3e4:	48e1                	li	a7,24
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3ec:	48e5                	li	a7,25
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3f4:	48e9                	li	a7,26
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <bind>:
.global bind
bind:
 li a7, SYS_bind
 3fc:	48ed                	li	a7,27
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <accept>:
.global accept
accept:
 li a7, SYS_accept
 404:	48f5                	li	a7,29
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <listen>:
.global listen
listen:
 li a7, SYS_listen
 40c:	48f1                	li	a7,28
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <connect>:
.global connect
connect:
 li a7, SYS_connect
 414:	48f9                	li	a7,30
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41c:	1101                	addi	sp,sp,-32
 41e:	ec06                	sd	ra,24(sp)
 420:	e822                	sd	s0,16(sp)
 422:	1000                	addi	s0,sp,32
 424:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 428:	4605                	li	a2,1
 42a:	fef40593          	addi	a1,s0,-17
 42e:	00000097          	auipc	ra,0x0
 432:	f26080e7          	jalr	-218(ra) # 354 <write>
}
 436:	60e2                	ld	ra,24(sp)
 438:	6442                	ld	s0,16(sp)
 43a:	6105                	addi	sp,sp,32
 43c:	8082                	ret

000000000000043e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43e:	7139                	addi	sp,sp,-64
 440:	fc06                	sd	ra,56(sp)
 442:	f822                	sd	s0,48(sp)
 444:	f426                	sd	s1,40(sp)
 446:	f04a                	sd	s2,32(sp)
 448:	ec4e                	sd	s3,24(sp)
 44a:	0080                	addi	s0,sp,64
 44c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44e:	c299                	beqz	a3,454 <printint+0x16>
 450:	0805c063          	bltz	a1,4d0 <printint+0x92>
  neg = 0;
 454:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 456:	fc040313          	addi	t1,s0,-64
  neg = 0;
 45a:	869a                	mv	a3,t1
  i = 0;
 45c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 45e:	00000817          	auipc	a6,0x0
 462:	74a80813          	addi	a6,a6,1866 # ba8 <digits>
 466:	88be                	mv	a7,a5
 468:	0017851b          	addiw	a0,a5,1
 46c:	87aa                	mv	a5,a0
 46e:	02c5f73b          	remuw	a4,a1,a2
 472:	1702                	slli	a4,a4,0x20
 474:	9301                	srli	a4,a4,0x20
 476:	9742                	add	a4,a4,a6
 478:	00074703          	lbu	a4,0(a4)
 47c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 480:	872e                	mv	a4,a1
 482:	02c5d5bb          	divuw	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fcc77fe3          	bgeu	a4,a2,466 <printint+0x28>
  if(neg)
 48c:	000e0c63          	beqz	t3,4a4 <printint+0x66>
    buf[i++] = '-';
 490:	fd050793          	addi	a5,a0,-48
 494:	00878533          	add	a0,a5,s0
 498:	02d00793          	li	a5,45
 49c:	fef50823          	sb	a5,-16(a0)
 4a0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4a4:	fff7899b          	addiw	s3,a5,-1
 4a8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ac:	fff4c583          	lbu	a1,-1(s1)
 4b0:	854a                	mv	a0,s2
 4b2:	00000097          	auipc	ra,0x0
 4b6:	f6a080e7          	jalr	-150(ra) # 41c <putc>
  while(--i >= 0)
 4ba:	39fd                	addiw	s3,s3,-1
 4bc:	14fd                	addi	s1,s1,-1
 4be:	fe09d7e3          	bgez	s3,4ac <printint+0x6e>
}
 4c2:	70e2                	ld	ra,56(sp)
 4c4:	7442                	ld	s0,48(sp)
 4c6:	74a2                	ld	s1,40(sp)
 4c8:	7902                	ld	s2,32(sp)
 4ca:	69e2                	ld	s3,24(sp)
 4cc:	6121                	addi	sp,sp,64
 4ce:	8082                	ret
    x = -xx;
 4d0:	40b005bb          	negw	a1,a1
    neg = 1;
 4d4:	4e05                	li	t3,1
    x = -xx;
 4d6:	b741                	j	456 <printint+0x18>

00000000000004d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d8:	715d                	addi	sp,sp,-80
 4da:	e486                	sd	ra,72(sp)
 4dc:	e0a2                	sd	s0,64(sp)
 4de:	f84a                	sd	s2,48(sp)
 4e0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e2:	0005c903          	lbu	s2,0(a1)
 4e6:	1a090a63          	beqz	s2,69a <vprintf+0x1c2>
 4ea:	fc26                	sd	s1,56(sp)
 4ec:	f44e                	sd	s3,40(sp)
 4ee:	f052                	sd	s4,32(sp)
 4f0:	ec56                	sd	s5,24(sp)
 4f2:	e85a                	sd	s6,16(sp)
 4f4:	e45e                	sd	s7,8(sp)
 4f6:	8aaa                	mv	s5,a0
 4f8:	8bb2                	mv	s7,a2
 4fa:	00158493          	addi	s1,a1,1
  state = 0;
 4fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 500:	02500a13          	li	s4,37
 504:	4b55                	li	s6,21
 506:	a839                	j	524 <vprintf+0x4c>
        putc(fd, c);
 508:	85ca                	mv	a1,s2
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	f10080e7          	jalr	-240(ra) # 41c <putc>
 514:	a019                	j	51a <vprintf+0x42>
    } else if(state == '%'){
 516:	01498d63          	beq	s3,s4,530 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 51a:	0485                	addi	s1,s1,1
 51c:	fff4c903          	lbu	s2,-1(s1)
 520:	16090763          	beqz	s2,68e <vprintf+0x1b6>
    if(state == 0){
 524:	fe0999e3          	bnez	s3,516 <vprintf+0x3e>
      if(c == '%'){
 528:	ff4910e3          	bne	s2,s4,508 <vprintf+0x30>
        state = '%';
 52c:	89d2                	mv	s3,s4
 52e:	b7f5                	j	51a <vprintf+0x42>
      if(c == 'd'){
 530:	13490463          	beq	s2,s4,658 <vprintf+0x180>
 534:	f9d9079b          	addiw	a5,s2,-99
 538:	0ff7f793          	zext.b	a5,a5
 53c:	12fb6763          	bltu	s6,a5,66a <vprintf+0x192>
 540:	f9d9079b          	addiw	a5,s2,-99
 544:	0ff7f713          	zext.b	a4,a5
 548:	12eb6163          	bltu	s6,a4,66a <vprintf+0x192>
 54c:	00271793          	slli	a5,a4,0x2
 550:	00000717          	auipc	a4,0x0
 554:	60070713          	addi	a4,a4,1536 # b50 <ithread_join+0xc2>
 558:	97ba                	add	a5,a5,a4
 55a:	439c                	lw	a5,0(a5)
 55c:	97ba                	add	a5,a5,a4
 55e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b8913          	addi	s2,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	ed0080e7          	jalr	-304(ra) # 43e <printint>
 576:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 578:	4981                	li	s3,0
 57a:	b745                	j	51a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	eb4080e7          	jalr	-332(ra) # 43e <printint>
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	b751                	j	51a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4641                	li	a2,16
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e98080e7          	jalr	-360(ra) # 43e <printint>
 5ae:	8bca                	mv	s7,s2
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b7a5                	j	51a <vprintf+0x42>
 5b4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b6:	008b8c13          	addi	s8,s7,8
 5ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5be:	03000593          	li	a1,48
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e58080e7          	jalr	-424(ra) # 41c <putc>
  putc(fd, 'x');
 5cc:	07800593          	li	a1,120
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e4a080e7          	jalr	-438(ra) # 41c <putc>
 5da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5dc:	00000b97          	auipc	s7,0x0
 5e0:	5ccb8b93          	addi	s7,s7,1484 # ba8 <digits>
 5e4:	03c9d793          	srli	a5,s3,0x3c
 5e8:	97de                	add	a5,a5,s7
 5ea:	0007c583          	lbu	a1,0(a5)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e2c080e7          	jalr	-468(ra) # 41c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f8:	0992                	slli	s3,s3,0x4
 5fa:	397d                	addiw	s2,s2,-1
 5fc:	fe0914e3          	bnez	s2,5e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 600:	8be2                	mv	s7,s8
      state = 0;
 602:	4981                	li	s3,0
 604:	6c02                	ld	s8,0(sp)
 606:	bf11                	j	51a <vprintf+0x42>
        s = va_arg(ap, char*);
 608:	008b8993          	addi	s3,s7,8
 60c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 610:	02090163          	beqz	s2,632 <vprintf+0x15a>
        while(*s != 0){
 614:	00094583          	lbu	a1,0(s2)
 618:	c9a5                	beqz	a1,688 <vprintf+0x1b0>
          putc(fd, *s);
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e00080e7          	jalr	-512(ra) # 41c <putc>
          s++;
 624:	0905                	addi	s2,s2,1
        while(*s != 0){
 626:	00094583          	lbu	a1,0(s2)
 62a:	f9e5                	bnez	a1,61a <vprintf+0x142>
        s = va_arg(ap, char*);
 62c:	8bce                	mv	s7,s3
      state = 0;
 62e:	4981                	li	s3,0
 630:	b5ed                	j	51a <vprintf+0x42>
          s = "(null)";
 632:	00000917          	auipc	s2,0x0
 636:	4e690913          	addi	s2,s2,1254 # b18 <ithread_join+0x8a>
        while(*s != 0){
 63a:	02800593          	li	a1,40
 63e:	bff1                	j	61a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 640:	008b8913          	addi	s2,s7,8
 644:	000bc583          	lbu	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	dd2080e7          	jalr	-558(ra) # 41c <putc>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b5d1                	j	51a <vprintf+0x42>
        putc(fd, c);
 658:	02500593          	li	a1,37
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	dbe080e7          	jalr	-578(ra) # 41c <putc>
      state = 0;
 666:	4981                	li	s3,0
 668:	bd4d                	j	51a <vprintf+0x42>
        putc(fd, '%');
 66a:	02500593          	li	a1,37
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	dac080e7          	jalr	-596(ra) # 41c <putc>
        putc(fd, c);
 678:	85ca                	mv	a1,s2
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	da0080e7          	jalr	-608(ra) # 41c <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	bd51                	j	51a <vprintf+0x42>
        s = va_arg(ap, char*);
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b579                	j	51a <vprintf+0x42>
 68e:	74e2                	ld	s1,56(sp)
 690:	79a2                	ld	s3,40(sp)
 692:	7a02                	ld	s4,32(sp)
 694:	6ae2                	ld	s5,24(sp)
 696:	6b42                	ld	s6,16(sp)
 698:	6ba2                	ld	s7,8(sp)
    }
  }
}
 69a:	60a6                	ld	ra,72(sp)
 69c:	6406                	ld	s0,64(sp)
 69e:	7942                	ld	s2,48(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a4:	715d                	addi	sp,sp,-80
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e010                	sd	a2,0(s0)
 6ae:	e414                	sd	a3,8(s0)
 6b0:	e818                	sd	a4,16(s0)
 6b2:	ec1c                	sd	a5,24(s0)
 6b4:	03043023          	sd	a6,32(s0)
 6b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6bc:	8622                	mv	a2,s0
 6be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e16080e7          	jalr	-490(ra) # 4d8 <vprintf>
}
 6ca:	60e2                	ld	ra,24(sp)
 6cc:	6442                	ld	s0,16(sp)
 6ce:	6161                	addi	sp,sp,80
 6d0:	8082                	ret

00000000000006d2 <printf>:

void
printf(const char *fmt, ...)
{
 6d2:	711d                	addi	sp,sp,-96
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	e40c                	sd	a1,8(s0)
 6dc:	e810                	sd	a2,16(s0)
 6de:	ec14                	sd	a3,24(s0)
 6e0:	f018                	sd	a4,32(s0)
 6e2:	f41c                	sd	a5,40(s0)
 6e4:	03043823          	sd	a6,48(s0)
 6e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ec:	00840613          	addi	a2,s0,8
 6f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f4:	85aa                	mv	a1,a0
 6f6:	4505                	li	a0,1
 6f8:	00000097          	auipc	ra,0x0
 6fc:	de0080e7          	jalr	-544(ra) # 4d8 <vprintf>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6125                	addi	sp,sp,96
 706:	8082                	ret

0000000000000708 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 708:	1141                	addi	sp,sp,-16
 70a:	e406                	sd	ra,8(sp)
 70c:	e022                	sd	s0,0(sp)
 70e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	00001797          	auipc	a5,0x1
 718:	dfc7b783          	ld	a5,-516(a5) # 1510 <freep>
 71c:	a02d                	j	746 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71e:	4618                	lw	a4,8(a2)
 720:	9f2d                	addw	a4,a4,a1
 722:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 726:	6398                	ld	a4,0(a5)
 728:	6310                	ld	a2,0(a4)
 72a:	a83d                	j	768 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 72c:	ff852703          	lw	a4,-8(a0)
 730:	9f31                	addw	a4,a4,a2
 732:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 734:	ff053683          	ld	a3,-16(a0)
 738:	a091                	j	77c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	6398                	ld	a4,0(a5)
 73c:	00e7e463          	bltu	a5,a4,744 <free+0x3c>
 740:	00e6ea63          	bltu	a3,a4,754 <free+0x4c>
{
 744:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	fed7fae3          	bgeu	a5,a3,73a <free+0x32>
 74a:	6398                	ld	a4,0(a5)
 74c:	00e6e463          	bltu	a3,a4,754 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	fee7eae3          	bltu	a5,a4,744 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 754:	ff852583          	lw	a1,-8(a0)
 758:	6390                	ld	a2,0(a5)
 75a:	02059813          	slli	a6,a1,0x20
 75e:	01c85713          	srli	a4,a6,0x1c
 762:	9736                	add	a4,a4,a3
 764:	fae60de3          	beq	a2,a4,71e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 76c:	4790                	lw	a2,8(a5)
 76e:	02061593          	slli	a1,a2,0x20
 772:	01c5d713          	srli	a4,a1,0x1c
 776:	973e                	add	a4,a4,a5
 778:	fae68ae3          	beq	a3,a4,72c <free+0x24>
    p->s.ptr = bp->s.ptr;
 77c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77e:	00001717          	auipc	a4,0x1
 782:	d8f73923          	sd	a5,-622(a4) # 1510 <freep>
}
 786:	60a2                	ld	ra,8(sp)
 788:	6402                	ld	s0,0(sp)
 78a:	0141                	addi	sp,sp,16
 78c:	8082                	ret

000000000000078e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78e:	7139                	addi	sp,sp,-64
 790:	fc06                	sd	ra,56(sp)
 792:	f822                	sd	s0,48(sp)
 794:	f04a                	sd	s2,32(sp)
 796:	ec4e                	sd	s3,24(sp)
 798:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79a:	02051993          	slli	s3,a0,0x20
 79e:	0209d993          	srli	s3,s3,0x20
 7a2:	09bd                	addi	s3,s3,15
 7a4:	0049d993          	srli	s3,s3,0x4
 7a8:	2985                	addiw	s3,s3,1
 7aa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ac:	00001517          	auipc	a0,0x1
 7b0:	d6453503          	ld	a0,-668(a0) # 1510 <freep>
 7b4:	c905                	beqz	a0,7e4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b8:	4798                	lw	a4,8(a5)
 7ba:	09377a63          	bgeu	a4,s3,84e <malloc+0xc0>
 7be:	f426                	sd	s1,40(sp)
 7c0:	e852                	sd	s4,16(sp)
 7c2:	e456                	sd	s5,8(sp)
 7c4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c6:	8a4e                	mv	s4,s3
 7c8:	6705                	lui	a4,0x1
 7ca:	00e9f363          	bgeu	s3,a4,7d0 <malloc+0x42>
 7ce:	6a05                	lui	s4,0x1
 7d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d8:	00001497          	auipc	s1,0x1
 7dc:	d3848493          	addi	s1,s1,-712 # 1510 <freep>
  if(p == (char*)-1)
 7e0:	5afd                	li	s5,-1
 7e2:	a089                	j	824 <malloc+0x96>
 7e4:	f426                	sd	s1,40(sp)
 7e6:	e852                	sd	s4,16(sp)
 7e8:	e456                	sd	s5,8(sp)
 7ea:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ec:	00001797          	auipc	a5,0x1
 7f0:	d4478793          	addi	a5,a5,-700 # 1530 <base>
 7f4:	00001717          	auipc	a4,0x1
 7f8:	d0f73e23          	sd	a5,-740(a4) # 1510 <freep>
 7fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 802:	b7d1                	j	7c6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	e118                	sd	a4,0(a0)
 808:	a8b9                	j	866 <malloc+0xd8>
  hp->s.size = nu;
 80a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80e:	0541                	addi	a0,a0,16
 810:	00000097          	auipc	ra,0x0
 814:	ef8080e7          	jalr	-264(ra) # 708 <free>
  return freep;
 818:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 81a:	c135                	beqz	a0,87e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	03277363          	bgeu	a4,s2,846 <malloc+0xb8>
    if(p == freep)
 824:	6098                	ld	a4,0(s1)
 826:	853e                	mv	a0,a5
 828:	fef71ae3          	bne	a4,a5,81c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	b8e080e7          	jalr	-1138(ra) # 3bc <sbrk>
  if(p == (char*)-1)
 836:	fd551ae3          	bne	a0,s5,80a <malloc+0x7c>
        return 0;
 83a:	4501                	li	a0,0
 83c:	74a2                	ld	s1,40(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
 844:	a03d                	j	872 <malloc+0xe4>
 846:	74a2                	ld	s1,40(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 84e:	fae90be3          	beq	s2,a4,804 <malloc+0x76>
        p->s.size -= nunits;
 852:	4137073b          	subw	a4,a4,s3
 856:	c798                	sw	a4,8(a5)
        p += p->s.size;
 858:	02071693          	slli	a3,a4,0x20
 85c:	01c6d713          	srli	a4,a3,0x1c
 860:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 862:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 866:	00001717          	auipc	a4,0x1
 86a:	caa73523          	sd	a0,-854(a4) # 1510 <freep>
      return (void*)(p + 1);
 86e:	01078513          	addi	a0,a5,16
  }
}
 872:	70e2                	ld	ra,56(sp)
 874:	7442                	ld	s0,48(sp)
 876:	7902                	ld	s2,32(sp)
 878:	69e2                	ld	s3,24(sp)
 87a:	6121                	addi	sp,sp,64
 87c:	8082                	ret
 87e:	74a2                	ld	s1,40(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	b7f5                	j	872 <malloc+0xe4>

0000000000000888 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 888:	1141                	addi	sp,sp,-16
 88a:	e406                	sd	ra,8(sp)
 88c:	e022                	sd	s0,0(sp)
 88e:	0800                	addi	s0,sp,16
  thread_exit(status);
 890:	2501                	sext.w	a0,a0
 892:	00000097          	auipc	ra,0x0
 896:	b5a080e7          	jalr	-1190(ra) # 3ec <thread_exit>
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret

00000000000008a2 <free_stacks>:
int free_stacks() {
 8a2:	7179                	addi	sp,sp,-48
 8a4:	f406                	sd	ra,40(sp)
 8a6:	f022                	sd	s0,32(sp)
 8a8:	ec26                	sd	s1,24(sp)
 8aa:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8ac:	00001797          	auipc	a5,0x1
 8b0:	c747a783          	lw	a5,-908(a5) # 1520 <num_threads>
 8b4:	04f05063          	blez	a5,8f4 <free_stacks+0x52>
 8b8:	e84a                	sd	s2,16(sp)
 8ba:	e44e                	sd	s3,8(sp)
 8bc:	4481                	li	s1,0
    free(stacks[i]);
 8be:	00001997          	auipc	s3,0x1
 8c2:	c5a98993          	addi	s3,s3,-934 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8c6:	00001917          	auipc	s2,0x1
 8ca:	c5a90913          	addi	s2,s2,-934 # 1520 <num_threads>
    free(stacks[i]);
 8ce:	0009b783          	ld	a5,0(s3)
 8d2:	00349713          	slli	a4,s1,0x3
 8d6:	97ba                	add	a5,a5,a4
 8d8:	6388                	ld	a0,0(a5)
 8da:	00000097          	auipc	ra,0x0
 8de:	e2e080e7          	jalr	-466(ra) # 708 <free>
  for (int i = 0; i < num_threads; i++) {
 8e2:	0485                	addi	s1,s1,1
 8e4:	00092703          	lw	a4,0(s2)
 8e8:	0004879b          	sext.w	a5,s1
 8ec:	fee7c1e3          	blt	a5,a4,8ce <free_stacks+0x2c>
 8f0:	6942                	ld	s2,16(sp)
 8f2:	69a2                	ld	s3,8(sp)
  free(stacks);
 8f4:	00001497          	auipc	s1,0x1
 8f8:	c2448493          	addi	s1,s1,-988 # 1518 <stacks>
 8fc:	6088                	ld	a0,0(s1)
 8fe:	00000097          	auipc	ra,0x0
 902:	e0a080e7          	jalr	-502(ra) # 708 <free>
  stacks = 0;
 906:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 90a:	00001797          	auipc	a5,0x1
 90e:	c007ab23          	sw	zero,-1002(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 912:	47a1                	li	a5,8
 914:	00001717          	auipc	a4,0x1
 918:	bef72623          	sw	a5,-1044(a4) # 1500 <max_stacks>
  threads_done = 0;
 91c:	00001797          	auipc	a5,0x1
 920:	c007a423          	sw	zero,-1016(a5) # 1524 <threads_done>
}
 924:	4501                	li	a0,0
 926:	70a2                	ld	ra,40(sp)
 928:	7402                	ld	s0,32(sp)
 92a:	64e2                	ld	s1,24(sp)
 92c:	6145                	addi	sp,sp,48
 92e:	8082                	ret

0000000000000930 <expand_num_threads>:
int expand_num_threads() {
 930:	1101                	addi	sp,sp,-32
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	e426                	sd	s1,8(sp)
 938:	e04a                	sd	s2,0(sp)
 93a:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 93c:	00001797          	auipc	a5,0x1
 940:	bc478793          	addi	a5,a5,-1084 # 1500 <max_stacks>
 944:	4388                	lw	a0,0(a5)
 946:	0015151b          	slliw	a0,a0,0x1
 94a:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 94c:	0035151b          	slliw	a0,a0,0x3
 950:	00000097          	auipc	ra,0x0
 954:	e3e080e7          	jalr	-450(ra) # 78e <malloc>
 958:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 95a:	00001617          	auipc	a2,0x1
 95e:	bc662603          	lw	a2,-1082(a2) # 1520 <num_threads>
 962:	00001497          	auipc	s1,0x1
 966:	bb648493          	addi	s1,s1,-1098 # 1518 <stacks>
 96a:	0036161b          	slliw	a2,a2,0x3
 96e:	608c                	ld	a1,0(s1)
 970:	00000097          	auipc	ra,0x0
 974:	90a080e7          	jalr	-1782(ra) # 27a <memmove>
  free(stacks);
 978:	6088                	ld	a0,0(s1)
 97a:	00000097          	auipc	ra,0x0
 97e:	d8e080e7          	jalr	-626(ra) # 708 <free>
  stacks = new_stacks;
 982:	0124b023          	sd	s2,0(s1)
}
 986:	4501                	li	a0,0
 988:	60e2                	ld	ra,24(sp)
 98a:	6442                	ld	s0,16(sp)
 98c:	64a2                	ld	s1,8(sp)
 98e:	6902                	ld	s2,0(sp)
 990:	6105                	addi	sp,sp,32
 992:	8082                	ret

0000000000000994 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 994:	7179                	addi	sp,sp,-48
 996:	f406                	sd	ra,40(sp)
 998:	f022                	sd	s0,32(sp)
 99a:	e84a                	sd	s2,16(sp)
 99c:	e44e                	sd	s3,8(sp)
 99e:	1800                	addi	s0,sp,48
 9a0:	892a                	mv	s2,a0
 9a2:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9a4:	00001797          	auipc	a5,0x1
 9a8:	b747b783          	ld	a5,-1164(a5) # 1518 <stacks>
 9ac:	c3d9                	beqz	a5,a32 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9ae:	00001797          	auipc	a5,0x1
 9b2:	b527a783          	lw	a5,-1198(a5) # 1500 <max_stacks>
 9b6:	00001717          	auipc	a4,0x1
 9ba:	b6a72703          	lw	a4,-1174(a4) # 1520 <num_threads>
 9be:	0af71363          	bne	a4,a5,a64 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9c2:	04000713          	li	a4,64
 9c6:	08e78563          	beq	a5,a4,a50 <ithread_create+0xbc>
 9ca:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9cc:	00000097          	auipc	ra,0x0
 9d0:	f64080e7          	jalr	-156(ra) # 930 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9d4:	6505                	lui	a0,0x1
 9d6:	00000097          	auipc	ra,0x0
 9da:	db8080e7          	jalr	-584(ra) # 78e <malloc>
 9de:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9e0:	00001717          	auipc	a4,0x1
 9e4:	b4072703          	lw	a4,-1216(a4) # 1520 <num_threads>
 9e8:	070e                	slli	a4,a4,0x3
 9ea:	00001797          	auipc	a5,0x1
 9ee:	b2e7b783          	ld	a5,-1234(a5) # 1518 <stacks>
 9f2:	97ba                	add	a5,a5,a4
 9f4:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9f6:	00000697          	auipc	a3,0x0
 9fa:	e9268693          	addi	a3,a3,-366 # 888 <ithread_exit>
 9fe:	862a                	mv	a2,a0
 a00:	85ce                	mv	a1,s3
 a02:	854a                	mv	a0,s2
 a04:	00000097          	auipc	ra,0x0
 a08:	9d8080e7          	jalr	-1576(ra) # 3dc <create_thread>
 a0c:	892a                	mv	s2,a0
  if (res != -1) {
 a0e:	57fd                	li	a5,-1
 a10:	04f50c63          	beq	a0,a5,a68 <ithread_create+0xd4>
    num_threads++;
 a14:	00001717          	auipc	a4,0x1
 a18:	b0c70713          	addi	a4,a4,-1268 # 1520 <num_threads>
 a1c:	431c                	lw	a5,0(a4)
 a1e:	2785                	addiw	a5,a5,1
 a20:	c31c                	sw	a5,0(a4)
 a22:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a24:	854a                	mv	a0,s2
 a26:	70a2                	ld	ra,40(sp)
 a28:	7402                	ld	s0,32(sp)
 a2a:	6942                	ld	s2,16(sp)
 a2c:	69a2                	ld	s3,8(sp)
 a2e:	6145                	addi	sp,sp,48
 a30:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a32:	00001517          	auipc	a0,0x1
 a36:	ace52503          	lw	a0,-1330(a0) # 1500 <max_stacks>
 a3a:	0035151b          	slliw	a0,a0,0x3
 a3e:	00000097          	auipc	ra,0x0
 a42:	d50080e7          	jalr	-688(ra) # 78e <malloc>
 a46:	00001797          	auipc	a5,0x1
 a4a:	aca7b923          	sd	a0,-1326(a5) # 1518 <stacks>
 a4e:	b785                	j	9ae <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a50:	00000517          	auipc	a0,0x0
 a54:	0d050513          	addi	a0,a0,208 # b20 <ithread_join+0x92>
 a58:	00000097          	auipc	ra,0x0
 a5c:	c7a080e7          	jalr	-902(ra) # 6d2 <printf>
      return -1;
 a60:	597d                	li	s2,-1
 a62:	b7c9                	j	a24 <ithread_create+0x90>
 a64:	ec26                	sd	s1,24(sp)
 a66:	b7bd                	j	9d4 <ithread_create+0x40>
    free(stack_ptr);
 a68:	8526                	mv	a0,s1
 a6a:	00000097          	auipc	ra,0x0
 a6e:	c9e080e7          	jalr	-866(ra) # 708 <free>
    stacks[num_threads] = 0;
 a72:	00001717          	auipc	a4,0x1
 a76:	aae72703          	lw	a4,-1362(a4) # 1520 <num_threads>
 a7a:	070e                	slli	a4,a4,0x3
 a7c:	00001797          	auipc	a5,0x1
 a80:	a9c7b783          	ld	a5,-1380(a5) # 1518 <stacks>
 a84:	97ba                	add	a5,a5,a4
 a86:	0007b023          	sd	zero,0(a5)
 a8a:	64e2                	ld	s1,24(sp)
 a8c:	bf61                	j	a24 <ithread_create+0x90>

0000000000000a8e <ithread_join>:

int ithread_join(int thread_id) {
 a8e:	1101                	addi	sp,sp,-32
 a90:	ec06                	sd	ra,24(sp)
 a92:	e822                	sd	s0,16(sp)
 a94:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a96:	ff040793          	addi	a5,s0,-16
 a9a:	ffc7859b          	addiw	a1,a5,-4
 a9e:	00000097          	auipc	ra,0x0
 aa2:	946080e7          	jalr	-1722(ra) # 3e4 <join_thread>
  threads_done++;
 aa6:	00001717          	auipc	a4,0x1
 aaa:	a7e70713          	addi	a4,a4,-1410 # 1524 <threads_done>
 aae:	431c                	lw	a5,0(a4)
 ab0:	2785                	addiw	a5,a5,1
 ab2:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ab4:	00001717          	auipc	a4,0x1
 ab8:	a6c72703          	lw	a4,-1428(a4) # 1520 <num_threads>
 abc:	00f70863          	beq	a4,a5,acc <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ac0:	fec42503          	lw	a0,-20(s0)
 ac4:	60e2                	ld	ra,24(sp)
 ac6:	6442                	ld	s0,16(sp)
 ac8:	6105                	addi	sp,sp,32
 aca:	8082                	ret
    free_stacks();
 acc:	00000097          	auipc	ra,0x0
 ad0:	dd6080e7          	jalr	-554(ra) # 8a2 <free_stacks>
 ad4:	b7f5                	j	ac0 <ithread_join+0x32>
