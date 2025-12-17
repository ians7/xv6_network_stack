
user/_rm:     file format elf64-littleriscv


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
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	34a080e7          	jalr	842(ra) # 372 <unlink>
  30:	02054a63          	bltz	a0,64 <main+0x64>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2e6080e7          	jalr	742(ra) # 322 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  48:	00001597          	auipc	a1,0x1
  4c:	ab858593          	addi	a1,a1,-1352 # b00 <ithread_join+0x4c>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	676080e7          	jalr	1654(ra) # 6c8 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2c6080e7          	jalr	710(ra) # 322 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  64:	6090                	ld	a2,0(s1)
  66:	00001597          	auipc	a1,0x1
  6a:	ab258593          	addi	a1,a1,-1358 # b18 <ithread_join+0x64>
  6e:	4509                	li	a0,2
  70:	00000097          	auipc	ra,0x0
  74:	658080e7          	jalr	1624(ra) # 6c8 <fprintf>
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

000000000000040a <send>:
.global send
send:
 li a7, SYS_send
 40a:	48fd                	li	a7,31
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <recv>:
.global recv
recv:
 li a7, SYS_recv
 412:	02000893          	li	a7,32
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 41c:	02100893          	li	a7,33
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 426:	02200893          	li	a7,34
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 430:	1101                	addi	sp,sp,-32
 432:	ec06                	sd	ra,24(sp)
 434:	e822                	sd	s0,16(sp)
 436:	1000                	addi	s0,sp,32
 438:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43c:	4605                	li	a2,1
 43e:	fef40593          	addi	a1,s0,-17
 442:	00000097          	auipc	ra,0x0
 446:	f00080e7          	jalr	-256(ra) # 342 <write>
}
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6105                	addi	sp,sp,32
 450:	8082                	ret

0000000000000452 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 452:	7139                	addi	sp,sp,-64
 454:	fc06                	sd	ra,56(sp)
 456:	f822                	sd	s0,48(sp)
 458:	f04a                	sd	s2,32(sp)
 45a:	ec4e                	sd	s3,24(sp)
 45c:	0080                	addi	s0,sp,64
 45e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 460:	cad9                	beqz	a3,4f6 <printint+0xa4>
 462:	01f5d79b          	srliw	a5,a1,0x1f
 466:	cbc1                	beqz	a5,4f6 <printint+0xa4>
    neg = 1;
    x = -xx;
 468:	40b005bb          	negw	a1,a1
    neg = 1;
 46c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 46e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 472:	86ce                	mv	a3,s3
  i = 0;
 474:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 476:	00000817          	auipc	a6,0x0
 47a:	75280813          	addi	a6,a6,1874 # bc8 <digits>
 47e:	88ba                	mv	a7,a4
 480:	0017051b          	addiw	a0,a4,1
 484:	872a                	mv	a4,a0
 486:	02c5f7bb          	remuw	a5,a1,a2
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	97c2                	add	a5,a5,a6
 490:	0007c783          	lbu	a5,0(a5)
 494:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 498:	87ae                	mv	a5,a1
 49a:	02c5d5bb          	divuw	a1,a1,a2
 49e:	0685                	addi	a3,a3,1
 4a0:	fcc7ffe3          	bgeu	a5,a2,47e <printint+0x2c>
  if(neg)
 4a4:	00030c63          	beqz	t1,4bc <printint+0x6a>
    buf[i++] = '-';
 4a8:	fd050793          	addi	a5,a0,-48
 4ac:	00878533          	add	a0,a5,s0
 4b0:	02d00793          	li	a5,45
 4b4:	fef50823          	sb	a5,-16(a0)
 4b8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4bc:	02e05763          	blez	a4,4ea <printint+0x98>
 4c0:	f426                	sd	s1,40(sp)
 4c2:	377d                	addiw	a4,a4,-1
 4c4:	00e984b3          	add	s1,s3,a4
 4c8:	19fd                	addi	s3,s3,-1
 4ca:	99ba                	add	s3,s3,a4
 4cc:	1702                	slli	a4,a4,0x20
 4ce:	9301                	srli	a4,a4,0x20
 4d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d4:	0004c583          	lbu	a1,0(s1)
 4d8:	854a                	mv	a0,s2
 4da:	00000097          	auipc	ra,0x0
 4de:	f56080e7          	jalr	-170(ra) # 430 <putc>
  while(--i >= 0)
 4e2:	14fd                	addi	s1,s1,-1
 4e4:	ff3498e3          	bne	s1,s3,4d4 <printint+0x82>
 4e8:	74a2                	ld	s1,40(sp)
}
 4ea:	70e2                	ld	ra,56(sp)
 4ec:	7442                	ld	s0,48(sp)
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
 4f2:	6121                	addi	sp,sp,64
 4f4:	8082                	ret
  neg = 0;
 4f6:	4301                	li	t1,0
 4f8:	bf9d                	j	46e <printint+0x1c>

