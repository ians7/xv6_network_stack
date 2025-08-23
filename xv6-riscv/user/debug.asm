
user/_debug:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char **argv) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  unsigned int i;
  int *p = malloc(10 *sizeof(int));
   e:	02800513          	li	a0,40
  12:	00000097          	auipc	ra,0x0
  16:	754080e7          	jalr	1876(ra) # 766 <malloc>
  1a:	892a                	mv	s2,a0

  for(i = 0; i < 10; i++)
  1c:	872a                	mv	a4,a0
  1e:	4781                	li	a5,0
  20:	46a9                	li	a3,10
    p[i] = i;
  22:	c31c                	sw	a5,0(a4)
  for(i = 0; i < 10; i++)
  24:	2785                	addiw	a5,a5,1
  26:	0711                	addi	a4,a4,4
  28:	fed79de3          	bne	a5,a3,22 <main+0x22>

  for(i = 9; i >= 0; i--)
  2c:	44a5                	li	s1,9
    printf("index: %d, value: %d\n", i, p[i]);
  2e:	00001997          	auipc	s3,0x1
  32:	a8298993          	addi	s3,s3,-1406 # ab0 <ithread_join+0x4a>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	664080e7          	jalr	1636(ra) # 6aa <printf>
  for(i = 9; i >= 0; i--)
  4e:	34fd                	addiw	s1,s1,-1
  50:	b7dd                	j	36 <main+0x36>

