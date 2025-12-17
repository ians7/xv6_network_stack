
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
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	56890913          	addi	s2,s2,1384 # 1580 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3c6080e7          	jalr	966(ra) # 3ee <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3ba080e7          	jalr	954(ra) # 3f6 <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	b6858593          	addi	a1,a1,-1176 # bb0 <ithread_join+0x48>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	72a080e7          	jalr	1834(ra) # 77c <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	37a080e7          	jalr	890(ra) # 3d6 <exit>
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
  7e:	b4e58593          	addi	a1,a1,-1202 # bc8 <ithread_join+0x60>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	6f8080e7          	jalr	1784(ra) # 77c <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	348080e7          	jalr	840(ra) # 3d6 <exit>

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
  c8:	352080e7          	jalr	850(ra) # 416 <open>
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
  e0:	322080e7          	jalr	802(ra) # 3fe <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2ea080e7          	jalr	746(ra) # 3d6 <exit>
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
 10a:	2d0080e7          	jalr	720(ra) # 3d6 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	ace58593          	addi	a1,a1,-1330 # be0 <ithread_join+0x78>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	660080e7          	jalr	1632(ra) # 77c <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2b0080e7          	jalr	688(ra) # 3d6 <exit>

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
 144:	296080e7          	jalr	662(ra) # 3d6 <exit>

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
 1a4:	cf91                	beqz	a5,1c0 <strlen+0x28>
 1a6:	00150793          	addi	a5,a0,1
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  for(n = 0; s[n]; n++)
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strlen+0x20>

00000000000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e406                	sd	ra,8(sp)
 1c8:	e022                	sd	s0,0(sp)
 1ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1cc:	ca19                	beqz	a2,1e2 <memset+0x1e>
 1ce:	87aa                	mv	a5,a0
 1d0:	1602                	slli	a2,a2,0x20
 1d2:	9201                	srli	a2,a2,0x20
 1d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1dc:	0785                	addi	a5,a5,1
 1de:	fee79de3          	bne	a5,a4,1d8 <memset+0x14>
  }
  return dst;
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf81                	beqz	a5,20e <strchr+0x24>
    if(*s == c)
 1f8:	00f58763          	beq	a1,a5,206 <strchr+0x1c>
  for(; *s; s++)
 1fc:	0505                	addi	a0,a0,1
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbfd                	bnez	a5,1f8 <strchr+0xe>
      return (char*)s;
  return 0;
 204:	4501                	li	a0,0
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  return 0;
 20e:	4501                	li	a0,0
 210:	bfdd                	j	206 <strchr+0x1c>

0000000000000212 <gets>:

