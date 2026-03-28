
src/user/_debug:     file format elf64-littleriscv


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
  12:	00001097          	auipc	ra,0x1
  16:	860080e7          	jalr	-1952(ra) # 872 <malloc>
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
  32:	ba298993          	addi	s3,s3,-1118 # bd0 <ithread_join+0x58>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	774080e7          	jalr	1908(ra) # 7ba <printf>
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
  68:	380080e7          	jalr	896(ra) # 3e4 <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  72:	87aa                	mv	a5,a0
  74:	0585                	addi	a1,a1,1
  76:	0785                	addi	a5,a5,1
  78:	fff5c703          	lbu	a4,-1(a1)
  7c:	fee78fa3          	sb	a4,-1(a5)
  80:	fb75                	bnez	a4,74 <strcpy+0x8>
    ;
  return os;
}
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cb91                	beqz	a5,a6 <strcmp+0x1e>
  94:	0005c703          	lbu	a4,0(a1)
  98:	00f71763          	bne	a4,a5,a6 <strcmp+0x1e>
    p++, q++;
  9c:	0505                	addi	a0,a0,1
  9e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	fbe5                	bnez	a5,94 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a6:	0005c503          	lbu	a0,0(a1)
}
  aa:	40a7853b          	subw	a0,a5,a0
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cf91                	beqz	a5,da <strlen+0x26>
  c0:	0505                	addi	a0,a0,1
  c2:	87aa                	mv	a5,a0
  c4:	86be                	mv	a3,a5
  c6:	0785                	addi	a5,a5,1
  c8:	fff7c703          	lbu	a4,-1(a5)
  cc:	ff65                	bnez	a4,c4 <strlen+0x10>
  ce:	40a6853b          	subw	a0,a3,a0
  d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret
  for(n = 0; s[n]; n++)
  da:	4501                	li	a0,0
  dc:	bfe5                	j	d4 <strlen+0x20>

00000000000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1c>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x12>
  }
  return dst;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e422                	sd	s0,8(sp)
 104:	0800                	addi	s0,sp,16
  for(; *s; s++)
 106:	00054783          	lbu	a5,0(a0)
 10a:	cb99                	beqz	a5,120 <strchr+0x20>
    if(*s == c)
 10c:	00f58763          	beq	a1,a5,11a <strchr+0x1a>
  for(; *s; s++)
 110:	0505                	addi	a0,a0,1
 112:	00054783          	lbu	a5,0(a0)
 116:	fbfd                	bnez	a5,10c <strchr+0xc>
      return (char*)s;
  return 0;
 118:	4501                	li	a0,0
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret
  return 0;
 120:	4501                	li	a0,0
 122:	bfe5                	j	11a <strchr+0x1a>

0000000000000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	1080                	addi	s0,sp,96
 13a:	8baa                	mv	s7,a0
 13c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13e:	892a                	mv	s2,a0
 140:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 142:	4aa9                	li	s5,10
 144:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 146:	89a6                	mv	s3,s1
 148:	2485                	addiw	s1,s1,1
 14a:	0344d863          	bge	s1,s4,17a <gets+0x56>
    cc = read(0, &c, 1);
 14e:	4605                	li	a2,1
 150:	faf40593          	addi	a1,s0,-81
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2a6080e7          	jalr	678(ra) # 3fc <read>
    if(cc < 1)
 15e:	00a05e63          	blez	a0,17a <gets+0x56>
    buf[i++] = c;
 162:	faf44783          	lbu	a5,-81(s0)
 166:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 16a:	01578763          	beq	a5,s5,178 <gets+0x54>
 16e:	0905                	addi	s2,s2,1
 170:	fd679be3          	bne	a5,s6,146 <gets+0x22>
    buf[i++] = c;
 174:	89a6                	mv	s3,s1
 176:	a011                	j	17a <gets+0x56>
 178:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 17a:	99de                	add	s3,s3,s7
 17c:	00098023          	sb	zero,0(s3)
  return buf;
}
 180:	855e                	mv	a0,s7
 182:	60e6                	ld	ra,88(sp)
 184:	6446                	ld	s0,80(sp)
 186:	64a6                	ld	s1,72(sp)
 188:	6906                	ld	s2,64(sp)
 18a:	79e2                	ld	s3,56(sp)
 18c:	7a42                	ld	s4,48(sp)
 18e:	7aa2                	ld	s5,40(sp)
 190:	7b02                	ld	s6,32(sp)
 192:	6be2                	ld	s7,24(sp)
 194:	6125                	addi	sp,sp,96
 196:	8082                	ret

0000000000000198 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 198:	711d                	addi	sp,sp,-96
 19a:	ec86                	sd	ra,88(sp)
 19c:	e8a2                	sd	s0,80(sp)
 19e:	e4a6                	sd	s1,72(sp)
 1a0:	e0ca                	sd	s2,64(sp)
 1a2:	fc4e                	sd	s3,56(sp)
 1a4:	f852                	sd	s4,48(sp)
 1a6:	f456                	sd	s5,40(sp)
 1a8:	f05a                	sd	s6,32(sp)
 1aa:	ec5e                	sd	s7,24(sp)
 1ac:	1080                	addi	s0,sp,96
 1ae:	8baa                	mv	s7,a0
 1b0:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 1b2:	892a                	mv	s2,a0
 1b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b6:	4aa9                	li	s5,10
 1b8:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 1ba:	8a26                	mv	s4,s1
 1bc:	2485                	addiw	s1,s1,1
 1be:	0334d863          	bge	s1,s3,1ee <fgetstdin+0x56>
    cc = read(0, &c, 1);
 1c2:	4605                	li	a2,1
 1c4:	faf40593          	addi	a1,s0,-81
 1c8:	4501                	li	a0,0
 1ca:	00000097          	auipc	ra,0x0
 1ce:	232080e7          	jalr	562(ra) # 3fc <read>
    if(cc < 1)
 1d2:	00a05e63          	blez	a0,1ee <fgetstdin+0x56>
    buf[i++] = c;
 1d6:	faf44783          	lbu	a5,-81(s0)
 1da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1de:	01578763          	beq	a5,s5,1ec <fgetstdin+0x54>
 1e2:	0905                	addi	s2,s2,1
 1e4:	fd679be3          	bne	a5,s6,1ba <fgetstdin+0x22>
    buf[i++] = c;
 1e8:	8a26                	mv	s4,s1
 1ea:	a011                	j	1ee <fgetstdin+0x56>
 1ec:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 1ee:	9bd2                	add	s7,s7,s4
 1f0:	000b8023          	sb	zero,0(s7)
  return i;
}
 1f4:	8552                	mv	a0,s4
 1f6:	60e6                	ld	ra,88(sp)
 1f8:	6446                	ld	s0,80(sp)
 1fa:	64a6                	ld	s1,72(sp)
 1fc:	6906                	ld	s2,64(sp)
 1fe:	79e2                	ld	s3,56(sp)
 200:	7a42                	ld	s4,48(sp)
 202:	7aa2                	ld	s5,40(sp)
 204:	7b02                	ld	s6,32(sp)
 206:	6be2                	ld	s7,24(sp)
 208:	6125                	addi	sp,sp,96
 20a:	8082                	ret

