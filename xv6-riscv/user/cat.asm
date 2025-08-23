
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	56c90913          	addi	s2,s2,1388 # 1580 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3d8080e7          	jalr	984(ra) # 400 <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3cc080e7          	jalr	972(ra) # 408 <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	b4858593          	addi	a1,a1,-1208 # b90 <ithread_join+0x4e>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	706080e7          	jalr	1798(ra) # 758 <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	38c080e7          	jalr	908(ra) # 3e8 <exit>
    }
  }
  if(n < 0){
  64:	00054b63          	bltz	a0,7a <cat+0x7a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  68:	70e2                	ld	ra,56(sp)
  6a:	7442                	ld	s0,48(sp)
  6c:	74a2                	ld	s1,40(sp)
  6e:	7902                	ld	s2,32(sp)
  70:	69e2                	ld	s3,24(sp)
  72:	6a42                	ld	s4,16(sp)
  74:	6aa2                	ld	s5,8(sp)
  76:	6121                	addi	sp,sp,64
  78:	8082                	ret
    fprintf(2, "cat: read error\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	b2e58593          	addi	a1,a1,-1234 # ba8 <ithread_join+0x66>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	6d4080e7          	jalr	1748(ra) # 758 <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	35a080e7          	jalr	858(ra) # 3e8 <exit>

0000000000000096 <main>:

int
main(int argc, char *argv[])
{
  96:	7179                	addi	sp,sp,-48
  98:	f406                	sd	ra,40(sp)
  9a:	f022                	sd	s0,32(sp)
  9c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9e:	4785                	li	a5,1
  a0:	04a7da63          	bge	a5,a0,f4 <main+0x5e>
  a4:	ec26                	sd	s1,24(sp)
  a6:	e84a                	sd	s2,16(sp)
  a8:	e44e                	sd	s3,8(sp)
  aa:	00858913          	addi	s2,a1,8
  ae:	ffe5099b          	addiw	s3,a0,-2
  b2:	02099793          	slli	a5,s3,0x20
  b6:	01d7d993          	srli	s3,a5,0x1d
  ba:	05c1                	addi	a1,a1,16
  bc:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  be:	4581                	li	a1,0
  c0:	00093503          	ld	a0,0(s2)
  c4:	00000097          	auipc	ra,0x0
  c8:	364080e7          	jalr	868(ra) # 428 <open>
  cc:	84aa                	mv	s1,a0
  ce:	04054063          	bltz	a0,10e <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <cat>
    close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	334080e7          	jalr	820(ra) # 410 <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2fc080e7          	jalr	764(ra) # 3e8 <exit>
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
    cat(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <cat>
    exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2e2080e7          	jalr	738(ra) # 3e8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	aae58593          	addi	a1,a1,-1362 # bc0 <ithread_join+0x7e>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	63c080e7          	jalr	1596(ra) # 758 <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2c2080e7          	jalr	706(ra) # 3e8 <exit>

000000000000012e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  extern int main();
  main();
 136:	00000097          	auipc	ra,0x0
 13a:	f60080e7          	jalr	-160(ra) # 96 <main>
  exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	2a8080e7          	jalr	680(ra) # 3e8 <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0xa>
    ;
  return os;
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb91                	beqz	a5,188 <strcmp+0x20>
 176:	0005c703          	lbu	a4,0(a1)
 17a:	00f71763          	bne	a4,a5,188 <strcmp+0x20>
    p++, q++;
 17e:	0505                	addi	a0,a0,1
 180:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	fbe5                	bnez	a5,176 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strlen>:

uint
strlen(const char *s)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e406                	sd	ra,8(sp)
 19c:	e022                	sd	s0,0(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cf99                	beqz	a5,1c2 <strlen+0x2a>
 1a6:	0505                	addi	a0,a0,1
 1a8:	87aa                	mv	a5,a0
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
 1b8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret
  for(n = 0; s[n]; n++)
 1c2:	4501                	li	a0,0
 1c4:	bfdd                	j	1ba <strlen+0x22>

00000000000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ce:	ca19                	beqz	a2,1e4 <memset+0x1e>
 1d0:	87aa                	mv	a5,a0
 1d2:	1602                	slli	a2,a2,0x20
 1d4:	9201                	srli	a2,a2,0x20
 1d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1de:	0785                	addi	a5,a5,1
 1e0:	fee79de3          	bne	a5,a4,1da <memset+0x14>
  }
  return dst;
}
 1e4:	60a2                	ld	ra,8(sp)
 1e6:	6402                	ld	s0,0(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf81                	beqz	a5,210 <strchr+0x24>
    if(*s == c)
 1fa:	00f58763          	beq	a1,a5,208 <strchr+0x1c>
  for(; *s; s++)
 1fe:	0505                	addi	a0,a0,1
 200:	00054783          	lbu	a5,0(a0)
 204:	fbfd                	bnez	a5,1fa <strchr+0xe>
      return (char*)s;
  return 0;
 206:	4501                	li	a0,0
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  return 0;
 210:	4501                	li	a0,0
 212:	bfdd                	j	208 <strchr+0x1c>

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	7159                	addi	sp,sp,-112
 216:	f486                	sd	ra,104(sp)
 218:	f0a2                	sd	s0,96(sp)
 21a:	eca6                	sd	s1,88(sp)
 21c:	e8ca                	sd	s2,80(sp)
 21e:	e4ce                	sd	s3,72(sp)
 220:	e0d2                	sd	s4,64(sp)
 222:	fc56                	sd	s5,56(sp)
 224:	f85a                	sd	s6,48(sp)
 226:	f45e                	sd	s7,40(sp)
 228:	f062                	sd	s8,32(sp)
 22a:	ec66                	sd	s9,24(sp)
 22c:	e86a                	sd	s10,16(sp)
 22e:	1880                	addi	s0,sp,112
 230:	8caa                	mv	s9,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
 238:	f9f40b13          	addi	s6,s0,-97
 23c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23e:	4ba9                	li	s7,10
 240:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 242:	8d26                	mv	s10,s1
 244:	0014899b          	addiw	s3,s1,1
 248:	84ce                	mv	s1,s3
 24a:	0349d763          	bge	s3,s4,278 <gets+0x64>
    cc = read(0, &c, 1);
 24e:	8656                	mv	a2,s5
 250:	85da                	mv	a1,s6
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	1ac080e7          	jalr	428(ra) # 400 <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x64>
    buf[i++] = c;
 260:	f9f44783          	lbu	a5,-97(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01778763          	beq	a5,s7,276 <gets+0x62>
 26c:	0905                	addi	s2,s2,1
 26e:	fd879ae3          	bne	a5,s8,242 <gets+0x2e>
    buf[i++] = c;
 272:	8d4e                	mv	s10,s3
 274:	a011                	j	278 <gets+0x64>
 276:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 278:	9d66                	add	s10,s10,s9
 27a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 27e:	8566                	mv	a0,s9
 280:	70a6                	ld	ra,104(sp)
 282:	7406                	ld	s0,96(sp)
 284:	64e6                	ld	s1,88(sp)
 286:	6946                	ld	s2,80(sp)
 288:	69a6                	ld	s3,72(sp)
 28a:	6a06                	ld	s4,64(sp)
 28c:	7ae2                	ld	s5,56(sp)
 28e:	7b42                	ld	s6,48(sp)
 290:	7ba2                	ld	s7,40(sp)
 292:	7c02                	ld	s8,32(sp)
 294:	6ce2                	ld	s9,24(sp)
 296:	6d42                	ld	s10,16(sp)
 298:	6165                	addi	sp,sp,112
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e04a                	sd	s2,0(sp)
 2a4:	1000                	addi	s0,sp,32
 2a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a8:	4581                	li	a1,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	17e080e7          	jalr	382(ra) # 428 <open>
  if(fd < 0)
 2b2:	02054663          	bltz	a0,2de <stat+0x42>
 2b6:	e426                	sd	s1,8(sp)
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	184080e7          	jalr	388(ra) # 440 <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	148080e7          	jalr	328(ra) # 410 <close>
  return r;
 2d0:	64a2                	ld	s1,8(sp)
}
 2d2:	854a                	mv	a0,s2
 2d4:	60e2                	ld	ra,24(sp)
 2d6:	6442                	ld	s0,16(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfcd                	j	2d2 <stat+0x36>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ea:	00054683          	lbu	a3,0(a0)
 2ee:	fd06879b          	addiw	a5,a3,-48
 2f2:	0ff7f793          	zext.b	a5,a5
 2f6:	4625                	li	a2,9
 2f8:	02f66963          	bltu	a2,a5,32a <atoi+0x48>
 2fc:	872a                	mv	a4,a0
  n = 0;
 2fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 300:	0705                	addi	a4,a4,1
 302:	0025179b          	slliw	a5,a0,0x2
 306:	9fa9                	addw	a5,a5,a0
 308:	0017979b          	slliw	a5,a5,0x1
 30c:	9fb5                	addw	a5,a5,a3
 30e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 312:	00074683          	lbu	a3,0(a4)
 316:	fd06879b          	addiw	a5,a3,-48
 31a:	0ff7f793          	zext.b	a5,a5
 31e:	fef671e3          	bgeu	a2,a5,300 <atoi+0x1e>
  return n;
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  n = 0;
 32a:	4501                	li	a0,0
 32c:	bfdd                	j	322 <atoi+0x40>

000000000000032e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 336:	02b57563          	bgeu	a0,a1,360 <memmove+0x32>
    while(n-- > 0)
 33a:	00c05f63          	blez	a2,358 <memmove+0x2a>
 33e:	1602                	slli	a2,a2,0x20
 340:	9201                	srli	a2,a2,0x20
 342:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 346:	872a                	mv	a4,a0
      *dst++ = *src++;
 348:	0585                	addi	a1,a1,1
 34a:	0705                	addi	a4,a4,1
 34c:	fff5c683          	lbu	a3,-1(a1)
 350:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
    dst += n;
 360:	00c50733          	add	a4,a0,a2
    src += n;
 364:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 366:	fec059e3          	blez	a2,358 <memmove+0x2a>
 36a:	fff6079b          	addiw	a5,a2,-1
 36e:	1782                	slli	a5,a5,0x20
 370:	9381                	srli	a5,a5,0x20
 372:	fff7c793          	not	a5,a5
 376:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 378:	15fd                	addi	a1,a1,-1
 37a:	177d                	addi	a4,a4,-1
 37c:	0005c683          	lbu	a3,0(a1)
 380:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 384:	fef71ae3          	bne	a4,a5,378 <memmove+0x4a>
 388:	bfc1                	j	358 <memmove+0x2a>

000000000000038a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 392:	ca0d                	beqz	a2,3c4 <memcmp+0x3a>
 394:	fff6069b          	addiw	a3,a2,-1
 398:	1682                	slli	a3,a3,0x20
 39a:	9281                	srli	a3,a3,0x20
 39c:	0685                	addi	a3,a3,1
 39e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	0005c703          	lbu	a4,0(a1)
 3a8:	00e79863          	bne	a5,a4,3b8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3ac:	0505                	addi	a0,a0,1
    p2++;
 3ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b0:	fed518e3          	bne	a0,a3,3a0 <memcmp+0x16>
  }
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	a019                	j	3bc <memcmp+0x32>
      return *p1 - *p2;
 3b8:	40e7853b          	subw	a0,a5,a4
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfdd                	j	3bc <memcmp+0x32>

00000000000003c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f5e080e7          	jalr	-162(ra) # 32e <memmove>
}
 3d8:	60a2                	ld	ra,8(sp)
 3da:	6402                	ld	s0,0(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret

00000000000003e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e0:	4885                	li	a7,1
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e8:	4889                	li	a7,2
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f0:	488d                	li	a7,3
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f8:	4891                	li	a7,4
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	4895                	li	a7,5
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <write>:
.global write
write:
 li a7, SYS_write
 408:	48c1                	li	a7,16
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <close>:
.global close
close:
 li a7, SYS_close
 410:	48d5                	li	a7,21
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <kill>:
.global kill
kill:
 li a7, SYS_kill
 418:	4899                	li	a7,6
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exec>:
.global exec
exec:
 li a7, SYS_exec
 420:	489d                	li	a7,7
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <open>:
.global open
open:
 li a7, SYS_open
 428:	48bd                	li	a7,15
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 430:	48c5                	li	a7,17
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 438:	48c9                	li	a7,18
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 440:	48a1                	li	a7,8
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <link>:
.global link
link:
 li a7, SYS_link
 448:	48cd                	li	a7,19
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 450:	48d1                	li	a7,20
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 458:	48a5                	li	a7,9
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <dup>:
.global dup
dup:
 li a7, SYS_dup
 460:	48a9                	li	a7,10
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 468:	48ad                	li	a7,11
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 470:	48b1                	li	a7,12
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 478:	48b5                	li	a7,13
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 480:	48b9                	li	a7,14
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 488:	48d9                	li	a7,22
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 490:	48dd                	li	a7,23
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 498:	48e1                	li	a7,24
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4a0:	48e5                	li	a7,25
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4a8:	48e9                	li	a7,26
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4b0:	48ed                	li	a7,27
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4b8:	48f5                	li	a7,29
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <listen>:
.global listen
listen:
 li a7, SYS_listen
 4c0:	48f1                	li	a7,28
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4c8:	48f9                	li	a7,30
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d0:	1101                	addi	sp,sp,-32
 4d2:	ec06                	sd	ra,24(sp)
 4d4:	e822                	sd	s0,16(sp)
 4d6:	1000                	addi	s0,sp,32
 4d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4dc:	4605                	li	a2,1
 4de:	fef40593          	addi	a1,s0,-17
 4e2:	00000097          	auipc	ra,0x0
 4e6:	f26080e7          	jalr	-218(ra) # 408 <write>
}
 4ea:	60e2                	ld	ra,24(sp)
 4ec:	6442                	ld	s0,16(sp)
 4ee:	6105                	addi	sp,sp,32
 4f0:	8082                	ret

00000000000004f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f2:	7139                	addi	sp,sp,-64
 4f4:	fc06                	sd	ra,56(sp)
 4f6:	f822                	sd	s0,48(sp)
 4f8:	f426                	sd	s1,40(sp)
 4fa:	f04a                	sd	s2,32(sp)
 4fc:	ec4e                	sd	s3,24(sp)
 4fe:	0080                	addi	s0,sp,64
 500:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 502:	c299                	beqz	a3,508 <printint+0x16>
 504:	0805c063          	bltz	a1,584 <printint+0x92>
  neg = 0;
 508:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 50a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 50e:	869a                	mv	a3,t1
  i = 0;
 510:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 512:	00000817          	auipc	a6,0x0
 516:	75680813          	addi	a6,a6,1878 # c68 <digits>
 51a:	88be                	mv	a7,a5
 51c:	0017851b          	addiw	a0,a5,1
 520:	87aa                	mv	a5,a0
 522:	02c5f73b          	remuw	a4,a1,a2
 526:	1702                	slli	a4,a4,0x20
 528:	9301                	srli	a4,a4,0x20
 52a:	9742                	add	a4,a4,a6
 52c:	00074703          	lbu	a4,0(a4)
 530:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 534:	872e                	mv	a4,a1
 536:	02c5d5bb          	divuw	a1,a1,a2
 53a:	0685                	addi	a3,a3,1
 53c:	fcc77fe3          	bgeu	a4,a2,51a <printint+0x28>
  if(neg)
 540:	000e0c63          	beqz	t3,558 <printint+0x66>
    buf[i++] = '-';
 544:	fd050793          	addi	a5,a0,-48
 548:	00878533          	add	a0,a5,s0
 54c:	02d00793          	li	a5,45
 550:	fef50823          	sb	a5,-16(a0)
 554:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 558:	fff7899b          	addiw	s3,a5,-1
 55c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 560:	fff4c583          	lbu	a1,-1(s1)
 564:	854a                	mv	a0,s2
 566:	00000097          	auipc	ra,0x0
 56a:	f6a080e7          	jalr	-150(ra) # 4d0 <putc>
  while(--i >= 0)
 56e:	39fd                	addiw	s3,s3,-1
 570:	14fd                	addi	s1,s1,-1
 572:	fe09d7e3          	bgez	s3,560 <printint+0x6e>
}
 576:	70e2                	ld	ra,56(sp)
 578:	7442                	ld	s0,48(sp)
 57a:	74a2                	ld	s1,40(sp)
 57c:	7902                	ld	s2,32(sp)
 57e:	69e2                	ld	s3,24(sp)
 580:	6121                	addi	sp,sp,64
 582:	8082                	ret
    x = -xx;
 584:	40b005bb          	negw	a1,a1
    neg = 1;
 588:	4e05                	li	t3,1
    x = -xx;
 58a:	b741                	j	50a <printint+0x18>

000000000000058c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58c:	715d                	addi	sp,sp,-80
 58e:	e486                	sd	ra,72(sp)
 590:	e0a2                	sd	s0,64(sp)
 592:	f84a                	sd	s2,48(sp)
 594:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 596:	0005c903          	lbu	s2,0(a1)
 59a:	1a090a63          	beqz	s2,74e <vprintf+0x1c2>
 59e:	fc26                	sd	s1,56(sp)
 5a0:	f44e                	sd	s3,40(sp)
 5a2:	f052                	sd	s4,32(sp)
 5a4:	ec56                	sd	s5,24(sp)
 5a6:	e85a                	sd	s6,16(sp)
 5a8:	e45e                	sd	s7,8(sp)
 5aa:	8aaa                	mv	s5,a0
 5ac:	8bb2                	mv	s7,a2
 5ae:	00158493          	addi	s1,a1,1
  state = 0;
 5b2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5b4:	02500a13          	li	s4,37
 5b8:	4b55                	li	s6,21
 5ba:	a839                	j	5d8 <vprintf+0x4c>
        putc(fd, c);
 5bc:	85ca                	mv	a1,s2
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f10080e7          	jalr	-240(ra) # 4d0 <putc>
 5c8:	a019                	j	5ce <vprintf+0x42>
    } else if(state == '%'){
 5ca:	01498d63          	beq	s3,s4,5e4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5ce:	0485                	addi	s1,s1,1
 5d0:	fff4c903          	lbu	s2,-1(s1)
 5d4:	16090763          	beqz	s2,742 <vprintf+0x1b6>
    if(state == 0){
 5d8:	fe0999e3          	bnez	s3,5ca <vprintf+0x3e>
      if(c == '%'){
 5dc:	ff4910e3          	bne	s2,s4,5bc <vprintf+0x30>
        state = '%';
 5e0:	89d2                	mv	s3,s4
 5e2:	b7f5                	j	5ce <vprintf+0x42>
      if(c == 'd'){
 5e4:	13490463          	beq	s2,s4,70c <vprintf+0x180>
 5e8:	f9d9079b          	addiw	a5,s2,-99
 5ec:	0ff7f793          	zext.b	a5,a5
 5f0:	12fb6763          	bltu	s6,a5,71e <vprintf+0x192>
 5f4:	f9d9079b          	addiw	a5,s2,-99
 5f8:	0ff7f713          	zext.b	a4,a5
 5fc:	12eb6163          	bltu	s6,a4,71e <vprintf+0x192>
 600:	00271793          	slli	a5,a4,0x2
 604:	00000717          	auipc	a4,0x0
 608:	60c70713          	addi	a4,a4,1548 # c10 <ithread_join+0xce>
 60c:	97ba                	add	a5,a5,a4
 60e:	439c                	lw	a5,0(a5)
 610:	97ba                	add	a5,a5,a4
 612:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 614:	008b8913          	addi	s2,s7,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	ed0080e7          	jalr	-304(ra) # 4f2 <printint>
 62a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b745                	j	5ce <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	008b8913          	addi	s2,s7,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	eb4080e7          	jalr	-332(ra) # 4f2 <printint>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	b751                	j	5ce <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 64c:	008b8913          	addi	s2,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000ba583          	lw	a1,0(s7)
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	e98080e7          	jalr	-360(ra) # 4f2 <printint>
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
 666:	b7a5                	j	5ce <vprintf+0x42>
 668:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66a:	008b8c13          	addi	s8,s7,8
 66e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e58080e7          	jalr	-424(ra) # 4d0 <putc>
  putc(fd, 'x');
 680:	07800593          	li	a1,120
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e4a080e7          	jalr	-438(ra) # 4d0 <putc>
 68e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	00000b97          	auipc	s7,0x0
 694:	5d8b8b93          	addi	s7,s7,1496 # c68 <digits>
 698:	03c9d793          	srli	a5,s3,0x3c
 69c:	97de                	add	a5,a5,s7
 69e:	0007c583          	lbu	a1,0(a5)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e2c080e7          	jalr	-468(ra) # 4d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ac:	0992                	slli	s3,s3,0x4
 6ae:	397d                	addiw	s2,s2,-1
 6b0:	fe0914e3          	bnez	s2,698 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6b4:	8be2                	mv	s7,s8
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	6c02                	ld	s8,0(sp)
 6ba:	bf11                	j	5ce <vprintf+0x42>
        s = va_arg(ap, char*);
 6bc:	008b8993          	addi	s3,s7,8
 6c0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6c4:	02090163          	beqz	s2,6e6 <vprintf+0x15a>
        while(*s != 0){
 6c8:	00094583          	lbu	a1,0(s2)
 6cc:	c9a5                	beqz	a1,73c <vprintf+0x1b0>
          putc(fd, *s);
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e00080e7          	jalr	-512(ra) # 4d0 <putc>
          s++;
 6d8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6da:	00094583          	lbu	a1,0(s2)
 6de:	f9e5                	bnez	a1,6ce <vprintf+0x142>
        s = va_arg(ap, char*);
 6e0:	8bce                	mv	s7,s3
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b5ed                	j	5ce <vprintf+0x42>
          s = "(null)";
 6e6:	00000917          	auipc	s2,0x0
 6ea:	4f290913          	addi	s2,s2,1266 # bd8 <ithread_join+0x96>
        while(*s != 0){
 6ee:	02800593          	li	a1,40
 6f2:	bff1                	j	6ce <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	000bc583          	lbu	a1,0(s7)
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	dd2080e7          	jalr	-558(ra) # 4d0 <putc>
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
 70a:	b5d1                	j	5ce <vprintf+0x42>
        putc(fd, c);
 70c:	02500593          	li	a1,37
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	dbe080e7          	jalr	-578(ra) # 4d0 <putc>
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bd4d                	j	5ce <vprintf+0x42>
        putc(fd, '%');
 71e:	02500593          	li	a1,37
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	dac080e7          	jalr	-596(ra) # 4d0 <putc>
        putc(fd, c);
 72c:	85ca                	mv	a1,s2
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	da0080e7          	jalr	-608(ra) # 4d0 <putc>
      state = 0;
 738:	4981                	li	s3,0
 73a:	bd51                	j	5ce <vprintf+0x42>
        s = va_arg(ap, char*);
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b579                	j	5ce <vprintf+0x42>
 742:	74e2                	ld	s1,56(sp)
 744:	79a2                	ld	s3,40(sp)
 746:	7a02                	ld	s4,32(sp)
 748:	6ae2                	ld	s5,24(sp)
 74a:	6b42                	ld	s6,16(sp)
 74c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 74e:	60a6                	ld	ra,72(sp)
 750:	6406                	ld	s0,64(sp)
 752:	7942                	ld	s2,48(sp)
 754:	6161                	addi	sp,sp,80
 756:	8082                	ret

0000000000000758 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 758:	715d                	addi	sp,sp,-80
 75a:	ec06                	sd	ra,24(sp)
 75c:	e822                	sd	s0,16(sp)
 75e:	1000                	addi	s0,sp,32
 760:	e010                	sd	a2,0(s0)
 762:	e414                	sd	a3,8(s0)
 764:	e818                	sd	a4,16(s0)
 766:	ec1c                	sd	a5,24(s0)
 768:	03043023          	sd	a6,32(s0)
 76c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 770:	8622                	mv	a2,s0
 772:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 776:	00000097          	auipc	ra,0x0
 77a:	e16080e7          	jalr	-490(ra) # 58c <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6161                	addi	sp,sp,80
 784:	8082                	ret

0000000000000786 <printf>:

void
printf(const char *fmt, ...)
{
 786:	711d                	addi	sp,sp,-96
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e40c                	sd	a1,8(s0)
 790:	e810                	sd	a2,16(s0)
 792:	ec14                	sd	a3,24(s0)
 794:	f018                	sd	a4,32(s0)
 796:	f41c                	sd	a5,40(s0)
 798:	03043823          	sd	a6,48(s0)
 79c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	00840613          	addi	a2,s0,8
 7a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a8:	85aa                	mv	a1,a0
 7aa:	4505                	li	a0,1
 7ac:	00000097          	auipc	ra,0x0
 7b0:	de0080e7          	jalr	-544(ra) # 58c <vprintf>
}
 7b4:	60e2                	ld	ra,24(sp)
 7b6:	6442                	ld	s0,16(sp)
 7b8:	6125                	addi	sp,sp,96
 7ba:	8082                	ret

00000000000007bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bc:	1141                	addi	sp,sp,-16
 7be:	e406                	sd	ra,8(sp)
 7c0:	e022                	sd	s0,0(sp)
 7c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c8:	00001797          	auipc	a5,0x1
 7cc:	d987b783          	ld	a5,-616(a5) # 1560 <freep>
 7d0:	a02d                	j	7fa <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d2:	4618                	lw	a4,8(a2)
 7d4:	9f2d                	addw	a4,a4,a1
 7d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7da:	6398                	ld	a4,0(a5)
 7dc:	6310                	ld	a2,0(a4)
 7de:	a83d                	j	81c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e0:	ff852703          	lw	a4,-8(a0)
 7e4:	9f31                	addw	a4,a4,a2
 7e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e8:	ff053683          	ld	a3,-16(a0)
 7ec:	a091                	j	830 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e7e463          	bltu	a5,a4,7f8 <free+0x3c>
 7f4:	00e6ea63          	bltu	a3,a4,808 <free+0x4c>
{
 7f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	fed7fae3          	bgeu	a5,a3,7ee <free+0x32>
 7fe:	6398                	ld	a4,0(a5)
 800:	00e6e463          	bltu	a3,a4,808 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	fee7eae3          	bltu	a5,a4,7f8 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 808:	ff852583          	lw	a1,-8(a0)
 80c:	6390                	ld	a2,0(a5)
 80e:	02059813          	slli	a6,a1,0x20
 812:	01c85713          	srli	a4,a6,0x1c
 816:	9736                	add	a4,a4,a3
 818:	fae60de3          	beq	a2,a4,7d2 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 820:	4790                	lw	a2,8(a5)
 822:	02061593          	slli	a1,a2,0x20
 826:	01c5d713          	srli	a4,a1,0x1c
 82a:	973e                	add	a4,a4,a5
 82c:	fae68ae3          	beq	a3,a4,7e0 <free+0x24>
    p->s.ptr = bp->s.ptr;
 830:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 832:	00001717          	auipc	a4,0x1
 836:	d2f73723          	sd	a5,-722(a4) # 1560 <freep>
}
 83a:	60a2                	ld	ra,8(sp)
 83c:	6402                	ld	s0,0(sp)
 83e:	0141                	addi	sp,sp,16
 840:	8082                	ret

0000000000000842 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 842:	7139                	addi	sp,sp,-64
 844:	fc06                	sd	ra,56(sp)
 846:	f822                	sd	s0,48(sp)
 848:	f04a                	sd	s2,32(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	02051993          	slli	s3,a0,0x20
 852:	0209d993          	srli	s3,s3,0x20
 856:	09bd                	addi	s3,s3,15
 858:	0049d993          	srli	s3,s3,0x4
 85c:	2985                	addiw	s3,s3,1
 85e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 860:	00001517          	auipc	a0,0x1
 864:	d0053503          	ld	a0,-768(a0) # 1560 <freep>
 868:	c905                	beqz	a0,898 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	09377a63          	bgeu	a4,s3,902 <malloc+0xc0>
 872:	f426                	sd	s1,40(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 87a:	8a4e                	mv	s4,s3
 87c:	6705                	lui	a4,0x1
 87e:	00e9f363          	bgeu	s3,a4,884 <malloc+0x42>
 882:	6a05                	lui	s4,0x1
 884:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 888:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88c:	00001497          	auipc	s1,0x1
 890:	cd448493          	addi	s1,s1,-812 # 1560 <freep>
  if(p == (char*)-1)
 894:	5afd                	li	s5,-1
 896:	a089                	j	8d8 <malloc+0x96>
 898:	f426                	sd	s1,40(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a0:	00001797          	auipc	a5,0x1
 8a4:	ee078793          	addi	a5,a5,-288 # 1780 <base>
 8a8:	00001717          	auipc	a4,0x1
 8ac:	caf73c23          	sd	a5,-840(a4) # 1560 <freep>
 8b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b6:	b7d1                	j	87a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b8:	6398                	ld	a4,0(a5)
 8ba:	e118                	sd	a4,0(a0)
 8bc:	a8b9                	j	91a <malloc+0xd8>
  hp->s.size = nu;
 8be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c2:	0541                	addi	a0,a0,16
 8c4:	00000097          	auipc	ra,0x0
 8c8:	ef8080e7          	jalr	-264(ra) # 7bc <free>
  return freep;
 8cc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ce:	c135                	beqz	a0,932 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d2:	4798                	lw	a4,8(a5)
 8d4:	03277363          	bgeu	a4,s2,8fa <malloc+0xb8>
    if(p == freep)
 8d8:	6098                	ld	a4,0(s1)
 8da:	853e                	mv	a0,a5
 8dc:	fef71ae3          	bne	a4,a5,8d0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8e0:	8552                	mv	a0,s4
 8e2:	00000097          	auipc	ra,0x0
 8e6:	b8e080e7          	jalr	-1138(ra) # 470 <sbrk>
  if(p == (char*)-1)
 8ea:	fd551ae3          	bne	a0,s5,8be <malloc+0x7c>
        return 0;
 8ee:	4501                	li	a0,0
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
 8f8:	a03d                	j	926 <malloc+0xe4>
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 902:	fae90be3          	beq	s2,a4,8b8 <malloc+0x76>
        p->s.size -= nunits;
 906:	4137073b          	subw	a4,a4,s3
 90a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90c:	02071693          	slli	a3,a4,0x20
 910:	01c6d713          	srli	a4,a3,0x1c
 914:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 916:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91a:	00001717          	auipc	a4,0x1
 91e:	c4a73323          	sd	a0,-954(a4) # 1560 <freep>
      return (void*)(p + 1);
 922:	01078513          	addi	a0,a5,16
  }
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	7902                	ld	s2,32(sp)
 92c:	69e2                	ld	s3,24(sp)
 92e:	6121                	addi	sp,sp,64
 930:	8082                	ret
 932:	74a2                	ld	s1,40(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
 93a:	b7f5                	j	926 <malloc+0xe4>

000000000000093c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 93c:	1141                	addi	sp,sp,-16
 93e:	e406                	sd	ra,8(sp)
 940:	e022                	sd	s0,0(sp)
 942:	0800                	addi	s0,sp,16
  thread_exit(status);
 944:	2501                	sext.w	a0,a0
 946:	00000097          	auipc	ra,0x0
 94a:	b5a080e7          	jalr	-1190(ra) # 4a0 <thread_exit>
}
 94e:	60a2                	ld	ra,8(sp)
 950:	6402                	ld	s0,0(sp)
 952:	0141                	addi	sp,sp,16
 954:	8082                	ret

0000000000000956 <free_stacks>:
int free_stacks() {
 956:	7179                	addi	sp,sp,-48
 958:	f406                	sd	ra,40(sp)
 95a:	f022                	sd	s0,32(sp)
 95c:	ec26                	sd	s1,24(sp)
 95e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 960:	00001797          	auipc	a5,0x1
 964:	c107a783          	lw	a5,-1008(a5) # 1570 <num_threads>
 968:	04f05063          	blez	a5,9a8 <free_stacks+0x52>
 96c:	e84a                	sd	s2,16(sp)
 96e:	e44e                	sd	s3,8(sp)
 970:	4481                	li	s1,0
    free(stacks[i]);
 972:	00001997          	auipc	s3,0x1
 976:	bf698993          	addi	s3,s3,-1034 # 1568 <stacks>
  for (int i = 0; i < num_threads; i++) {
 97a:	00001917          	auipc	s2,0x1
 97e:	bf690913          	addi	s2,s2,-1034 # 1570 <num_threads>
    free(stacks[i]);
 982:	0009b783          	ld	a5,0(s3)
 986:	00349713          	slli	a4,s1,0x3
 98a:	97ba                	add	a5,a5,a4
 98c:	6388                	ld	a0,0(a5)
 98e:	00000097          	auipc	ra,0x0
 992:	e2e080e7          	jalr	-466(ra) # 7bc <free>
  for (int i = 0; i < num_threads; i++) {
 996:	0485                	addi	s1,s1,1
 998:	00092703          	lw	a4,0(s2)
 99c:	0004879b          	sext.w	a5,s1
 9a0:	fee7c1e3          	blt	a5,a4,982 <free_stacks+0x2c>
 9a4:	6942                	ld	s2,16(sp)
 9a6:	69a2                	ld	s3,8(sp)
  free(stacks);
 9a8:	00001497          	auipc	s1,0x1
 9ac:	bc048493          	addi	s1,s1,-1088 # 1568 <stacks>
 9b0:	6088                	ld	a0,0(s1)
 9b2:	00000097          	auipc	ra,0x0
 9b6:	e0a080e7          	jalr	-502(ra) # 7bc <free>
  stacks = 0;
 9ba:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9be:	00001797          	auipc	a5,0x1
 9c2:	ba07a923          	sw	zero,-1102(a5) # 1570 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9c6:	47a1                	li	a5,8
 9c8:	00001717          	auipc	a4,0x1
 9cc:	b8f72423          	sw	a5,-1144(a4) # 1550 <max_stacks>
  threads_done = 0;
 9d0:	00001797          	auipc	a5,0x1
 9d4:	ba07a223          	sw	zero,-1116(a5) # 1574 <threads_done>
}
 9d8:	4501                	li	a0,0
 9da:	70a2                	ld	ra,40(sp)
 9dc:	7402                	ld	s0,32(sp)
 9de:	64e2                	ld	s1,24(sp)
 9e0:	6145                	addi	sp,sp,48
 9e2:	8082                	ret

00000000000009e4 <expand_num_threads>:
int expand_num_threads() {
 9e4:	1101                	addi	sp,sp,-32
 9e6:	ec06                	sd	ra,24(sp)
 9e8:	e822                	sd	s0,16(sp)
 9ea:	e426                	sd	s1,8(sp)
 9ec:	e04a                	sd	s2,0(sp)
 9ee:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9f0:	00001797          	auipc	a5,0x1
 9f4:	b6078793          	addi	a5,a5,-1184 # 1550 <max_stacks>
 9f8:	4388                	lw	a0,0(a5)
 9fa:	0015151b          	slliw	a0,a0,0x1
 9fe:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a00:	0035151b          	slliw	a0,a0,0x3
 a04:	00000097          	auipc	ra,0x0
 a08:	e3e080e7          	jalr	-450(ra) # 842 <malloc>
 a0c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a0e:	00001617          	auipc	a2,0x1
 a12:	b6262603          	lw	a2,-1182(a2) # 1570 <num_threads>
 a16:	00001497          	auipc	s1,0x1
 a1a:	b5248493          	addi	s1,s1,-1198 # 1568 <stacks>
 a1e:	0036161b          	slliw	a2,a2,0x3
 a22:	608c                	ld	a1,0(s1)
 a24:	00000097          	auipc	ra,0x0
 a28:	90a080e7          	jalr	-1782(ra) # 32e <memmove>
  free(stacks);
 a2c:	6088                	ld	a0,0(s1)
 a2e:	00000097          	auipc	ra,0x0
 a32:	d8e080e7          	jalr	-626(ra) # 7bc <free>
  stacks = new_stacks;
 a36:	0124b023          	sd	s2,0(s1)
}
 a3a:	4501                	li	a0,0
 a3c:	60e2                	ld	ra,24(sp)
 a3e:	6442                	ld	s0,16(sp)
 a40:	64a2                	ld	s1,8(sp)
 a42:	6902                	ld	s2,0(sp)
 a44:	6105                	addi	sp,sp,32
 a46:	8082                	ret

0000000000000a48 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a48:	7179                	addi	sp,sp,-48
 a4a:	f406                	sd	ra,40(sp)
 a4c:	f022                	sd	s0,32(sp)
 a4e:	e84a                	sd	s2,16(sp)
 a50:	e44e                	sd	s3,8(sp)
 a52:	1800                	addi	s0,sp,48
 a54:	892a                	mv	s2,a0
 a56:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a58:	00001797          	auipc	a5,0x1
 a5c:	b107b783          	ld	a5,-1264(a5) # 1568 <stacks>
 a60:	c3d9                	beqz	a5,ae6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a62:	00001797          	auipc	a5,0x1
 a66:	aee7a783          	lw	a5,-1298(a5) # 1550 <max_stacks>
 a6a:	00001717          	auipc	a4,0x1
 a6e:	b0672703          	lw	a4,-1274(a4) # 1570 <num_threads>
 a72:	0af71363          	bne	a4,a5,b18 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a76:	04000713          	li	a4,64
 a7a:	08e78563          	beq	a5,a4,b04 <ithread_create+0xbc>
 a7e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a80:	00000097          	auipc	ra,0x0
 a84:	f64080e7          	jalr	-156(ra) # 9e4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a88:	6505                	lui	a0,0x1
 a8a:	00000097          	auipc	ra,0x0
 a8e:	db8080e7          	jalr	-584(ra) # 842 <malloc>
 a92:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a94:	00001717          	auipc	a4,0x1
 a98:	adc72703          	lw	a4,-1316(a4) # 1570 <num_threads>
 a9c:	070e                	slli	a4,a4,0x3
 a9e:	00001797          	auipc	a5,0x1
 aa2:	aca7b783          	ld	a5,-1334(a5) # 1568 <stacks>
 aa6:	97ba                	add	a5,a5,a4
 aa8:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 aaa:	00000697          	auipc	a3,0x0
 aae:	e9268693          	addi	a3,a3,-366 # 93c <ithread_exit>
 ab2:	862a                	mv	a2,a0
 ab4:	85ce                	mv	a1,s3
 ab6:	854a                	mv	a0,s2
 ab8:	00000097          	auipc	ra,0x0
 abc:	9d8080e7          	jalr	-1576(ra) # 490 <create_thread>
 ac0:	892a                	mv	s2,a0
  if (res != -1) {
 ac2:	57fd                	li	a5,-1
 ac4:	04f50c63          	beq	a0,a5,b1c <ithread_create+0xd4>
    num_threads++;
 ac8:	00001717          	auipc	a4,0x1
 acc:	aa870713          	addi	a4,a4,-1368 # 1570 <num_threads>
 ad0:	431c                	lw	a5,0(a4)
 ad2:	2785                	addiw	a5,a5,1
 ad4:	c31c                	sw	a5,0(a4)
 ad6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ad8:	854a                	mv	a0,s2
 ada:	70a2                	ld	ra,40(sp)
 adc:	7402                	ld	s0,32(sp)
 ade:	6942                	ld	s2,16(sp)
 ae0:	69a2                	ld	s3,8(sp)
 ae2:	6145                	addi	sp,sp,48
 ae4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ae6:	00001517          	auipc	a0,0x1
 aea:	a6a52503          	lw	a0,-1430(a0) # 1550 <max_stacks>
 aee:	0035151b          	slliw	a0,a0,0x3
 af2:	00000097          	auipc	ra,0x0
 af6:	d50080e7          	jalr	-688(ra) # 842 <malloc>
 afa:	00001797          	auipc	a5,0x1
 afe:	a6a7b723          	sd	a0,-1426(a5) # 1568 <stacks>
 b02:	b785                	j	a62 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b04:	00000517          	auipc	a0,0x0
 b08:	0dc50513          	addi	a0,a0,220 # be0 <ithread_join+0x9e>
 b0c:	00000097          	auipc	ra,0x0
 b10:	c7a080e7          	jalr	-902(ra) # 786 <printf>
      return -1;
 b14:	597d                	li	s2,-1
 b16:	b7c9                	j	ad8 <ithread_create+0x90>
 b18:	ec26                	sd	s1,24(sp)
 b1a:	b7bd                	j	a88 <ithread_create+0x40>
    free(stack_ptr);
 b1c:	8526                	mv	a0,s1
 b1e:	00000097          	auipc	ra,0x0
 b22:	c9e080e7          	jalr	-866(ra) # 7bc <free>
    stacks[num_threads] = 0;
 b26:	00001717          	auipc	a4,0x1
 b2a:	a4a72703          	lw	a4,-1462(a4) # 1570 <num_threads>
 b2e:	070e                	slli	a4,a4,0x3
 b30:	00001797          	auipc	a5,0x1
 b34:	a387b783          	ld	a5,-1480(a5) # 1568 <stacks>
 b38:	97ba                	add	a5,a5,a4
 b3a:	0007b023          	sd	zero,0(a5)
 b3e:	64e2                	ld	s1,24(sp)
 b40:	bf61                	j	ad8 <ithread_create+0x90>

0000000000000b42 <ithread_join>:

int ithread_join(int thread_id) {
 b42:	1101                	addi	sp,sp,-32
 b44:	ec06                	sd	ra,24(sp)
 b46:	e822                	sd	s0,16(sp)
 b48:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b4a:	ff040793          	addi	a5,s0,-16
 b4e:	ffc7859b          	addiw	a1,a5,-4
 b52:	00000097          	auipc	ra,0x0
 b56:	946080e7          	jalr	-1722(ra) # 498 <join_thread>
  threads_done++;
 b5a:	00001717          	auipc	a4,0x1
 b5e:	a1a70713          	addi	a4,a4,-1510 # 1574 <threads_done>
 b62:	431c                	lw	a5,0(a4)
 b64:	2785                	addiw	a5,a5,1
 b66:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b68:	00001717          	auipc	a4,0x1
 b6c:	a0872703          	lw	a4,-1528(a4) # 1570 <num_threads>
 b70:	00f70863          	beq	a4,a5,b80 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b74:	fec42503          	lw	a0,-20(s0)
 b78:	60e2                	ld	ra,24(sp)
 b7a:	6442                	ld	s0,16(sp)
 b7c:	6105                	addi	sp,sp,32
 b7e:	8082                	ret
    free_stacks();
 b80:	00000097          	auipc	ra,0x0
 b84:	dd6080e7          	jalr	-554(ra) # 956 <free_stacks>
 b88:	b7f5                	j	b74 <ithread_join+0x32>
