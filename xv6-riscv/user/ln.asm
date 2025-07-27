
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
  14:	ab058593          	addi	a1,a1,-1360 # ac0 <ithread_join+0x4a>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	670080e7          	jalr	1648(ra) # 68a <fprintf>
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
  52:	a8a58593          	addi	a1,a1,-1398 # ad8 <ithread_join+0x62>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	632080e7          	jalr	1586(ra) # 68a <fprintf>
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

00000000000003ca <socket>:
.global socket
socket:
 li a7, SYS_socket
 3ca:	48e9                	li	a7,26
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3d2:	48ed                	li	a7,27
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <accept>:
.global accept
accept:
 li a7, SYS_accept
 3da:	48f5                	li	a7,29
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3e2:	48f1                	li	a7,28
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <connect>:
.global connect
connect:
 li a7, SYS_connect
 3ea:	48f9                	li	a7,30
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f2:	1101                	addi	sp,sp,-32
 3f4:	ec06                	sd	ra,24(sp)
 3f6:	e822                	sd	s0,16(sp)
 3f8:	1000                	addi	s0,sp,32
 3fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3fe:	4605                	li	a2,1
 400:	fef40593          	addi	a1,s0,-17
 404:	00000097          	auipc	ra,0x0
 408:	f26080e7          	jalr	-218(ra) # 32a <write>
}
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	6105                	addi	sp,sp,32
 412:	8082                	ret

0000000000000414 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 414:	7139                	addi	sp,sp,-64
 416:	fc06                	sd	ra,56(sp)
 418:	f822                	sd	s0,48(sp)
 41a:	f04a                	sd	s2,32(sp)
 41c:	ec4e                	sd	s3,24(sp)
 41e:	0080                	addi	s0,sp,64
 420:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 422:	cad9                	beqz	a3,4b8 <printint+0xa4>
 424:	01f5d79b          	srliw	a5,a1,0x1f
 428:	cbc1                	beqz	a5,4b8 <printint+0xa4>
    neg = 1;
    x = -xx;
 42a:	40b005bb          	negw	a1,a1
    neg = 1;
 42e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 430:	fc040993          	addi	s3,s0,-64
  neg = 0;
 434:	86ce                	mv	a3,s3
  i = 0;
 436:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 438:	00000817          	auipc	a6,0x0
 43c:	74880813          	addi	a6,a6,1864 # b80 <digits>
 440:	88ba                	mv	a7,a4
 442:	0017051b          	addiw	a0,a4,1
 446:	872a                	mv	a4,a0
 448:	02c5f7bb          	remuw	a5,a1,a2
 44c:	1782                	slli	a5,a5,0x20
 44e:	9381                	srli	a5,a5,0x20
 450:	97c2                	add	a5,a5,a6
 452:	0007c783          	lbu	a5,0(a5)
 456:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 45a:	87ae                	mv	a5,a1
 45c:	02c5d5bb          	divuw	a1,a1,a2
 460:	0685                	addi	a3,a3,1
 462:	fcc7ffe3          	bgeu	a5,a2,440 <printint+0x2c>
  if(neg)
 466:	00030c63          	beqz	t1,47e <printint+0x6a>
    buf[i++] = '-';
 46a:	fd050793          	addi	a5,a0,-48
 46e:	00878533          	add	a0,a5,s0
 472:	02d00793          	li	a5,45
 476:	fef50823          	sb	a5,-16(a0)
 47a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 47e:	02e05763          	blez	a4,4ac <printint+0x98>
 482:	f426                	sd	s1,40(sp)
 484:	377d                	addiw	a4,a4,-1
 486:	00e984b3          	add	s1,s3,a4
 48a:	19fd                	addi	s3,s3,-1
 48c:	99ba                	add	s3,s3,a4
 48e:	1702                	slli	a4,a4,0x20
 490:	9301                	srli	a4,a4,0x20
 492:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 496:	0004c583          	lbu	a1,0(s1)
 49a:	854a                	mv	a0,s2
 49c:	00000097          	auipc	ra,0x0
 4a0:	f56080e7          	jalr	-170(ra) # 3f2 <putc>
  while(--i >= 0)
 4a4:	14fd                	addi	s1,s1,-1
 4a6:	ff3498e3          	bne	s1,s3,496 <printint+0x82>
 4aa:	74a2                	ld	s1,40(sp)
}
 4ac:	70e2                	ld	ra,56(sp)
 4ae:	7442                	ld	s0,48(sp)
 4b0:	7902                	ld	s2,32(sp)
 4b2:	69e2                	ld	s3,24(sp)
 4b4:	6121                	addi	sp,sp,64
 4b6:	8082                	ret
  neg = 0;
 4b8:	4301                	li	t1,0
 4ba:	bf9d                	j	430 <printint+0x1c>