000000000000020c <stat>:

int
stat(const char *n, struct stat *st)
{
 20c:	1101                	addi	sp,sp,-32
 20e:	ec06                	sd	ra,24(sp)
 210:	e822                	sd	s0,16(sp)
 212:	e04a                	sd	s2,0(sp)
 214:	1000                	addi	s0,sp,32
 216:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	4581                	li	a1,0
 21a:	00000097          	auipc	ra,0x0
 21e:	20a080e7          	jalr	522(ra) # 424 <open>
  if(fd < 0)
 222:	02054663          	bltz	a0,24e <stat+0x42>
 226:	e426                	sd	s1,8(sp)
 228:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22a:	85ca                	mv	a1,s2
 22c:	00000097          	auipc	ra,0x0
 230:	210080e7          	jalr	528(ra) # 43c <fstat>
 234:	892a                	mv	s2,a0
  close(fd);
 236:	8526                	mv	a0,s1
 238:	00000097          	auipc	ra,0x0
 23c:	1d4080e7          	jalr	468(ra) # 40c <close>
  return r;
 240:	64a2                	ld	s1,8(sp)
}
 242:	854a                	mv	a0,s2
 244:	60e2                	ld	ra,24(sp)
 246:	6442                	ld	s0,16(sp)
 248:	6902                	ld	s2,0(sp)
 24a:	6105                	addi	sp,sp,32
 24c:	8082                	ret
    return -1;
 24e:	597d                	li	s2,-1
 250:	bfcd                	j	242 <stat+0x36>

0000000000000252 <atoi>:

int
atoi(const char *s)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 258:	00054683          	lbu	a3,0(a0)
 25c:	fd06879b          	addiw	a5,a3,-48
 260:	0ff7f793          	zext.b	a5,a5
 264:	4625                	li	a2,9
 266:	02f66863          	bltu	a2,a5,296 <atoi+0x44>
 26a:	872a                	mv	a4,a0
  n = 0;
 26c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 26e:	0705                	addi	a4,a4,1
 270:	0025179b          	slliw	a5,a0,0x2
 274:	9fa9                	addw	a5,a5,a0
 276:	0017979b          	slliw	a5,a5,0x1
 27a:	9fb5                	addw	a5,a5,a3
 27c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 280:	00074683          	lbu	a3,0(a4)
 284:	fd06879b          	addiw	a5,a3,-48
 288:	0ff7f793          	zext.b	a5,a5
 28c:	fef671e3          	bgeu	a2,a5,26e <atoi+0x1c>
  return n;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  n = 0;
 296:	4501                	li	a0,0
 298:	bfe5                	j	290 <atoi+0x3e>

000000000000029a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57463          	bgeu	a0,a1,2c8 <memmove+0x2e>
    while(n-- > 0)
 2a4:	00c05f63          	blez	a2,2c2 <memmove+0x28>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b2:	0585                	addi	a1,a1,1
 2b4:	0705                	addi	a4,a4,1
 2b6:	fff5c683          	lbu	a3,-1(a1)
 2ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2be:	fef71ae3          	bne	a4,a5,2b2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
    dst += n;
 2c8:	00c50733          	add	a4,a0,a2
    src += n;
 2cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ce:	fec05ae3          	blez	a2,2c2 <memmove+0x28>
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	fff7c793          	not	a5,a5
 2de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e0:	15fd                	addi	a1,a1,-1
 2e2:	177d                	addi	a4,a4,-1
 2e4:	0005c683          	lbu	a3,0(a1)
 2e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ec:	fee79ae3          	bne	a5,a4,2e0 <memmove+0x46>
 2f0:	bfc9                	j	2c2 <memmove+0x28>

00000000000002f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f8:	ca05                	beqz	a2,328 <memcmp+0x36>
 2fa:	fff6069b          	addiw	a3,a2,-1
 2fe:	1682                	slli	a3,a3,0x20
 300:	9281                	srli	a3,a3,0x20
 302:	0685                	addi	a3,a3,1
 304:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 306:	00054783          	lbu	a5,0(a0)
 30a:	0005c703          	lbu	a4,0(a1)
 30e:	00e79863          	bne	a5,a4,31e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 312:	0505                	addi	a0,a0,1
    p2++;
 314:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 316:	fed518e3          	bne	a0,a3,306 <memcmp+0x14>
  }
  return 0;
 31a:	4501                	li	a0,0
 31c:	a019                	j	322 <memcmp+0x30>
      return *p1 - *p2;
 31e:	40e7853b          	subw	a0,a5,a4
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <memcmp+0x30>

