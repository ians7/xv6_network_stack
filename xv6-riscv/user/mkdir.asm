
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
  2c:	362080e7          	jalr	866(ra) # 38a <mkdir>
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
  40:	2e6080e7          	jalr	742(ra) # 322 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	a9858593          	addi	a1,a1,-1384 # ae0 <ithread_join+0x52>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	650080e7          	jalr	1616(ra) # 6a2 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2c6080e7          	jalr	710(ra) # 322 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  64:	6090                	ld	a2,0(s1)
  66:	00001597          	auipc	a1,0x1
  6a:	a9258593          	addi	a1,a1,-1390 # af8 <ithread_join+0x6a>
  6e:	4509                	li	a0,2
  70:	00000097          	auipc	ra,0x0
  74:	632080e7          	jalr	1586(ra) # 6a2 <fprintf>
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
  90:	296080e7          	jalr	662(ra) # 322 <exit>

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
  f0:	cf91                	beqz	a5,10c <strlen+0x28>
  f2:	00150793          	addi	a5,a0,1
  f6:	86be                	mv	a3,a5
  f8:	0785                	addi	a5,a5,1
  fa:	fff7c703          	lbu	a4,-1(a5)
  fe:	ff65                	bnez	a4,f6 <strlen+0x12>
 100:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 104:	60a2                	ld	ra,8(sp)
 106:	6402                	ld	s0,0(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
  for(n = 0; s[n]; n++)
 10c:	4501                	li	a0,0
 10e:	bfdd                	j	104 <strlen+0x20>

0000000000000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	1141                	addi	sp,sp,-16
 112:	e406                	sd	ra,8(sp)
 114:	e022                	sd	s0,0(sp)
 116:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 118:	ca19                	beqz	a2,12e <memset+0x1e>
 11a:	87aa                	mv	a5,a0
 11c:	1602                	slli	a2,a2,0x20
 11e:	9201                	srli	a2,a2,0x20
 120:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 124:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 128:	0785                	addi	a5,a5,1
 12a:	fee79de3          	bne	a5,a4,124 <memset+0x14>
  }
  return dst;
}
 12e:	60a2                	ld	ra,8(sp)
 130:	6402                	ld	s0,0(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <strchr>:

char*
strchr(const char *s, char c)
{
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cf81                	beqz	a5,15a <strchr+0x24>
    if(*s == c)
 144:	00f58763          	beq	a1,a5,152 <strchr+0x1c>
  for(; *s; s++)
 148:	0505                	addi	a0,a0,1
 14a:	00054783          	lbu	a5,0(a0)
 14e:	fbfd                	bnez	a5,144 <strchr+0xe>
      return (char*)s;
  return 0;
 150:	4501                	li	a0,0
}
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
  return 0;
 15a:	4501                	li	a0,0
 15c:	bfdd                	j	152 <strchr+0x1c>

000000000000015e <gets>:

char*
gets(char *buf, int max)
{
 15e:	711d                	addi	sp,sp,-96
 160:	ec86                	sd	ra,88(sp)
 162:	e8a2                	sd	s0,80(sp)
 164:	e4a6                	sd	s1,72(sp)
 166:	e0ca                	sd	s2,64(sp)
 168:	fc4e                	sd	s3,56(sp)
 16a:	f852                	sd	s4,48(sp)
 16c:	f456                	sd	s5,40(sp)
 16e:	f05a                	sd	s6,32(sp)
 170:	ec5e                	sd	s7,24(sp)
 172:	e862                	sd	s8,16(sp)
 174:	1080                	addi	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 17e:	faf40b13          	addi	s6,s0,-81
 182:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 184:	8c26                	mv	s8,s1
 186:	0014899b          	addiw	s3,s1,1
 18a:	84ce                	mv	s1,s3
 18c:	0349d663          	bge	s3,s4,1b8 <gets+0x5a>
    cc = read(0, &c, 1);
 190:	8656                	mv	a2,s5
 192:	85da                	mv	a1,s6
 194:	4501                	li	a0,0
 196:	00000097          	auipc	ra,0x0
 19a:	1a4080e7          	jalr	420(ra) # 33a <read>
    if(cc < 1)
 19e:	00a05d63          	blez	a0,1b8 <gets+0x5a>
      break;
    buf[i++] = c;
 1a2:	faf44783          	lbu	a5,-81(s0)
 1a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1aa:	0905                	addi	s2,s2,1
 1ac:	ff678713          	addi	a4,a5,-10
 1b0:	c319                	beqz	a4,1b6 <gets+0x58>
 1b2:	17cd                	addi	a5,a5,-13
 1b4:	fbe1                	bnez	a5,184 <gets+0x26>
    buf[i++] = c;
 1b6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1b8:	9c5e                	add	s8,s8,s7
 1ba:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1be:	855e                	mv	a0,s7
 1c0:	60e6                	ld	ra,88(sp)
 1c2:	6446                	ld	s0,80(sp)
 1c4:	64a6                	ld	s1,72(sp)
 1c6:	6906                	ld	s2,64(sp)
 1c8:	79e2                	ld	s3,56(sp)
 1ca:	7a42                	ld	s4,48(sp)
 1cc:	7aa2                	ld	s5,40(sp)
 1ce:	7b02                	ld	s6,32(sp)
 1d0:	6be2                	ld	s7,24(sp)
 1d2:	6c42                	ld	s8,16(sp)
 1d4:	6125                	addi	sp,sp,96
 1d6:	8082                	ret

00000000000001d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d8:	1101                	addi	sp,sp,-32
 1da:	ec06                	sd	ra,24(sp)
 1dc:	e822                	sd	s0,16(sp)
 1de:	e04a                	sd	s2,0(sp)
 1e0:	1000                	addi	s0,sp,32
 1e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	4581                	li	a1,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	17c080e7          	jalr	380(ra) # 362 <open>
  if(fd < 0)
 1ee:	02054663          	bltz	a0,21a <stat+0x42>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	00000097          	auipc	ra,0x0
 1fc:	182080e7          	jalr	386(ra) # 37a <fstat>
 200:	892a                	mv	s2,a0
  close(fd);
 202:	8526                	mv	a0,s1
 204:	00000097          	auipc	ra,0x0
 208:	146080e7          	jalr	326(ra) # 34a <close>
  return r;
 20c:	64a2                	ld	s1,8(sp)
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	6902                	ld	s2,0(sp)
 216:	6105                	addi	sp,sp,32
 218:	8082                	ret
    return -1;
 21a:	57fd                	li	a5,-1
 21c:	893e                	mv	s2,a5
 21e:	bfc5                	j	20e <stat+0x36>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e406                	sd	ra,8(sp)
 224:	e022                	sd	s0,0(sp)
 226:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 228:	00054683          	lbu	a3,0(a0)
 22c:	fd06879b          	addiw	a5,a3,-48
 230:	0ff7f793          	zext.b	a5,a5
 234:	4625                	li	a2,9
 236:	02f66963          	bltu	a2,a5,268 <atoi+0x48>
 23a:	872a                	mv	a4,a0
  n = 0;
 23c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23e:	0705                	addi	a4,a4,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb5                	addw	a5,a5,a3
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	00074683          	lbu	a3,0(a4)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	fef671e3          	bgeu	a2,a5,23e <atoi+0x1e>
  return n;
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  n = 0;
 268:	4501                	li	a0,0
 26a:	bfdd                	j	260 <atoi+0x40>

000000000000026c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 274:	02b57563          	bgeu	a0,a1,29e <memmove+0x32>
    while(n-- > 0)
 278:	00c05f63          	blez	a2,296 <memmove+0x2a>
 27c:	1602                	slli	a2,a2,0x20
 27e:	9201                	srli	a2,a2,0x20
 280:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 284:	872a                	mv	a4,a0
      *dst++ = *src++;
 286:	0585                	addi	a1,a1,1
 288:	0705                	addi	a4,a4,1
 28a:	fff5c683          	lbu	a3,-1(a1)
 28e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
    while(n-- > 0)
 29e:	fec05ce3          	blez	a2,296 <memmove+0x2a>
    dst += n;
 2a2:	00c50733          	add	a4,a0,a2
    src += n;
 2a6:	95b2                	add	a1,a1,a2
 2a8:	fff6079b          	addiw	a5,a2,-1
 2ac:	1782                	slli	a5,a5,0x20
 2ae:	9381                	srli	a5,a5,0x20
 2b0:	fff7c793          	not	a5,a5
 2b4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b6:	15fd                	addi	a1,a1,-1
 2b8:	177d                	addi	a4,a4,-1
 2ba:	0005c683          	lbu	a3,0(a1)
 2be:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c2:	fef71ae3          	bne	a4,a5,2b6 <memmove+0x4a>
 2c6:	bfc1                	j	296 <memmove+0x2a>

00000000000002c8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d0:	c61d                	beqz	a2,2fe <memcmp+0x36>
 2d2:	1602                	slli	a2,a2,0x20
 2d4:	9201                	srli	a2,a2,0x20
 2d6:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2da:	00054783          	lbu	a5,0(a0)
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00e79863          	bne	a5,a4,2f2 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2e6:	0505                	addi	a0,a0,1
    p2++;
 2e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ea:	fed518e3          	bne	a0,a3,2da <memcmp+0x12>
  }
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	a019                	j	2f6 <memcmp+0x2e>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  return 0;
 2fe:	4501                	li	a0,0
 300:	bfdd                	j	2f6 <memcmp+0x2e>

0000000000000302 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30a:	00000097          	auipc	ra,0x0
 30e:	f62080e7          	jalr	-158(ra) # 26c <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3d2:	48e1                	li	a7,24
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3da:	48e5                	li	a7,25
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3e2:	48e9                	li	a7,26
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <bind>:
.global bind
bind:
 li a7, SYS_bind
 3ea:	48ed                	li	a7,27
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3f2:	48f5                	li	a7,29
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <listen>:
.global listen
listen:
 li a7, SYS_listen
 3fa:	48f1                	li	a7,28
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <connect>:
.global connect
connect:
 li a7, SYS_connect
 402:	48f9                	li	a7,30
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	1000                	addi	s0,sp,32
 412:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 416:	4605                	li	a2,1
 418:	fef40593          	addi	a1,s0,-17
 41c:	00000097          	auipc	ra,0x0
 420:	f26080e7          	jalr	-218(ra) # 342 <write>
}
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6105                	addi	sp,sp,32
 42a:	8082                	ret

