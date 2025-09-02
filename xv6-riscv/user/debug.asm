
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
  16:	77a080e7          	jalr	1914(ra) # 78c <malloc>
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
  32:	ab298993          	addi	s3,s3,-1358 # ae0 <ithread_join+0x54>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	68a080e7          	jalr	1674(ra) # 6d0 <printf>
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

00000000000003f4 <send>:
.global send
send:
 li a7, SYS_send
 3f4:	48fd                	li	a7,31
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <recv>:
.global recv
recv:
 li a7, SYS_recv
 3fc:	02000893          	li	a7,32
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 406:	02100893          	li	a7,33
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 410:	02200893          	li	a7,34
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	1000                	addi	s0,sp,32
 422:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 426:	4605                	li	a2,1
 428:	fef40593          	addi	a1,s0,-17
 42c:	00000097          	auipc	ra,0x0
 430:	f00080e7          	jalr	-256(ra) # 32c <write>
}
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	6105                	addi	sp,sp,32
 43a:	8082                	ret

000000000000043c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43c:	7139                	addi	sp,sp,-64
 43e:	fc06                	sd	ra,56(sp)
 440:	f822                	sd	s0,48(sp)
 442:	f426                	sd	s1,40(sp)
 444:	f04a                	sd	s2,32(sp)
 446:	ec4e                	sd	s3,24(sp)
 448:	0080                	addi	s0,sp,64
 44a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44c:	c299                	beqz	a3,452 <printint+0x16>
 44e:	0805c063          	bltz	a1,4ce <printint+0x92>
  neg = 0;
 452:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 454:	fc040313          	addi	t1,s0,-64
  neg = 0;
 458:	869a                	mv	a3,t1
  i = 0;
 45a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 45c:	00000817          	auipc	a6,0x0
 460:	72c80813          	addi	a6,a6,1836 # b88 <digits>
 464:	88be                	mv	a7,a5
 466:	0017851b          	addiw	a0,a5,1
 46a:	87aa                	mv	a5,a0
 46c:	02c5f73b          	remuw	a4,a1,a2
 470:	1702                	slli	a4,a4,0x20
 472:	9301                	srli	a4,a4,0x20
 474:	9742                	add	a4,a4,a6
 476:	00074703          	lbu	a4,0(a4)
 47a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 47e:	872e                	mv	a4,a1
 480:	02c5d5bb          	divuw	a1,a1,a2
 484:	0685                	addi	a3,a3,1
 486:	fcc77fe3          	bgeu	a4,a2,464 <printint+0x28>
  if(neg)
 48a:	000e0c63          	beqz	t3,4a2 <printint+0x66>
    buf[i++] = '-';
 48e:	fd050793          	addi	a5,a0,-48
 492:	00878533          	add	a0,a5,s0
 496:	02d00793          	li	a5,45
 49a:	fef50823          	sb	a5,-16(a0)
 49e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4a2:	fff7899b          	addiw	s3,a5,-1
 4a6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4aa:	fff4c583          	lbu	a1,-1(s1)
 4ae:	854a                	mv	a0,s2
 4b0:	00000097          	auipc	ra,0x0
 4b4:	f6a080e7          	jalr	-150(ra) # 41a <putc>
  while(--i >= 0)
 4b8:	39fd                	addiw	s3,s3,-1
 4ba:	14fd                	addi	s1,s1,-1
 4bc:	fe09d7e3          	bgez	s3,4aa <printint+0x6e>
}
 4c0:	70e2                	ld	ra,56(sp)
 4c2:	7442                	ld	s0,48(sp)
 4c4:	74a2                	ld	s1,40(sp)
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
 4ca:	6121                	addi	sp,sp,64
 4cc:	8082                	ret
    x = -xx;
 4ce:	40b005bb          	negw	a1,a1
    neg = 1;
 4d2:	4e05                	li	t3,1
    x = -xx;
 4d4:	b741                	j	454 <printint+0x18>