000000000000032c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 334:	00000097          	auipc	ra,0x0
 338:	f66080e7          	jalr	-154(ra) # 29a <memmove>
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 344:	1141                	addi	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 34a:	00054783          	lbu	a5,0(a0)
 34e:	cfbd                	beqz	a5,3cc <inet_addr+0x88>
  int dots = 0;
 350:	4801                	li	a6,0
  int digits = 0;
 352:	4601                	li	a2,0
  int octet = 0;
 354:	4681                	li	a3,0
  uint result = 0;
 356:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 358:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 35a:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 35e:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 360:	4301                	li	t1,0
      if (octet > 255)
 362:	0ff00e13          	li	t3,255
 366:	a015                	j	38a <inet_addr+0x46>
    } else if (*s == '.') {
 368:	07d79463          	bne	a5,t4,3d0 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 36c:	c625                	beqz	a2,3d4 <inet_addr+0x90>
 36e:	07e80563          	beq	a6,t5,3d8 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 372:	0085959b          	slliw	a1,a1,0x8
 376:	8ecd                	or	a3,a3,a1
 378:	0006859b          	sext.w	a1,a3
      dots++;
 37c:	2805                	addiw	a6,a6,1
      digits = 0;
 37e:	861a                	mv	a2,t1
      octet = 0;
 380:	869a                	mv	a3,t1
  for (; *s; s++) {
 382:	0505                	addi	a0,a0,1
 384:	00054783          	lbu	a5,0(a0)
 388:	c79d                	beqz	a5,3b6 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 38a:	fd07871b          	addiw	a4,a5,-48
 38e:	0ff77713          	zext.b	a4,a4
 392:	fce8ebe3          	bltu	a7,a4,368 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 396:	0026971b          	slliw	a4,a3,0x2
 39a:	9f35                	addw	a4,a4,a3
 39c:	0017171b          	slliw	a4,a4,0x1
 3a0:	fd07879b          	addiw	a5,a5,-48
 3a4:	00e786bb          	addw	a3,a5,a4
      digits++;
 3a8:	2605                	addiw	a2,a2,1
      if (octet > 255)
 3aa:	fcde5ce3          	bge	t3,a3,382 <inet_addr+0x3e>
        return 0;
 3ae:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
    return 0;
 3b6:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 3b8:	de65                	beqz	a2,3b0 <inet_addr+0x6c>
 3ba:	478d                	li	a5,3
 3bc:	fef81ae3          	bne	a6,a5,3b0 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 3c0:	0085959b          	slliw	a1,a1,0x8
 3c4:	8ecd                	or	a3,a3,a1
 3c6:	0006851b          	sext.w	a0,a3
  return result;
 3ca:	b7dd                	j	3b0 <inet_addr+0x6c>
    return 0;
 3cc:	4501                	li	a0,0
 3ce:	b7cd                	j	3b0 <inet_addr+0x6c>
      return 0;
 3d0:	4501                	li	a0,0
 3d2:	bff9                	j	3b0 <inet_addr+0x6c>
        return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe9                	j	3b0 <inet_addr+0x6c>
 3d8:	4501                	li	a0,0
 3da:	bfd9                	j	3b0 <inet_addr+0x6c>

00000000000003dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3dc:	4885                	li	a7,1
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e4:	4889                	li	a7,2
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ec:	488d                	li	a7,3
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f4:	4891                	li	a7,4
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <read>:
.global read
read:
 li a7, SYS_read
 3fc:	4895                	li	a7,5
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <write>:
.global write
write:
 li a7, SYS_write
 404:	48c1                	li	a7,16
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <close>:
.global close
close:
 li a7, SYS_close
 40c:	48d5                	li	a7,21
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <kill>:
.global kill
kill:
 li a7, SYS_kill
 414:	4899                	li	a7,6
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exec>:
.global exec
exec:
 li a7, SYS_exec
 41c:	489d                	li	a7,7
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <open>:
.global open
open:
 li a7, SYS_open
 424:	48bd                	li	a7,15
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42c:	48c5                	li	a7,17
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 434:	48c9                	li	a7,18
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43c:	48a1                	li	a7,8
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <link>:
.global link
link:
 li a7, SYS_link
 444:	48cd                	li	a7,19
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44c:	48d1                	li	a7,20
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 454:	48a5                	li	a7,9
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <dup>:
.global dup
dup:
 li a7, SYS_dup
 45c:	48a9                	li	a7,10
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 464:	48ad                	li	a7,11
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 46c:	48b1                	li	a7,12
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 474:	48b5                	li	a7,13
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47c:	48b9                	li	a7,14
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 484:	48d9                	li	a7,22
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 48c:	48dd                	li	a7,23
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 494:	48e1                	li	a7,24
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 49c:	48e5                	li	a7,25
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4a4:	48e9                	li	a7,26
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <bind>:
.global bind
bind:
 li a7, SYS_bind
 4ac:	48ed                	li	a7,27
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4b4:	48f5                	li	a7,29
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <listen>:
.global listen
listen:
 li a7, SYS_listen
 4bc:	48f1                	li	a7,28
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4c4:	48f9                	li	a7,30
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <send>:
.global send
send:
 li a7, SYS_send
 4cc:	48fd                	li	a7,31
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4d4:	02000893          	li	a7,32
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4de:	02100893          	li	a7,33
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4e8:	02200893          	li	a7,34
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f2:	1101                	addi	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	1000                	addi	s0,sp,32
 4fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fe:	4605                	li	a2,1
 500:	fef40593          	addi	a1,s0,-17
 504:	00000097          	auipc	ra,0x0
 508:	f00080e7          	jalr	-256(ra) # 404 <write>
}
 50c:	60e2                	ld	ra,24(sp)
 50e:	6442                	ld	s0,16(sp)
 510:	6105                	addi	sp,sp,32
 512:	8082                	ret

0000000000000514 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 514:	7139                	addi	sp,sp,-64
 516:	fc06                	sd	ra,56(sp)
 518:	f822                	sd	s0,48(sp)
 51a:	f426                	sd	s1,40(sp)
 51c:	0080                	addi	s0,sp,64
 51e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 520:	c299                	beqz	a3,526 <printint+0x12>
 522:	0805cb63          	bltz	a1,5b8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 526:	2581                	sext.w	a1,a1
  neg = 0;
 528:	4881                	li	a7,0
 52a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 52e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 530:	2601                	sext.w	a2,a2
 532:	00000517          	auipc	a0,0x0
 536:	74650513          	addi	a0,a0,1862 # c78 <digits>
 53a:	883a                	mv	a6,a4
 53c:	2705                	addiw	a4,a4,1
 53e:	02c5f7bb          	remuw	a5,a1,a2
 542:	1782                	slli	a5,a5,0x20
 544:	9381                	srli	a5,a5,0x20
 546:	97aa                	add	a5,a5,a0
 548:	0007c783          	lbu	a5,0(a5)
 54c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 550:	0005879b          	sext.w	a5,a1
 554:	02c5d5bb          	divuw	a1,a1,a2
 558:	0685                	addi	a3,a3,1
 55a:	fec7f0e3          	bgeu	a5,a2,53a <printint+0x26>
  if(neg)
 55e:	00088c63          	beqz	a7,576 <printint+0x62>
    buf[i++] = '-';
 562:	fd070793          	addi	a5,a4,-48
 566:	00878733          	add	a4,a5,s0
 56a:	02d00793          	li	a5,45
 56e:	fef70823          	sb	a5,-16(a4)
 572:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 576:	02e05c63          	blez	a4,5ae <printint+0x9a>
 57a:	f04a                	sd	s2,32(sp)
 57c:	ec4e                	sd	s3,24(sp)
 57e:	fc040793          	addi	a5,s0,-64
 582:	00e78933          	add	s2,a5,a4
 586:	fff78993          	addi	s3,a5,-1
 58a:	99ba                	add	s3,s3,a4
 58c:	377d                	addiw	a4,a4,-1
 58e:	1702                	slli	a4,a4,0x20
 590:	9301                	srli	a4,a4,0x20
 592:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 596:	fff94583          	lbu	a1,-1(s2)
 59a:	8526                	mv	a0,s1
 59c:	00000097          	auipc	ra,0x0
 5a0:	f56080e7          	jalr	-170(ra) # 4f2 <putc>
  while(--i >= 0)
 5a4:	197d                	addi	s2,s2,-1
 5a6:	ff3918e3          	bne	s2,s3,596 <printint+0x82>
 5aa:	7902                	ld	s2,32(sp)
 5ac:	69e2                	ld	s3,24(sp)
}
 5ae:	70e2                	ld	ra,56(sp)
 5b0:	7442                	ld	s0,48(sp)
 5b2:	74a2                	ld	s1,40(sp)
 5b4:	6121                	addi	sp,sp,64
 5b6:	8082                	ret
    x = -xx;
 5b8:	40b005bb          	negw	a1,a1
    neg = 1;
 5bc:	4885                	li	a7,1
    x = -xx;
 5be:	b7b5                	j	52a <printint+0x16>