char*
gets(char *buf, int max)
{
 212:	711d                	addi	sp,sp,-96
 214:	ec86                	sd	ra,88(sp)
 216:	e8a2                	sd	s0,80(sp)
 218:	e4a6                	sd	s1,72(sp)
 21a:	e0ca                	sd	s2,64(sp)
 21c:	fc4e                	sd	s3,56(sp)
 21e:	f852                	sd	s4,48(sp)
 220:	f456                	sd	s5,40(sp)
 222:	f05a                	sd	s6,32(sp)
 224:	ec5e                	sd	s7,24(sp)
 226:	e862                	sd	s8,16(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
 232:	faf40b13          	addi	s6,s0,-81
 236:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 238:	8c26                	mv	s8,s1
 23a:	0014899b          	addiw	s3,s1,1
 23e:	84ce                	mv	s1,s3
 240:	0349d663          	bge	s3,s4,26c <gets+0x5a>
    cc = read(0, &c, 1);
 244:	8656                	mv	a2,s5
 246:	85da                	mv	a1,s6
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	1a4080e7          	jalr	420(ra) # 3ee <read>
    if(cc < 1)
 252:	00a05d63          	blez	a0,26c <gets+0x5a>
      break;
    buf[i++] = c;
 256:	faf44783          	lbu	a5,-81(s0)
 25a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25e:	0905                	addi	s2,s2,1
 260:	ff678713          	addi	a4,a5,-10
 264:	c319                	beqz	a4,26a <gets+0x58>
 266:	17cd                	addi	a5,a5,-13
 268:	fbe1                	bnez	a5,238 <gets+0x26>
    buf[i++] = c;
 26a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 26c:	9c5e                	add	s8,s8,s7
 26e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 272:	855e                	mv	a0,s7
 274:	60e6                	ld	ra,88(sp)
 276:	6446                	ld	s0,80(sp)
 278:	64a6                	ld	s1,72(sp)
 27a:	6906                	ld	s2,64(sp)
 27c:	79e2                	ld	s3,56(sp)
 27e:	7a42                	ld	s4,48(sp)
 280:	7aa2                	ld	s5,40(sp)
 282:	7b02                	ld	s6,32(sp)
 284:	6be2                	ld	s7,24(sp)
 286:	6c42                	ld	s8,16(sp)
 288:	6125                	addi	sp,sp,96
 28a:	8082                	ret

000000000000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	1101                	addi	sp,sp,-32
 28e:	ec06                	sd	ra,24(sp)
 290:	e822                	sd	s0,16(sp)
 292:	e04a                	sd	s2,0(sp)
 294:	1000                	addi	s0,sp,32
 296:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	4581                	li	a1,0
 29a:	00000097          	auipc	ra,0x0
 29e:	17c080e7          	jalr	380(ra) # 416 <open>
  if(fd < 0)
 2a2:	02054663          	bltz	a0,2ce <stat+0x42>
 2a6:	e426                	sd	s1,8(sp)
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	00000097          	auipc	ra,0x0
 2b0:	182080e7          	jalr	386(ra) # 42e <fstat>
 2b4:	892a                	mv	s2,a0
  close(fd);
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	146080e7          	jalr	326(ra) # 3fe <close>
  return r;
 2c0:	64a2                	ld	s1,8(sp)
}
 2c2:	854a                	mv	a0,s2
 2c4:	60e2                	ld	ra,24(sp)
 2c6:	6442                	ld	s0,16(sp)
 2c8:	6902                	ld	s2,0(sp)
 2ca:	6105                	addi	sp,sp,32
 2cc:	8082                	ret
    return -1;
 2ce:	57fd                	li	a5,-1
 2d0:	893e                	mv	s2,a5
 2d2:	bfc5                	j	2c2 <stat+0x36>

00000000000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2dc:	00054683          	lbu	a3,0(a0)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	4625                	li	a2,9
 2ea:	02f66963          	bltu	a2,a5,31c <atoi+0x48>
 2ee:	872a                	mv	a4,a0
  n = 0;
 2f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f2:	0705                	addi	a4,a4,1
 2f4:	0025179b          	slliw	a5,a0,0x2
 2f8:	9fa9                	addw	a5,a5,a0
 2fa:	0017979b          	slliw	a5,a5,0x1
 2fe:	9fb5                	addw	a5,a5,a3
 300:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 304:	00074683          	lbu	a3,0(a4)
 308:	fd06879b          	addiw	a5,a3,-48
 30c:	0ff7f793          	zext.b	a5,a5
 310:	fef671e3          	bgeu	a2,a5,2f2 <atoi+0x1e>
  return n;
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  n = 0;
 31c:	4501                	li	a0,0
 31e:	bfdd                	j	314 <atoi+0x40>

0000000000000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57563          	bgeu	a0,a1,352 <memmove+0x32>
    while(n-- > 0)
 32c:	00c05f63          	blez	a2,34a <memmove+0x2a>
 330:	1602                	slli	a2,a2,0x20
 332:	9201                	srli	a2,a2,0x20
 334:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 338:	872a                	mv	a4,a0
      *dst++ = *src++;
 33a:	0585                	addi	a1,a1,1
 33c:	0705                	addi	a4,a4,1
 33e:	fff5c683          	lbu	a3,-1(a1)
 342:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 346:	fee79ae3          	bne	a5,a4,33a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    while(n-- > 0)
 352:	fec05ce3          	blez	a2,34a <memmove+0x2a>
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fef71ae3          	bne	a4,a5,36a <memmove+0x4a>
 37a:	bfc1                	j	34a <memmove+0x2a>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 384:	c61d                	beqz	a2,3b2 <memcmp+0x36>
 386:	1602                	slli	a2,a2,0x20
 388:	9201                	srli	a2,a2,0x20
 38a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 38e:	00054783          	lbu	a5,0(a0)
 392:	0005c703          	lbu	a4,0(a1)
 396:	00e79863          	bne	a5,a4,3a6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 39a:	0505                	addi	a0,a0,1
    p2++;
 39c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39e:	fed518e3          	bne	a0,a3,38e <memcmp+0x12>
  }
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	a019                	j	3aa <memcmp+0x2e>
      return *p1 - *p2;
 3a6:	40e7853b          	subw	a0,a5,a4
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfdd                	j	3aa <memcmp+0x2e>

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
 3c2:	f62080e7          	jalr	-158(ra) # 320 <memmove>
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
 50c:	f04a                	sd	s2,32(sp)
 50e:	ec4e                	sd	s3,24(sp)
 510:	0080                	addi	s0,sp,64
 512:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 514:	cad9                	beqz	a3,5aa <printint+0xa4>
 516:	01f5d79b          	srliw	a5,a1,0x1f
 51a:	cbc1                	beqz	a5,5aa <printint+0xa4>
    neg = 1;
    x = -xx;
 51c:	40b005bb          	negw	a1,a1
    neg = 1;
 520:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 522:	fc040993          	addi	s3,s0,-64
  neg = 0;
 526:	86ce                	mv	a3,s3
  i = 0;
 528:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52a:	00000817          	auipc	a6,0x0
 52e:	75e80813          	addi	a6,a6,1886 # c88 <digits>
 532:	88ba                	mv	a7,a4
 534:	0017051b          	addiw	a0,a4,1
 538:	872a                	mv	a4,a0
 53a:	02c5f7bb          	remuw	a5,a1,a2
 53e:	1782                	slli	a5,a5,0x20
 540:	9381                	srli	a5,a5,0x20
 542:	97c2                	add	a5,a5,a6
 544:	0007c783          	lbu	a5,0(a5)
 548:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54c:	87ae                	mv	a5,a1
 54e:	02c5d5bb          	divuw	a1,a1,a2
 552:	0685                	addi	a3,a3,1
 554:	fcc7ffe3          	bgeu	a5,a2,532 <printint+0x2c>
  if(neg)
 558:	00030c63          	beqz	t1,570 <printint+0x6a>
    buf[i++] = '-';
 55c:	fd050793          	addi	a5,a0,-48
 560:	00878533          	add	a0,a5,s0
 564:	02d00793          	li	a5,45
 568:	fef50823          	sb	a5,-16(a0)
 56c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 570:	02e05763          	blez	a4,59e <printint+0x98>
 574:	f426                	sd	s1,40(sp)
 576:	377d                	addiw	a4,a4,-1
 578:	00e984b3          	add	s1,s3,a4
 57c:	19fd                	addi	s3,s3,-1
 57e:	99ba                	add	s3,s3,a4
 580:	1702                	slli	a4,a4,0x20
 582:	9301                	srli	a4,a4,0x20
 584:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 588:	0004c583          	lbu	a1,0(s1)
 58c:	854a                	mv	a0,s2
 58e:	00000097          	auipc	ra,0x0
 592:	f56080e7          	jalr	-170(ra) # 4e4 <putc>
  while(--i >= 0)
 596:	14fd                	addi	s1,s1,-1
 598:	ff3498e3          	bne	s1,s3,588 <printint+0x82>
 59c:	74a2                	ld	s1,40(sp)
}
 59e:	70e2                	ld	ra,56(sp)
 5a0:	7442                	ld	s0,48(sp)
 5a2:	7902                	ld	s2,32(sp)
 5a4:	69e2                	ld	s3,24(sp)
 5a6:	6121                	addi	sp,sp,64
 5a8:	8082                	ret
  neg = 0;
 5aa:	4301                	li	t1,0
 5ac:	bf9d                	j	522 <printint+0x1c>