0000000000000052 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5a:	00000097          	auipc	ra,0x0
  5e:	fa6080e7          	jalr	-90(ra) # 0 <main>
  exit(0);
  62:	4501                	li	a0,0
  64:	00000097          	auipc	ra,0x0
  68:	2a8080e7          	jalr	680(ra) # 30c <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  74:	87aa                	mv	a5,a0
  76:	0585                	addi	a1,a1,1
  78:	0785                	addi	a5,a5,1
  7a:	fff5c703          	lbu	a4,-1(a1)
  7e:	fee78fa3          	sb	a4,-1(a5)
  82:	fb75                	bnez	a4,76 <strcpy+0xa>
    ;
  return os;
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	cb91                	beqz	a5,ac <strcmp+0x20>
  9a:	0005c703          	lbu	a4,0(a1)
  9e:	00f71763          	bne	a4,a5,ac <strcmp+0x20>
    p++, q++;
  a2:	0505                	addi	a0,a0,1
  a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	fbe5                	bnez	a5,9a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ac:	0005c503          	lbu	a0,0(a1)
}
  b0:	40a7853b          	subw	a0,a5,a0
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cf99                	beqz	a5,e6 <strlen+0x2a>
  ca:	0505                	addi	a0,a0,1
  cc:	87aa                	mv	a5,a0
  ce:	86be                	mv	a3,a5
  d0:	0785                	addi	a5,a5,1
  d2:	fff7c703          	lbu	a4,-1(a5)
  d6:	ff65                	bnez	a4,ce <strlen+0x12>
  d8:	40a6853b          	subw	a0,a3,a0
  dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfdd                	j	de <strlen+0x22>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f2:	ca19                	beqz	a2,108 <memset+0x1e>
  f4:	87aa                	mv	a5,a0
  f6:	1602                	slli	a2,a2,0x20
  f8:	9201                	srli	a2,a2,0x20
  fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 102:	0785                	addi	a5,a5,1
 104:	fee79de3          	bne	a5,a4,fe <memset+0x14>
  }
  return dst;
}
 108:	60a2                	ld	ra,8(sp)
 10a:	6402                	ld	s0,0(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	addi	sp,sp,-16
 112:	e406                	sd	ra,8(sp)
 114:	e022                	sd	s0,0(sp)
 116:	0800                	addi	s0,sp,16
  for(; *s; s++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cf81                	beqz	a5,134 <strchr+0x24>
    if(*s == c)
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1c>
  for(; *s; s++)
 122:	0505                	addi	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xe>
      return (char*)s;
  return 0;
 12a:	4501                	li	a0,0
}
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret
  return 0;
 134:	4501                	li	a0,0
 136:	bfdd                	j	12c <strchr+0x1c>

0000000000000138 <gets>:

char*
gets(char *buf, int max)
{
 138:	7159                	addi	sp,sp,-112
 13a:	f486                	sd	ra,104(sp)
 13c:	f0a2                	sd	s0,96(sp)
 13e:	eca6                	sd	s1,88(sp)
 140:	e8ca                	sd	s2,80(sp)
 142:	e4ce                	sd	s3,72(sp)
 144:	e0d2                	sd	s4,64(sp)
 146:	fc56                	sd	s5,56(sp)
 148:	f85a                	sd	s6,48(sp)
 14a:	f45e                	sd	s7,40(sp)
 14c:	f062                	sd	s8,32(sp)
 14e:	ec66                	sd	s9,24(sp)
 150:	e86a                	sd	s10,16(sp)
 152:	1880                	addi	s0,sp,112
 154:	8caa                	mv	s9,a0
 156:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 158:	892a                	mv	s2,a0
 15a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 15c:	f9f40b13          	addi	s6,s0,-97
 160:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 162:	4ba9                	li	s7,10
 164:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 166:	8d26                	mv	s10,s1
 168:	0014899b          	addiw	s3,s1,1
 16c:	84ce                	mv	s1,s3
 16e:	0349d763          	bge	s3,s4,19c <gets+0x64>
    cc = read(0, &c, 1);
 172:	8656                	mv	a2,s5
 174:	85da                	mv	a1,s6
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	1ac080e7          	jalr	428(ra) # 324 <read>
    if(cc < 1)
 180:	00a05e63          	blez	a0,19c <gets+0x64>
    buf[i++] = c;
 184:	f9f44783          	lbu	a5,-97(s0)
 188:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18c:	01778763          	beq	a5,s7,19a <gets+0x62>
 190:	0905                	addi	s2,s2,1
 192:	fd879ae3          	bne	a5,s8,166 <gets+0x2e>
    buf[i++] = c;
 196:	8d4e                	mv	s10,s3
 198:	a011                	j	19c <gets+0x64>
 19a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 19c:	9d66                	add	s10,s10,s9
 19e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1a2:	8566                	mv	a0,s9
 1a4:	70a6                	ld	ra,104(sp)
 1a6:	7406                	ld	s0,96(sp)
 1a8:	64e6                	ld	s1,88(sp)
 1aa:	6946                	ld	s2,80(sp)
 1ac:	69a6                	ld	s3,72(sp)
 1ae:	6a06                	ld	s4,64(sp)
 1b0:	7ae2                	ld	s5,56(sp)
 1b2:	7b42                	ld	s6,48(sp)
 1b4:	7ba2                	ld	s7,40(sp)
 1b6:	7c02                	ld	s8,32(sp)
 1b8:	6ce2                	ld	s9,24(sp)
 1ba:	6d42                	ld	s10,16(sp)
 1bc:	6165                	addi	sp,sp,112
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
 1d2:	17e080e7          	jalr	382(ra) # 34c <open>
  if(fd < 0)
 1d6:	02054663          	bltz	a0,202 <stat+0x42>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	184080e7          	jalr	388(ra) # 364 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	148080e7          	jalr	328(ra) # 334 <close>
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
 202:	597d                	li	s2,-1
 204:	bfcd                	j	1f6 <stat+0x36>

0000000000000206 <atoi>:

int
atoi(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e406                	sd	ra,8(sp)
 20a:	e022                	sd	s0,0(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20e:	00054683          	lbu	a3,0(a0)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	4625                	li	a2,9
 21c:	02f66963          	bltu	a2,a5,24e <atoi+0x48>
 220:	872a                	mv	a4,a0
  n = 0;
 222:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 224:	0705                	addi	a4,a4,1
 226:	0025179b          	slliw	a5,a0,0x2
 22a:	9fa9                	addw	a5,a5,a0
 22c:	0017979b          	slliw	a5,a5,0x1
 230:	9fb5                	addw	a5,a5,a3
 232:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 236:	00074683          	lbu	a3,0(a4)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	fef671e3          	bgeu	a2,a5,224 <atoi+0x1e>
  return n;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfdd                	j	246 <atoi+0x40>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25a:	02b57563          	bgeu	a0,a1,284 <memmove+0x32>
    while(n-- > 0)
 25e:	00c05f63          	blez	a2,27c <memmove+0x2a>
 262:	1602                	slli	a2,a2,0x20
 264:	9201                	srli	a2,a2,0x20
 266:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26a:	872a                	mv	a4,a0
      *dst++ = *src++;
 26c:	0585                	addi	a1,a1,1
 26e:	0705                	addi	a4,a4,1
 270:	fff5c683          	lbu	a3,-1(a1)
 274:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 278:	fee79ae3          	bne	a5,a4,26c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27c:	60a2                	ld	ra,8(sp)
 27e:	6402                	ld	s0,0(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
    dst += n;
 284:	00c50733          	add	a4,a0,a2
    src += n;
 288:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 28a:	fec059e3          	blez	a2,27c <memmove+0x2a>
 28e:	fff6079b          	addiw	a5,a2,-1
 292:	1782                	slli	a5,a5,0x20
 294:	9381                	srli	a5,a5,0x20
 296:	fff7c793          	not	a5,a5
 29a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29c:	15fd                	addi	a1,a1,-1
 29e:	177d                	addi	a4,a4,-1
 2a0:	0005c683          	lbu	a3,0(a1)
 2a4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a8:	fef71ae3          	bne	a4,a5,29c <memmove+0x4a>
 2ac:	bfc1                	j	27c <memmove+0x2a>

00000000000002ae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b6:	ca0d                	beqz	a2,2e8 <memcmp+0x3a>
 2b8:	fff6069b          	addiw	a3,a2,-1
 2bc:	1682                	slli	a3,a3,0x20
 2be:	9281                	srli	a3,a3,0x20
 2c0:	0685                	addi	a3,a3,1
 2c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2d0:	0505                	addi	a0,a0,1
    p2++;
 2d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x16>
  }
  return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x32>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	bfdd                	j	2e0 <memcmp+0x32>

00000000000002ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f4:	00000097          	auipc	ra,0x0
 2f8:	f5e080e7          	jalr	-162(ra) # 252 <memmove>
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret

0000000000000304 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 304:	4885                	li	a7,1
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exit>:
.global exit
exit:
 li a7, SYS_exit
 30c:	4889                	li	a7,2
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <wait>:
.global wait
wait:
 li a7, SYS_wait
 314:	488d                	li	a7,3
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31c:	4891                	li	a7,4
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <read>:
.global read
read:
 li a7, SYS_read
 324:	4895                	li	a7,5
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <write>:
.global write
write:
 li a7, SYS_write
 32c:	48c1                	li	a7,16
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <close>:
.global close
close:
 li a7, SYS_close
 334:	48d5                	li	a7,21
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <kill>:
.global kill
kill:
 li a7, SYS_kill
 33c:	4899                	li	a7,6
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <exec>:
.global exec
exec:
 li a7, SYS_exec
 344:	489d                	li	a7,7
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <open>:
.global open
open:
 li a7, SYS_open
 34c:	48bd                	li	a7,15
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 354:	48c5                	li	a7,17
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35c:	48c9                	li	a7,18
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 364:	48a1                	li	a7,8
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <link>:
.global link
link:
 li a7, SYS_link
 36c:	48cd                	li	a7,19
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 374:	48d1                	li	a7,20
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37c:	48a5                	li	a7,9
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <dup>:
.global dup
dup:
 li a7, SYS_dup
 384:	48a9                	li	a7,10
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38c:	48ad                	li	a7,11
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 394:	48b1                	li	a7,12
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39c:	48b5                	li	a7,13
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a4:	48b9                	li	a7,14
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3ac:	48d9                	li	a7,22
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3b4:	48dd                	li	a7,23
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3bc:	48e1                	li	a7,24
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3c4:	48e5                	li	a7,25
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <socket>:
.global socket
socket:
 li a7, SYS_socket
 3cc:	48e9                	li	a7,26
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3d4:	48ed                	li	a7,27
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <accept>:
.global accept
accept:
 li a7, SYS_accept
 3dc:	48f5                	li	a7,29
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3e4:	48f1                	li	a7,28
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <connect>:
.global connect
connect:
 li a7, SYS_connect
 3ec:	48f9                	li	a7,30
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f4:	1101                	addi	sp,sp,-32
 3f6:	ec06                	sd	ra,24(sp)
 3f8:	e822                	sd	s0,16(sp)
 3fa:	1000                	addi	s0,sp,32
 3fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 400:	4605                	li	a2,1
 402:	fef40593          	addi	a1,s0,-17
 406:	00000097          	auipc	ra,0x0
 40a:	f26080e7          	jalr	-218(ra) # 32c <write>
}
 40e:	60e2                	ld	ra,24(sp)
 410:	6442                	ld	s0,16(sp)
 412:	6105                	addi	sp,sp,32
 414:	8082                	ret

0000000000000416 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 416:	7139                	addi	sp,sp,-64
 418:	fc06                	sd	ra,56(sp)
 41a:	f822                	sd	s0,48(sp)
 41c:	f426                	sd	s1,40(sp)
 41e:	f04a                	sd	s2,32(sp)
 420:	ec4e                	sd	s3,24(sp)
 422:	0080                	addi	s0,sp,64
 424:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 426:	c299                	beqz	a3,42c <printint+0x16>
 428:	0805c063          	bltz	a1,4a8 <printint+0x92>
  neg = 0;
 42c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 42e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 432:	869a                	mv	a3,t1
  i = 0;
 434:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 436:	00000817          	auipc	a6,0x0
 43a:	72280813          	addi	a6,a6,1826 # b58 <digits>
 43e:	88be                	mv	a7,a5
 440:	0017851b          	addiw	a0,a5,1
 444:	87aa                	mv	a5,a0
 446:	02c5f73b          	remuw	a4,a1,a2
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	9742                	add	a4,a4,a6
 450:	00074703          	lbu	a4,0(a4)
 454:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 458:	872e                	mv	a4,a1
 45a:	02c5d5bb          	divuw	a1,a1,a2
 45e:	0685                	addi	a3,a3,1
 460:	fcc77fe3          	bgeu	a4,a2,43e <printint+0x28>
  if(neg)
 464:	000e0c63          	beqz	t3,47c <printint+0x66>
    buf[i++] = '-';
 468:	fd050793          	addi	a5,a0,-48
 46c:	00878533          	add	a0,a5,s0
 470:	02d00793          	li	a5,45
 474:	fef50823          	sb	a5,-16(a0)
 478:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 47c:	fff7899b          	addiw	s3,a5,-1
 480:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 484:	fff4c583          	lbu	a1,-1(s1)
 488:	854a                	mv	a0,s2
 48a:	00000097          	auipc	ra,0x0
 48e:	f6a080e7          	jalr	-150(ra) # 3f4 <putc>
  while(--i >= 0)
 492:	39fd                	addiw	s3,s3,-1
 494:	14fd                	addi	s1,s1,-1
 496:	fe09d7e3          	bgez	s3,484 <printint+0x6e>
}
 49a:	70e2                	ld	ra,56(sp)
 49c:	7442                	ld	s0,48(sp)
 49e:	74a2                	ld	s1,40(sp)
 4a0:	7902                	ld	s2,32(sp)
 4a2:	69e2                	ld	s3,24(sp)
 4a4:	6121                	addi	sp,sp,64
 4a6:	8082                	ret
    x = -xx;
 4a8:	40b005bb          	negw	a1,a1
    neg = 1;
 4ac:	4e05                	li	t3,1
    x = -xx;
 4ae:	b741                	j	42e <printint+0x18>

00000000000004b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b0:	715d                	addi	sp,sp,-80
 4b2:	e486                	sd	ra,72(sp)
 4b4:	e0a2                	sd	s0,64(sp)
 4b6:	f84a                	sd	s2,48(sp)
 4b8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ba:	0005c903          	lbu	s2,0(a1)
 4be:	1a090a63          	beqz	s2,672 <vprintf+0x1c2>
 4c2:	fc26                	sd	s1,56(sp)
 4c4:	f44e                	sd	s3,40(sp)
 4c6:	f052                	sd	s4,32(sp)
 4c8:	ec56                	sd	s5,24(sp)
 4ca:	e85a                	sd	s6,16(sp)
 4cc:	e45e                	sd	s7,8(sp)
 4ce:	8aaa                	mv	s5,a0
 4d0:	8bb2                	mv	s7,a2
 4d2:	00158493          	addi	s1,a1,1
  state = 0;
 4d6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d8:	02500a13          	li	s4,37
 4dc:	4b55                	li	s6,21
 4de:	a839                	j	4fc <vprintf+0x4c>
        putc(fd, c);
 4e0:	85ca                	mv	a1,s2
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f10080e7          	jalr	-240(ra) # 3f4 <putc>
 4ec:	a019                	j	4f2 <vprintf+0x42>
    } else if(state == '%'){
 4ee:	01498d63          	beq	s3,s4,508 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4f2:	0485                	addi	s1,s1,1
 4f4:	fff4c903          	lbu	s2,-1(s1)
 4f8:	16090763          	beqz	s2,666 <vprintf+0x1b6>
    if(state == 0){
 4fc:	fe0999e3          	bnez	s3,4ee <vprintf+0x3e>
      if(c == '%'){
 500:	ff4910e3          	bne	s2,s4,4e0 <vprintf+0x30>
        state = '%';
 504:	89d2                	mv	s3,s4
 506:	b7f5                	j	4f2 <vprintf+0x42>
      if(c == 'd'){
 508:	13490463          	beq	s2,s4,630 <vprintf+0x180>
 50c:	f9d9079b          	addiw	a5,s2,-99
 510:	0ff7f793          	zext.b	a5,a5
 514:	12fb6763          	bltu	s6,a5,642 <vprintf+0x192>
 518:	f9d9079b          	addiw	a5,s2,-99
 51c:	0ff7f713          	zext.b	a4,a5
 520:	12eb6163          	bltu	s6,a4,642 <vprintf+0x192>
 524:	00271793          	slli	a5,a4,0x2
 528:	00000717          	auipc	a4,0x0
 52c:	5d870713          	addi	a4,a4,1496 # b00 <ithread_join+0x9a>
 530:	97ba                	add	a5,a5,a4
 532:	439c                	lw	a5,0(a5)
 534:	97ba                	add	a5,a5,a4
 536:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 538:	008b8913          	addi	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	ed0080e7          	jalr	-304(ra) # 416 <printint>
 54e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 550:	4981                	li	s3,0
 552:	b745                	j	4f2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 554:	008b8913          	addi	s2,s7,8
 558:	4681                	li	a3,0
 55a:	4629                	li	a2,10
 55c:	000ba583          	lw	a1,0(s7)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	eb4080e7          	jalr	-332(ra) # 416 <printint>
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b751                	j	4f2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4641                	li	a2,16
 578:	000ba583          	lw	a1,0(s7)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e98080e7          	jalr	-360(ra) # 416 <printint>
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	b7a5                	j	4f2 <vprintf+0x42>
 58c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 58e:	008b8c13          	addi	s8,s7,8
 592:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 596:	03000593          	li	a1,48
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e58080e7          	jalr	-424(ra) # 3f4 <putc>
  putc(fd, 'x');
 5a4:	07800593          	li	a1,120
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e4a080e7          	jalr	-438(ra) # 3f4 <putc>
 5b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b4:	00000b97          	auipc	s7,0x0
 5b8:	5a4b8b93          	addi	s7,s7,1444 # b58 <digits>
 5bc:	03c9d793          	srli	a5,s3,0x3c
 5c0:	97de                	add	a5,a5,s7
 5c2:	0007c583          	lbu	a1,0(a5)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e2c080e7          	jalr	-468(ra) # 3f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d0:	0992                	slli	s3,s3,0x4
 5d2:	397d                	addiw	s2,s2,-1
 5d4:	fe0914e3          	bnez	s2,5bc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5d8:	8be2                	mv	s7,s8
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	6c02                	ld	s8,0(sp)
 5de:	bf11                	j	4f2 <vprintf+0x42>
        s = va_arg(ap, char*);
 5e0:	008b8993          	addi	s3,s7,8
 5e4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5e8:	02090163          	beqz	s2,60a <vprintf+0x15a>
        while(*s != 0){
 5ec:	00094583          	lbu	a1,0(s2)
 5f0:	c9a5                	beqz	a1,660 <vprintf+0x1b0>
          putc(fd, *s);
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e00080e7          	jalr	-512(ra) # 3f4 <putc>
          s++;
 5fc:	0905                	addi	s2,s2,1
        while(*s != 0){
 5fe:	00094583          	lbu	a1,0(s2)
 602:	f9e5                	bnez	a1,5f2 <vprintf+0x142>
        s = va_arg(ap, char*);
 604:	8bce                	mv	s7,s3
      state = 0;
 606:	4981                	li	s3,0
 608:	b5ed                	j	4f2 <vprintf+0x42>
          s = "(null)";
 60a:	00000917          	auipc	s2,0x0
 60e:	4be90913          	addi	s2,s2,1214 # ac8 <ithread_join+0x62>
        while(*s != 0){
 612:	02800593          	li	a1,40
 616:	bff1                	j	5f2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 618:	008b8913          	addi	s2,s7,8
 61c:	000bc583          	lbu	a1,0(s7)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	dd2080e7          	jalr	-558(ra) # 3f4 <putc>
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b5d1                	j	4f2 <vprintf+0x42>
        putc(fd, c);
 630:	02500593          	li	a1,37
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	dbe080e7          	jalr	-578(ra) # 3f4 <putc>
      state = 0;
 63e:	4981                	li	s3,0
 640:	bd4d                	j	4f2 <vprintf+0x42>
        putc(fd, '%');
 642:	02500593          	li	a1,37
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dac080e7          	jalr	-596(ra) # 3f4 <putc>
        putc(fd, c);
 650:	85ca                	mv	a1,s2
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	da0080e7          	jalr	-608(ra) # 3f4 <putc>
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd51                	j	4f2 <vprintf+0x42>
        s = va_arg(ap, char*);
 660:	8bce                	mv	s7,s3
      state = 0;
 662:	4981                	li	s3,0
 664:	b579                	j	4f2 <vprintf+0x42>
 666:	74e2                	ld	s1,56(sp)
 668:	79a2                	ld	s3,40(sp)
 66a:	7a02                	ld	s4,32(sp)
 66c:	6ae2                	ld	s5,24(sp)
 66e:	6b42                	ld	s6,16(sp)
 670:	6ba2                	ld	s7,8(sp)
    }
  }
}
 672:	60a6                	ld	ra,72(sp)
 674:	6406                	ld	s0,64(sp)
 676:	7942                	ld	s2,48(sp)
 678:	6161                	addi	sp,sp,80
 67a:	8082                	ret

000000000000067c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67c:	715d                	addi	sp,sp,-80
 67e:	ec06                	sd	ra,24(sp)
 680:	e822                	sd	s0,16(sp)
 682:	1000                	addi	s0,sp,32
 684:	e010                	sd	a2,0(s0)
 686:	e414                	sd	a3,8(s0)
 688:	e818                	sd	a4,16(s0)
 68a:	ec1c                	sd	a5,24(s0)
 68c:	03043023          	sd	a6,32(s0)
 690:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 694:	8622                	mv	a2,s0
 696:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69a:	00000097          	auipc	ra,0x0
 69e:	e16080e7          	jalr	-490(ra) # 4b0 <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6161                	addi	sp,sp,80
 6a8:	8082                	ret

00000000000006aa <printf>:

void
printf(const char *fmt, ...)
{
 6aa:	711d                	addi	sp,sp,-96
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e40c                	sd	a1,8(s0)
 6b4:	e810                	sd	a2,16(s0)
 6b6:	ec14                	sd	a3,24(s0)
 6b8:	f018                	sd	a4,32(s0)
 6ba:	f41c                	sd	a5,40(s0)
 6bc:	03043823          	sd	a6,48(s0)
 6c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c4:	00840613          	addi	a2,s0,8
 6c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6cc:	85aa                	mv	a1,a0
 6ce:	4505                	li	a0,1
 6d0:	00000097          	auipc	ra,0x0
 6d4:	de0080e7          	jalr	-544(ra) # 4b0 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret

00000000000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e406                	sd	ra,8(sp)
 6e4:	e022                	sd	s0,0(sp)
 6e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	00001797          	auipc	a5,0x1
 6f0:	e247b783          	ld	a5,-476(a5) # 1510 <freep>
 6f4:	a02d                	j	71e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f6:	4618                	lw	a4,8(a2)
 6f8:	9f2d                	addw	a4,a4,a1
 6fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	6398                	ld	a4,0(a5)
 700:	6310                	ld	a2,0(a4)
 702:	a83d                	j	740 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 704:	ff852703          	lw	a4,-8(a0)
 708:	9f31                	addw	a4,a4,a2
 70a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70c:	ff053683          	ld	a3,-16(a0)
 710:	a091                	j	754 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x3c>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x4c>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x32>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059813          	slli	a6,a1,0x20
 736:	01c85713          	srli	a4,a6,0x1c
 73a:	9736                	add	a4,a4,a3
 73c:	fae60de3          	beq	a2,a4,6f6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061593          	slli	a1,a2,0x20
 74a:	01c5d713          	srli	a4,a1,0x1c
 74e:	973e                	add	a4,a4,a5
 750:	fae68ae3          	beq	a3,a4,704 <free+0x24>
    p->s.ptr = bp->s.ptr;
 754:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 756:	00001717          	auipc	a4,0x1
 75a:	daf73d23          	sd	a5,-582(a4) # 1510 <freep>
}
 75e:	60a2                	ld	ra,8(sp)
 760:	6402                	ld	s0,0(sp)
 762:	0141                	addi	sp,sp,16
 764:	8082                	ret

0000000000000766 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 766:	7139                	addi	sp,sp,-64
 768:	fc06                	sd	ra,56(sp)
 76a:	f822                	sd	s0,48(sp)
 76c:	f04a                	sd	s2,32(sp)
 76e:	ec4e                	sd	s3,24(sp)
 770:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	02051993          	slli	s3,a0,0x20
 776:	0209d993          	srli	s3,s3,0x20
 77a:	09bd                	addi	s3,s3,15
 77c:	0049d993          	srli	s3,s3,0x4
 780:	2985                	addiw	s3,s3,1
 782:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 784:	00001517          	auipc	a0,0x1
 788:	d8c53503          	ld	a0,-628(a0) # 1510 <freep>
 78c:	c905                	beqz	a0,7bc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 790:	4798                	lw	a4,8(a5)
 792:	09377a63          	bgeu	a4,s3,826 <malloc+0xc0>
 796:	f426                	sd	s1,40(sp)
 798:	e852                	sd	s4,16(sp)
 79a:	e456                	sd	s5,8(sp)
 79c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79e:	8a4e                	mv	s4,s3
 7a0:	6705                	lui	a4,0x1
 7a2:	00e9f363          	bgeu	s3,a4,7a8 <malloc+0x42>
 7a6:	6a05                	lui	s4,0x1
 7a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b0:	00001497          	auipc	s1,0x1
 7b4:	d6048493          	addi	s1,s1,-672 # 1510 <freep>
  if(p == (char*)-1)
 7b8:	5afd                	li	s5,-1
 7ba:	a089                	j	7fc <malloc+0x96>
 7bc:	f426                	sd	s1,40(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c4:	00001797          	auipc	a5,0x1
 7c8:	d6c78793          	addi	a5,a5,-660 # 1530 <base>
 7cc:	00001717          	auipc	a4,0x1
 7d0:	d4f73223          	sd	a5,-700(a4) # 1510 <freep>
 7d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7da:	b7d1                	j	79e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	e118                	sd	a4,0(a0)
 7e0:	a8b9                	j	83e <malloc+0xd8>
  hp->s.size = nu;
 7e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e6:	0541                	addi	a0,a0,16
 7e8:	00000097          	auipc	ra,0x0
 7ec:	ef8080e7          	jalr	-264(ra) # 6e0 <free>
  return freep;
 7f0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7f2:	c135                	beqz	a0,856 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f6:	4798                	lw	a4,8(a5)
 7f8:	03277363          	bgeu	a4,s2,81e <malloc+0xb8>
    if(p == freep)
 7fc:	6098                	ld	a4,0(s1)
 7fe:	853e                	mv	a0,a5
 800:	fef71ae3          	bne	a4,a5,7f4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 804:	8552                	mv	a0,s4
 806:	00000097          	auipc	ra,0x0
 80a:	b8e080e7          	jalr	-1138(ra) # 394 <sbrk>
  if(p == (char*)-1)
 80e:	fd551ae3          	bne	a0,s5,7e2 <malloc+0x7c>
        return 0;
 812:	4501                	li	a0,0
 814:	74a2                	ld	s1,40(sp)
 816:	6a42                	ld	s4,16(sp)
 818:	6aa2                	ld	s5,8(sp)
 81a:	6b02                	ld	s6,0(sp)
 81c:	a03d                	j	84a <malloc+0xe4>
 81e:	74a2                	ld	s1,40(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 826:	fae90be3          	beq	s2,a4,7dc <malloc+0x76>
        p->s.size -= nunits;
 82a:	4137073b          	subw	a4,a4,s3
 82e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 830:	02071693          	slli	a3,a4,0x20
 834:	01c6d713          	srli	a4,a3,0x1c
 838:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83e:	00001717          	auipc	a4,0x1
 842:	cca73923          	sd	a0,-814(a4) # 1510 <freep>
      return (void*)(p + 1);
 846:	01078513          	addi	a0,a5,16
  }
}
 84a:	70e2                	ld	ra,56(sp)
 84c:	7442                	ld	s0,48(sp)
 84e:	7902                	ld	s2,32(sp)
 850:	69e2                	ld	s3,24(sp)
 852:	6121                	addi	sp,sp,64
 854:	8082                	ret
 856:	74a2                	ld	s1,40(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	b7f5                	j	84a <malloc+0xe4>

0000000000000860 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 860:	1141                	addi	sp,sp,-16
 862:	e406                	sd	ra,8(sp)
 864:	e022                	sd	s0,0(sp)
 866:	0800                	addi	s0,sp,16
  thread_exit(status);
 868:	2501                	sext.w	a0,a0
 86a:	00000097          	auipc	ra,0x0
 86e:	b5a080e7          	jalr	-1190(ra) # 3c4 <thread_exit>
}
 872:	60a2                	ld	ra,8(sp)
 874:	6402                	ld	s0,0(sp)
 876:	0141                	addi	sp,sp,16
 878:	8082                	ret

000000000000087a <free_stacks>:
int free_stacks() {
 87a:	7179                	addi	sp,sp,-48
 87c:	f406                	sd	ra,40(sp)
 87e:	f022                	sd	s0,32(sp)
 880:	ec26                	sd	s1,24(sp)
 882:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 884:	00001797          	auipc	a5,0x1
 888:	c9c7a783          	lw	a5,-868(a5) # 1520 <num_threads>
 88c:	04f05063          	blez	a5,8cc <free_stacks+0x52>
 890:	e84a                	sd	s2,16(sp)
 892:	e44e                	sd	s3,8(sp)
 894:	4481                	li	s1,0
    free(stacks[i]);
 896:	00001997          	auipc	s3,0x1
 89a:	c8298993          	addi	s3,s3,-894 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 89e:	00001917          	auipc	s2,0x1
 8a2:	c8290913          	addi	s2,s2,-894 # 1520 <num_threads>
    free(stacks[i]);
 8a6:	0009b783          	ld	a5,0(s3)
 8aa:	00349713          	slli	a4,s1,0x3
 8ae:	97ba                	add	a5,a5,a4
 8b0:	6388                	ld	a0,0(a5)
 8b2:	00000097          	auipc	ra,0x0
 8b6:	e2e080e7          	jalr	-466(ra) # 6e0 <free>
  for (int i = 0; i < num_threads; i++) {
 8ba:	0485                	addi	s1,s1,1
 8bc:	00092703          	lw	a4,0(s2)
 8c0:	0004879b          	sext.w	a5,s1
 8c4:	fee7c1e3          	blt	a5,a4,8a6 <free_stacks+0x2c>
 8c8:	6942                	ld	s2,16(sp)
 8ca:	69a2                	ld	s3,8(sp)
  free(stacks);
 8cc:	00001497          	auipc	s1,0x1
 8d0:	c4c48493          	addi	s1,s1,-948 # 1518 <stacks>
 8d4:	6088                	ld	a0,0(s1)
 8d6:	00000097          	auipc	ra,0x0
 8da:	e0a080e7          	jalr	-502(ra) # 6e0 <free>
  stacks = 0;
 8de:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8e2:	00001797          	auipc	a5,0x1
 8e6:	c207af23          	sw	zero,-962(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8ea:	47a1                	li	a5,8
 8ec:	00001717          	auipc	a4,0x1
 8f0:	c0f72a23          	sw	a5,-1004(a4) # 1500 <max_stacks>
  threads_done = 0;
 8f4:	00001797          	auipc	a5,0x1
 8f8:	c207a823          	sw	zero,-976(a5) # 1524 <threads_done>
}
 8fc:	4501                	li	a0,0
 8fe:	70a2                	ld	ra,40(sp)
 900:	7402                	ld	s0,32(sp)
 902:	64e2                	ld	s1,24(sp)
 904:	6145                	addi	sp,sp,48
 906:	8082                	ret

0000000000000908 <expand_num_threads>:
int expand_num_threads() {
 908:	1101                	addi	sp,sp,-32
 90a:	ec06                	sd	ra,24(sp)
 90c:	e822                	sd	s0,16(sp)
 90e:	e426                	sd	s1,8(sp)
 910:	e04a                	sd	s2,0(sp)
 912:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 914:	00001797          	auipc	a5,0x1
 918:	bec78793          	addi	a5,a5,-1044 # 1500 <max_stacks>
 91c:	4388                	lw	a0,0(a5)
 91e:	0015151b          	slliw	a0,a0,0x1
 922:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 924:	0035151b          	slliw	a0,a0,0x3
 928:	00000097          	auipc	ra,0x0
 92c:	e3e080e7          	jalr	-450(ra) # 766 <malloc>
 930:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 932:	00001617          	auipc	a2,0x1
 936:	bee62603          	lw	a2,-1042(a2) # 1520 <num_threads>
 93a:	00001497          	auipc	s1,0x1
 93e:	bde48493          	addi	s1,s1,-1058 # 1518 <stacks>
 942:	0036161b          	slliw	a2,a2,0x3
 946:	608c                	ld	a1,0(s1)
 948:	00000097          	auipc	ra,0x0
 94c:	90a080e7          	jalr	-1782(ra) # 252 <memmove>
  free(stacks);
 950:	6088                	ld	a0,0(s1)
 952:	00000097          	auipc	ra,0x0
 956:	d8e080e7          	jalr	-626(ra) # 6e0 <free>
  stacks = new_stacks;
 95a:	0124b023          	sd	s2,0(s1)
}
 95e:	4501                	li	a0,0
 960:	60e2                	ld	ra,24(sp)
 962:	6442                	ld	s0,16(sp)
 964:	64a2                	ld	s1,8(sp)
 966:	6902                	ld	s2,0(sp)
 968:	6105                	addi	sp,sp,32
 96a:	8082                	ret

000000000000096c <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 96c:	7179                	addi	sp,sp,-48
 96e:	f406                	sd	ra,40(sp)
 970:	f022                	sd	s0,32(sp)
 972:	e84a                	sd	s2,16(sp)
 974:	e44e                	sd	s3,8(sp)
 976:	1800                	addi	s0,sp,48
 978:	892a                	mv	s2,a0
 97a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 97c:	00001797          	auipc	a5,0x1
 980:	b9c7b783          	ld	a5,-1124(a5) # 1518 <stacks>
 984:	c3d9                	beqz	a5,a0a <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 986:	00001797          	auipc	a5,0x1
 98a:	b7a7a783          	lw	a5,-1158(a5) # 1500 <max_stacks>
 98e:	00001717          	auipc	a4,0x1
 992:	b9272703          	lw	a4,-1134(a4) # 1520 <num_threads>
 996:	0af71363          	bne	a4,a5,a3c <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 99a:	04000713          	li	a4,64
 99e:	08e78563          	beq	a5,a4,a28 <ithread_create+0xbc>
 9a2:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9a4:	00000097          	auipc	ra,0x0
 9a8:	f64080e7          	jalr	-156(ra) # 908 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9ac:	6505                	lui	a0,0x1
 9ae:	00000097          	auipc	ra,0x0
 9b2:	db8080e7          	jalr	-584(ra) # 766 <malloc>
 9b6:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9b8:	00001717          	auipc	a4,0x1
 9bc:	b6872703          	lw	a4,-1176(a4) # 1520 <num_threads>
 9c0:	070e                	slli	a4,a4,0x3
 9c2:	00001797          	auipc	a5,0x1
 9c6:	b567b783          	ld	a5,-1194(a5) # 1518 <stacks>
 9ca:	97ba                	add	a5,a5,a4
 9cc:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9ce:	00000697          	auipc	a3,0x0
 9d2:	e9268693          	addi	a3,a3,-366 # 860 <ithread_exit>
 9d6:	862a                	mv	a2,a0
 9d8:	85ce                	mv	a1,s3
 9da:	854a                	mv	a0,s2
 9dc:	00000097          	auipc	ra,0x0
 9e0:	9d8080e7          	jalr	-1576(ra) # 3b4 <create_thread>
 9e4:	892a                	mv	s2,a0
  if (res != -1) {
 9e6:	57fd                	li	a5,-1
 9e8:	04f50c63          	beq	a0,a5,a40 <ithread_create+0xd4>
    num_threads++;
 9ec:	00001717          	auipc	a4,0x1
 9f0:	b3470713          	addi	a4,a4,-1228 # 1520 <num_threads>
 9f4:	431c                	lw	a5,0(a4)
 9f6:	2785                	addiw	a5,a5,1
 9f8:	c31c                	sw	a5,0(a4)
 9fa:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9fc:	854a                	mv	a0,s2
 9fe:	70a2                	ld	ra,40(sp)
 a00:	7402                	ld	s0,32(sp)
 a02:	6942                	ld	s2,16(sp)
 a04:	69a2                	ld	s3,8(sp)
 a06:	6145                	addi	sp,sp,48
 a08:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a0a:	00001517          	auipc	a0,0x1
 a0e:	af652503          	lw	a0,-1290(a0) # 1500 <max_stacks>
 a12:	0035151b          	slliw	a0,a0,0x3
 a16:	00000097          	auipc	ra,0x0
 a1a:	d50080e7          	jalr	-688(ra) # 766 <malloc>
 a1e:	00001797          	auipc	a5,0x1
 a22:	aea7bd23          	sd	a0,-1286(a5) # 1518 <stacks>
 a26:	b785                	j	986 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a28:	00000517          	auipc	a0,0x0
 a2c:	0a850513          	addi	a0,a0,168 # ad0 <ithread_join+0x6a>
 a30:	00000097          	auipc	ra,0x0
 a34:	c7a080e7          	jalr	-902(ra) # 6aa <printf>
      return -1;
 a38:	597d                	li	s2,-1
 a3a:	b7c9                	j	9fc <ithread_create+0x90>
 a3c:	ec26                	sd	s1,24(sp)
 a3e:	b7bd                	j	9ac <ithread_create+0x40>
    free(stack_ptr);
 a40:	8526                	mv	a0,s1
 a42:	00000097          	auipc	ra,0x0
 a46:	c9e080e7          	jalr	-866(ra) # 6e0 <free>
    stacks[num_threads] = 0;
 a4a:	00001717          	auipc	a4,0x1
 a4e:	ad672703          	lw	a4,-1322(a4) # 1520 <num_threads>
 a52:	070e                	slli	a4,a4,0x3
 a54:	00001797          	auipc	a5,0x1
 a58:	ac47b783          	ld	a5,-1340(a5) # 1518 <stacks>
 a5c:	97ba                	add	a5,a5,a4
 a5e:	0007b023          	sd	zero,0(a5)
 a62:	64e2                	ld	s1,24(sp)
 a64:	bf61                	j	9fc <ithread_create+0x90>

0000000000000a66 <ithread_join>:

int ithread_join(int thread_id) {
 a66:	1101                	addi	sp,sp,-32
 a68:	ec06                	sd	ra,24(sp)
 a6a:	e822                	sd	s0,16(sp)
 a6c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a6e:	ff040793          	addi	a5,s0,-16
 a72:	ffc7859b          	addiw	a1,a5,-4
 a76:	00000097          	auipc	ra,0x0
 a7a:	946080e7          	jalr	-1722(ra) # 3bc <join_thread>
  threads_done++;
 a7e:	00001717          	auipc	a4,0x1
 a82:	aa670713          	addi	a4,a4,-1370 # 1524 <threads_done>
 a86:	431c                	lw	a5,0(a4)
 a88:	2785                	addiw	a5,a5,1
 a8a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a8c:	00001717          	auipc	a4,0x1
 a90:	a9472703          	lw	a4,-1388(a4) # 1520 <num_threads>
 a94:	00f70863          	beq	a4,a5,aa4 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 a98:	fec42503          	lw	a0,-20(s0)
 a9c:	60e2                	ld	ra,24(sp)
 a9e:	6442                	ld	s0,16(sp)
 aa0:	6105                	addi	sp,sp,32
 aa2:	8082                	ret
    free_stacks();
 aa4:	00000097          	auipc	ra,0x0
 aa8:	dd6080e7          	jalr	-554(ra) # 87a <free_stacks>
 aac:	b7f5                	j	a98 <ithread_join+0x32>