000000000000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	7139                	addi	sp,sp,-64
 42e:	fc06                	sd	ra,56(sp)
 430:	f822                	sd	s0,48(sp)
 432:	f04a                	sd	s2,32(sp)
 434:	ec4e                	sd	s3,24(sp)
 436:	0080                	addi	s0,sp,64
 438:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43a:	cad9                	beqz	a3,4d0 <printint+0xa4>
 43c:	01f5d79b          	srliw	a5,a1,0x1f
 440:	cbc1                	beqz	a5,4d0 <printint+0xa4>
    neg = 1;
    x = -xx;
 442:	40b005bb          	negw	a1,a1
    neg = 1;
 446:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 448:	fc040993          	addi	s3,s0,-64
  neg = 0;
 44c:	86ce                	mv	a3,s3
  i = 0;
 44e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 450:	00000817          	auipc	a6,0x0
 454:	75880813          	addi	a6,a6,1880 # ba8 <digits>
 458:	88ba                	mv	a7,a4
 45a:	0017051b          	addiw	a0,a4,1
 45e:	872a                	mv	a4,a0
 460:	02c5f7bb          	remuw	a5,a1,a2
 464:	1782                	slli	a5,a5,0x20
 466:	9381                	srli	a5,a5,0x20
 468:	97c2                	add	a5,a5,a6
 46a:	0007c783          	lbu	a5,0(a5)
 46e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 472:	87ae                	mv	a5,a1
 474:	02c5d5bb          	divuw	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fcc7ffe3          	bgeu	a5,a2,458 <printint+0x2c>
  if(neg)
 47e:	00030c63          	beqz	t1,496 <printint+0x6a>
    buf[i++] = '-';
 482:	fd050793          	addi	a5,a0,-48
 486:	00878533          	add	a0,a5,s0
 48a:	02d00793          	li	a5,45
 48e:	fef50823          	sb	a5,-16(a0)
 492:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 496:	02e05763          	blez	a4,4c4 <printint+0x98>
 49a:	f426                	sd	s1,40(sp)
 49c:	377d                	addiw	a4,a4,-1
 49e:	00e984b3          	add	s1,s3,a4
 4a2:	19fd                	addi	s3,s3,-1
 4a4:	99ba                	add	s3,s3,a4
 4a6:	1702                	slli	a4,a4,0x20
 4a8:	9301                	srli	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ae:	0004c583          	lbu	a1,0(s1)
 4b2:	854a                	mv	a0,s2
 4b4:	00000097          	auipc	ra,0x0
 4b8:	f56080e7          	jalr	-170(ra) # 40a <putc>
  while(--i >= 0)
 4bc:	14fd                	addi	s1,s1,-1
 4be:	ff3498e3          	bne	s1,s3,4ae <printint+0x82>
 4c2:	74a2                	ld	s1,40(sp)
}
 4c4:	70e2                	ld	ra,56(sp)
 4c6:	7442                	ld	s0,48(sp)
 4c8:	7902                	ld	s2,32(sp)
 4ca:	69e2                	ld	s3,24(sp)
 4cc:	6121                	addi	sp,sp,64
 4ce:	8082                	ret
  neg = 0;
 4d0:	4301                	li	t1,0
 4d2:	bf9d                	j	448 <printint+0x1c>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	715d                	addi	sp,sp,-80
 4d6:	e486                	sd	ra,72(sp)
 4d8:	e0a2                	sd	s0,64(sp)
 4da:	f84a                	sd	s2,48(sp)
 4dc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4de:	0005c903          	lbu	s2,0(a1)
 4e2:	1a090b63          	beqz	s2,698 <vprintf+0x1c4>
 4e6:	fc26                	sd	s1,56(sp)
 4e8:	f44e                	sd	s3,40(sp)
 4ea:	f052                	sd	s4,32(sp)
 4ec:	ec56                	sd	s5,24(sp)
 4ee:	e85a                	sd	s6,16(sp)
 4f0:	e45e                	sd	s7,8(sp)
 4f2:	8aaa                	mv	s5,a0
 4f4:	8bb2                	mv	s7,a2
 4f6:	00158493          	addi	s1,a1,1
  state = 0;
 4fa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fc:	02500a13          	li	s4,37
 500:	4b55                	li	s6,21
 502:	a839                	j	520 <vprintf+0x4c>
        putc(fd, c);
 504:	85ca                	mv	a1,s2
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	f02080e7          	jalr	-254(ra) # 40a <putc>
 510:	a019                	j	516 <vprintf+0x42>
    } else if(state == '%'){
 512:	01498d63          	beq	s3,s4,52c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 516:	0485                	addi	s1,s1,1
 518:	fff4c903          	lbu	s2,-1(s1)
 51c:	16090863          	beqz	s2,68c <vprintf+0x1b8>
    if(state == 0){
 520:	fe0999e3          	bnez	s3,512 <vprintf+0x3e>
      if(c == '%'){
 524:	ff4910e3          	bne	s2,s4,504 <vprintf+0x30>
        state = '%';
 528:	89d2                	mv	s3,s4
 52a:	b7f5                	j	516 <vprintf+0x42>
      if(c == 'd'){
 52c:	13490563          	beq	s2,s4,656 <vprintf+0x182>
 530:	f9d9079b          	addiw	a5,s2,-99
 534:	0ff7f793          	zext.b	a5,a5
 538:	12fb6863          	bltu	s6,a5,668 <vprintf+0x194>
 53c:	f9d9079b          	addiw	a5,s2,-99
 540:	0ff7f713          	zext.b	a4,a5
 544:	12eb6263          	bltu	s6,a4,668 <vprintf+0x194>
 548:	00271793          	slli	a5,a4,0x2
 54c:	00000717          	auipc	a4,0x0
 550:	60470713          	addi	a4,a4,1540 # b50 <ithread_join+0xc2>
 554:	97ba                	add	a5,a5,a4
 556:	439c                	lw	a5,0(a5)
 558:	97ba                	add	a5,a5,a4
 55a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 55c:	008b8913          	addi	s2,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000ba583          	lw	a1,0(s7)
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	ec2080e7          	jalr	-318(ra) # 42c <printint>
 572:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 574:	4981                	li	s3,0
 576:	b745                	j	516 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 578:	008b8913          	addi	s2,s7,8
 57c:	4681                	li	a3,0
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	ea6080e7          	jalr	-346(ra) # 42c <printint>
 58e:	8bca                	mv	s7,s2
      state = 0;
 590:	4981                	li	s3,0
 592:	b751                	j	516 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 594:	008b8913          	addi	s2,s7,8
 598:	4681                	li	a3,0
 59a:	4641                	li	a2,16
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e8a080e7          	jalr	-374(ra) # 42c <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b7a5                	j	516 <vprintf+0x42>
 5b0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b2:	008b8793          	addi	a5,s7,8
 5b6:	8c3e                	mv	s8,a5
 5b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5bc:	03000593          	li	a1,48
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e48080e7          	jalr	-440(ra) # 40a <putc>
  putc(fd, 'x');
 5ca:	07800593          	li	a1,120
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e3a080e7          	jalr	-454(ra) # 40a <putc>
 5d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5da:	00000b97          	auipc	s7,0x0
 5de:	5ceb8b93          	addi	s7,s7,1486 # ba8 <digits>
 5e2:	03c9d793          	srli	a5,s3,0x3c
 5e6:	97de                	add	a5,a5,s7
 5e8:	0007c583          	lbu	a1,0(a5)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e1c080e7          	jalr	-484(ra) # 40a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	397d                	addiw	s2,s2,-1
 5fa:	fe0914e3          	bnez	s2,5e2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5fe:	8be2                	mv	s7,s8
      state = 0;
 600:	4981                	li	s3,0
 602:	6c02                	ld	s8,0(sp)
 604:	bf09                	j	516 <vprintf+0x42>
        s = va_arg(ap, char*);
 606:	008b8993          	addi	s3,s7,8
 60a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 60e:	02090163          	beqz	s2,630 <vprintf+0x15c>
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	c9a5                	beqz	a1,686 <vprintf+0x1b2>
          putc(fd, *s);
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	df0080e7          	jalr	-528(ra) # 40a <putc>
          s++;
 622:	0905                	addi	s2,s2,1
        while(*s != 0){
 624:	00094583          	lbu	a1,0(s2)
 628:	f9e5                	bnez	a1,618 <vprintf+0x144>
        s = va_arg(ap, char*);
 62a:	8bce                	mv	s7,s3
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b5e5                	j	516 <vprintf+0x42>
          s = "(null)";
 630:	00000917          	auipc	s2,0x0
 634:	4e890913          	addi	s2,s2,1256 # b18 <ithread_join+0x8a>
        while(*s != 0){
 638:	02800593          	li	a1,40
 63c:	bff1                	j	618 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 63e:	008b8913          	addi	s2,s7,8
 642:	000bc583          	lbu	a1,0(s7)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dc2080e7          	jalr	-574(ra) # 40a <putc>
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	b5c9                	j	516 <vprintf+0x42>
        putc(fd, c);
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dae080e7          	jalr	-594(ra) # 40a <putc>
      state = 0;
 664:	4981                	li	s3,0
 666:	bd45                	j	516 <vprintf+0x42>
        putc(fd, '%');
 668:	02500593          	li	a1,37
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	d9c080e7          	jalr	-612(ra) # 40a <putc>
        putc(fd, c);
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	d90080e7          	jalr	-624(ra) # 40a <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	bd49                	j	516 <vprintf+0x42>
        s = va_arg(ap, char*);
 686:	8bce                	mv	s7,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	b571                	j	516 <vprintf+0x42>
 68c:	74e2                	ld	s1,56(sp)
 68e:	79a2                	ld	s3,40(sp)
 690:	7a02                	ld	s4,32(sp)
 692:	6ae2                	ld	s5,24(sp)
 694:	6b42                	ld	s6,16(sp)
 696:	6ba2                	ld	s7,8(sp)
    }
  }
}
 698:	60a6                	ld	ra,72(sp)
 69a:	6406                	ld	s0,64(sp)
 69c:	7942                	ld	s2,48(sp)
 69e:	6161                	addi	sp,sp,80
 6a0:	8082                	ret

00000000000006a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a2:	715d                	addi	sp,sp,-80
 6a4:	ec06                	sd	ra,24(sp)
 6a6:	e822                	sd	s0,16(sp)
 6a8:	1000                	addi	s0,sp,32
 6aa:	e010                	sd	a2,0(s0)
 6ac:	e414                	sd	a3,8(s0)
 6ae:	e818                	sd	a4,16(s0)
 6b0:	ec1c                	sd	a5,24(s0)
 6b2:	03043023          	sd	a6,32(s0)
 6b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ba:	8622                	mv	a2,s0
 6bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e14080e7          	jalr	-492(ra) # 4d4 <vprintf>
}
 6c8:	60e2                	ld	ra,24(sp)
 6ca:	6442                	ld	s0,16(sp)
 6cc:	6161                	addi	sp,sp,80
 6ce:	8082                	ret

00000000000006d0 <printf>:

void
printf(const char *fmt, ...)
{
 6d0:	711d                	addi	sp,sp,-96
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e40c                	sd	a1,8(s0)
 6da:	e810                	sd	a2,16(s0)
 6dc:	ec14                	sd	a3,24(s0)
 6de:	f018                	sd	a4,32(s0)
 6e0:	f41c                	sd	a5,40(s0)
 6e2:	03043823          	sd	a6,48(s0)
 6e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ea:	00840613          	addi	a2,s0,8
 6ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f2:	85aa                	mv	a1,a0
 6f4:	4505                	li	a0,1
 6f6:	00000097          	auipc	ra,0x0
 6fa:	dde080e7          	jalr	-546(ra) # 4d4 <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6125                	addi	sp,sp,96
 704:	8082                	ret

0000000000000706 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 706:	1141                	addi	sp,sp,-16
 708:	e406                	sd	ra,8(sp)
 70a:	e022                	sd	s0,0(sp)
 70c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	00001797          	auipc	a5,0x1
 716:	dfe7b783          	ld	a5,-514(a5) # 1510 <freep>
 71a:	a039                	j	728 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	6398                	ld	a4,0(a5)
 71e:	00e7e463          	bltu	a5,a4,726 <free+0x20>
 722:	00e6ea63          	bltu	a3,a4,736 <free+0x30>
{
 726:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	fed7fae3          	bgeu	a5,a3,71c <free+0x16>
 72c:	6398                	ld	a4,0(a5)
 72e:	00e6e463          	bltu	a3,a4,736 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	fee7eae3          	bltu	a5,a4,726 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 736:	ff852583          	lw	a1,-8(a0)
 73a:	6390                	ld	a2,0(a5)
 73c:	02059813          	slli	a6,a1,0x20
 740:	01c85713          	srli	a4,a6,0x1c
 744:	9736                	add	a4,a4,a3
 746:	02e60563          	beq	a2,a4,770 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 74a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 74e:	4790                	lw	a2,8(a5)
 750:	02061593          	slli	a1,a2,0x20
 754:	01c5d713          	srli	a4,a1,0x1c
 758:	973e                	add	a4,a4,a5
 75a:	02e68263          	beq	a3,a4,77e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 75e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 760:	00001717          	auipc	a4,0x1
 764:	daf73823          	sd	a5,-592(a4) # 1510 <freep>
}
 768:	60a2                	ld	ra,8(sp)
 76a:	6402                	ld	s0,0(sp)
 76c:	0141                	addi	sp,sp,16
 76e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 770:	4618                	lw	a4,8(a2)
 772:	9f2d                	addw	a4,a4,a1
 774:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	6398                	ld	a4,0(a5)
 77a:	6310                	ld	a2,0(a4)
 77c:	b7f9                	j	74a <free+0x44>
    p->s.size += bp->s.size;
 77e:	ff852703          	lw	a4,-8(a0)
 782:	9f31                	addw	a4,a4,a2
 784:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 786:	ff053683          	ld	a3,-16(a0)
 78a:	bfd1                	j	75e <free+0x58>

000000000000078c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78c:	7139                	addi	sp,sp,-64
 78e:	fc06                	sd	ra,56(sp)
 790:	f822                	sd	s0,48(sp)
 792:	f04a                	sd	s2,32(sp)
 794:	ec4e                	sd	s3,24(sp)
 796:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 798:	02051993          	slli	s3,a0,0x20
 79c:	0209d993          	srli	s3,s3,0x20
 7a0:	09bd                	addi	s3,s3,15
 7a2:	0049d993          	srli	s3,s3,0x4
 7a6:	2985                	addiw	s3,s3,1
 7a8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7aa:	00001517          	auipc	a0,0x1
 7ae:	d6653503          	ld	a0,-666(a0) # 1510 <freep>
 7b2:	c905                	beqz	a0,7e2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b6:	4798                	lw	a4,8(a5)
 7b8:	09377a63          	bgeu	a4,s3,84c <malloc+0xc0>
 7bc:	f426                	sd	s1,40(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c4:	8a4e                	mv	s4,s3
 7c6:	6705                	lui	a4,0x1
 7c8:	00e9f363          	bgeu	s3,a4,7ce <malloc+0x42>
 7cc:	6a05                	lui	s4,0x1
 7ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d6:	00001497          	auipc	s1,0x1
 7da:	d3a48493          	addi	s1,s1,-710 # 1510 <freep>
  if(p == (char*)-1)
 7de:	5afd                	li	s5,-1
 7e0:	a089                	j	822 <malloc+0x96>
 7e2:	f426                	sd	s1,40(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ea:	00001797          	auipc	a5,0x1
 7ee:	d4678793          	addi	a5,a5,-698 # 1530 <base>
 7f2:	00001717          	auipc	a4,0x1
 7f6:	d0f73f23          	sd	a5,-738(a4) # 1510 <freep>
 7fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 800:	b7d1                	j	7c4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	e118                	sd	a4,0(a0)
 806:	a8b9                	j	864 <malloc+0xd8>
  hp->s.size = nu;
 808:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80c:	0541                	addi	a0,a0,16
 80e:	00000097          	auipc	ra,0x0
 812:	ef8080e7          	jalr	-264(ra) # 706 <free>
  return freep;
 816:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 818:	c135                	beqz	a0,87c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	03277363          	bgeu	a4,s2,844 <malloc+0xb8>
    if(p == freep)
 822:	6098                	ld	a4,0(s1)
 824:	853e                	mv	a0,a5
 826:	fef71ae3          	bne	a4,a5,81a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 82a:	8552                	mv	a0,s4
 82c:	00000097          	auipc	ra,0x0
 830:	b7e080e7          	jalr	-1154(ra) # 3aa <sbrk>
  if(p == (char*)-1)
 834:	fd551ae3          	bne	a0,s5,808 <malloc+0x7c>
        return 0;
 838:	4501                	li	a0,0
 83a:	74a2                	ld	s1,40(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
 842:	a03d                	j	870 <malloc+0xe4>
 844:	74a2                	ld	s1,40(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 84c:	fae90be3          	beq	s2,a4,802 <malloc+0x76>
        p->s.size -= nunits;
 850:	4137073b          	subw	a4,a4,s3
 854:	c798                	sw	a4,8(a5)
        p += p->s.size;
 856:	02071693          	slli	a3,a4,0x20
 85a:	01c6d713          	srli	a4,a3,0x1c
 85e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 860:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 864:	00001717          	auipc	a4,0x1
 868:	caa73623          	sd	a0,-852(a4) # 1510 <freep>
      return (void*)(p + 1);
 86c:	01078513          	addi	a0,a5,16
  }
}
 870:	70e2                	ld	ra,56(sp)
 872:	7442                	ld	s0,48(sp)
 874:	7902                	ld	s2,32(sp)
 876:	69e2                	ld	s3,24(sp)
 878:	6121                	addi	sp,sp,64
 87a:	8082                	ret
 87c:	74a2                	ld	s1,40(sp)
 87e:	6a42                	ld	s4,16(sp)
 880:	6aa2                	ld	s5,8(sp)
 882:	6b02                	ld	s6,0(sp)
 884:	b7f5                	j	870 <malloc+0xe4>

0000000000000886 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 886:	1141                	addi	sp,sp,-16
 888:	e406                	sd	ra,8(sp)
 88a:	e022                	sd	s0,0(sp)
 88c:	0800                	addi	s0,sp,16
  thread_exit(status);
 88e:	2501                	sext.w	a0,a0
 890:	00000097          	auipc	ra,0x0
 894:	b4a080e7          	jalr	-1206(ra) # 3da <thread_exit>
}
 898:	60a2                	ld	ra,8(sp)
 89a:	6402                	ld	s0,0(sp)
 89c:	0141                	addi	sp,sp,16
 89e:	8082                	ret

00000000000008a0 <free_stacks>:
int free_stacks() {
 8a0:	7179                	addi	sp,sp,-48
 8a2:	f406                	sd	ra,40(sp)
 8a4:	f022                	sd	s0,32(sp)
 8a6:	ec26                	sd	s1,24(sp)
 8a8:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8aa:	00001797          	auipc	a5,0x1
 8ae:	c767a783          	lw	a5,-906(a5) # 1520 <num_threads>
 8b2:	04f05063          	blez	a5,8f2 <free_stacks+0x52>
 8b6:	e84a                	sd	s2,16(sp)
 8b8:	e44e                	sd	s3,8(sp)
 8ba:	4481                	li	s1,0
    free(stacks[i]);
 8bc:	00001997          	auipc	s3,0x1
 8c0:	c5c98993          	addi	s3,s3,-932 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8c4:	00001917          	auipc	s2,0x1
 8c8:	c5c90913          	addi	s2,s2,-932 # 1520 <num_threads>
    free(stacks[i]);
 8cc:	0009b783          	ld	a5,0(s3)
 8d0:	00349713          	slli	a4,s1,0x3
 8d4:	97ba                	add	a5,a5,a4
 8d6:	6388                	ld	a0,0(a5)
 8d8:	00000097          	auipc	ra,0x0
 8dc:	e2e080e7          	jalr	-466(ra) # 706 <free>
  for (int i = 0; i < num_threads; i++) {
 8e0:	0485                	addi	s1,s1,1
 8e2:	00092703          	lw	a4,0(s2)
 8e6:	0004879b          	sext.w	a5,s1
 8ea:	fee7c1e3          	blt	a5,a4,8cc <free_stacks+0x2c>
 8ee:	6942                	ld	s2,16(sp)
 8f0:	69a2                	ld	s3,8(sp)
  free(stacks);
 8f2:	00001497          	auipc	s1,0x1
 8f6:	c2648493          	addi	s1,s1,-986 # 1518 <stacks>
 8fa:	6088                	ld	a0,0(s1)
 8fc:	00000097          	auipc	ra,0x0
 900:	e0a080e7          	jalr	-502(ra) # 706 <free>
  stacks = 0;
 904:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 908:	00001797          	auipc	a5,0x1
 90c:	c007ac23          	sw	zero,-1000(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 910:	47a1                	li	a5,8
 912:	00001717          	auipc	a4,0x1
 916:	bef72723          	sw	a5,-1042(a4) # 1500 <max_stacks>
  threads_done = 0;
 91a:	00001797          	auipc	a5,0x1
 91e:	c007a523          	sw	zero,-1014(a5) # 1524 <threads_done>
}
 922:	4501                	li	a0,0
 924:	70a2                	ld	ra,40(sp)
 926:	7402                	ld	s0,32(sp)
 928:	64e2                	ld	s1,24(sp)
 92a:	6145                	addi	sp,sp,48
 92c:	8082                	ret

000000000000092e <expand_num_threads>:
int expand_num_threads() {
 92e:	1101                	addi	sp,sp,-32
 930:	ec06                	sd	ra,24(sp)
 932:	e822                	sd	s0,16(sp)
 934:	e426                	sd	s1,8(sp)
 936:	e04a                	sd	s2,0(sp)
 938:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 93a:	00001797          	auipc	a5,0x1
 93e:	bc678793          	addi	a5,a5,-1082 # 1500 <max_stacks>
 942:	4388                	lw	a0,0(a5)
 944:	0015151b          	slliw	a0,a0,0x1
 948:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 94a:	0035151b          	slliw	a0,a0,0x3
 94e:	00000097          	auipc	ra,0x0
 952:	e3e080e7          	jalr	-450(ra) # 78c <malloc>
 956:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 958:	00001617          	auipc	a2,0x1
 95c:	bc862603          	lw	a2,-1080(a2) # 1520 <num_threads>
 960:	00001497          	auipc	s1,0x1
 964:	bb848493          	addi	s1,s1,-1096 # 1518 <stacks>
 968:	0036161b          	slliw	a2,a2,0x3
 96c:	608c                	ld	a1,0(s1)
 96e:	00000097          	auipc	ra,0x0
 972:	8fe080e7          	jalr	-1794(ra) # 26c <memmove>
  free(stacks);
 976:	6088                	ld	a0,0(s1)
 978:	00000097          	auipc	ra,0x0
 97c:	d8e080e7          	jalr	-626(ra) # 706 <free>
  stacks = new_stacks;
 980:	0124b023          	sd	s2,0(s1)
}
 984:	4501                	li	a0,0
 986:	60e2                	ld	ra,24(sp)
 988:	6442                	ld	s0,16(sp)
 98a:	64a2                	ld	s1,8(sp)
 98c:	6902                	ld	s2,0(sp)
 98e:	6105                	addi	sp,sp,32
 990:	8082                	ret

0000000000000992 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 992:	7179                	addi	sp,sp,-48
 994:	f406                	sd	ra,40(sp)
 996:	f022                	sd	s0,32(sp)
 998:	e84a                	sd	s2,16(sp)
 99a:	e44e                	sd	s3,8(sp)
 99c:	1800                	addi	s0,sp,48
 99e:	892a                	mv	s2,a0
 9a0:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9a2:	00001797          	auipc	a5,0x1
 9a6:	b767b783          	ld	a5,-1162(a5) # 1518 <stacks>
 9aa:	c3d9                	beqz	a5,a30 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9ac:	00001797          	auipc	a5,0x1
 9b0:	b547a783          	lw	a5,-1196(a5) # 1500 <max_stacks>
 9b4:	00001717          	auipc	a4,0x1
 9b8:	b6c72703          	lw	a4,-1172(a4) # 1520 <num_threads>
 9bc:	0af71463          	bne	a4,a5,a64 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9c0:	04000713          	li	a4,64
 9c4:	08e78563          	beq	a5,a4,a4e <ithread_create+0xbc>
 9c8:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9ca:	00000097          	auipc	ra,0x0
 9ce:	f64080e7          	jalr	-156(ra) # 92e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9d2:	6505                	lui	a0,0x1
 9d4:	00000097          	auipc	ra,0x0
 9d8:	db8080e7          	jalr	-584(ra) # 78c <malloc>
 9dc:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9de:	00001717          	auipc	a4,0x1
 9e2:	b4272703          	lw	a4,-1214(a4) # 1520 <num_threads>
 9e6:	070e                	slli	a4,a4,0x3
 9e8:	00001797          	auipc	a5,0x1
 9ec:	b307b783          	ld	a5,-1232(a5) # 1518 <stacks>
 9f0:	97ba                	add	a5,a5,a4
 9f2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9f4:	00000697          	auipc	a3,0x0
 9f8:	e9268693          	addi	a3,a3,-366 # 886 <ithread_exit>
 9fc:	862a                	mv	a2,a0
 9fe:	85ce                	mv	a1,s3
 a00:	854a                	mv	a0,s2
 a02:	00000097          	auipc	ra,0x0
 a06:	9c8080e7          	jalr	-1592(ra) # 3ca <create_thread>
 a0a:	892a                	mv	s2,a0
  if (res != -1) {
 a0c:	57fd                	li	a5,-1
 a0e:	04f50d63          	beq	a0,a5,a68 <ithread_create+0xd6>
    num_threads++;
 a12:	00001717          	auipc	a4,0x1
 a16:	b0e70713          	addi	a4,a4,-1266 # 1520 <num_threads>
 a1a:	431c                	lw	a5,0(a4)
 a1c:	2785                	addiw	a5,a5,1
 a1e:	c31c                	sw	a5,0(a4)
 a20:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a22:	854a                	mv	a0,s2
 a24:	70a2                	ld	ra,40(sp)
 a26:	7402                	ld	s0,32(sp)
 a28:	6942                	ld	s2,16(sp)
 a2a:	69a2                	ld	s3,8(sp)
 a2c:	6145                	addi	sp,sp,48
 a2e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a30:	00001517          	auipc	a0,0x1
 a34:	ad052503          	lw	a0,-1328(a0) # 1500 <max_stacks>
 a38:	0035151b          	slliw	a0,a0,0x3
 a3c:	00000097          	auipc	ra,0x0
 a40:	d50080e7          	jalr	-688(ra) # 78c <malloc>
 a44:	00001797          	auipc	a5,0x1
 a48:	aca7ba23          	sd	a0,-1324(a5) # 1518 <stacks>
 a4c:	b785                	j	9ac <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a4e:	00000517          	auipc	a0,0x0
 a52:	0d250513          	addi	a0,a0,210 # b20 <ithread_join+0x92>
 a56:	00000097          	auipc	ra,0x0
 a5a:	c7a080e7          	jalr	-902(ra) # 6d0 <printf>
      return -1;
 a5e:	57fd                	li	a5,-1
 a60:	893e                	mv	s2,a5
 a62:	b7c1                	j	a22 <ithread_create+0x90>
 a64:	ec26                	sd	s1,24(sp)
 a66:	b7b5                	j	9d2 <ithread_create+0x40>
    free(stack_ptr);
 a68:	8526                	mv	a0,s1
 a6a:	00000097          	auipc	ra,0x0
 a6e:	c9c080e7          	jalr	-868(ra) # 706 <free>
    stacks[num_threads] = 0;
 a72:	00001717          	auipc	a4,0x1
 a76:	aae72703          	lw	a4,-1362(a4) # 1520 <num_threads>
 a7a:	070e                	slli	a4,a4,0x3
 a7c:	00001797          	auipc	a5,0x1
 a80:	a9c7b783          	ld	a5,-1380(a5) # 1518 <stacks>
 a84:	97ba                	add	a5,a5,a4
 a86:	0007b023          	sd	zero,0(a5)
 a8a:	64e2                	ld	s1,24(sp)
 a8c:	bf59                	j	a22 <ithread_create+0x90>

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
 aa2:	934080e7          	jalr	-1740(ra) # 3d2 <join_thread>
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
 ad0:	dd4080e7          	jalr	-556(ra) # 8a0 <free_stacks>
 ad4:	b7f5                	j	ac0 <ithread_join+0x32>