00000000000005c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c0:	715d                	addi	sp,sp,-80
 5c2:	e486                	sd	ra,72(sp)
 5c4:	e0a2                	sd	s0,64(sp)
 5c6:	f84a                	sd	s2,48(sp)
 5c8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ca:	0005c903          	lbu	s2,0(a1)
 5ce:	1a090a63          	beqz	s2,782 <vprintf+0x1c2>
 5d2:	fc26                	sd	s1,56(sp)
 5d4:	f44e                	sd	s3,40(sp)
 5d6:	f052                	sd	s4,32(sp)
 5d8:	ec56                	sd	s5,24(sp)
 5da:	e85a                	sd	s6,16(sp)
 5dc:	e45e                	sd	s7,8(sp)
 5de:	8aaa                	mv	s5,a0
 5e0:	8bb2                	mv	s7,a2
 5e2:	00158493          	addi	s1,a1,1
  state = 0;
 5e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e8:	02500a13          	li	s4,37
 5ec:	4b55                	li	s6,21
 5ee:	a839                	j	60c <vprintf+0x4c>
        putc(fd, c);
 5f0:	85ca                	mv	a1,s2
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	efe080e7          	jalr	-258(ra) # 4f2 <putc>
 5fc:	a019                	j	602 <vprintf+0x42>
    } else if(state == '%'){
 5fe:	01498d63          	beq	s3,s4,618 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 602:	0485                	addi	s1,s1,1
 604:	fff4c903          	lbu	s2,-1(s1)
 608:	16090763          	beqz	s2,776 <vprintf+0x1b6>
    if(state == 0){
 60c:	fe0999e3          	bnez	s3,5fe <vprintf+0x3e>
      if(c == '%'){
 610:	ff4910e3          	bne	s2,s4,5f0 <vprintf+0x30>
        state = '%';
 614:	89d2                	mv	s3,s4
 616:	b7f5                	j	602 <vprintf+0x42>
      if(c == 'd'){
 618:	13490463          	beq	s2,s4,740 <vprintf+0x180>
 61c:	f9d9079b          	addiw	a5,s2,-99
 620:	0ff7f793          	zext.b	a5,a5
 624:	12fb6763          	bltu	s6,a5,752 <vprintf+0x192>
 628:	f9d9079b          	addiw	a5,s2,-99
 62c:	0ff7f713          	zext.b	a4,a5
 630:	12eb6163          	bltu	s6,a4,752 <vprintf+0x192>
 634:	00271793          	slli	a5,a4,0x2
 638:	00000717          	auipc	a4,0x0
 63c:	5e870713          	addi	a4,a4,1512 # c20 <ithread_join+0xa8>
 640:	97ba                	add	a5,a5,a4
 642:	439c                	lw	a5,0(a5)
 644:	97ba                	add	a5,a5,a4
 646:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 648:	008b8913          	addi	s2,s7,8
 64c:	4685                	li	a3,1
 64e:	4629                	li	a2,10
 650:	000ba583          	lw	a1,0(s7)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	ebe080e7          	jalr	-322(ra) # 514 <printint>
 65e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 660:	4981                	li	s3,0
 662:	b745                	j	602 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 664:	008b8913          	addi	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000ba583          	lw	a1,0(s7)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	ea2080e7          	jalr	-350(ra) # 514 <printint>
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b751                	j	602 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 680:	008b8913          	addi	s2,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000ba583          	lw	a1,0(s7)
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	e86080e7          	jalr	-378(ra) # 514 <printint>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b7a5                	j	602 <vprintf+0x42>
 69c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 69e:	008b8c13          	addi	s8,s7,8
 6a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a6:	03000593          	li	a1,48
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e46080e7          	jalr	-442(ra) # 4f2 <putc>
  putc(fd, 'x');
 6b4:	07800593          	li	a1,120
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	e38080e7          	jalr	-456(ra) # 4f2 <putc>
 6c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	5b4b8b93          	addi	s7,s7,1460 # c78 <digits>
 6cc:	03c9d793          	srli	a5,s3,0x3c
 6d0:	97de                	add	a5,a5,s7
 6d2:	0007c583          	lbu	a1,0(a5)
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e1a080e7          	jalr	-486(ra) # 4f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e0:	0992                	slli	s3,s3,0x4
 6e2:	397d                	addiw	s2,s2,-1
 6e4:	fe0914e3          	bnez	s2,6cc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6e8:	8be2                	mv	s7,s8
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	6c02                	ld	s8,0(sp)
 6ee:	bf11                	j	602 <vprintf+0x42>
        s = va_arg(ap, char*);
 6f0:	008b8993          	addi	s3,s7,8
 6f4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6f8:	02090163          	beqz	s2,71a <vprintf+0x15a>
        while(*s != 0){
 6fc:	00094583          	lbu	a1,0(s2)
 700:	c9a5                	beqz	a1,770 <vprintf+0x1b0>
          putc(fd, *s);
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	dee080e7          	jalr	-530(ra) # 4f2 <putc>
          s++;
 70c:	0905                	addi	s2,s2,1
        while(*s != 0){
 70e:	00094583          	lbu	a1,0(s2)
 712:	f9e5                	bnez	a1,702 <vprintf+0x142>
        s = va_arg(ap, char*);
 714:	8bce                	mv	s7,s3
      state = 0;
 716:	4981                	li	s3,0
 718:	b5ed                	j	602 <vprintf+0x42>
          s = "(null)";
 71a:	00000917          	auipc	s2,0x0
 71e:	4ce90913          	addi	s2,s2,1230 # be8 <ithread_join+0x70>
        while(*s != 0){
 722:	02800593          	li	a1,40
 726:	bff1                	j	702 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 728:	008b8913          	addi	s2,s7,8
 72c:	000bc583          	lbu	a1,0(s7)
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	dc0080e7          	jalr	-576(ra) # 4f2 <putc>
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b5d1                	j	602 <vprintf+0x42>
        putc(fd, c);
 740:	02500593          	li	a1,37
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	dac080e7          	jalr	-596(ra) # 4f2 <putc>
      state = 0;
 74e:	4981                	li	s3,0
 750:	bd4d                	j	602 <vprintf+0x42>
        putc(fd, '%');
 752:	02500593          	li	a1,37
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	d9a080e7          	jalr	-614(ra) # 4f2 <putc>
        putc(fd, c);
 760:	85ca                	mv	a1,s2
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	d8e080e7          	jalr	-626(ra) # 4f2 <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bd51                	j	602 <vprintf+0x42>
        s = va_arg(ap, char*);
 770:	8bce                	mv	s7,s3
      state = 0;
 772:	4981                	li	s3,0
 774:	b579                	j	602 <vprintf+0x42>
 776:	74e2                	ld	s1,56(sp)
 778:	79a2                	ld	s3,40(sp)
 77a:	7a02                	ld	s4,32(sp)
 77c:	6ae2                	ld	s5,24(sp)
 77e:	6b42                	ld	s6,16(sp)
 780:	6ba2                	ld	s7,8(sp)
    }
  }
}
 782:	60a6                	ld	ra,72(sp)
 784:	6406                	ld	s0,64(sp)
 786:	7942                	ld	s2,48(sp)
 788:	6161                	addi	sp,sp,80
 78a:	8082                	ret

000000000000078c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78c:	715d                	addi	sp,sp,-80
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e010                	sd	a2,0(s0)
 796:	e414                	sd	a3,8(s0)
 798:	e818                	sd	a4,16(s0)
 79a:	ec1c                	sd	a5,24(s0)
 79c:	03043023          	sd	a6,32(s0)
 7a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a8:	8622                	mv	a2,s0
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e16080e7          	jalr	-490(ra) # 5c0 <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6161                	addi	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <printf>:

void
printf(const char *fmt, ...)
{
 7ba:	711d                	addi	sp,sp,-96
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e40c                	sd	a1,8(s0)
 7c4:	e810                	sd	a2,16(s0)
 7c6:	ec14                	sd	a3,24(s0)
 7c8:	f018                	sd	a4,32(s0)
 7ca:	f41c                	sd	a5,40(s0)
 7cc:	03043823          	sd	a6,48(s0)
 7d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	00840613          	addi	a2,s0,8
 7d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7dc:	85aa                	mv	a1,a0
 7de:	4505                	li	a0,1
 7e0:	00000097          	auipc	ra,0x0
 7e4:	de0080e7          	jalr	-544(ra) # 5c0 <vprintf>
}
 7e8:	60e2                	ld	ra,24(sp)
 7ea:	6442                	ld	s0,16(sp)
 7ec:	6125                	addi	sp,sp,96
 7ee:	8082                	ret

00000000000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	1141                	addi	sp,sp,-16
 7f2:	e422                	sd	s0,8(sp)
 7f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	00001797          	auipc	a5,0x1
 7fe:	8167b783          	ld	a5,-2026(a5) # 1010 <freep>
 802:	a02d                	j	82c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 804:	4618                	lw	a4,8(a2)
 806:	9f2d                	addw	a4,a4,a1
 808:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	6398                	ld	a4,0(a5)
 80e:	6310                	ld	a2,0(a4)
 810:	a83d                	j	84e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 812:	ff852703          	lw	a4,-8(a0)
 816:	9f31                	addw	a4,a4,a2
 818:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81a:	ff053683          	ld	a3,-16(a0)
 81e:	a091                	j	862 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	6398                	ld	a4,0(a5)
 822:	00e7e463          	bltu	a5,a4,82a <free+0x3a>
 826:	00e6ea63          	bltu	a3,a4,83a <free+0x4a>
{
 82a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	fed7fae3          	bgeu	a5,a3,820 <free+0x30>
 830:	6398                	ld	a4,0(a5)
 832:	00e6e463          	bltu	a3,a4,83a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	fee7eae3          	bltu	a5,a4,82a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 83a:	ff852583          	lw	a1,-8(a0)
 83e:	6390                	ld	a2,0(a5)
 840:	02059813          	slli	a6,a1,0x20
 844:	01c85713          	srli	a4,a6,0x1c
 848:	9736                	add	a4,a4,a3
 84a:	fae60de3          	beq	a2,a4,804 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 852:	4790                	lw	a2,8(a5)
 854:	02061593          	slli	a1,a2,0x20
 858:	01c5d713          	srli	a4,a1,0x1c
 85c:	973e                	add	a4,a4,a5
 85e:	fae68ae3          	beq	a3,a4,812 <free+0x22>
    p->s.ptr = bp->s.ptr;
 862:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 864:	00000717          	auipc	a4,0x0
 868:	7af73623          	sd	a5,1964(a4) # 1010 <freep>
}
 86c:	6422                	ld	s0,8(sp)
 86e:	0141                	addi	sp,sp,16
 870:	8082                	ret

0000000000000872 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 872:	7139                	addi	sp,sp,-64
 874:	fc06                	sd	ra,56(sp)
 876:	f822                	sd	s0,48(sp)
 878:	f426                	sd	s1,40(sp)
 87a:	ec4e                	sd	s3,24(sp)
 87c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87e:	02051493          	slli	s1,a0,0x20
 882:	9081                	srli	s1,s1,0x20
 884:	04bd                	addi	s1,s1,15
 886:	8091                	srli	s1,s1,0x4
 888:	0014899b          	addiw	s3,s1,1
 88c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88e:	00000517          	auipc	a0,0x0
 892:	78253503          	ld	a0,1922(a0) # 1010 <freep>
 896:	c915                	beqz	a0,8ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	08977e63          	bgeu	a4,s1,938 <malloc+0xc6>
 8a0:	f04a                	sd	s2,32(sp)
 8a2:	e852                	sd	s4,16(sp)
 8a4:	e456                	sd	s5,8(sp)
 8a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a8:	8a4e                	mv	s4,s3
 8aa:	0009871b          	sext.w	a4,s3
 8ae:	6685                	lui	a3,0x1
 8b0:	00d77363          	bgeu	a4,a3,8b6 <malloc+0x44>
 8b4:	6a05                	lui	s4,0x1
 8b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8be:	00000917          	auipc	s2,0x0
 8c2:	75290913          	addi	s2,s2,1874 # 1010 <freep>
  if(p == (char*)-1)
 8c6:	5afd                	li	s5,-1
 8c8:	a091                	j	90c <malloc+0x9a>
 8ca:	f04a                	sd	s2,32(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	75e78793          	addi	a5,a5,1886 # 1030 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73b23          	sd	a5,1846(a4) # 1010 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e8:	b7c1                	j	8a8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	e118                	sd	a4,0(a0)
 8ee:	a08d                	j	950 <malloc+0xde>
  hp->s.size = nu;
 8f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f4:	0541                	addi	a0,a0,16
 8f6:	00000097          	auipc	ra,0x0
 8fa:	efa080e7          	jalr	-262(ra) # 7f0 <free>
  return freep;
 8fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 902:	c13d                	beqz	a0,968 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 904:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 906:	4798                	lw	a4,8(a5)
 908:	02977463          	bgeu	a4,s1,930 <malloc+0xbe>
    if(p == freep)
 90c:	00093703          	ld	a4,0(s2)
 910:	853e                	mv	a0,a5
 912:	fef719e3          	bne	a4,a5,904 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 916:	8552                	mv	a0,s4
 918:	00000097          	auipc	ra,0x0
 91c:	b54080e7          	jalr	-1196(ra) # 46c <sbrk>
  if(p == (char*)-1)
 920:	fd5518e3          	bne	a0,s5,8f0 <malloc+0x7e>
        return 0;
 924:	4501                	li	a0,0
 926:	7902                	ld	s2,32(sp)
 928:	6a42                	ld	s4,16(sp)
 92a:	6aa2                	ld	s5,8(sp)
 92c:	6b02                	ld	s6,0(sp)
 92e:	a03d                	j	95c <malloc+0xea>
 930:	7902                	ld	s2,32(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 938:	fae489e3          	beq	s1,a4,8ea <malloc+0x78>
        p->s.size -= nunits;
 93c:	4137073b          	subw	a4,a4,s3
 940:	c798                	sw	a4,8(a5)
        p += p->s.size;
 942:	02071693          	slli	a3,a4,0x20
 946:	01c6d713          	srli	a4,a3,0x1c
 94a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 950:	00000717          	auipc	a4,0x0
 954:	6ca73023          	sd	a0,1728(a4) # 1010 <freep>
      return (void*)(p + 1);
 958:	01078513          	addi	a0,a5,16
  }
}
 95c:	70e2                	ld	ra,56(sp)
 95e:	7442                	ld	s0,48(sp)
 960:	74a2                	ld	s1,40(sp)
 962:	69e2                	ld	s3,24(sp)
 964:	6121                	addi	sp,sp,64
 966:	8082                	ret
 968:	7902                	ld	s2,32(sp)
 96a:	6a42                	ld	s4,16(sp)
 96c:	6aa2                	ld	s5,8(sp)
 96e:	6b02                	ld	s6,0(sp)
 970:	b7f5                	j	95c <malloc+0xea>

0000000000000972 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 972:	1141                	addi	sp,sp,-16
 974:	e406                	sd	ra,8(sp)
 976:	e022                	sd	s0,0(sp)
 978:	0800                	addi	s0,sp,16
  thread_exit(status);
 97a:	2501                	sext.w	a0,a0
 97c:	00000097          	auipc	ra,0x0
 980:	b20080e7          	jalr	-1248(ra) # 49c <thread_exit>
}
 984:	60a2                	ld	ra,8(sp)
 986:	6402                	ld	s0,0(sp)
 988:	0141                	addi	sp,sp,16
 98a:	8082                	ret

000000000000098c <free_stacks>:
int free_stacks() {
 98c:	7179                	addi	sp,sp,-48
 98e:	f406                	sd	ra,40(sp)
 990:	f022                	sd	s0,32(sp)
 992:	ec26                	sd	s1,24(sp)
 994:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 996:	00000797          	auipc	a5,0x0
 99a:	68a7a783          	lw	a5,1674(a5) # 1020 <num_threads>
 99e:	04f05063          	blez	a5,9de <free_stacks+0x52>
 9a2:	e84a                	sd	s2,16(sp)
 9a4:	e44e                	sd	s3,8(sp)
 9a6:	4481                	li	s1,0
    free(stacks[i]);
 9a8:	00000997          	auipc	s3,0x0
 9ac:	67098993          	addi	s3,s3,1648 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9b0:	00000917          	auipc	s2,0x0
 9b4:	67090913          	addi	s2,s2,1648 # 1020 <num_threads>
    free(stacks[i]);
 9b8:	0009b783          	ld	a5,0(s3)
 9bc:	00349713          	slli	a4,s1,0x3
 9c0:	97ba                	add	a5,a5,a4
 9c2:	6388                	ld	a0,0(a5)
 9c4:	00000097          	auipc	ra,0x0
 9c8:	e2c080e7          	jalr	-468(ra) # 7f0 <free>
  for (int i = 0; i < num_threads; i++) {
 9cc:	0485                	addi	s1,s1,1
 9ce:	00092703          	lw	a4,0(s2)
 9d2:	0004879b          	sext.w	a5,s1
 9d6:	fee7c1e3          	blt	a5,a4,9b8 <free_stacks+0x2c>
 9da:	6942                	ld	s2,16(sp)
 9dc:	69a2                	ld	s3,8(sp)
  free(stacks);
 9de:	00000497          	auipc	s1,0x0
 9e2:	63a48493          	addi	s1,s1,1594 # 1018 <stacks>
 9e6:	6088                	ld	a0,0(s1)
 9e8:	00000097          	auipc	ra,0x0
 9ec:	e08080e7          	jalr	-504(ra) # 7f0 <free>
  stacks = 0;
 9f0:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9f4:	00000797          	auipc	a5,0x0
 9f8:	6207a623          	sw	zero,1580(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9fc:	47a1                	li	a5,8
 9fe:	00000717          	auipc	a4,0x0
 a02:	60f72123          	sw	a5,1538(a4) # 1000 <max_stacks>
  threads_done = 0;
 a06:	00000797          	auipc	a5,0x0
 a0a:	6007af23          	sw	zero,1566(a5) # 1024 <threads_done>
}
 a0e:	4501                	li	a0,0
 a10:	70a2                	ld	ra,40(sp)
 a12:	7402                	ld	s0,32(sp)
 a14:	64e2                	ld	s1,24(sp)
 a16:	6145                	addi	sp,sp,48
 a18:	8082                	ret

0000000000000a1a <expand_num_threads>:
int expand_num_threads() {
 a1a:	1101                	addi	sp,sp,-32
 a1c:	ec06                	sd	ra,24(sp)
 a1e:	e822                	sd	s0,16(sp)
 a20:	e426                	sd	s1,8(sp)
 a22:	e04a                	sd	s2,0(sp)
 a24:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a26:	00000797          	auipc	a5,0x0
 a2a:	5da78793          	addi	a5,a5,1498 # 1000 <max_stacks>
 a2e:	4388                	lw	a0,0(a5)
 a30:	0015151b          	slliw	a0,a0,0x1
 a34:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a36:	0035151b          	slliw	a0,a0,0x3
 a3a:	00000097          	auipc	ra,0x0
 a3e:	e38080e7          	jalr	-456(ra) # 872 <malloc>
 a42:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a44:	00000617          	auipc	a2,0x0
 a48:	5dc62603          	lw	a2,1500(a2) # 1020 <num_threads>
 a4c:	00000497          	auipc	s1,0x0
 a50:	5cc48493          	addi	s1,s1,1484 # 1018 <stacks>
 a54:	0036161b          	slliw	a2,a2,0x3
 a58:	608c                	ld	a1,0(s1)
 a5a:	00000097          	auipc	ra,0x0
 a5e:	840080e7          	jalr	-1984(ra) # 29a <memmove>
  free(stacks);
 a62:	6088                	ld	a0,0(s1)
 a64:	00000097          	auipc	ra,0x0
 a68:	d8c080e7          	jalr	-628(ra) # 7f0 <free>
  stacks = new_stacks;
 a6c:	0124b023          	sd	s2,0(s1)
}
 a70:	4501                	li	a0,0
 a72:	60e2                	ld	ra,24(sp)
 a74:	6442                	ld	s0,16(sp)
 a76:	64a2                	ld	s1,8(sp)
 a78:	6902                	ld	s2,0(sp)
 a7a:	6105                	addi	sp,sp,32
 a7c:	8082                	ret

0000000000000a7e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a7e:	7179                	addi	sp,sp,-48
 a80:	f406                	sd	ra,40(sp)
 a82:	f022                	sd	s0,32(sp)
 a84:	e84a                	sd	s2,16(sp)
 a86:	e44e                	sd	s3,8(sp)
 a88:	1800                	addi	s0,sp,48
 a8a:	892a                	mv	s2,a0
 a8c:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a8e:	00000797          	auipc	a5,0x0
 a92:	58a7b783          	ld	a5,1418(a5) # 1018 <stacks>
 a96:	c3d9                	beqz	a5,b1c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a98:	00000797          	auipc	a5,0x0
 a9c:	5687a783          	lw	a5,1384(a5) # 1000 <max_stacks>
 aa0:	00000717          	auipc	a4,0x0
 aa4:	58072703          	lw	a4,1408(a4) # 1020 <num_threads>
 aa8:	0af71363          	bne	a4,a5,b4e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 aac:	04000713          	li	a4,64
 ab0:	08e78563          	beq	a5,a4,b3a <ithread_create+0xbc>
 ab4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 ab6:	00000097          	auipc	ra,0x0
 aba:	f64080e7          	jalr	-156(ra) # a1a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 abe:	6505                	lui	a0,0x1
 ac0:	00000097          	auipc	ra,0x0
 ac4:	db2080e7          	jalr	-590(ra) # 872 <malloc>
 ac8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 aca:	00000717          	auipc	a4,0x0
 ace:	55672703          	lw	a4,1366(a4) # 1020 <num_threads>
 ad2:	070e                	slli	a4,a4,0x3
 ad4:	00000797          	auipc	a5,0x0
 ad8:	5447b783          	ld	a5,1348(a5) # 1018 <stacks>
 adc:	97ba                	add	a5,a5,a4
 ade:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 ae0:	00000697          	auipc	a3,0x0
 ae4:	e9268693          	addi	a3,a3,-366 # 972 <ithread_exit>
 ae8:	862a                	mv	a2,a0
 aea:	85ce                	mv	a1,s3
 aec:	854a                	mv	a0,s2
 aee:	00000097          	auipc	ra,0x0
 af2:	99e080e7          	jalr	-1634(ra) # 48c <create_thread>
 af6:	892a                	mv	s2,a0
  if (res != -1) {
 af8:	57fd                	li	a5,-1
 afa:	04f50c63          	beq	a0,a5,b52 <ithread_create+0xd4>
    num_threads++;
 afe:	00000717          	auipc	a4,0x0
 b02:	52270713          	addi	a4,a4,1314 # 1020 <num_threads>
 b06:	431c                	lw	a5,0(a4)
 b08:	2785                	addiw	a5,a5,1
 b0a:	c31c                	sw	a5,0(a4)
 b0c:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b0e:	854a                	mv	a0,s2
 b10:	70a2                	ld	ra,40(sp)
 b12:	7402                	ld	s0,32(sp)
 b14:	6942                	ld	s2,16(sp)
 b16:	69a2                	ld	s3,8(sp)
 b18:	6145                	addi	sp,sp,48
 b1a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b1c:	00000517          	auipc	a0,0x0
 b20:	4e452503          	lw	a0,1252(a0) # 1000 <max_stacks>
 b24:	0035151b          	slliw	a0,a0,0x3
 b28:	00000097          	auipc	ra,0x0
 b2c:	d4a080e7          	jalr	-694(ra) # 872 <malloc>
 b30:	00000797          	auipc	a5,0x0
 b34:	4ea7b423          	sd	a0,1256(a5) # 1018 <stacks>
 b38:	b785                	j	a98 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b3a:	00000517          	auipc	a0,0x0
 b3e:	0b650513          	addi	a0,a0,182 # bf0 <ithread_join+0x78>
 b42:	00000097          	auipc	ra,0x0
 b46:	c78080e7          	jalr	-904(ra) # 7ba <printf>
      return -1;
 b4a:	597d                	li	s2,-1
 b4c:	b7c9                	j	b0e <ithread_create+0x90>
 b4e:	ec26                	sd	s1,24(sp)
 b50:	b7bd                	j	abe <ithread_create+0x40>
    free(stack_ptr);
 b52:	8526                	mv	a0,s1
 b54:	00000097          	auipc	ra,0x0
 b58:	c9c080e7          	jalr	-868(ra) # 7f0 <free>
    stacks[num_threads] = 0;
 b5c:	00000717          	auipc	a4,0x0
 b60:	4c472703          	lw	a4,1220(a4) # 1020 <num_threads>
 b64:	070e                	slli	a4,a4,0x3
 b66:	00000797          	auipc	a5,0x0
 b6a:	4b27b783          	ld	a5,1202(a5) # 1018 <stacks>
 b6e:	97ba                	add	a5,a5,a4
 b70:	0007b023          	sd	zero,0(a5)
 b74:	64e2                	ld	s1,24(sp)
 b76:	bf61                	j	b0e <ithread_create+0x90>

0000000000000b78 <ithread_join>:

int ithread_join(int thread_id) {
 b78:	1101                	addi	sp,sp,-32
 b7a:	ec06                	sd	ra,24(sp)
 b7c:	e822                	sd	s0,16(sp)
 b7e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b80:	ff040793          	addi	a5,s0,-16
 b84:	ffc7859b          	addiw	a1,a5,-4
 b88:	00000097          	auipc	ra,0x0
 b8c:	90c080e7          	jalr	-1780(ra) # 494 <join_thread>
  threads_done++;
 b90:	00000717          	auipc	a4,0x0
 b94:	49470713          	addi	a4,a4,1172 # 1024 <threads_done>
 b98:	431c                	lw	a5,0(a4)
 b9a:	2785                	addiw	a5,a5,1
 b9c:	0007869b          	sext.w	a3,a5
 ba0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ba2:	00000797          	auipc	a5,0x0
 ba6:	47e7a783          	lw	a5,1150(a5) # 1020 <num_threads>
 baa:	00d78863          	beq	a5,a3,bba <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 bae:	fec42503          	lw	a0,-20(s0)
 bb2:	60e2                	ld	ra,24(sp)
 bb4:	6442                	ld	s0,16(sp)
 bb6:	6105                	addi	sp,sp,32
 bb8:	8082                	ret
    free_stacks();
 bba:	00000097          	auipc	ra,0x0
 bbe:	dd2080e7          	jalr	-558(ra) # 98c <free_stacks>
 bc2:	b7f5                	j	bae <ithread_join+0x36>