00000000000005ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ae:	715d                	addi	sp,sp,-80
 5b0:	e486                	sd	ra,72(sp)
 5b2:	e0a2                	sd	s0,64(sp)
 5b4:	f84a                	sd	s2,48(sp)
 5b6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b8:	0005c903          	lbu	s2,0(a1)
 5bc:	1a090b63          	beqz	s2,772 <vprintf+0x1c4>
 5c0:	fc26                	sd	s1,56(sp)
 5c2:	f44e                	sd	s3,40(sp)
 5c4:	f052                	sd	s4,32(sp)
 5c6:	ec56                	sd	s5,24(sp)
 5c8:	e85a                	sd	s6,16(sp)
 5ca:	e45e                	sd	s7,8(sp)
 5cc:	8aaa                	mv	s5,a0
 5ce:	8bb2                	mv	s7,a2
 5d0:	00158493          	addi	s1,a1,1
  state = 0;
 5d4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d6:	02500a13          	li	s4,37
 5da:	4b55                	li	s6,21
 5dc:	a839                	j	5fa <vprintf+0x4c>
        putc(fd, c);
 5de:	85ca                	mv	a1,s2
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	f02080e7          	jalr	-254(ra) # 4e4 <putc>
 5ea:	a019                	j	5f0 <vprintf+0x42>
    } else if(state == '%'){
 5ec:	01498d63          	beq	s3,s4,606 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5f0:	0485                	addi	s1,s1,1
 5f2:	fff4c903          	lbu	s2,-1(s1)
 5f6:	16090863          	beqz	s2,766 <vprintf+0x1b8>
    if(state == 0){
 5fa:	fe0999e3          	bnez	s3,5ec <vprintf+0x3e>
      if(c == '%'){
 5fe:	ff4910e3          	bne	s2,s4,5de <vprintf+0x30>
        state = '%';
 602:	89d2                	mv	s3,s4
 604:	b7f5                	j	5f0 <vprintf+0x42>
      if(c == 'd'){
 606:	13490563          	beq	s2,s4,730 <vprintf+0x182>
 60a:	f9d9079b          	addiw	a5,s2,-99
 60e:	0ff7f793          	zext.b	a5,a5
 612:	12fb6863          	bltu	s6,a5,742 <vprintf+0x194>
 616:	f9d9079b          	addiw	a5,s2,-99
 61a:	0ff7f713          	zext.b	a4,a5
 61e:	12eb6263          	bltu	s6,a4,742 <vprintf+0x194>
 622:	00271793          	slli	a5,a4,0x2
 626:	00000717          	auipc	a4,0x0
 62a:	60a70713          	addi	a4,a4,1546 # c30 <ithread_join+0xc8>
 62e:	97ba                	add	a5,a5,a4
 630:	439c                	lw	a5,0(a5)
 632:	97ba                	add	a5,a5,a4
 634:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 636:	008b8913          	addi	s2,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000ba583          	lw	a1,0(s7)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	ec2080e7          	jalr	-318(ra) # 506 <printint>
 64c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64e:	4981                	li	s3,0
 650:	b745                	j	5f0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000ba583          	lw	a1,0(s7)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	ea6080e7          	jalr	-346(ra) # 506 <printint>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b751                	j	5f0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000ba583          	lw	a1,0(s7)
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e8a080e7          	jalr	-374(ra) # 506 <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	b7a5                	j	5f0 <vprintf+0x42>
 68a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 68c:	008b8793          	addi	a5,s7,8
 690:	8c3e                	mv	s8,a5
 692:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 696:	03000593          	li	a1,48
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e48080e7          	jalr	-440(ra) # 4e4 <putc>
  putc(fd, 'x');
 6a4:	07800593          	li	a1,120
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e3a080e7          	jalr	-454(ra) # 4e4 <putc>
 6b2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b4:	00000b97          	auipc	s7,0x0
 6b8:	5d4b8b93          	addi	s7,s7,1492 # c88 <digits>
 6bc:	03c9d793          	srli	a5,s3,0x3c
 6c0:	97de                	add	a5,a5,s7
 6c2:	0007c583          	lbu	a1,0(a5)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e1c080e7          	jalr	-484(ra) # 4e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d0:	0992                	slli	s3,s3,0x4
 6d2:	397d                	addiw	s2,s2,-1
 6d4:	fe0914e3          	bnez	s2,6bc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 6d8:	8be2                	mv	s7,s8
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	6c02                	ld	s8,0(sp)
 6de:	bf09                	j	5f0 <vprintf+0x42>
        s = va_arg(ap, char*);
 6e0:	008b8993          	addi	s3,s7,8
 6e4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6e8:	02090163          	beqz	s2,70a <vprintf+0x15c>
        while(*s != 0){
 6ec:	00094583          	lbu	a1,0(s2)
 6f0:	c9a5                	beqz	a1,760 <vprintf+0x1b2>
          putc(fd, *s);
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	df0080e7          	jalr	-528(ra) # 4e4 <putc>
          s++;
 6fc:	0905                	addi	s2,s2,1
        while(*s != 0){
 6fe:	00094583          	lbu	a1,0(s2)
 702:	f9e5                	bnez	a1,6f2 <vprintf+0x144>
        s = va_arg(ap, char*);
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	b5e5                	j	5f0 <vprintf+0x42>
          s = "(null)";
 70a:	00000917          	auipc	s2,0x0
 70e:	4ee90913          	addi	s2,s2,1262 # bf8 <ithread_join+0x90>
        while(*s != 0){
 712:	02800593          	li	a1,40
 716:	bff1                	j	6f2 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 718:	008b8913          	addi	s2,s7,8
 71c:	000bc583          	lbu	a1,0(s7)
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	dc2080e7          	jalr	-574(ra) # 4e4 <putc>
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b5c9                	j	5f0 <vprintf+0x42>
        putc(fd, c);
 730:	02500593          	li	a1,37
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	dae080e7          	jalr	-594(ra) # 4e4 <putc>
      state = 0;
 73e:	4981                	li	s3,0
 740:	bd45                	j	5f0 <vprintf+0x42>
        putc(fd, '%');
 742:	02500593          	li	a1,37
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	d9c080e7          	jalr	-612(ra) # 4e4 <putc>
        putc(fd, c);
 750:	85ca                	mv	a1,s2
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	d90080e7          	jalr	-624(ra) # 4e4 <putc>
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bd49                	j	5f0 <vprintf+0x42>
        s = va_arg(ap, char*);
 760:	8bce                	mv	s7,s3
      state = 0;
 762:	4981                	li	s3,0
 764:	b571                	j	5f0 <vprintf+0x42>
 766:	74e2                	ld	s1,56(sp)
 768:	79a2                	ld	s3,40(sp)
 76a:	7a02                	ld	s4,32(sp)
 76c:	6ae2                	ld	s5,24(sp)
 76e:	6b42                	ld	s6,16(sp)
 770:	6ba2                	ld	s7,8(sp)
    }
  }
}
 772:	60a6                	ld	ra,72(sp)
 774:	6406                	ld	s0,64(sp)
 776:	7942                	ld	s2,48(sp)
 778:	6161                	addi	sp,sp,80
 77a:	8082                	ret

000000000000077c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e010                	sd	a2,0(s0)
 786:	e414                	sd	a3,8(s0)
 788:	e818                	sd	a4,16(s0)
 78a:	ec1c                	sd	a5,24(s0)
 78c:	03043023          	sd	a6,32(s0)
 790:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 794:	8622                	mv	a2,s0
 796:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79a:	00000097          	auipc	ra,0x0
 79e:	e14080e7          	jalr	-492(ra) # 5ae <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6161                	addi	sp,sp,80
 7a8:	8082                	ret

00000000000007aa <printf>:

void
printf(const char *fmt, ...)
{
 7aa:	711d                	addi	sp,sp,-96
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e40c                	sd	a1,8(s0)
 7b4:	e810                	sd	a2,16(s0)
 7b6:	ec14                	sd	a3,24(s0)
 7b8:	f018                	sd	a4,32(s0)
 7ba:	f41c                	sd	a5,40(s0)
 7bc:	03043823          	sd	a6,48(s0)
 7c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	00840613          	addi	a2,s0,8
 7c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7cc:	85aa                	mv	a1,a0
 7ce:	4505                	li	a0,1
 7d0:	00000097          	auipc	ra,0x0
 7d4:	dde080e7          	jalr	-546(ra) # 5ae <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e406                	sd	ra,8(sp)
 7e4:	e022                	sd	s0,0(sp)
 7e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	00001797          	auipc	a5,0x1
 7f0:	d747b783          	ld	a5,-652(a5) # 1560 <freep>
 7f4:	a039                	j	802 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	6398                	ld	a4,0(a5)
 7f8:	00e7e463          	bltu	a5,a4,800 <free+0x20>
 7fc:	00e6ea63          	bltu	a3,a4,810 <free+0x30>
{
 800:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	fed7fae3          	bgeu	a5,a3,7f6 <free+0x16>
 806:	6398                	ld	a4,0(a5)
 808:	00e6e463          	bltu	a3,a4,810 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80c:	fee7eae3          	bltu	a5,a4,800 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 810:	ff852583          	lw	a1,-8(a0)
 814:	6390                	ld	a2,0(a5)
 816:	02059813          	slli	a6,a1,0x20
 81a:	01c85713          	srli	a4,a6,0x1c
 81e:	9736                	add	a4,a4,a3
 820:	02e60563          	beq	a2,a4,84a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 828:	4790                	lw	a2,8(a5)
 82a:	02061593          	slli	a1,a2,0x20
 82e:	01c5d713          	srli	a4,a1,0x1c
 832:	973e                	add	a4,a4,a5
 834:	02e68263          	beq	a3,a4,858 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 838:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83a:	00001717          	auipc	a4,0x1
 83e:	d2f73323          	sd	a5,-730(a4) # 1560 <freep>
}
 842:	60a2                	ld	ra,8(sp)
 844:	6402                	ld	s0,0(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 84a:	4618                	lw	a4,8(a2)
 84c:	9f2d                	addw	a4,a4,a1
 84e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	6310                	ld	a2,0(a4)
 856:	b7f9                	j	824 <free+0x44>
    p->s.size += bp->s.size;
 858:	ff852703          	lw	a4,-8(a0)
 85c:	9f31                	addw	a4,a4,a2
 85e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 860:	ff053683          	ld	a3,-16(a0)
 864:	bfd1                	j	838 <free+0x58>

0000000000000866 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 866:	7139                	addi	sp,sp,-64
 868:	fc06                	sd	ra,56(sp)
 86a:	f822                	sd	s0,48(sp)
 86c:	f04a                	sd	s2,32(sp)
 86e:	ec4e                	sd	s3,24(sp)
 870:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	02051993          	slli	s3,a0,0x20
 876:	0209d993          	srli	s3,s3,0x20
 87a:	09bd                	addi	s3,s3,15
 87c:	0049d993          	srli	s3,s3,0x4
 880:	2985                	addiw	s3,s3,1
 882:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 884:	00001517          	auipc	a0,0x1
 888:	cdc53503          	ld	a0,-804(a0) # 1560 <freep>
 88c:	c905                	beqz	a0,8bc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	09377a63          	bgeu	a4,s3,926 <malloc+0xc0>
 896:	f426                	sd	s1,40(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 89e:	8a4e                	mv	s4,s3
 8a0:	6705                	lui	a4,0x1
 8a2:	00e9f363          	bgeu	s3,a4,8a8 <malloc+0x42>
 8a6:	6a05                	lui	s4,0x1
 8a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b0:	00001497          	auipc	s1,0x1
 8b4:	cb048493          	addi	s1,s1,-848 # 1560 <freep>
  if(p == (char*)-1)
 8b8:	5afd                	li	s5,-1
 8ba:	a089                	j	8fc <malloc+0x96>
 8bc:	f426                	sd	s1,40(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c4:	00001797          	auipc	a5,0x1
 8c8:	ebc78793          	addi	a5,a5,-324 # 1780 <base>
 8cc:	00001717          	auipc	a4,0x1
 8d0:	c8f73a23          	sd	a5,-876(a4) # 1560 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8da:	b7d1                	j	89e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	e118                	sd	a4,0(a0)
 8e0:	a8b9                	j	93e <malloc+0xd8>
  hp->s.size = nu;
 8e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e6:	0541                	addi	a0,a0,16
 8e8:	00000097          	auipc	ra,0x0
 8ec:	ef8080e7          	jalr	-264(ra) # 7e0 <free>
  return freep;
 8f0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8f2:	c135                	beqz	a0,956 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f6:	4798                	lw	a4,8(a5)
 8f8:	03277363          	bgeu	a4,s2,91e <malloc+0xb8>
    if(p == freep)
 8fc:	6098                	ld	a4,0(s1)
 8fe:	853e                	mv	a0,a5
 900:	fef71ae3          	bne	a4,a5,8f4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 904:	8552                	mv	a0,s4
 906:	00000097          	auipc	ra,0x0
 90a:	b58080e7          	jalr	-1192(ra) # 45e <sbrk>
  if(p == (char*)-1)
 90e:	fd551ae3          	bne	a0,s5,8e2 <malloc+0x7c>
        return 0;
 912:	4501                	li	a0,0
 914:	74a2                	ld	s1,40(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
 91c:	a03d                	j	94a <malloc+0xe4>
 91e:	74a2                	ld	s1,40(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 926:	fae90be3          	beq	s2,a4,8dc <malloc+0x76>
        p->s.size -= nunits;
 92a:	4137073b          	subw	a4,a4,s3
 92e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 930:	02071693          	slli	a3,a4,0x20
 934:	01c6d713          	srli	a4,a3,0x1c
 938:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93e:	00001717          	auipc	a4,0x1
 942:	c2a73123          	sd	a0,-990(a4) # 1560 <freep>
      return (void*)(p + 1);
 946:	01078513          	addi	a0,a5,16
  }
}
 94a:	70e2                	ld	ra,56(sp)
 94c:	7442                	ld	s0,48(sp)
 94e:	7902                	ld	s2,32(sp)
 950:	69e2                	ld	s3,24(sp)
 952:	6121                	addi	sp,sp,64
 954:	8082                	ret
 956:	74a2                	ld	s1,40(sp)
 958:	6a42                	ld	s4,16(sp)
 95a:	6aa2                	ld	s5,8(sp)
 95c:	6b02                	ld	s6,0(sp)
 95e:	b7f5                	j	94a <malloc+0xe4>

0000000000000960 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 960:	1141                	addi	sp,sp,-16
 962:	e406                	sd	ra,8(sp)
 964:	e022                	sd	s0,0(sp)
 966:	0800                	addi	s0,sp,16
  thread_exit(status);
 968:	2501                	sext.w	a0,a0
 96a:	00000097          	auipc	ra,0x0
 96e:	b24080e7          	jalr	-1244(ra) # 48e <thread_exit>
}
 972:	60a2                	ld	ra,8(sp)
 974:	6402                	ld	s0,0(sp)
 976:	0141                	addi	sp,sp,16
 978:	8082                	ret

000000000000097a <free_stacks>:
int free_stacks() {
 97a:	7179                	addi	sp,sp,-48
 97c:	f406                	sd	ra,40(sp)
 97e:	f022                	sd	s0,32(sp)
 980:	ec26                	sd	s1,24(sp)
 982:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 984:	00001797          	auipc	a5,0x1
 988:	bec7a783          	lw	a5,-1044(a5) # 1570 <num_threads>
 98c:	04f05063          	blez	a5,9cc <free_stacks+0x52>
 990:	e84a                	sd	s2,16(sp)
 992:	e44e                	sd	s3,8(sp)
 994:	4481                	li	s1,0
    free(stacks[i]);
 996:	00001997          	auipc	s3,0x1
 99a:	bd298993          	addi	s3,s3,-1070 # 1568 <stacks>
  for (int i = 0; i < num_threads; i++) {
 99e:	00001917          	auipc	s2,0x1
 9a2:	bd290913          	addi	s2,s2,-1070 # 1570 <num_threads>
    free(stacks[i]);
 9a6:	0009b783          	ld	a5,0(s3)
 9aa:	00349713          	slli	a4,s1,0x3
 9ae:	97ba                	add	a5,a5,a4
 9b0:	6388                	ld	a0,0(a5)
 9b2:	00000097          	auipc	ra,0x0
 9b6:	e2e080e7          	jalr	-466(ra) # 7e0 <free>
  for (int i = 0; i < num_threads; i++) {
 9ba:	0485                	addi	s1,s1,1
 9bc:	00092703          	lw	a4,0(s2)
 9c0:	0004879b          	sext.w	a5,s1
 9c4:	fee7c1e3          	blt	a5,a4,9a6 <free_stacks+0x2c>
 9c8:	6942                	ld	s2,16(sp)
 9ca:	69a2                	ld	s3,8(sp)
  free(stacks);
 9cc:	00001497          	auipc	s1,0x1
 9d0:	b9c48493          	addi	s1,s1,-1124 # 1568 <stacks>
 9d4:	6088                	ld	a0,0(s1)
 9d6:	00000097          	auipc	ra,0x0
 9da:	e0a080e7          	jalr	-502(ra) # 7e0 <free>
  stacks = 0;
 9de:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9e2:	00001797          	auipc	a5,0x1
 9e6:	b807a723          	sw	zero,-1138(a5) # 1570 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9ea:	47a1                	li	a5,8
 9ec:	00001717          	auipc	a4,0x1
 9f0:	b6f72223          	sw	a5,-1180(a4) # 1550 <max_stacks>
  threads_done = 0;
 9f4:	00001797          	auipc	a5,0x1
 9f8:	b807a023          	sw	zero,-1152(a5) # 1574 <threads_done>
}
 9fc:	4501                	li	a0,0
 9fe:	70a2                	ld	ra,40(sp)
 a00:	7402                	ld	s0,32(sp)
 a02:	64e2                	ld	s1,24(sp)
 a04:	6145                	addi	sp,sp,48
 a06:	8082                	ret

0000000000000a08 <expand_num_threads>:
int expand_num_threads() {
 a08:	1101                	addi	sp,sp,-32
 a0a:	ec06                	sd	ra,24(sp)
 a0c:	e822                	sd	s0,16(sp)
 a0e:	e426                	sd	s1,8(sp)
 a10:	e04a                	sd	s2,0(sp)
 a12:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a14:	00001797          	auipc	a5,0x1
 a18:	b3c78793          	addi	a5,a5,-1220 # 1550 <max_stacks>
 a1c:	4388                	lw	a0,0(a5)
 a1e:	0015151b          	slliw	a0,a0,0x1
 a22:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a24:	0035151b          	slliw	a0,a0,0x3
 a28:	00000097          	auipc	ra,0x0
 a2c:	e3e080e7          	jalr	-450(ra) # 866 <malloc>
 a30:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a32:	00001617          	auipc	a2,0x1
 a36:	b3e62603          	lw	a2,-1218(a2) # 1570 <num_threads>
 a3a:	00001497          	auipc	s1,0x1
 a3e:	b2e48493          	addi	s1,s1,-1234 # 1568 <stacks>
 a42:	0036161b          	slliw	a2,a2,0x3
 a46:	608c                	ld	a1,0(s1)
 a48:	00000097          	auipc	ra,0x0
 a4c:	8d8080e7          	jalr	-1832(ra) # 320 <memmove>
  free(stacks);
 a50:	6088                	ld	a0,0(s1)
 a52:	00000097          	auipc	ra,0x0
 a56:	d8e080e7          	jalr	-626(ra) # 7e0 <free>
  stacks = new_stacks;
 a5a:	0124b023          	sd	s2,0(s1)
}
 a5e:	4501                	li	a0,0
 a60:	60e2                	ld	ra,24(sp)
 a62:	6442                	ld	s0,16(sp)
 a64:	64a2                	ld	s1,8(sp)
 a66:	6902                	ld	s2,0(sp)
 a68:	6105                	addi	sp,sp,32
 a6a:	8082                	ret

0000000000000a6c <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a6c:	7179                	addi	sp,sp,-48
 a6e:	f406                	sd	ra,40(sp)
 a70:	f022                	sd	s0,32(sp)
 a72:	e84a                	sd	s2,16(sp)
 a74:	e44e                	sd	s3,8(sp)
 a76:	1800                	addi	s0,sp,48
 a78:	892a                	mv	s2,a0
 a7a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a7c:	00001797          	auipc	a5,0x1
 a80:	aec7b783          	ld	a5,-1300(a5) # 1568 <stacks>
 a84:	c3d9                	beqz	a5,b0a <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a86:	00001797          	auipc	a5,0x1
 a8a:	aca7a783          	lw	a5,-1334(a5) # 1550 <max_stacks>
 a8e:	00001717          	auipc	a4,0x1
 a92:	ae272703          	lw	a4,-1310(a4) # 1570 <num_threads>
 a96:	0af71463          	bne	a4,a5,b3e <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a9a:	04000713          	li	a4,64
 a9e:	08e78563          	beq	a5,a4,b28 <ithread_create+0xbc>
 aa2:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 aa4:	00000097          	auipc	ra,0x0
 aa8:	f64080e7          	jalr	-156(ra) # a08 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 aac:	6505                	lui	a0,0x1
 aae:	00000097          	auipc	ra,0x0
 ab2:	db8080e7          	jalr	-584(ra) # 866 <malloc>
 ab6:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 ab8:	00001717          	auipc	a4,0x1
 abc:	ab872703          	lw	a4,-1352(a4) # 1570 <num_threads>
 ac0:	070e                	slli	a4,a4,0x3
 ac2:	00001797          	auipc	a5,0x1
 ac6:	aa67b783          	ld	a5,-1370(a5) # 1568 <stacks>
 aca:	97ba                	add	a5,a5,a4
 acc:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 ace:	00000697          	auipc	a3,0x0
 ad2:	e9268693          	addi	a3,a3,-366 # 960 <ithread_exit>
 ad6:	862a                	mv	a2,a0
 ad8:	85ce                	mv	a1,s3
 ada:	854a                	mv	a0,s2
 adc:	00000097          	auipc	ra,0x0
 ae0:	9a2080e7          	jalr	-1630(ra) # 47e <create_thread>
 ae4:	892a                	mv	s2,a0
  if (res != -1) {
 ae6:	57fd                	li	a5,-1
 ae8:	04f50d63          	beq	a0,a5,b42 <ithread_create+0xd6>
    num_threads++;
 aec:	00001717          	auipc	a4,0x1
 af0:	a8470713          	addi	a4,a4,-1404 # 1570 <num_threads>
 af4:	431c                	lw	a5,0(a4)
 af6:	2785                	addiw	a5,a5,1
 af8:	c31c                	sw	a5,0(a4)
 afa:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 afc:	854a                	mv	a0,s2
 afe:	70a2                	ld	ra,40(sp)
 b00:	7402                	ld	s0,32(sp)
 b02:	6942                	ld	s2,16(sp)
 b04:	69a2                	ld	s3,8(sp)
 b06:	6145                	addi	sp,sp,48
 b08:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b0a:	00001517          	auipc	a0,0x1
 b0e:	a4652503          	lw	a0,-1466(a0) # 1550 <max_stacks>
 b12:	0035151b          	slliw	a0,a0,0x3
 b16:	00000097          	auipc	ra,0x0
 b1a:	d50080e7          	jalr	-688(ra) # 866 <malloc>
 b1e:	00001797          	auipc	a5,0x1
 b22:	a4a7b523          	sd	a0,-1462(a5) # 1568 <stacks>
 b26:	b785                	j	a86 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b28:	00000517          	auipc	a0,0x0
 b2c:	0d850513          	addi	a0,a0,216 # c00 <ithread_join+0x98>
 b30:	00000097          	auipc	ra,0x0
 b34:	c7a080e7          	jalr	-902(ra) # 7aa <printf>
      return -1;
 b38:	57fd                	li	a5,-1
 b3a:	893e                	mv	s2,a5
 b3c:	b7c1                	j	afc <ithread_create+0x90>
 b3e:	ec26                	sd	s1,24(sp)
 b40:	b7b5                	j	aac <ithread_create+0x40>
    free(stack_ptr);
 b42:	8526                	mv	a0,s1
 b44:	00000097          	auipc	ra,0x0
 b48:	c9c080e7          	jalr	-868(ra) # 7e0 <free>
    stacks[num_threads] = 0;
 b4c:	00001717          	auipc	a4,0x1
 b50:	a2472703          	lw	a4,-1500(a4) # 1570 <num_threads>
 b54:	070e                	slli	a4,a4,0x3
 b56:	00001797          	auipc	a5,0x1
 b5a:	a127b783          	ld	a5,-1518(a5) # 1568 <stacks>
 b5e:	97ba                	add	a5,a5,a4
 b60:	0007b023          	sd	zero,0(a5)
 b64:	64e2                	ld	s1,24(sp)
 b66:	bf59                	j	afc <ithread_create+0x90>

0000000000000b68 <ithread_join>:

int ithread_join(int thread_id) {
 b68:	1101                	addi	sp,sp,-32
 b6a:	ec06                	sd	ra,24(sp)
 b6c:	e822                	sd	s0,16(sp)
 b6e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b70:	ff040793          	addi	a5,s0,-16
 b74:	ffc7859b          	addiw	a1,a5,-4
 b78:	00000097          	auipc	ra,0x0
 b7c:	90e080e7          	jalr	-1778(ra) # 486 <join_thread>
  threads_done++;
 b80:	00001717          	auipc	a4,0x1
 b84:	9f470713          	addi	a4,a4,-1548 # 1574 <threads_done>
 b88:	431c                	lw	a5,0(a4)
 b8a:	2785                	addiw	a5,a5,1
 b8c:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b8e:	00001717          	auipc	a4,0x1
 b92:	9e272703          	lw	a4,-1566(a4) # 1570 <num_threads>
 b96:	00f70863          	beq	a4,a5,ba6 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b9a:	fec42503          	lw	a0,-20(s0)
 b9e:	60e2                	ld	ra,24(sp)
 ba0:	6442                	ld	s0,16(sp)
 ba2:	6105                	addi	sp,sp,32
 ba4:	8082                	ret
    free_stacks();
 ba6:	00000097          	auipc	ra,0x0
 baa:	dd4080e7          	jalr	-556(ra) # 97a <free_stacks>
 bae:	b7f5                	j	b9a <ithread_join+0x32>