00000000000004bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	715d                	addi	sp,sp,-80
 4be:	e486                	sd	ra,72(sp)
 4c0:	e0a2                	sd	s0,64(sp)
 4c2:	f84a                	sd	s2,48(sp)
 4c4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c6:	0005c903          	lbu	s2,0(a1)
 4ca:	1a090b63          	beqz	s2,680 <vprintf+0x1c4>
 4ce:	fc26                	sd	s1,56(sp)
 4d0:	f44e                	sd	s3,40(sp)
 4d2:	f052                	sd	s4,32(sp)
 4d4:	ec56                	sd	s5,24(sp)
 4d6:	e85a                	sd	s6,16(sp)
 4d8:	e45e                	sd	s7,8(sp)
 4da:	8aaa                	mv	s5,a0
 4dc:	8bb2                	mv	s7,a2
 4de:	00158493          	addi	s1,a1,1
  state = 0;
 4e2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e4:	02500a13          	li	s4,37
 4e8:	4b55                	li	s6,21
 4ea:	a839                	j	508 <vprintf+0x4c>
        putc(fd, c);
 4ec:	85ca                	mv	a1,s2
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	f02080e7          	jalr	-254(ra) # 3f2 <putc>
 4f8:	a019                	j	4fe <vprintf+0x42>
    } else if(state == '%'){
 4fa:	01498d63          	beq	s3,s4,514 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4fe:	0485                	addi	s1,s1,1
 500:	fff4c903          	lbu	s2,-1(s1)
 504:	16090863          	beqz	s2,674 <vprintf+0x1b8>
    if(state == 0){
 508:	fe0999e3          	bnez	s3,4fa <vprintf+0x3e>
      if(c == '%'){
 50c:	ff4910e3          	bne	s2,s4,4ec <vprintf+0x30>
        state = '%';
 510:	89d2                	mv	s3,s4
 512:	b7f5                	j	4fe <vprintf+0x42>
      if(c == 'd'){
 514:	13490563          	beq	s2,s4,63e <vprintf+0x182>
 518:	f9d9079b          	addiw	a5,s2,-99
 51c:	0ff7f793          	zext.b	a5,a5
 520:	12fb6863          	bltu	s6,a5,650 <vprintf+0x194>
 524:	f9d9079b          	addiw	a5,s2,-99
 528:	0ff7f713          	zext.b	a4,a5
 52c:	12eb6263          	bltu	s6,a4,650 <vprintf+0x194>
 530:	00271793          	slli	a5,a4,0x2
 534:	00000717          	auipc	a4,0x0
 538:	5f470713          	addi	a4,a4,1524 # b28 <ithread_join+0xb2>
 53c:	97ba                	add	a5,a5,a4
 53e:	439c                	lw	a5,0(a5)
 540:	97ba                	add	a5,a5,a4
 542:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 544:	008b8913          	addi	s2,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	ec2080e7          	jalr	-318(ra) # 414 <printint>
 55a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b745                	j	4fe <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 560:	008b8913          	addi	s2,s7,8
 564:	4681                	li	a3,0
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	ea6080e7          	jalr	-346(ra) # 414 <printint>
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
 57a:	b751                	j	4fe <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4641                	li	a2,16
 584:	000ba583          	lw	a1,0(s7)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e8a080e7          	jalr	-374(ra) # 414 <printint>
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	b7a5                	j	4fe <vprintf+0x42>
 598:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 59a:	008b8793          	addi	a5,s7,8
 59e:	8c3e                	mv	s8,a5
 5a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5a4:	03000593          	li	a1,48
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e48080e7          	jalr	-440(ra) # 3f2 <putc>
  putc(fd, 'x');
 5b2:	07800593          	li	a1,120
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e3a080e7          	jalr	-454(ra) # 3f2 <putc>
 5c0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c2:	00000b97          	auipc	s7,0x0
 5c6:	5beb8b93          	addi	s7,s7,1470 # b80 <digits>
 5ca:	03c9d793          	srli	a5,s3,0x3c
 5ce:	97de                	add	a5,a5,s7
 5d0:	0007c583          	lbu	a1,0(a5)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e1c080e7          	jalr	-484(ra) # 3f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5de:	0992                	slli	s3,s3,0x4
 5e0:	397d                	addiw	s2,s2,-1
 5e2:	fe0914e3          	bnez	s2,5ca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5e6:	8be2                	mv	s7,s8
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	6c02                	ld	s8,0(sp)
 5ec:	bf09                	j	4fe <vprintf+0x42>
        s = va_arg(ap, char*);
 5ee:	008b8993          	addi	s3,s7,8
 5f2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5f6:	02090163          	beqz	s2,618 <vprintf+0x15c>
        while(*s != 0){
 5fa:	00094583          	lbu	a1,0(s2)
 5fe:	c9a5                	beqz	a1,66e <vprintf+0x1b2>
          putc(fd, *s);
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	df0080e7          	jalr	-528(ra) # 3f2 <putc>
          s++;
 60a:	0905                	addi	s2,s2,1
        while(*s != 0){
 60c:	00094583          	lbu	a1,0(s2)
 610:	f9e5                	bnez	a1,600 <vprintf+0x144>
        s = va_arg(ap, char*);
 612:	8bce                	mv	s7,s3
      state = 0;
 614:	4981                	li	s3,0
 616:	b5e5                	j	4fe <vprintf+0x42>
          s = "(null)";
 618:	00000917          	auipc	s2,0x0
 61c:	4d890913          	addi	s2,s2,1240 # af0 <ithread_join+0x7a>
        while(*s != 0){
 620:	02800593          	li	a1,40
 624:	bff1                	j	600 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 626:	008b8913          	addi	s2,s7,8
 62a:	000bc583          	lbu	a1,0(s7)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	dc2080e7          	jalr	-574(ra) # 3f2 <putc>
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b5c9                	j	4fe <vprintf+0x42>
        putc(fd, c);
 63e:	02500593          	li	a1,37
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	dae080e7          	jalr	-594(ra) # 3f2 <putc>
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bd45                	j	4fe <vprintf+0x42>
        putc(fd, '%');
 650:	02500593          	li	a1,37
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	d9c080e7          	jalr	-612(ra) # 3f2 <putc>
        putc(fd, c);
 65e:	85ca                	mv	a1,s2
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	d90080e7          	jalr	-624(ra) # 3f2 <putc>
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bd49                	j	4fe <vprintf+0x42>
        s = va_arg(ap, char*);
 66e:	8bce                	mv	s7,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	b571                	j	4fe <vprintf+0x42>
 674:	74e2                	ld	s1,56(sp)
 676:	79a2                	ld	s3,40(sp)
 678:	7a02                	ld	s4,32(sp)
 67a:	6ae2                	ld	s5,24(sp)
 67c:	6b42                	ld	s6,16(sp)
 67e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 680:	60a6                	ld	ra,72(sp)
 682:	6406                	ld	s0,64(sp)
 684:	7942                	ld	s2,48(sp)
 686:	6161                	addi	sp,sp,80
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	8622                	mv	a2,s0
 6a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e14080e7          	jalr	-492(ra) # 4bc <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <printf>:

void
printf(const char *fmt, ...)
{
 6b8:	711d                	addi	sp,sp,-96
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e40c                	sd	a1,8(s0)
 6c2:	e810                	sd	a2,16(s0)
 6c4:	ec14                	sd	a3,24(s0)
 6c6:	f018                	sd	a4,32(s0)
 6c8:	f41c                	sd	a5,40(s0)
 6ca:	03043823          	sd	a6,48(s0)
 6ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	00840613          	addi	a2,s0,8
 6d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6da:	85aa                	mv	a1,a0
 6dc:	4505                	li	a0,1
 6de:	00000097          	auipc	ra,0x0
 6e2:	dde080e7          	jalr	-546(ra) # 4bc <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret

00000000000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e406                	sd	ra,8(sp)
 6f2:	e022                	sd	s0,0(sp)
 6f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	00001797          	auipc	a5,0x1
 6fe:	e167b783          	ld	a5,-490(a5) # 1510 <freep>
 702:	a039                	j	710 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	6398                	ld	a4,0(a5)
 706:	00e7e463          	bltu	a5,a4,70e <free+0x20>
 70a:	00e6ea63          	bltu	a3,a4,71e <free+0x30>
{
 70e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	fed7fae3          	bgeu	a5,a3,704 <free+0x16>
 714:	6398                	ld	a4,0(a5)
 716:	00e6e463          	bltu	a3,a4,71e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	fee7eae3          	bltu	a5,a4,70e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 71e:	ff852583          	lw	a1,-8(a0)
 722:	6390                	ld	a2,0(a5)
 724:	02059813          	slli	a6,a1,0x20
 728:	01c85713          	srli	a4,a6,0x1c
 72c:	9736                	add	a4,a4,a3
 72e:	02e60563          	beq	a2,a4,758 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 736:	4790                	lw	a2,8(a5)
 738:	02061593          	slli	a1,a2,0x20
 73c:	01c5d713          	srli	a4,a1,0x1c
 740:	973e                	add	a4,a4,a5
 742:	02e68263          	beq	a3,a4,766 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 746:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 748:	00001717          	auipc	a4,0x1
 74c:	dcf73423          	sd	a5,-568(a4) # 1510 <freep>
}
 750:	60a2                	ld	ra,8(sp)
 752:	6402                	ld	s0,0(sp)
 754:	0141                	addi	sp,sp,16
 756:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 758:	4618                	lw	a4,8(a2)
 75a:	9f2d                	addw	a4,a4,a1
 75c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	6398                	ld	a4,0(a5)
 762:	6310                	ld	a2,0(a4)
 764:	b7f9                	j	732 <free+0x44>
    p->s.size += bp->s.size;
 766:	ff852703          	lw	a4,-8(a0)
 76a:	9f31                	addw	a4,a4,a2
 76c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 76e:	ff053683          	ld	a3,-16(a0)
 772:	bfd1                	j	746 <free+0x58>

0000000000000774 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 774:	7139                	addi	sp,sp,-64
 776:	fc06                	sd	ra,56(sp)
 778:	f822                	sd	s0,48(sp)
 77a:	f04a                	sd	s2,32(sp)
 77c:	ec4e                	sd	s3,24(sp)
 77e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 780:	02051993          	slli	s3,a0,0x20
 784:	0209d993          	srli	s3,s3,0x20
 788:	09bd                	addi	s3,s3,15
 78a:	0049d993          	srli	s3,s3,0x4
 78e:	2985                	addiw	s3,s3,1
 790:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 792:	00001517          	auipc	a0,0x1
 796:	d7e53503          	ld	a0,-642(a0) # 1510 <freep>
 79a:	c905                	beqz	a0,7ca <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79e:	4798                	lw	a4,8(a5)
 7a0:	09377a63          	bgeu	a4,s3,834 <malloc+0xc0>
 7a4:	f426                	sd	s1,40(sp)
 7a6:	e852                	sd	s4,16(sp)
 7a8:	e456                	sd	s5,8(sp)
 7aa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ac:	8a4e                	mv	s4,s3
 7ae:	6705                	lui	a4,0x1
 7b0:	00e9f363          	bgeu	s3,a4,7b6 <malloc+0x42>
 7b4:	6a05                	lui	s4,0x1
 7b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7be:	00001497          	auipc	s1,0x1
 7c2:	d5248493          	addi	s1,s1,-686 # 1510 <freep>
  if(p == (char*)-1)
 7c6:	5afd                	li	s5,-1
 7c8:	a089                	j	80a <malloc+0x96>
 7ca:	f426                	sd	s1,40(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d2:	00001797          	auipc	a5,0x1
 7d6:	d5e78793          	addi	a5,a5,-674 # 1530 <base>
 7da:	00001717          	auipc	a4,0x1
 7de:	d2f73b23          	sd	a5,-714(a4) # 1510 <freep>
 7e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e8:	b7d1                	j	7ac <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7ea:	6398                	ld	a4,0(a5)
 7ec:	e118                	sd	a4,0(a0)
 7ee:	a8b9                	j	84c <malloc+0xd8>
  hp->s.size = nu;
 7f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f4:	0541                	addi	a0,a0,16
 7f6:	00000097          	auipc	ra,0x0
 7fa:	ef8080e7          	jalr	-264(ra) # 6ee <free>
  return freep;
 7fe:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 800:	c135                	beqz	a0,864 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	03277363          	bgeu	a4,s2,82c <malloc+0xb8>
    if(p == freep)
 80a:	6098                	ld	a4,0(s1)
 80c:	853e                	mv	a0,a5
 80e:	fef71ae3          	bne	a4,a5,802 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 812:	8552                	mv	a0,s4
 814:	00000097          	auipc	ra,0x0
 818:	b7e080e7          	jalr	-1154(ra) # 392 <sbrk>
  if(p == (char*)-1)
 81c:	fd551ae3          	bne	a0,s5,7f0 <malloc+0x7c>
        return 0;
 820:	4501                	li	a0,0
 822:	74a2                	ld	s1,40(sp)
 824:	6a42                	ld	s4,16(sp)
 826:	6aa2                	ld	s5,8(sp)
 828:	6b02                	ld	s6,0(sp)
 82a:	a03d                	j	858 <malloc+0xe4>
 82c:	74a2                	ld	s1,40(sp)
 82e:	6a42                	ld	s4,16(sp)
 830:	6aa2                	ld	s5,8(sp)
 832:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 834:	fae90be3          	beq	s2,a4,7ea <malloc+0x76>
        p->s.size -= nunits;
 838:	4137073b          	subw	a4,a4,s3
 83c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83e:	02071693          	slli	a3,a4,0x20
 842:	01c6d713          	srli	a4,a3,0x1c
 846:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 848:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84c:	00001717          	auipc	a4,0x1
 850:	cca73223          	sd	a0,-828(a4) # 1510 <freep>
      return (void*)(p + 1);
 854:	01078513          	addi	a0,a5,16
  }
}
 858:	70e2                	ld	ra,56(sp)
 85a:	7442                	ld	s0,48(sp)
 85c:	7902                	ld	s2,32(sp)
 85e:	69e2                	ld	s3,24(sp)
 860:	6121                	addi	sp,sp,64
 862:	8082                	ret
 864:	74a2                	ld	s1,40(sp)
 866:	6a42                	ld	s4,16(sp)
 868:	6aa2                	ld	s5,8(sp)
 86a:	6b02                	ld	s6,0(sp)
 86c:	b7f5                	j	858 <malloc+0xe4>

000000000000086e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 86e:	1141                	addi	sp,sp,-16
 870:	e406                	sd	ra,8(sp)
 872:	e022                	sd	s0,0(sp)
 874:	0800                	addi	s0,sp,16
  thread_exit(status);
 876:	2501                	sext.w	a0,a0
 878:	00000097          	auipc	ra,0x0
 87c:	b4a080e7          	jalr	-1206(ra) # 3c2 <thread_exit>
}
 880:	60a2                	ld	ra,8(sp)
 882:	6402                	ld	s0,0(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <free_stacks>:
int free_stacks() {
 888:	7179                	addi	sp,sp,-48
 88a:	f406                	sd	ra,40(sp)
 88c:	f022                	sd	s0,32(sp)
 88e:	ec26                	sd	s1,24(sp)
 890:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 892:	00001797          	auipc	a5,0x1
 896:	c8e7a783          	lw	a5,-882(a5) # 1520 <num_threads>
 89a:	04f05063          	blez	a5,8da <free_stacks+0x52>
 89e:	e84a                	sd	s2,16(sp)
 8a0:	e44e                	sd	s3,8(sp)
 8a2:	4481                	li	s1,0
    free(stacks[i]);
 8a4:	00001997          	auipc	s3,0x1
 8a8:	c7498993          	addi	s3,s3,-908 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8ac:	00001917          	auipc	s2,0x1
 8b0:	c7490913          	addi	s2,s2,-908 # 1520 <num_threads>
    free(stacks[i]);
 8b4:	0009b783          	ld	a5,0(s3)
 8b8:	00349713          	slli	a4,s1,0x3
 8bc:	97ba                	add	a5,a5,a4
 8be:	6388                	ld	a0,0(a5)
 8c0:	00000097          	auipc	ra,0x0
 8c4:	e2e080e7          	jalr	-466(ra) # 6ee <free>
  for (int i = 0; i < num_threads; i++) {
 8c8:	0485                	addi	s1,s1,1
 8ca:	00092703          	lw	a4,0(s2)
 8ce:	0004879b          	sext.w	a5,s1
 8d2:	fee7c1e3          	blt	a5,a4,8b4 <free_stacks+0x2c>
 8d6:	6942                	ld	s2,16(sp)
 8d8:	69a2                	ld	s3,8(sp)
  free(stacks);
 8da:	00001497          	auipc	s1,0x1
 8de:	c3e48493          	addi	s1,s1,-962 # 1518 <stacks>
 8e2:	6088                	ld	a0,0(s1)
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e0a080e7          	jalr	-502(ra) # 6ee <free>
  stacks = 0;
 8ec:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8f0:	00001797          	auipc	a5,0x1
 8f4:	c207a823          	sw	zero,-976(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8f8:	47a1                	li	a5,8
 8fa:	00001717          	auipc	a4,0x1
 8fe:	c0f72323          	sw	a5,-1018(a4) # 1500 <max_stacks>
  threads_done = 0;
 902:	00001797          	auipc	a5,0x1
 906:	c207a123          	sw	zero,-990(a5) # 1524 <threads_done>
}
 90a:	4501                	li	a0,0
 90c:	70a2                	ld	ra,40(sp)
 90e:	7402                	ld	s0,32(sp)
 910:	64e2                	ld	s1,24(sp)
 912:	6145                	addi	sp,sp,48
 914:	8082                	ret

0000000000000916 <expand_num_threads>:
int expand_num_threads() {
 916:	1101                	addi	sp,sp,-32
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	e426                	sd	s1,8(sp)
 91e:	e04a                	sd	s2,0(sp)
 920:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 922:	00001797          	auipc	a5,0x1
 926:	bde78793          	addi	a5,a5,-1058 # 1500 <max_stacks>
 92a:	4388                	lw	a0,0(a5)
 92c:	0015151b          	slliw	a0,a0,0x1
 930:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 932:	0035151b          	slliw	a0,a0,0x3
 936:	00000097          	auipc	ra,0x0
 93a:	e3e080e7          	jalr	-450(ra) # 774 <malloc>
 93e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 940:	00001617          	auipc	a2,0x1
 944:	be062603          	lw	a2,-1056(a2) # 1520 <num_threads>
 948:	00001497          	auipc	s1,0x1
 94c:	bd048493          	addi	s1,s1,-1072 # 1518 <stacks>
 950:	0036161b          	slliw	a2,a2,0x3
 954:	608c                	ld	a1,0(s1)
 956:	00000097          	auipc	ra,0x0
 95a:	8fe080e7          	jalr	-1794(ra) # 254 <memmove>
  free(stacks);
 95e:	6088                	ld	a0,0(s1)
 960:	00000097          	auipc	ra,0x0
 964:	d8e080e7          	jalr	-626(ra) # 6ee <free>
  stacks = new_stacks;
 968:	0124b023          	sd	s2,0(s1)
}
 96c:	4501                	li	a0,0
 96e:	60e2                	ld	ra,24(sp)
 970:	6442                	ld	s0,16(sp)
 972:	64a2                	ld	s1,8(sp)
 974:	6902                	ld	s2,0(sp)
 976:	6105                	addi	sp,sp,32
 978:	8082                	ret

000000000000097a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 97a:	7179                	addi	sp,sp,-48
 97c:	f406                	sd	ra,40(sp)
 97e:	f022                	sd	s0,32(sp)
 980:	e84a                	sd	s2,16(sp)
 982:	e44e                	sd	s3,8(sp)
 984:	1800                	addi	s0,sp,48
 986:	892a                	mv	s2,a0
 988:	89ae                	mv	s3,a1
  if (stacks == 0) {
 98a:	00001797          	auipc	a5,0x1
 98e:	b8e7b783          	ld	a5,-1138(a5) # 1518 <stacks>
 992:	c3d9                	beqz	a5,a18 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 994:	00001797          	auipc	a5,0x1
 998:	b6c7a783          	lw	a5,-1172(a5) # 1500 <max_stacks>
 99c:	00001717          	auipc	a4,0x1
 9a0:	b8472703          	lw	a4,-1148(a4) # 1520 <num_threads>
 9a4:	0af71463          	bne	a4,a5,a4c <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9a8:	04000713          	li	a4,64
 9ac:	08e78563          	beq	a5,a4,a36 <ithread_create+0xbc>
 9b0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9b2:	00000097          	auipc	ra,0x0
 9b6:	f64080e7          	jalr	-156(ra) # 916 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9ba:	6505                	lui	a0,0x1
 9bc:	00000097          	auipc	ra,0x0
 9c0:	db8080e7          	jalr	-584(ra) # 774 <malloc>
 9c4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9c6:	00001717          	auipc	a4,0x1
 9ca:	b5a72703          	lw	a4,-1190(a4) # 1520 <num_threads>
 9ce:	070e                	slli	a4,a4,0x3
 9d0:	00001797          	auipc	a5,0x1
 9d4:	b487b783          	ld	a5,-1208(a5) # 1518 <stacks>
 9d8:	97ba                	add	a5,a5,a4
 9da:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9dc:	00000697          	auipc	a3,0x0
 9e0:	e9268693          	addi	a3,a3,-366 # 86e <ithread_exit>
 9e4:	862a                	mv	a2,a0
 9e6:	85ce                	mv	a1,s3
 9e8:	854a                	mv	a0,s2
 9ea:	00000097          	auipc	ra,0x0
 9ee:	9c8080e7          	jalr	-1592(ra) # 3b2 <create_thread>
 9f2:	892a                	mv	s2,a0
  if (res != -1) {
 9f4:	57fd                	li	a5,-1
 9f6:	04f50d63          	beq	a0,a5,a50 <ithread_create+0xd6>
    num_threads++;
 9fa:	00001717          	auipc	a4,0x1
 9fe:	b2670713          	addi	a4,a4,-1242 # 1520 <num_threads>
 a02:	431c                	lw	a5,0(a4)
 a04:	2785                	addiw	a5,a5,1
 a06:	c31c                	sw	a5,0(a4)
 a08:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a0a:	854a                	mv	a0,s2
 a0c:	70a2                	ld	ra,40(sp)
 a0e:	7402                	ld	s0,32(sp)
 a10:	6942                	ld	s2,16(sp)
 a12:	69a2                	ld	s3,8(sp)
 a14:	6145                	addi	sp,sp,48
 a16:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a18:	00001517          	auipc	a0,0x1
 a1c:	ae852503          	lw	a0,-1304(a0) # 1500 <max_stacks>
 a20:	0035151b          	slliw	a0,a0,0x3
 a24:	00000097          	auipc	ra,0x0
 a28:	d50080e7          	jalr	-688(ra) # 774 <malloc>
 a2c:	00001797          	auipc	a5,0x1
 a30:	aea7b623          	sd	a0,-1300(a5) # 1518 <stacks>
 a34:	b785                	j	994 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a36:	00000517          	auipc	a0,0x0
 a3a:	0c250513          	addi	a0,a0,194 # af8 <ithread_join+0x82>
 a3e:	00000097          	auipc	ra,0x0
 a42:	c7a080e7          	jalr	-902(ra) # 6b8 <printf>
      return -1;
 a46:	57fd                	li	a5,-1
 a48:	893e                	mv	s2,a5
 a4a:	b7c1                	j	a0a <ithread_create+0x90>
 a4c:	ec26                	sd	s1,24(sp)
 a4e:	b7b5                	j	9ba <ithread_create+0x40>
    free(stack_ptr);
 a50:	8526                	mv	a0,s1
 a52:	00000097          	auipc	ra,0x0
 a56:	c9c080e7          	jalr	-868(ra) # 6ee <free>
    stacks[num_threads] = 0;
 a5a:	00001717          	auipc	a4,0x1
 a5e:	ac672703          	lw	a4,-1338(a4) # 1520 <num_threads>
 a62:	070e                	slli	a4,a4,0x3
 a64:	00001797          	auipc	a5,0x1
 a68:	ab47b783          	ld	a5,-1356(a5) # 1518 <stacks>
 a6c:	97ba                	add	a5,a5,a4
 a6e:	0007b023          	sd	zero,0(a5)
 a72:	64e2                	ld	s1,24(sp)
 a74:	bf59                	j	a0a <ithread_create+0x90>

0000000000000a76 <ithread_join>:

int ithread_join(int thread_id) {
 a76:	1101                	addi	sp,sp,-32
 a78:	ec06                	sd	ra,24(sp)
 a7a:	e822                	sd	s0,16(sp)
 a7c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a7e:	ff040793          	addi	a5,s0,-16
 a82:	ffc7859b          	addiw	a1,a5,-4
 a86:	00000097          	auipc	ra,0x0
 a8a:	934080e7          	jalr	-1740(ra) # 3ba <join_thread>
  threads_done++;
 a8e:	00001717          	auipc	a4,0x1
 a92:	a9670713          	addi	a4,a4,-1386 # 1524 <threads_done>
 a96:	431c                	lw	a5,0(a4)
 a98:	2785                	addiw	a5,a5,1
 a9a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a9c:	00001717          	auipc	a4,0x1
 aa0:	a8472703          	lw	a4,-1404(a4) # 1520 <num_threads>
 aa4:	00f70863          	beq	a4,a5,ab4 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 aa8:	fec42503          	lw	a0,-20(s0)
 aac:	60e2                	ld	ra,24(sp)
 aae:	6442                	ld	s0,16(sp)
 ab0:	6105                	addi	sp,sp,32
 ab2:	8082                	ret
    free_stacks();
 ab4:	00000097          	auipc	ra,0x0
 ab8:	dd4080e7          	jalr	-556(ra) # 888 <free_stacks>
 abc:	b7f5                	j	aa8 <ithread_join+0x32>