00000000000004d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d6:	715d                	addi	sp,sp,-80
 4d8:	e486                	sd	ra,72(sp)
 4da:	e0a2                	sd	s0,64(sp)
 4dc:	f84a                	sd	s2,48(sp)
 4de:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e0:	0005c903          	lbu	s2,0(a1)
 4e4:	1a090a63          	beqz	s2,698 <vprintf+0x1c2>
 4e8:	fc26                	sd	s1,56(sp)
 4ea:	f44e                	sd	s3,40(sp)
 4ec:	f052                	sd	s4,32(sp)
 4ee:	ec56                	sd	s5,24(sp)
 4f0:	e85a                	sd	s6,16(sp)
 4f2:	e45e                	sd	s7,8(sp)
 4f4:	8aaa                	mv	s5,a0
 4f6:	8bb2                	mv	s7,a2
 4f8:	00158493          	addi	s1,a1,1
  state = 0;
 4fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fe:	02500a13          	li	s4,37
 502:	4b55                	li	s6,21
 504:	a839                	j	522 <vprintf+0x4c>
        putc(fd, c);
 506:	85ca                	mv	a1,s2
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	f10080e7          	jalr	-240(ra) # 41a <putc>
 512:	a019                	j	518 <vprintf+0x42>
    } else if(state == '%'){
 514:	01498d63          	beq	s3,s4,52e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 518:	0485                	addi	s1,s1,1
 51a:	fff4c903          	lbu	s2,-1(s1)
 51e:	16090763          	beqz	s2,68c <vprintf+0x1b6>
    if(state == 0){
 522:	fe0999e3          	bnez	s3,514 <vprintf+0x3e>
      if(c == '%'){
 526:	ff4910e3          	bne	s2,s4,506 <vprintf+0x30>
        state = '%';
 52a:	89d2                	mv	s3,s4
 52c:	b7f5                	j	518 <vprintf+0x42>
      if(c == 'd'){
 52e:	13490463          	beq	s2,s4,656 <vprintf+0x180>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f793          	zext.b	a5,a5
 53a:	12fb6763          	bltu	s6,a5,668 <vprintf+0x192>
 53e:	f9d9079b          	addiw	a5,s2,-99
 542:	0ff7f713          	zext.b	a4,a5
 546:	12eb6163          	bltu	s6,a4,668 <vprintf+0x192>
 54a:	00271793          	slli	a5,a4,0x2
 54e:	00000717          	auipc	a4,0x0
 552:	5e270713          	addi	a4,a4,1506 # b30 <ithread_join+0xa4>
 556:	97ba                	add	a5,a5,a4
 558:	439c                	lw	a5,0(a5)
 55a:	97ba                	add	a5,a5,a4
 55c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 55e:	008b8913          	addi	s2,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ed0080e7          	jalr	-304(ra) # 43c <printint>
 574:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 576:	4981                	li	s3,0
 578:	b745                	j	518 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57a:	008b8913          	addi	s2,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	eb4080e7          	jalr	-332(ra) # 43c <printint>
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
 594:	b751                	j	518 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 596:	008b8913          	addi	s2,s7,8
 59a:	4681                	li	a3,0
 59c:	4641                	li	a2,16
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e98080e7          	jalr	-360(ra) # 43c <printint>
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b7a5                	j	518 <vprintf+0x42>
 5b2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b4:	008b8c13          	addi	s8,s7,8
 5b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5bc:	03000593          	li	a1,48
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e58080e7          	jalr	-424(ra) # 41a <putc>
  putc(fd, 'x');
 5ca:	07800593          	li	a1,120
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e4a080e7          	jalr	-438(ra) # 41a <putc>
 5d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5da:	00000b97          	auipc	s7,0x0
 5de:	5aeb8b93          	addi	s7,s7,1454 # b88 <digits>
 5e2:	03c9d793          	srli	a5,s3,0x3c
 5e6:	97de                	add	a5,a5,s7
 5e8:	0007c583          	lbu	a1,0(a5)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e2c080e7          	jalr	-468(ra) # 41a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	397d                	addiw	s2,s2,-1
 5fa:	fe0914e3          	bnez	s2,5e2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5fe:	8be2                	mv	s7,s8
      state = 0;
 600:	4981                	li	s3,0
 602:	6c02                	ld	s8,0(sp)
 604:	bf11                	j	518 <vprintf+0x42>
        s = va_arg(ap, char*);
 606:	008b8993          	addi	s3,s7,8
 60a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 60e:	02090163          	beqz	s2,630 <vprintf+0x15a>
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	c9a5                	beqz	a1,686 <vprintf+0x1b0>
          putc(fd, *s);
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e00080e7          	jalr	-512(ra) # 41a <putc>
          s++;
 622:	0905                	addi	s2,s2,1
        while(*s != 0){
 624:	00094583          	lbu	a1,0(s2)
 628:	f9e5                	bnez	a1,618 <vprintf+0x142>
        s = va_arg(ap, char*);
 62a:	8bce                	mv	s7,s3
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b5ed                	j	518 <vprintf+0x42>
          s = "(null)";
 630:	00000917          	auipc	s2,0x0
 634:	4c890913          	addi	s2,s2,1224 # af8 <ithread_join+0x6c>
        while(*s != 0){
 638:	02800593          	li	a1,40
 63c:	bff1                	j	618 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 63e:	008b8913          	addi	s2,s7,8
 642:	000bc583          	lbu	a1,0(s7)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dd2080e7          	jalr	-558(ra) # 41a <putc>
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	b5d1                	j	518 <vprintf+0x42>
        putc(fd, c);
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dbe080e7          	jalr	-578(ra) # 41a <putc>
      state = 0;
 664:	4981                	li	s3,0
 666:	bd4d                	j	518 <vprintf+0x42>
        putc(fd, '%');
 668:	02500593          	li	a1,37
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	dac080e7          	jalr	-596(ra) # 41a <putc>
        putc(fd, c);
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	da0080e7          	jalr	-608(ra) # 41a <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	bd51                	j	518 <vprintf+0x42>
        s = va_arg(ap, char*);
 686:	8bce                	mv	s7,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	b579                	j	518 <vprintf+0x42>
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
 6c4:	e16080e7          	jalr	-490(ra) # 4d6 <vprintf>
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
 6fa:	de0080e7          	jalr	-544(ra) # 4d6 <vprintf>
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
 71a:	a02d                	j	744 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71c:	4618                	lw	a4,8(a2)
 71e:	9f2d                	addw	a4,a4,a1
 720:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 724:	6398                	ld	a4,0(a5)
 726:	6310                	ld	a2,0(a4)
 728:	a83d                	j	766 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 72a:	ff852703          	lw	a4,-8(a0)
 72e:	9f31                	addw	a4,a4,a2
 730:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 732:	ff053683          	ld	a3,-16(a0)
 736:	a091                	j	77a <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	6398                	ld	a4,0(a5)
 73a:	00e7e463          	bltu	a5,a4,742 <free+0x3c>
 73e:	00e6ea63          	bltu	a3,a4,752 <free+0x4c>
{
 742:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	fed7fae3          	bgeu	a5,a3,738 <free+0x32>
 748:	6398                	ld	a4,0(a5)
 74a:	00e6e463          	bltu	a3,a4,752 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74e:	fee7eae3          	bltu	a5,a4,742 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 752:	ff852583          	lw	a1,-8(a0)
 756:	6390                	ld	a2,0(a5)
 758:	02059813          	slli	a6,a1,0x20
 75c:	01c85713          	srli	a4,a6,0x1c
 760:	9736                	add	a4,a4,a3
 762:	fae60de3          	beq	a2,a4,71c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 76a:	4790                	lw	a2,8(a5)
 76c:	02061593          	slli	a1,a2,0x20
 770:	01c5d713          	srli	a4,a1,0x1c
 774:	973e                	add	a4,a4,a5
 776:	fae68ae3          	beq	a3,a4,72a <free+0x24>
    p->s.ptr = bp->s.ptr;
 77a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 77c:	00001717          	auipc	a4,0x1
 780:	d8f73a23          	sd	a5,-620(a4) # 1510 <freep>
}
 784:	60a2                	ld	ra,8(sp)
 786:	6402                	ld	s0,0(sp)
 788:	0141                	addi	sp,sp,16
 78a:	8082                	ret

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
 830:	b68080e7          	jalr	-1176(ra) # 394 <sbrk>
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
 894:	b34080e7          	jalr	-1228(ra) # 3c4 <thread_exit>
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
 972:	8e4080e7          	jalr	-1820(ra) # 252 <memmove>
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
 9bc:	0af71363          	bne	a4,a5,a62 <ithread_create+0xd0>
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
 a06:	9b2080e7          	jalr	-1614(ra) # 3b4 <create_thread>
 a0a:	892a                	mv	s2,a0
  if (res != -1) {
 a0c:	57fd                	li	a5,-1
 a0e:	04f50c63          	beq	a0,a5,a66 <ithread_create+0xd4>
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
 a52:	0b250513          	addi	a0,a0,178 # b00 <ithread_join+0x74>
 a56:	00000097          	auipc	ra,0x0
 a5a:	c7a080e7          	jalr	-902(ra) # 6d0 <printf>
      return -1;
 a5e:	597d                	li	s2,-1
 a60:	b7c9                	j	a22 <ithread_create+0x90>
 a62:	ec26                	sd	s1,24(sp)
 a64:	b7bd                	j	9d2 <ithread_create+0x40>
    free(stack_ptr);
 a66:	8526                	mv	a0,s1
 a68:	00000097          	auipc	ra,0x0
 a6c:	c9e080e7          	jalr	-866(ra) # 706 <free>
    stacks[num_threads] = 0;
 a70:	00001717          	auipc	a4,0x1
 a74:	ab072703          	lw	a4,-1360(a4) # 1520 <num_threads>
 a78:	070e                	slli	a4,a4,0x3
 a7a:	00001797          	auipc	a5,0x1
 a7e:	a9e7b783          	ld	a5,-1378(a5) # 1518 <stacks>
 a82:	97ba                	add	a5,a5,a4
 a84:	0007b023          	sd	zero,0(a5)
 a88:	64e2                	ld	s1,24(sp)
 a8a:	bf61                	j	a22 <ithread_create+0x90>

0000000000000a8c <ithread_join>:

int ithread_join(int thread_id) {
 a8c:	1101                	addi	sp,sp,-32
 a8e:	ec06                	sd	ra,24(sp)
 a90:	e822                	sd	s0,16(sp)
 a92:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a94:	ff040793          	addi	a5,s0,-16
 a98:	ffc7859b          	addiw	a1,a5,-4
 a9c:	00000097          	auipc	ra,0x0
 aa0:	920080e7          	jalr	-1760(ra) # 3bc <join_thread>
  threads_done++;
 aa4:	00001717          	auipc	a4,0x1
 aa8:	a8070713          	addi	a4,a4,-1408 # 1524 <threads_done>
 aac:	431c                	lw	a5,0(a4)
 aae:	2785                	addiw	a5,a5,1
 ab0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ab2:	00001717          	auipc	a4,0x1
 ab6:	a6e72703          	lw	a4,-1426(a4) # 1520 <num_threads>
 aba:	00f70863          	beq	a4,a5,aca <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 abe:	fec42503          	lw	a0,-20(s0)
 ac2:	60e2                	ld	ra,24(sp)
 ac4:	6442                	ld	s0,16(sp)
 ac6:	6105                	addi	sp,sp,32
 ac8:	8082                	ret
    free_stacks();
 aca:	00000097          	auipc	ra,0x0
 ace:	dd6080e7          	jalr	-554(ra) # 8a0 <free_stacks>
 ad2:	b7f5                	j	abe <ithread_join+0x32>
