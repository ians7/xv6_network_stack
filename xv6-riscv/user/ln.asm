
user/_ln:     file format elf64-littleriscv


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
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	a8058593          	addi	a1,a1,-1408 # a90 <ithread_join+0x44>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	648080e7          	jalr	1608(ra) # 662 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2e6080e7          	jalr	742(ra) # 30a <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	336080e7          	jalr	822(ra) # 36a <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	2c8080e7          	jalr	712(ra) # 30a <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	a5a58593          	addi	a1,a1,-1446 # aa8 <ithread_join+0x5c>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	60a080e7          	jalr	1546(ra) # 662 <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	296080e7          	jalr	662(ra) # 30a <exit>

000000000000007c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0xa>
    ;
  return os;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x20>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x20>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	60a2                	ld	ra,8(sp)
  c6:	6402                	ld	s0,0(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf91                	beqz	a5,f4 <strlen+0x28>
  da:	00150793          	addi	a5,a0,1
  de:	86be                	mv	a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	ff65                	bnez	a4,de <strlen+0x12>
  e8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  for(n = 0; s[n]; n++)
  f4:	4501                	li	a0,0
  f6:	bfdd                	j	ec <strlen+0x20>

00000000000000f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 100:	ca19                	beqz	a2,116 <memset+0x1e>
 102:	87aa                	mv	a5,a0
 104:	1602                	slli	a2,a2,0x20
 106:	9201                	srli	a2,a2,0x20
 108:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 110:	0785                	addi	a5,a5,1
 112:	fee79de3          	bne	a5,a4,10c <memset+0x14>
  }
  return dst;
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strchr>:

char*
strchr(const char *s, char c)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  for(; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf81                	beqz	a5,142 <strchr+0x24>
    if(*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1c>
  for(; *s; s++)
 130:	0505                	addi	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xe>
      return (char*)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	60a2                	ld	ra,8(sp)
 13c:	6402                	ld	s0,0(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret
  return 0;
 142:	4501                	li	a0,0
 144:	bfdd                	j	13a <strchr+0x1c>

0000000000000146 <gets>:

char*
gets(char *buf, int max)
{
 146:	711d                	addi	sp,sp,-96
 148:	ec86                	sd	ra,88(sp)
 14a:	e8a2                	sd	s0,80(sp)
 14c:	e4a6                	sd	s1,72(sp)
 14e:	e0ca                	sd	s2,64(sp)
 150:	fc4e                	sd	s3,56(sp)
 152:	f852                	sd	s4,48(sp)
 154:	f456                	sd	s5,40(sp)
 156:	f05a                	sd	s6,32(sp)
 158:	ec5e                	sd	s7,24(sp)
 15a:	e862                	sd	s8,16(sp)
 15c:	1080                	addi	s0,sp,96
 15e:	8baa                	mv	s7,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
    cc = read(0, &c, 1);
 166:	faf40b13          	addi	s6,s0,-81
 16a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 16c:	8c26                	mv	s8,s1
 16e:	0014899b          	addiw	s3,s1,1
 172:	84ce                	mv	s1,s3
 174:	0349d663          	bge	s3,s4,1a0 <gets+0x5a>
    cc = read(0, &c, 1);
 178:	8656                	mv	a2,s5
 17a:	85da                	mv	a1,s6
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	1a4080e7          	jalr	420(ra) # 322 <read>
    if(cc < 1)
 186:	00a05d63          	blez	a0,1a0 <gets+0x5a>
      break;
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	0905                	addi	s2,s2,1
 194:	ff678713          	addi	a4,a5,-10
 198:	c319                	beqz	a4,19e <gets+0x58>
 19a:	17cd                	addi	a5,a5,-13
 19c:	fbe1                	bnez	a5,16c <gets+0x26>
    buf[i++] = c;
 19e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1a0:	9c5e                	add	s8,s8,s7
 1a2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6c42                	ld	s8,16(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	1101                	addi	sp,sp,-32
 1c2:	ec06                	sd	ra,24(sp)
 1c4:	e822                	sd	s0,16(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	17c080e7          	jalr	380(ra) # 34a <open>
  if(fd < 0)
 1d6:	02054663          	bltz	a0,202 <stat+0x42>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	182080e7          	jalr	386(ra) # 362 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	146080e7          	jalr	326(ra) # 332 <close>
  return r;
 1f4:	64a2                	ld	s1,8(sp)
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	57fd                	li	a5,-1
 204:	893e                	mv	s2,a5
 206:	bfc5                	j	1f6 <stat+0x36>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66963          	bltu	a2,a5,250 <atoi+0x48>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1e>
  return n;
}
 248:	60a2                	ld	ra,8(sp)
 24a:	6402                	ld	s0,0(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  n = 0;
 250:	4501                	li	a0,0
 252:	bfdd                	j	248 <atoi+0x40>

0000000000000254 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25c:	02b57563          	bgeu	a0,a1,286 <memmove+0x32>
    while(n-- > 0)
 260:	00c05f63          	blez	a2,27e <memmove+0x2a>
 264:	1602                	slli	a2,a2,0x20
 266:	9201                	srli	a2,a2,0x20
 268:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    while(n-- > 0)
 286:	fec05ce3          	blez	a2,27e <memmove+0x2a>
    dst += n;
 28a:	00c50733          	add	a4,a0,a2
    src += n;
 28e:	95b2                	add	a1,a1,a2
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2aa:	fef71ae3          	bne	a4,a5,29e <memmove+0x4a>
 2ae:	bfc1                	j	27e <memmove+0x2a>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b8:	c61d                	beqz	a2,2e6 <memcmp+0x36>
 2ba:	1602                	slli	a2,a2,0x20
 2bc:	9201                	srli	a2,a2,0x20
 2be:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00e79863          	bne	a5,a4,2da <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ce:	0505                	addi	a0,a0,1
    p2++;
 2d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d2:	fed518e3          	bne	a0,a3,2c2 <memcmp+0x12>
  }
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	a019                	j	2de <memcmp+0x2e>
      return *p1 - *p2;
 2da:	40e7853b          	subw	a0,a5,a4
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfdd                	j	2de <memcmp+0x2e>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	00000097          	auipc	ra,0x0
 2f6:	f62080e7          	jalr	-158(ra) # 254 <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3b2:	48dd                	li	a7,23
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3ba:	48e1                	li	a7,24
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3c2:	48e5                	li	a7,25
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	1000                	addi	s0,sp,32
 3d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d6:	4605                	li	a2,1
 3d8:	fef40593          	addi	a1,s0,-17
 3dc:	00000097          	auipc	ra,0x0
 3e0:	f4e080e7          	jalr	-178(ra) # 32a <write>
}
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6105                	addi	sp,sp,32
 3ea:	8082                	ret

00000000000003ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ec:	7139                	addi	sp,sp,-64
 3ee:	fc06                	sd	ra,56(sp)
 3f0:	f822                	sd	s0,48(sp)
 3f2:	f04a                	sd	s2,32(sp)
 3f4:	ec4e                	sd	s3,24(sp)
 3f6:	0080                	addi	s0,sp,64
 3f8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fa:	cad9                	beqz	a3,490 <printint+0xa4>
 3fc:	01f5d79b          	srliw	a5,a1,0x1f
 400:	cbc1                	beqz	a5,490 <printint+0xa4>
    neg = 1;
    x = -xx;
 402:	40b005bb          	negw	a1,a1
    neg = 1;
 406:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 408:	fc040993          	addi	s3,s0,-64
  neg = 0;
 40c:	86ce                	mv	a3,s3
  i = 0;
 40e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 410:	00000817          	auipc	a6,0x0
 414:	74080813          	addi	a6,a6,1856 # b50 <digits>
 418:	88ba                	mv	a7,a4
 41a:	0017051b          	addiw	a0,a4,1
 41e:	872a                	mv	a4,a0
 420:	02c5f7bb          	remuw	a5,a1,a2
 424:	1782                	slli	a5,a5,0x20
 426:	9381                	srli	a5,a5,0x20
 428:	97c2                	add	a5,a5,a6
 42a:	0007c783          	lbu	a5,0(a5)
 42e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 432:	87ae                	mv	a5,a1
 434:	02c5d5bb          	divuw	a1,a1,a2
 438:	0685                	addi	a3,a3,1
 43a:	fcc7ffe3          	bgeu	a5,a2,418 <printint+0x2c>
  if(neg)
 43e:	00030c63          	beqz	t1,456 <printint+0x6a>
    buf[i++] = '-';
 442:	fd050793          	addi	a5,a0,-48
 446:	00878533          	add	a0,a5,s0
 44a:	02d00793          	li	a5,45
 44e:	fef50823          	sb	a5,-16(a0)
 452:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 456:	02e05763          	blez	a4,484 <printint+0x98>
 45a:	f426                	sd	s1,40(sp)
 45c:	377d                	addiw	a4,a4,-1
 45e:	00e984b3          	add	s1,s3,a4
 462:	19fd                	addi	s3,s3,-1
 464:	99ba                	add	s3,s3,a4
 466:	1702                	slli	a4,a4,0x20
 468:	9301                	srli	a4,a4,0x20
 46a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46e:	0004c583          	lbu	a1,0(s1)
 472:	854a                	mv	a0,s2
 474:	00000097          	auipc	ra,0x0
 478:	f56080e7          	jalr	-170(ra) # 3ca <putc>
  while(--i >= 0)
 47c:	14fd                	addi	s1,s1,-1
 47e:	ff3498e3          	bne	s1,s3,46e <printint+0x82>
 482:	74a2                	ld	s1,40(sp)
}
 484:	70e2                	ld	ra,56(sp)
 486:	7442                	ld	s0,48(sp)
 488:	7902                	ld	s2,32(sp)
 48a:	69e2                	ld	s3,24(sp)
 48c:	6121                	addi	sp,sp,64
 48e:	8082                	ret
  neg = 0;
 490:	4301                	li	t1,0
 492:	bf9d                	j	408 <printint+0x1c>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	715d                	addi	sp,sp,-80
 496:	e486                	sd	ra,72(sp)
 498:	e0a2                	sd	s0,64(sp)
 49a:	f84a                	sd	s2,48(sp)
 49c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c903          	lbu	s2,0(a1)
 4a2:	1a090b63          	beqz	s2,658 <vprintf+0x1c4>
 4a6:	fc26                	sd	s1,56(sp)
 4a8:	f44e                	sd	s3,40(sp)
 4aa:	f052                	sd	s4,32(sp)
 4ac:	ec56                	sd	s5,24(sp)
 4ae:	e85a                	sd	s6,16(sp)
 4b0:	e45e                	sd	s7,8(sp)
 4b2:	8aaa                	mv	s5,a0
 4b4:	8bb2                	mv	s7,a2
 4b6:	00158493          	addi	s1,a1,1
  state = 0;
 4ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bc:	02500a13          	li	s4,37
 4c0:	4b55                	li	s6,21
 4c2:	a839                	j	4e0 <vprintf+0x4c>
        putc(fd, c);
 4c4:	85ca                	mv	a1,s2
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f02080e7          	jalr	-254(ra) # 3ca <putc>
 4d0:	a019                	j	4d6 <vprintf+0x42>
    } else if(state == '%'){
 4d2:	01498d63          	beq	s3,s4,4ec <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4d6:	0485                	addi	s1,s1,1
 4d8:	fff4c903          	lbu	s2,-1(s1)
 4dc:	16090863          	beqz	s2,64c <vprintf+0x1b8>
    if(state == 0){
 4e0:	fe0999e3          	bnez	s3,4d2 <vprintf+0x3e>
      if(c == '%'){
 4e4:	ff4910e3          	bne	s2,s4,4c4 <vprintf+0x30>
        state = '%';
 4e8:	89d2                	mv	s3,s4
 4ea:	b7f5                	j	4d6 <vprintf+0x42>
      if(c == 'd'){
 4ec:	13490563          	beq	s2,s4,616 <vprintf+0x182>
 4f0:	f9d9079b          	addiw	a5,s2,-99
 4f4:	0ff7f793          	zext.b	a5,a5
 4f8:	12fb6863          	bltu	s6,a5,628 <vprintf+0x194>
 4fc:	f9d9079b          	addiw	a5,s2,-99
 500:	0ff7f713          	zext.b	a4,a5
 504:	12eb6263          	bltu	s6,a4,628 <vprintf+0x194>
 508:	00271793          	slli	a5,a4,0x2
 50c:	00000717          	auipc	a4,0x0
 510:	5ec70713          	addi	a4,a4,1516 # af8 <ithread_join+0xac>
 514:	97ba                	add	a5,a5,a4
 516:	439c                	lw	a5,0(a5)
 518:	97ba                	add	a5,a5,a4
 51a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b8913          	addi	s2,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000ba583          	lw	a1,0(s7)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	ec2080e7          	jalr	-318(ra) # 3ec <printint>
 532:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 534:	4981                	li	s3,0
 536:	b745                	j	4d6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 538:	008b8913          	addi	s2,s7,8
 53c:	4681                	li	a3,0
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	ea6080e7          	jalr	-346(ra) # 3ec <printint>
 54e:	8bca                	mv	s7,s2
      state = 0;
 550:	4981                	li	s3,0
 552:	b751                	j	4d6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 554:	008b8913          	addi	s2,s7,8
 558:	4681                	li	a3,0
 55a:	4641                	li	a2,16
 55c:	000ba583          	lw	a1,0(s7)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e8a080e7          	jalr	-374(ra) # 3ec <printint>
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b7a5                	j	4d6 <vprintf+0x42>
 570:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 572:	008b8793          	addi	a5,s7,8
 576:	8c3e                	mv	s8,a5
 578:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 57c:	03000593          	li	a1,48
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e48080e7          	jalr	-440(ra) # 3ca <putc>
  putc(fd, 'x');
 58a:	07800593          	li	a1,120
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e3a080e7          	jalr	-454(ra) # 3ca <putc>
 598:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59a:	00000b97          	auipc	s7,0x0
 59e:	5b6b8b93          	addi	s7,s7,1462 # b50 <digits>
 5a2:	03c9d793          	srli	a5,s3,0x3c
 5a6:	97de                	add	a5,a5,s7
 5a8:	0007c583          	lbu	a1,0(a5)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e1c080e7          	jalr	-484(ra) # 3ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b6:	0992                	slli	s3,s3,0x4
 5b8:	397d                	addiw	s2,s2,-1
 5ba:	fe0914e3          	bnez	s2,5a2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5be:	8be2                	mv	s7,s8
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	6c02                	ld	s8,0(sp)
 5c4:	bf09                	j	4d6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5c6:	008b8993          	addi	s3,s7,8
 5ca:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ce:	02090163          	beqz	s2,5f0 <vprintf+0x15c>
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	c9a5                	beqz	a1,646 <vprintf+0x1b2>
          putc(fd, *s);
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	df0080e7          	jalr	-528(ra) # 3ca <putc>
          s++;
 5e2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5e4:	00094583          	lbu	a1,0(s2)
 5e8:	f9e5                	bnez	a1,5d8 <vprintf+0x144>
        s = va_arg(ap, char*);
 5ea:	8bce                	mv	s7,s3
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b5e5                	j	4d6 <vprintf+0x42>
          s = "(null)";
 5f0:	00000917          	auipc	s2,0x0
 5f4:	4d090913          	addi	s2,s2,1232 # ac0 <ithread_join+0x74>
        while(*s != 0){
 5f8:	02800593          	li	a1,40
 5fc:	bff1                	j	5d8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5fe:	008b8913          	addi	s2,s7,8
 602:	000bc583          	lbu	a1,0(s7)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	dc2080e7          	jalr	-574(ra) # 3ca <putc>
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	b5c9                	j	4d6 <vprintf+0x42>
        putc(fd, c);
 616:	02500593          	li	a1,37
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	dae080e7          	jalr	-594(ra) # 3ca <putc>
      state = 0;
 624:	4981                	li	s3,0
 626:	bd45                	j	4d6 <vprintf+0x42>
        putc(fd, '%');
 628:	02500593          	li	a1,37
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	d9c080e7          	jalr	-612(ra) # 3ca <putc>
        putc(fd, c);
 636:	85ca                	mv	a1,s2
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	d90080e7          	jalr	-624(ra) # 3ca <putc>
      state = 0;
 642:	4981                	li	s3,0
 644:	bd49                	j	4d6 <vprintf+0x42>
        s = va_arg(ap, char*);
 646:	8bce                	mv	s7,s3
      state = 0;
 648:	4981                	li	s3,0
 64a:	b571                	j	4d6 <vprintf+0x42>
 64c:	74e2                	ld	s1,56(sp)
 64e:	79a2                	ld	s3,40(sp)
 650:	7a02                	ld	s4,32(sp)
 652:	6ae2                	ld	s5,24(sp)
 654:	6b42                	ld	s6,16(sp)
 656:	6ba2                	ld	s7,8(sp)
    }
  }
}
 658:	60a6                	ld	ra,72(sp)
 65a:	6406                	ld	s0,64(sp)
 65c:	7942                	ld	s2,48(sp)
 65e:	6161                	addi	sp,sp,80
 660:	8082                	ret

0000000000000662 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 662:	715d                	addi	sp,sp,-80
 664:	ec06                	sd	ra,24(sp)
 666:	e822                	sd	s0,16(sp)
 668:	1000                	addi	s0,sp,32
 66a:	e010                	sd	a2,0(s0)
 66c:	e414                	sd	a3,8(s0)
 66e:	e818                	sd	a4,16(s0)
 670:	ec1c                	sd	a5,24(s0)
 672:	03043023          	sd	a6,32(s0)
 676:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 67a:	8622                	mv	a2,s0
 67c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 680:	00000097          	auipc	ra,0x0
 684:	e14080e7          	jalr	-492(ra) # 494 <vprintf>
}
 688:	60e2                	ld	ra,24(sp)
 68a:	6442                	ld	s0,16(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret

0000000000000690 <printf>:

void
printf(const char *fmt, ...)
{
 690:	711d                	addi	sp,sp,-96
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	addi	s0,sp,32
 698:	e40c                	sd	a1,8(s0)
 69a:	e810                	sd	a2,16(s0)
 69c:	ec14                	sd	a3,24(s0)
 69e:	f018                	sd	a4,32(s0)
 6a0:	f41c                	sd	a5,40(s0)
 6a2:	03043823          	sd	a6,48(s0)
 6a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6aa:	00840613          	addi	a2,s0,8
 6ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b2:	85aa                	mv	a1,a0
 6b4:	4505                	li	a0,1
 6b6:	00000097          	auipc	ra,0x0
 6ba:	dde080e7          	jalr	-546(ra) # 494 <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret

00000000000006c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	1141                	addi	sp,sp,-16
 6c8:	e406                	sd	ra,8(sp)
 6ca:	e022                	sd	s0,0(sp)
 6cc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ce:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d2:	00001797          	auipc	a5,0x1
 6d6:	e3e7b783          	ld	a5,-450(a5) # 1510 <freep>
 6da:	a039                	j	6e8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dc:	6398                	ld	a4,0(a5)
 6de:	00e7e463          	bltu	a5,a4,6e6 <free+0x20>
 6e2:	00e6ea63          	bltu	a3,a4,6f6 <free+0x30>
{
 6e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	fed7fae3          	bgeu	a5,a3,6dc <free+0x16>
 6ec:	6398                	ld	a4,0(a5)
 6ee:	00e6e463          	bltu	a3,a4,6f6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	fee7eae3          	bltu	a5,a4,6e6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f6:	ff852583          	lw	a1,-8(a0)
 6fa:	6390                	ld	a2,0(a5)
 6fc:	02059813          	slli	a6,a1,0x20
 700:	01c85713          	srli	a4,a6,0x1c
 704:	9736                	add	a4,a4,a3
 706:	02e60563          	beq	a2,a4,730 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 70e:	4790                	lw	a2,8(a5)
 710:	02061593          	slli	a1,a2,0x20
 714:	01c5d713          	srli	a4,a1,0x1c
 718:	973e                	add	a4,a4,a5
 71a:	02e68263          	beq	a3,a4,73e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 71e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 720:	00001717          	auipc	a4,0x1
 724:	def73823          	sd	a5,-528(a4) # 1510 <freep>
}
 728:	60a2                	ld	ra,8(sp)
 72a:	6402                	ld	s0,0(sp)
 72c:	0141                	addi	sp,sp,16
 72e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 730:	4618                	lw	a4,8(a2)
 732:	9f2d                	addw	a4,a4,a1
 734:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	6398                	ld	a4,0(a5)
 73a:	6310                	ld	a2,0(a4)
 73c:	b7f9                	j	70a <free+0x44>
    p->s.size += bp->s.size;
 73e:	ff852703          	lw	a4,-8(a0)
 742:	9f31                	addw	a4,a4,a2
 744:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 746:	ff053683          	ld	a3,-16(a0)
 74a:	bfd1                	j	71e <free+0x58>

000000000000074c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 74c:	7139                	addi	sp,sp,-64
 74e:	fc06                	sd	ra,56(sp)
 750:	f822                	sd	s0,48(sp)
 752:	f04a                	sd	s2,32(sp)
 754:	ec4e                	sd	s3,24(sp)
 756:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	02051993          	slli	s3,a0,0x20
 75c:	0209d993          	srli	s3,s3,0x20
 760:	09bd                	addi	s3,s3,15
 762:	0049d993          	srli	s3,s3,0x4
 766:	2985                	addiw	s3,s3,1
 768:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 76a:	00001517          	auipc	a0,0x1
 76e:	da653503          	ld	a0,-602(a0) # 1510 <freep>
 772:	c905                	beqz	a0,7a2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 774:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 776:	4798                	lw	a4,8(a5)
 778:	09377a63          	bgeu	a4,s3,80c <malloc+0xc0>
 77c:	f426                	sd	s1,40(sp)
 77e:	e852                	sd	s4,16(sp)
 780:	e456                	sd	s5,8(sp)
 782:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 784:	8a4e                	mv	s4,s3
 786:	6705                	lui	a4,0x1
 788:	00e9f363          	bgeu	s3,a4,78e <malloc+0x42>
 78c:	6a05                	lui	s4,0x1
 78e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 792:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 796:	00001497          	auipc	s1,0x1
 79a:	d7a48493          	addi	s1,s1,-646 # 1510 <freep>
  if(p == (char*)-1)
 79e:	5afd                	li	s5,-1
 7a0:	a089                	j	7e2 <malloc+0x96>
 7a2:	f426                	sd	s1,40(sp)
 7a4:	e852                	sd	s4,16(sp)
 7a6:	e456                	sd	s5,8(sp)
 7a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7aa:	00001797          	auipc	a5,0x1
 7ae:	d8678793          	addi	a5,a5,-634 # 1530 <base>
 7b2:	00001717          	auipc	a4,0x1
 7b6:	d4f73f23          	sd	a5,-674(a4) # 1510 <freep>
 7ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c0:	b7d1                	j	784 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	e118                	sd	a4,0(a0)
 7c6:	a8b9                	j	824 <malloc+0xd8>
  hp->s.size = nu;
 7c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7cc:	0541                	addi	a0,a0,16
 7ce:	00000097          	auipc	ra,0x0
 7d2:	ef8080e7          	jalr	-264(ra) # 6c6 <free>
  return freep;
 7d6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7d8:	c135                	beqz	a0,83c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7dc:	4798                	lw	a4,8(a5)
 7de:	03277363          	bgeu	a4,s2,804 <malloc+0xb8>
    if(p == freep)
 7e2:	6098                	ld	a4,0(s1)
 7e4:	853e                	mv	a0,a5
 7e6:	fef71ae3          	bne	a4,a5,7da <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7ea:	8552                	mv	a0,s4
 7ec:	00000097          	auipc	ra,0x0
 7f0:	ba6080e7          	jalr	-1114(ra) # 392 <sbrk>
  if(p == (char*)-1)
 7f4:	fd551ae3          	bne	a0,s5,7c8 <malloc+0x7c>
        return 0;
 7f8:	4501                	li	a0,0
 7fa:	74a2                	ld	s1,40(sp)
 7fc:	6a42                	ld	s4,16(sp)
 7fe:	6aa2                	ld	s5,8(sp)
 800:	6b02                	ld	s6,0(sp)
 802:	a03d                	j	830 <malloc+0xe4>
 804:	74a2                	ld	s1,40(sp)
 806:	6a42                	ld	s4,16(sp)
 808:	6aa2                	ld	s5,8(sp)
 80a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 80c:	fae90be3          	beq	s2,a4,7c2 <malloc+0x76>
        p->s.size -= nunits;
 810:	4137073b          	subw	a4,a4,s3
 814:	c798                	sw	a4,8(a5)
        p += p->s.size;
 816:	02071693          	slli	a3,a4,0x20
 81a:	01c6d713          	srli	a4,a3,0x1c
 81e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 820:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 824:	00001717          	auipc	a4,0x1
 828:	cea73623          	sd	a0,-788(a4) # 1510 <freep>
      return (void*)(p + 1);
 82c:	01078513          	addi	a0,a5,16
  }
}
 830:	70e2                	ld	ra,56(sp)
 832:	7442                	ld	s0,48(sp)
 834:	7902                	ld	s2,32(sp)
 836:	69e2                	ld	s3,24(sp)
 838:	6121                	addi	sp,sp,64
 83a:	8082                	ret
 83c:	74a2                	ld	s1,40(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
 844:	b7f5                	j	830 <malloc+0xe4>

0000000000000846 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 846:	1141                	addi	sp,sp,-16
 848:	e406                	sd	ra,8(sp)
 84a:	e022                	sd	s0,0(sp)
 84c:	0800                	addi	s0,sp,16
  thread_exit(status);
 84e:	00000097          	auipc	ra,0x0
 852:	b74080e7          	jalr	-1164(ra) # 3c2 <thread_exit>
}
 856:	60a2                	ld	ra,8(sp)
 858:	6402                	ld	s0,0(sp)
 85a:	0141                	addi	sp,sp,16
 85c:	8082                	ret

000000000000085e <free_stacks>:
int free_stacks() {
 85e:	7179                	addi	sp,sp,-48
 860:	f406                	sd	ra,40(sp)
 862:	f022                	sd	s0,32(sp)
 864:	ec26                	sd	s1,24(sp)
 866:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 868:	00001797          	auipc	a5,0x1
 86c:	cb87a783          	lw	a5,-840(a5) # 1520 <num_threads>
 870:	04f05063          	blez	a5,8b0 <free_stacks+0x52>
 874:	e84a                	sd	s2,16(sp)
 876:	e44e                	sd	s3,8(sp)
 878:	4481                	li	s1,0
    free(stacks[i]);
 87a:	00001997          	auipc	s3,0x1
 87e:	c9e98993          	addi	s3,s3,-866 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 882:	00001917          	auipc	s2,0x1
 886:	c9e90913          	addi	s2,s2,-866 # 1520 <num_threads>
    free(stacks[i]);
 88a:	0009b783          	ld	a5,0(s3)
 88e:	00349713          	slli	a4,s1,0x3
 892:	97ba                	add	a5,a5,a4
 894:	6388                	ld	a0,0(a5)
 896:	00000097          	auipc	ra,0x0
 89a:	e30080e7          	jalr	-464(ra) # 6c6 <free>
  for (int i = 0; i < num_threads; i++) {
 89e:	0485                	addi	s1,s1,1
 8a0:	00092703          	lw	a4,0(s2)
 8a4:	0004879b          	sext.w	a5,s1
 8a8:	fee7c1e3          	blt	a5,a4,88a <free_stacks+0x2c>
 8ac:	6942                	ld	s2,16(sp)
 8ae:	69a2                	ld	s3,8(sp)
  free(stacks);
 8b0:	00001497          	auipc	s1,0x1
 8b4:	c6848493          	addi	s1,s1,-920 # 1518 <stacks>
 8b8:	6088                	ld	a0,0(s1)
 8ba:	00000097          	auipc	ra,0x0
 8be:	e0c080e7          	jalr	-500(ra) # 6c6 <free>
  stacks = 0;
 8c2:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8c6:	00001797          	auipc	a5,0x1
 8ca:	c407ad23          	sw	zero,-934(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8ce:	47a1                	li	a5,8
 8d0:	00001717          	auipc	a4,0x1
 8d4:	c2f72823          	sw	a5,-976(a4) # 1500 <max_stacks>
  threads_done = 0;
 8d8:	00001797          	auipc	a5,0x1
 8dc:	c407a623          	sw	zero,-948(a5) # 1524 <threads_done>
}
 8e0:	4501                	li	a0,0
 8e2:	70a2                	ld	ra,40(sp)
 8e4:	7402                	ld	s0,32(sp)
 8e6:	64e2                	ld	s1,24(sp)
 8e8:	6145                	addi	sp,sp,48
 8ea:	8082                	ret

00000000000008ec <expand_num_threads>:
int expand_num_threads() {
 8ec:	1101                	addi	sp,sp,-32
 8ee:	ec06                	sd	ra,24(sp)
 8f0:	e822                	sd	s0,16(sp)
 8f2:	e426                	sd	s1,8(sp)
 8f4:	e04a                	sd	s2,0(sp)
 8f6:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8f8:	00001797          	auipc	a5,0x1
 8fc:	c0878793          	addi	a5,a5,-1016 # 1500 <max_stacks>
 900:	4388                	lw	a0,0(a5)
 902:	0015151b          	slliw	a0,a0,0x1
 906:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 908:	0035151b          	slliw	a0,a0,0x3
 90c:	00000097          	auipc	ra,0x0
 910:	e40080e7          	jalr	-448(ra) # 74c <malloc>
 914:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 916:	00001617          	auipc	a2,0x1
 91a:	c0a62603          	lw	a2,-1014(a2) # 1520 <num_threads>
 91e:	00001497          	auipc	s1,0x1
 922:	bfa48493          	addi	s1,s1,-1030 # 1518 <stacks>
 926:	0036161b          	slliw	a2,a2,0x3
 92a:	608c                	ld	a1,0(s1)
 92c:	00000097          	auipc	ra,0x0
 930:	928080e7          	jalr	-1752(ra) # 254 <memmove>
  free(stacks);
 934:	6088                	ld	a0,0(s1)
 936:	00000097          	auipc	ra,0x0
 93a:	d90080e7          	jalr	-624(ra) # 6c6 <free>
  stacks = new_stacks;
 93e:	0124b023          	sd	s2,0(s1)
}
 942:	4501                	li	a0,0
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	64a2                	ld	s1,8(sp)
 94a:	6902                	ld	s2,0(sp)
 94c:	6105                	addi	sp,sp,32
 94e:	8082                	ret

0000000000000950 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 950:	7179                	addi	sp,sp,-48
 952:	f406                	sd	ra,40(sp)
 954:	f022                	sd	s0,32(sp)
 956:	e84a                	sd	s2,16(sp)
 958:	e44e                	sd	s3,8(sp)
 95a:	1800                	addi	s0,sp,48
 95c:	892a                	mv	s2,a0
 95e:	89ae                	mv	s3,a1
  if (stacks == 0) {
 960:	00001797          	auipc	a5,0x1
 964:	bb87b783          	ld	a5,-1096(a5) # 1518 <stacks>
 968:	c3d9                	beqz	a5,9ee <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 96a:	00001797          	auipc	a5,0x1
 96e:	b967a783          	lw	a5,-1130(a5) # 1500 <max_stacks>
 972:	00001717          	auipc	a4,0x1
 976:	bae72703          	lw	a4,-1106(a4) # 1520 <num_threads>
 97a:	0af71463          	bne	a4,a5,a22 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 97e:	04000713          	li	a4,64
 982:	08e78563          	beq	a5,a4,a0c <ithread_create+0xbc>
 986:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 988:	00000097          	auipc	ra,0x0
 98c:	f64080e7          	jalr	-156(ra) # 8ec <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 990:	6505                	lui	a0,0x1
 992:	00000097          	auipc	ra,0x0
 996:	dba080e7          	jalr	-582(ra) # 74c <malloc>
 99a:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 99c:	00001717          	auipc	a4,0x1
 9a0:	b8472703          	lw	a4,-1148(a4) # 1520 <num_threads>
 9a4:	070e                	slli	a4,a4,0x3
 9a6:	00001797          	auipc	a5,0x1
 9aa:	b727b783          	ld	a5,-1166(a5) # 1518 <stacks>
 9ae:	97ba                	add	a5,a5,a4
 9b0:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9b2:	00000697          	auipc	a3,0x0
 9b6:	e9468693          	addi	a3,a3,-364 # 846 <ithread_exit>
 9ba:	862a                	mv	a2,a0
 9bc:	85ce                	mv	a1,s3
 9be:	854a                	mv	a0,s2
 9c0:	00000097          	auipc	ra,0x0
 9c4:	9f2080e7          	jalr	-1550(ra) # 3b2 <create_thread>
 9c8:	892a                	mv	s2,a0
  if (res != -1) {
 9ca:	57fd                	li	a5,-1
 9cc:	04f50d63          	beq	a0,a5,a26 <ithread_create+0xd6>
    num_threads++;
 9d0:	00001717          	auipc	a4,0x1
 9d4:	b5070713          	addi	a4,a4,-1200 # 1520 <num_threads>
 9d8:	431c                	lw	a5,0(a4)
 9da:	2785                	addiw	a5,a5,1
 9dc:	c31c                	sw	a5,0(a4)
 9de:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9e0:	854a                	mv	a0,s2
 9e2:	70a2                	ld	ra,40(sp)
 9e4:	7402                	ld	s0,32(sp)
 9e6:	6942                	ld	s2,16(sp)
 9e8:	69a2                	ld	s3,8(sp)
 9ea:	6145                	addi	sp,sp,48
 9ec:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9ee:	00001517          	auipc	a0,0x1
 9f2:	b1252503          	lw	a0,-1262(a0) # 1500 <max_stacks>
 9f6:	0035151b          	slliw	a0,a0,0x3
 9fa:	00000097          	auipc	ra,0x0
 9fe:	d52080e7          	jalr	-686(ra) # 74c <malloc>
 a02:	00001797          	auipc	a5,0x1
 a06:	b0a7bb23          	sd	a0,-1258(a5) # 1518 <stacks>
 a0a:	b785                	j	96a <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a0c:	00000517          	auipc	a0,0x0
 a10:	0bc50513          	addi	a0,a0,188 # ac8 <ithread_join+0x7c>
 a14:	00000097          	auipc	ra,0x0
 a18:	c7c080e7          	jalr	-900(ra) # 690 <printf>
      return -1;
 a1c:	57fd                	li	a5,-1
 a1e:	893e                	mv	s2,a5
 a20:	b7c1                	j	9e0 <ithread_create+0x90>
 a22:	ec26                	sd	s1,24(sp)
 a24:	b7b5                	j	990 <ithread_create+0x40>
    free(stack_ptr);
 a26:	8526                	mv	a0,s1
 a28:	00000097          	auipc	ra,0x0
 a2c:	c9e080e7          	jalr	-866(ra) # 6c6 <free>
    stacks[num_threads] = 0;
 a30:	00001717          	auipc	a4,0x1
 a34:	af072703          	lw	a4,-1296(a4) # 1520 <num_threads>
 a38:	070e                	slli	a4,a4,0x3
 a3a:	00001797          	auipc	a5,0x1
 a3e:	ade7b783          	ld	a5,-1314(a5) # 1518 <stacks>
 a42:	97ba                	add	a5,a5,a4
 a44:	0007b023          	sd	zero,0(a5)
 a48:	64e2                	ld	s1,24(sp)
 a4a:	bf59                	j	9e0 <ithread_create+0x90>

0000000000000a4c <ithread_join>:

int ithread_join(int thread_id) {
 a4c:	1101                	addi	sp,sp,-32
 a4e:	ec06                	sd	ra,24(sp)
 a50:	e822                	sd	s0,16(sp)
 a52:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a54:	fec40593          	addi	a1,s0,-20
 a58:	00000097          	auipc	ra,0x0
 a5c:	962080e7          	jalr	-1694(ra) # 3ba <join_thread>
  threads_done++;
 a60:	00001717          	auipc	a4,0x1
 a64:	ac470713          	addi	a4,a4,-1340 # 1524 <threads_done>
 a68:	431c                	lw	a5,0(a4)
 a6a:	2785                	addiw	a5,a5,1
 a6c:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a6e:	00001717          	auipc	a4,0x1
 a72:	ab272703          	lw	a4,-1358(a4) # 1520 <num_threads>
 a76:	00f70863          	beq	a4,a5,a86 <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 a7a:	fec42503          	lw	a0,-20(s0)
 a7e:	60e2                	ld	ra,24(sp)
 a80:	6442                	ld	s0,16(sp)
 a82:	6105                	addi	sp,sp,32
 a84:	8082                	ret
    free_stacks();
 a86:	00000097          	auipc	ra,0x0
 a8a:	dd8080e7          	jalr	-552(ra) # 85e <free_stacks>
 a8e:	b7f5                	j	a7a <ithread_join+0x2e>