00000000000004fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fa:	715d                	addi	sp,sp,-80
 4fc:	e486                	sd	ra,72(sp)
 4fe:	e0a2                	sd	s0,64(sp)
 500:	f84a                	sd	s2,48(sp)
 502:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 504:	0005c903          	lbu	s2,0(a1)
 508:	1a090b63          	beqz	s2,6be <vprintf+0x1c4>
 50c:	fc26                	sd	s1,56(sp)
 50e:	f44e                	sd	s3,40(sp)
 510:	f052                	sd	s4,32(sp)
 512:	ec56                	sd	s5,24(sp)
 514:	e85a                	sd	s6,16(sp)
 516:	e45e                	sd	s7,8(sp)
 518:	8aaa                	mv	s5,a0
 51a:	8bb2                	mv	s7,a2
 51c:	00158493          	addi	s1,a1,1
  state = 0;
 520:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 522:	02500a13          	li	s4,37
 526:	4b55                	li	s6,21
 528:	a839                	j	546 <vprintf+0x4c>
        putc(fd, c);
 52a:	85ca                	mv	a1,s2
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	f02080e7          	jalr	-254(ra) # 430 <putc>
 536:	a019                	j	53c <vprintf+0x42>
    } else if(state == '%'){
 538:	01498d63          	beq	s3,s4,552 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 53c:	0485                	addi	s1,s1,1
 53e:	fff4c903          	lbu	s2,-1(s1)
 542:	16090863          	beqz	s2,6b2 <vprintf+0x1b8>
    if(state == 0){
 546:	fe0999e3          	bnez	s3,538 <vprintf+0x3e>
      if(c == '%'){
 54a:	ff4910e3          	bne	s2,s4,52a <vprintf+0x30>
        state = '%';
 54e:	89d2                	mv	s3,s4
 550:	b7f5                	j	53c <vprintf+0x42>
      if(c == 'd'){
 552:	13490563          	beq	s2,s4,67c <vprintf+0x182>
 556:	f9d9079b          	addiw	a5,s2,-99
 55a:	0ff7f793          	zext.b	a5,a5
 55e:	12fb6863          	bltu	s6,a5,68e <vprintf+0x194>
 562:	f9d9079b          	addiw	a5,s2,-99
 566:	0ff7f713          	zext.b	a4,a5
 56a:	12eb6263          	bltu	s6,a4,68e <vprintf+0x194>
 56e:	00271793          	slli	a5,a4,0x2
 572:	00000717          	auipc	a4,0x0
 576:	5fe70713          	addi	a4,a4,1534 # b70 <ithread_join+0xbc>
 57a:	97ba                	add	a5,a5,a4
 57c:	439c                	lw	a5,0(a5)
 57e:	97ba                	add	a5,a5,a4
 580:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 582:	008b8913          	addi	s2,s7,8
 586:	4685                	li	a3,1
 588:	4629                	li	a2,10
 58a:	000ba583          	lw	a1,0(s7)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	ec2080e7          	jalr	-318(ra) # 452 <printint>
 598:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b745                	j	53c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	ea6080e7          	jalr	-346(ra) # 452 <printint>
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b751                	j	53c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e8a080e7          	jalr	-374(ra) # 452 <printint>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b7a5                	j	53c <vprintf+0x42>
 5d6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5d8:	008b8793          	addi	a5,s7,8
 5dc:	8c3e                	mv	s8,a5
 5de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e2:	03000593          	li	a1,48
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e48080e7          	jalr	-440(ra) # 430 <putc>
  putc(fd, 'x');
 5f0:	07800593          	li	a1,120
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e3a080e7          	jalr	-454(ra) # 430 <putc>
 5fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 600:	00000b97          	auipc	s7,0x0
 604:	5c8b8b93          	addi	s7,s7,1480 # bc8 <digits>
 608:	03c9d793          	srli	a5,s3,0x3c
 60c:	97de                	add	a5,a5,s7
 60e:	0007c583          	lbu	a1,0(a5)
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e1c080e7          	jalr	-484(ra) # 430 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61c:	0992                	slli	s3,s3,0x4
 61e:	397d                	addiw	s2,s2,-1
 620:	fe0914e3          	bnez	s2,608 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 624:	8be2                	mv	s7,s8
      state = 0;
 626:	4981                	li	s3,0
 628:	6c02                	ld	s8,0(sp)
 62a:	bf09                	j	53c <vprintf+0x42>
        s = va_arg(ap, char*);
 62c:	008b8993          	addi	s3,s7,8
 630:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 634:	02090163          	beqz	s2,656 <vprintf+0x15c>
        while(*s != 0){
 638:	00094583          	lbu	a1,0(s2)
 63c:	c9a5                	beqz	a1,6ac <vprintf+0x1b2>
          putc(fd, *s);
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	df0080e7          	jalr	-528(ra) # 430 <putc>
          s++;
 648:	0905                	addi	s2,s2,1
        while(*s != 0){
 64a:	00094583          	lbu	a1,0(s2)
 64e:	f9e5                	bnez	a1,63e <vprintf+0x144>
        s = va_arg(ap, char*);
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	b5e5                	j	53c <vprintf+0x42>
          s = "(null)";
 656:	00000917          	auipc	s2,0x0
 65a:	4e290913          	addi	s2,s2,1250 # b38 <ithread_join+0x84>
        while(*s != 0){
 65e:	02800593          	li	a1,40
 662:	bff1                	j	63e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 664:	008b8913          	addi	s2,s7,8
 668:	000bc583          	lbu	a1,0(s7)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	dc2080e7          	jalr	-574(ra) # 430 <putc>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b5c9                	j	53c <vprintf+0x42>
        putc(fd, c);
 67c:	02500593          	li	a1,37
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	dae080e7          	jalr	-594(ra) # 430 <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bd45                	j	53c <vprintf+0x42>
        putc(fd, '%');
 68e:	02500593          	li	a1,37
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d9c080e7          	jalr	-612(ra) # 430 <putc>
        putc(fd, c);
 69c:	85ca                	mv	a1,s2
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	d90080e7          	jalr	-624(ra) # 430 <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bd49                	j	53c <vprintf+0x42>
        s = va_arg(ap, char*);
 6ac:	8bce                	mv	s7,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b571                	j	53c <vprintf+0x42>
 6b2:	74e2                	ld	s1,56(sp)
 6b4:	79a2                	ld	s3,40(sp)
 6b6:	7a02                	ld	s4,32(sp)
 6b8:	6ae2                	ld	s5,24(sp)
 6ba:	6b42                	ld	s6,16(sp)
 6bc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6be:	60a6                	ld	ra,72(sp)
 6c0:	6406                	ld	s0,64(sp)
 6c2:	7942                	ld	s2,48(sp)
 6c4:	6161                	addi	sp,sp,80
 6c6:	8082                	ret

00000000000006c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c8:	715d                	addi	sp,sp,-80
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e010                	sd	a2,0(s0)
 6d2:	e414                	sd	a3,8(s0)
 6d4:	e818                	sd	a4,16(s0)
 6d6:	ec1c                	sd	a5,24(s0)
 6d8:	03043023          	sd	a6,32(s0)
 6dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	8622                	mv	a2,s0
 6e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e6:	00000097          	auipc	ra,0x0
 6ea:	e14080e7          	jalr	-492(ra) # 4fa <vprintf>
}
 6ee:	60e2                	ld	ra,24(sp)
 6f0:	6442                	ld	s0,16(sp)
 6f2:	6161                	addi	sp,sp,80
 6f4:	8082                	ret

00000000000006f6 <printf>:

void
printf(const char *fmt, ...)
{
 6f6:	711d                	addi	sp,sp,-96
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	e822                	sd	s0,16(sp)
 6fc:	1000                	addi	s0,sp,32
 6fe:	e40c                	sd	a1,8(s0)
 700:	e810                	sd	a2,16(s0)
 702:	ec14                	sd	a3,24(s0)
 704:	f018                	sd	a4,32(s0)
 706:	f41c                	sd	a5,40(s0)
 708:	03043823          	sd	a6,48(s0)
 70c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	00840613          	addi	a2,s0,8
 714:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 718:	85aa                	mv	a1,a0
 71a:	4505                	li	a0,1
 71c:	00000097          	auipc	ra,0x0
 720:	dde080e7          	jalr	-546(ra) # 4fa <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6125                	addi	sp,sp,96
 72a:	8082                	ret

000000000000072c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72c:	1141                	addi	sp,sp,-16
 72e:	e406                	sd	ra,8(sp)
 730:	e022                	sd	s0,0(sp)
 732:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 734:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	00001797          	auipc	a5,0x1
 73c:	dd87b783          	ld	a5,-552(a5) # 1510 <freep>
 740:	a039                	j	74e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	6398                	ld	a4,0(a5)
 744:	00e7e463          	bltu	a5,a4,74c <free+0x20>
 748:	00e6ea63          	bltu	a3,a4,75c <free+0x30>
{
 74c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	fed7fae3          	bgeu	a5,a3,742 <free+0x16>
 752:	6398                	ld	a4,0(a5)
 754:	00e6e463          	bltu	a3,a4,75c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	fee7eae3          	bltu	a5,a4,74c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 75c:	ff852583          	lw	a1,-8(a0)
 760:	6390                	ld	a2,0(a5)
 762:	02059813          	slli	a6,a1,0x20
 766:	01c85713          	srli	a4,a6,0x1c
 76a:	9736                	add	a4,a4,a3
 76c:	02e60563          	beq	a2,a4,796 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 774:	4790                	lw	a2,8(a5)
 776:	02061593          	slli	a1,a2,0x20
 77a:	01c5d713          	srli	a4,a1,0x1c
 77e:	973e                	add	a4,a4,a5
 780:	02e68263          	beq	a3,a4,7a4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 784:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 786:	00001717          	auipc	a4,0x1
 78a:	d8f73523          	sd	a5,-630(a4) # 1510 <freep>
}
 78e:	60a2                	ld	ra,8(sp)
 790:	6402                	ld	s0,0(sp)
 792:	0141                	addi	sp,sp,16
 794:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 796:	4618                	lw	a4,8(a2)
 798:	9f2d                	addw	a4,a4,a1
 79a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	6310                	ld	a2,0(a4)
 7a2:	b7f9                	j	770 <free+0x44>
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9f31                	addw	a4,a4,a2
 7aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053683          	ld	a3,-16(a0)
 7b0:	bfd1                	j	784 <free+0x58>

00000000000007b2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b2:	7139                	addi	sp,sp,-64
 7b4:	fc06                	sd	ra,56(sp)
 7b6:	f822                	sd	s0,48(sp)
 7b8:	f04a                	sd	s2,32(sp)
 7ba:	ec4e                	sd	s3,24(sp)
 7bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	02051993          	slli	s3,a0,0x20
 7c2:	0209d993          	srli	s3,s3,0x20
 7c6:	09bd                	addi	s3,s3,15
 7c8:	0049d993          	srli	s3,s3,0x4
 7cc:	2985                	addiw	s3,s3,1
 7ce:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7d0:	00001517          	auipc	a0,0x1
 7d4:	d4053503          	ld	a0,-704(a0) # 1510 <freep>
 7d8:	c905                	beqz	a0,808 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7dc:	4798                	lw	a4,8(a5)
 7de:	09377a63          	bgeu	a4,s3,872 <malloc+0xc0>
 7e2:	f426                	sd	s1,40(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ea:	8a4e                	mv	s4,s3
 7ec:	6705                	lui	a4,0x1
 7ee:	00e9f363          	bgeu	s3,a4,7f4 <malloc+0x42>
 7f2:	6a05                	lui	s4,0x1
 7f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fc:	00001497          	auipc	s1,0x1
 800:	d1448493          	addi	s1,s1,-748 # 1510 <freep>
  if(p == (char*)-1)
 804:	5afd                	li	s5,-1
 806:	a089                	j	848 <malloc+0x96>
 808:	f426                	sd	s1,40(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 810:	00001797          	auipc	a5,0x1
 814:	d2078793          	addi	a5,a5,-736 # 1530 <base>
 818:	00001717          	auipc	a4,0x1
 81c:	cef73c23          	sd	a5,-776(a4) # 1510 <freep>
 820:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 822:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 826:	b7d1                	j	7ea <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	e118                	sd	a4,0(a0)
 82c:	a8b9                	j	88a <malloc+0xd8>
  hp->s.size = nu;
 82e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 832:	0541                	addi	a0,a0,16
 834:	00000097          	auipc	ra,0x0
 838:	ef8080e7          	jalr	-264(ra) # 72c <free>
  return freep;
 83c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 83e:	c135                	beqz	a0,8a2 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	03277363          	bgeu	a4,s2,86a <malloc+0xb8>
    if(p == freep)
 848:	6098                	ld	a4,0(s1)
 84a:	853e                	mv	a0,a5
 84c:	fef71ae3          	bne	a4,a5,840 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 850:	8552                	mv	a0,s4
 852:	00000097          	auipc	ra,0x0
 856:	b58080e7          	jalr	-1192(ra) # 3aa <sbrk>
  if(p == (char*)-1)
 85a:	fd551ae3          	bne	a0,s5,82e <malloc+0x7c>
        return 0;
 85e:	4501                	li	a0,0
 860:	74a2                	ld	s1,40(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
 868:	a03d                	j	896 <malloc+0xe4>
 86a:	74a2                	ld	s1,40(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 872:	fae90be3          	beq	s2,a4,828 <malloc+0x76>
        p->s.size -= nunits;
 876:	4137073b          	subw	a4,a4,s3
 87a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87c:	02071693          	slli	a3,a4,0x20
 880:	01c6d713          	srli	a4,a3,0x1c
 884:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 886:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88a:	00001717          	auipc	a4,0x1
 88e:	c8a73323          	sd	a0,-890(a4) # 1510 <freep>
      return (void*)(p + 1);
 892:	01078513          	addi	a0,a5,16
  }
}
 896:	70e2                	ld	ra,56(sp)
 898:	7442                	ld	s0,48(sp)
 89a:	7902                	ld	s2,32(sp)
 89c:	69e2                	ld	s3,24(sp)
 89e:	6121                	addi	sp,sp,64
 8a0:	8082                	ret
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	b7f5                	j	896 <malloc+0xe4>

00000000000008ac <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8ac:	1141                	addi	sp,sp,-16
 8ae:	e406                	sd	ra,8(sp)
 8b0:	e022                	sd	s0,0(sp)
 8b2:	0800                	addi	s0,sp,16
  thread_exit(status);
 8b4:	2501                	sext.w	a0,a0
 8b6:	00000097          	auipc	ra,0x0
 8ba:	b24080e7          	jalr	-1244(ra) # 3da <thread_exit>
}
 8be:	60a2                	ld	ra,8(sp)
 8c0:	6402                	ld	s0,0(sp)
 8c2:	0141                	addi	sp,sp,16
 8c4:	8082                	ret

00000000000008c6 <free_stacks>:
int free_stacks() {
 8c6:	7179                	addi	sp,sp,-48
 8c8:	f406                	sd	ra,40(sp)
 8ca:	f022                	sd	s0,32(sp)
 8cc:	ec26                	sd	s1,24(sp)
 8ce:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8d0:	00001797          	auipc	a5,0x1
 8d4:	c507a783          	lw	a5,-944(a5) # 1520 <num_threads>
 8d8:	04f05063          	blez	a5,918 <free_stacks+0x52>
 8dc:	e84a                	sd	s2,16(sp)
 8de:	e44e                	sd	s3,8(sp)
 8e0:	4481                	li	s1,0
    free(stacks[i]);
 8e2:	00001997          	auipc	s3,0x1
 8e6:	c3698993          	addi	s3,s3,-970 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8ea:	00001917          	auipc	s2,0x1
 8ee:	c3690913          	addi	s2,s2,-970 # 1520 <num_threads>
    free(stacks[i]);
 8f2:	0009b783          	ld	a5,0(s3)
 8f6:	00349713          	slli	a4,s1,0x3
 8fa:	97ba                	add	a5,a5,a4
 8fc:	6388                	ld	a0,0(a5)
 8fe:	00000097          	auipc	ra,0x0
 902:	e2e080e7          	jalr	-466(ra) # 72c <free>
  for (int i = 0; i < num_threads; i++) {
 906:	0485                	addi	s1,s1,1
 908:	00092703          	lw	a4,0(s2)
 90c:	0004879b          	sext.w	a5,s1
 910:	fee7c1e3          	blt	a5,a4,8f2 <free_stacks+0x2c>
 914:	6942                	ld	s2,16(sp)
 916:	69a2                	ld	s3,8(sp)
  free(stacks);
 918:	00001497          	auipc	s1,0x1
 91c:	c0048493          	addi	s1,s1,-1024 # 1518 <stacks>
 920:	6088                	ld	a0,0(s1)
 922:	00000097          	auipc	ra,0x0
 926:	e0a080e7          	jalr	-502(ra) # 72c <free>
  stacks = 0;
 92a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 92e:	00001797          	auipc	a5,0x1
 932:	be07a923          	sw	zero,-1038(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 936:	47a1                	li	a5,8
 938:	00001717          	auipc	a4,0x1
 93c:	bcf72423          	sw	a5,-1080(a4) # 1500 <max_stacks>
  threads_done = 0;
 940:	00001797          	auipc	a5,0x1
 944:	be07a223          	sw	zero,-1052(a5) # 1524 <threads_done>
}
 948:	4501                	li	a0,0
 94a:	70a2                	ld	ra,40(sp)
 94c:	7402                	ld	s0,32(sp)
 94e:	64e2                	ld	s1,24(sp)
 950:	6145                	addi	sp,sp,48
 952:	8082                	ret

0000000000000954 <expand_num_threads>:
int expand_num_threads() {
 954:	1101                	addi	sp,sp,-32
 956:	ec06                	sd	ra,24(sp)
 958:	e822                	sd	s0,16(sp)
 95a:	e426                	sd	s1,8(sp)
 95c:	e04a                	sd	s2,0(sp)
 95e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 960:	00001797          	auipc	a5,0x1
 964:	ba078793          	addi	a5,a5,-1120 # 1500 <max_stacks>
 968:	4388                	lw	a0,0(a5)
 96a:	0015151b          	slliw	a0,a0,0x1
 96e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 970:	0035151b          	slliw	a0,a0,0x3
 974:	00000097          	auipc	ra,0x0
 978:	e3e080e7          	jalr	-450(ra) # 7b2 <malloc>
 97c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 97e:	00001617          	auipc	a2,0x1
 982:	ba262603          	lw	a2,-1118(a2) # 1520 <num_threads>
 986:	00001497          	auipc	s1,0x1
 98a:	b9248493          	addi	s1,s1,-1134 # 1518 <stacks>
 98e:	0036161b          	slliw	a2,a2,0x3
 992:	608c                	ld	a1,0(s1)
 994:	00000097          	auipc	ra,0x0
 998:	8d8080e7          	jalr	-1832(ra) # 26c <memmove>
  free(stacks);
 99c:	6088                	ld	a0,0(s1)
 99e:	00000097          	auipc	ra,0x0
 9a2:	d8e080e7          	jalr	-626(ra) # 72c <free>
  stacks = new_stacks;
 9a6:	0124b023          	sd	s2,0(s1)
}
 9aa:	4501                	li	a0,0
 9ac:	60e2                	ld	ra,24(sp)
 9ae:	6442                	ld	s0,16(sp)
 9b0:	64a2                	ld	s1,8(sp)
 9b2:	6902                	ld	s2,0(sp)
 9b4:	6105                	addi	sp,sp,32
 9b6:	8082                	ret

00000000000009b8 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9b8:	7179                	addi	sp,sp,-48
 9ba:	f406                	sd	ra,40(sp)
 9bc:	f022                	sd	s0,32(sp)
 9be:	e84a                	sd	s2,16(sp)
 9c0:	e44e                	sd	s3,8(sp)
 9c2:	1800                	addi	s0,sp,48
 9c4:	892a                	mv	s2,a0
 9c6:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9c8:	00001797          	auipc	a5,0x1
 9cc:	b507b783          	ld	a5,-1200(a5) # 1518 <stacks>
 9d0:	c3d9                	beqz	a5,a56 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9d2:	00001797          	auipc	a5,0x1
 9d6:	b2e7a783          	lw	a5,-1234(a5) # 1500 <max_stacks>
 9da:	00001717          	auipc	a4,0x1
 9de:	b4672703          	lw	a4,-1210(a4) # 1520 <num_threads>
 9e2:	0af71463          	bne	a4,a5,a8a <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9e6:	04000713          	li	a4,64
 9ea:	08e78563          	beq	a5,a4,a74 <ithread_create+0xbc>
 9ee:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9f0:	00000097          	auipc	ra,0x0
 9f4:	f64080e7          	jalr	-156(ra) # 954 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9f8:	6505                	lui	a0,0x1
 9fa:	00000097          	auipc	ra,0x0
 9fe:	db8080e7          	jalr	-584(ra) # 7b2 <malloc>
 a02:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a04:	00001717          	auipc	a4,0x1
 a08:	b1c72703          	lw	a4,-1252(a4) # 1520 <num_threads>
 a0c:	070e                	slli	a4,a4,0x3
 a0e:	00001797          	auipc	a5,0x1
 a12:	b0a7b783          	ld	a5,-1270(a5) # 1518 <stacks>
 a16:	97ba                	add	a5,a5,a4
 a18:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a1a:	00000697          	auipc	a3,0x0
 a1e:	e9268693          	addi	a3,a3,-366 # 8ac <ithread_exit>
 a22:	862a                	mv	a2,a0
 a24:	85ce                	mv	a1,s3
 a26:	854a                	mv	a0,s2
 a28:	00000097          	auipc	ra,0x0
 a2c:	9a2080e7          	jalr	-1630(ra) # 3ca <create_thread>
 a30:	892a                	mv	s2,a0
  if (res != -1) {
 a32:	57fd                	li	a5,-1
 a34:	04f50d63          	beq	a0,a5,a8e <ithread_create+0xd6>
    num_threads++;
 a38:	00001717          	auipc	a4,0x1
 a3c:	ae870713          	addi	a4,a4,-1304 # 1520 <num_threads>
 a40:	431c                	lw	a5,0(a4)
 a42:	2785                	addiw	a5,a5,1
 a44:	c31c                	sw	a5,0(a4)
 a46:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a48:	854a                	mv	a0,s2
 a4a:	70a2                	ld	ra,40(sp)
 a4c:	7402                	ld	s0,32(sp)
 a4e:	6942                	ld	s2,16(sp)
 a50:	69a2                	ld	s3,8(sp)
 a52:	6145                	addi	sp,sp,48
 a54:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a56:	00001517          	auipc	a0,0x1
 a5a:	aaa52503          	lw	a0,-1366(a0) # 1500 <max_stacks>
 a5e:	0035151b          	slliw	a0,a0,0x3
 a62:	00000097          	auipc	ra,0x0
 a66:	d50080e7          	jalr	-688(ra) # 7b2 <malloc>
 a6a:	00001797          	auipc	a5,0x1
 a6e:	aaa7b723          	sd	a0,-1362(a5) # 1518 <stacks>
 a72:	b785                	j	9d2 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a74:	00000517          	auipc	a0,0x0
 a78:	0cc50513          	addi	a0,a0,204 # b40 <ithread_join+0x8c>
 a7c:	00000097          	auipc	ra,0x0
 a80:	c7a080e7          	jalr	-902(ra) # 6f6 <printf>
      return -1;
 a84:	57fd                	li	a5,-1
 a86:	893e                	mv	s2,a5
 a88:	b7c1                	j	a48 <ithread_create+0x90>
 a8a:	ec26                	sd	s1,24(sp)
 a8c:	b7b5                	j	9f8 <ithread_create+0x40>
    free(stack_ptr);
 a8e:	8526                	mv	a0,s1
 a90:	00000097          	auipc	ra,0x0
 a94:	c9c080e7          	jalr	-868(ra) # 72c <free>
    stacks[num_threads] = 0;
 a98:	00001717          	auipc	a4,0x1
 a9c:	a8872703          	lw	a4,-1400(a4) # 1520 <num_threads>
 aa0:	070e                	slli	a4,a4,0x3
 aa2:	00001797          	auipc	a5,0x1
 aa6:	a767b783          	ld	a5,-1418(a5) # 1518 <stacks>
 aaa:	97ba                	add	a5,a5,a4
 aac:	0007b023          	sd	zero,0(a5)
 ab0:	64e2                	ld	s1,24(sp)
 ab2:	bf59                	j	a48 <ithread_create+0x90>

0000000000000ab4 <ithread_join>:

int ithread_join(int thread_id) {
 ab4:	1101                	addi	sp,sp,-32
 ab6:	ec06                	sd	ra,24(sp)
 ab8:	e822                	sd	s0,16(sp)
 aba:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 abc:	ff040793          	addi	a5,s0,-16
 ac0:	ffc7859b          	addiw	a1,a5,-4
 ac4:	00000097          	auipc	ra,0x0
 ac8:	90e080e7          	jalr	-1778(ra) # 3d2 <join_thread>
  threads_done++;
 acc:	00001717          	auipc	a4,0x1
 ad0:	a5870713          	addi	a4,a4,-1448 # 1524 <threads_done>
 ad4:	431c                	lw	a5,0(a4)
 ad6:	2785                	addiw	a5,a5,1
 ad8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ada:	00001717          	auipc	a4,0x1
 ade:	a4672703          	lw	a4,-1466(a4) # 1520 <num_threads>
 ae2:	00f70863          	beq	a4,a5,af2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ae6:	fec42503          	lw	a0,-20(s0)
 aea:	60e2                	ld	ra,24(sp)
 aec:	6442                	ld	s0,16(sp)
 aee:	6105                	addi	sp,sp,32
 af0:	8082                	ret
    free_stacks();
 af2:	00000097          	auipc	ra,0x0
 af6:	dd4080e7          	jalr	-556(ra) # 8c6 <free_stacks>
 afa:	b7f5                	j	ae6 <ithread_join+0x32>
