
src/user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	002d8d93          	addi	s11,s11,2 # 1030 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	bc8a0a13          	addi	s4,s4,-1080 # c00 <ithread_join+0x56>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f8080e7          	jalr	504(ra) # 23e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3b2080e7          	jalr	946(ra) # 42e <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	fa648493          	addi	s1,s1,-90 # 1030 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	b7250513          	addi	a0,a0,-1166 # c18 <ithread_join+0x6e>
  ae:	00000097          	auipc	ra,0x0
  b2:	73e080e7          	jalr	1854(ra) # 7ec <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	b3450513          	addi	a0,a0,-1228 # c08 <ithread_join+0x5e>
  dc:	00000097          	auipc	ra,0x0
  e0:	710080e7          	jalr	1808(ra) # 7ec <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	330080e7          	jalr	816(ra) # 416 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	33a080e7          	jalr	826(ra) # 456 <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	306080e7          	jalr	774(ra) # 43e <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2ce080e7          	jalr	718(ra) # 416 <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	b1a58593          	addi	a1,a1,-1254 # c70 <ithread_join+0xc6>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2ac080e7          	jalr	684(ra) # 416 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	ab250513          	addi	a0,a0,-1358 # c28 <ithread_join+0x7e>
 17e:	00000097          	auipc	ra,0x0
 182:	66e080e7          	jalr	1646(ra) # 7ec <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	28e080e7          	jalr	654(ra) # 416 <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	274080e7          	jalr	628(ra) # 416 <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	addi	a1,a1,1
 1b4:	0785                	addi	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
    ;
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
    p++, q++;
 1da:	0505                	addi	a0,a0,1
 1dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	addi	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	86be                	mv	a3,a5
 204:	0785                	addi	a5,a5,1
 206:	fff7c703          	lbu	a4,-1(a5)
 20a:	ff65                	bnez	a4,202 <strlen+0x10>
 20c:	40a6853b          	subw	a0,a3,a0
 210:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ca19                	beqz	a2,238 <memset+0x1c>
 224:	87aa                	mv	a5,a0
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x12>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  for(; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if(*s == c)
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for(; *s; s++)
 24e:	0505                	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
      return (char*)s;
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	711d                	addi	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	addi	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	2485                	addiw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	addi	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	19a080e7          	jalr	410(ra) # 42e <read>
    if(cc < 1)
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	addi	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
    buf[i++] = c;
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	addi	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e04a                	sd	s2,0(sp)
 2de:	1000                	addi	s0,sp,32
 2e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	4581                	li	a1,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	172080e7          	jalr	370(ra) # 456 <open>
  if(fd < 0)
 2ec:	02054663          	bltz	a0,318 <stat+0x42>
 2f0:	e426                	sd	s1,8(sp)
 2f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	178080e7          	jalr	376(ra) # 46e <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	00000097          	auipc	ra,0x0
 306:	13c080e7          	jalr	316(ra) # 43e <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	597d                	li	s2,-1
 31a:	bfcd                	j	30c <stat+0x36>

000000000000031c <atoi>:

int
atoi(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 322:	00054683          	lbu	a3,0(a0)
 326:	fd06879b          	addiw	a5,a3,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	4625                	li	a2,9
 330:	02f66863          	bltu	a2,a5,360 <atoi+0x44>
 334:	872a                	mv	a4,a0
  n = 0;
 336:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 338:	0705                	addi	a4,a4,1
 33a:	0025179b          	slliw	a5,a0,0x2
 33e:	9fa9                	addw	a5,a5,a0
 340:	0017979b          	slliw	a5,a5,0x1
 344:	9fb5                	addw	a5,a5,a3
 346:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34a:	00074683          	lbu	a3,0(a4)
 34e:	fd06879b          	addiw	a5,a3,-48
 352:	0ff7f793          	zext.b	a5,a5
 356:	fef671e3          	bgeu	a2,a5,338 <atoi+0x1c>
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  n = 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <atoi+0x3e>

0000000000000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36a:	02b57463          	bgeu	a0,a1,392 <memmove+0x2e>
    while(n-- > 0)
 36e:	00c05f63          	blez	a2,38c <memmove+0x28>
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37a:	872a                	mv	a4,a0
      *dst++ = *src++;
 37c:	0585                	addi	a1,a1,1
 37e:	0705                	addi	a4,a4,1
 380:	fff5c683          	lbu	a3,-1(a1)
 384:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 388:	fef71ae3          	bne	a4,a5,37c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
    dst += n;
 392:	00c50733          	add	a4,a0,a2
    src += n;
 396:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 398:	fec05ae3          	blez	a2,38c <memmove+0x28>
 39c:	fff6079b          	addiw	a5,a2,-1
 3a0:	1782                	slli	a5,a5,0x20
 3a2:	9381                	srli	a5,a5,0x20
 3a4:	fff7c793          	not	a5,a5
 3a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3aa:	15fd                	addi	a1,a1,-1
 3ac:	177d                	addi	a4,a4,-1
 3ae:	0005c683          	lbu	a3,0(a1)
 3b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x46>
 3ba:	bfc9                	j	38c <memmove+0x28>

00000000000003bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c2:	ca05                	beqz	a2,3f2 <memcmp+0x36>
 3c4:	fff6069b          	addiw	a3,a2,-1
 3c8:	1682                	slli	a3,a3,0x20
 3ca:	9281                	srli	a3,a3,0x20
 3cc:	0685                	addi	a3,a3,1
 3ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00e79863          	bne	a5,a4,3e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3dc:	0505                	addi	a0,a0,1
    p2++;
 3de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e0:	fed518e3          	bne	a0,a3,3d0 <memcmp+0x14>
  }
  return 0;
 3e4:	4501                	li	a0,0
 3e6:	a019                	j	3ec <memcmp+0x30>
      return *p1 - *p2;
 3e8:	40e7853b          	subw	a0,a5,a4
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <memcmp+0x30>

00000000000003f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fe:	00000097          	auipc	ra,0x0
 402:	f66080e7          	jalr	-154(ra) # 364 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40e:	4885                	li	a7,1
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exit>:
.global exit
exit:
 li a7, SYS_exit
 416:	4889                	li	a7,2
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <wait>:
.global wait
wait:
 li a7, SYS_wait
 41e:	488d                	li	a7,3
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 426:	4891                	li	a7,4
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <read>:
.global read
read:
 li a7, SYS_read
 42e:	4895                	li	a7,5
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <write>:
.global write
write:
 li a7, SYS_write
 436:	48c1                	li	a7,16
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <close>:
.global close
close:
 li a7, SYS_close
 43e:	48d5                	li	a7,21
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <kill>:
.global kill
kill:
 li a7, SYS_kill
 446:	4899                	li	a7,6
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exec>:
.global exec
exec:
 li a7, SYS_exec
 44e:	489d                	li	a7,7
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <open>:
.global open
open:
 li a7, SYS_open
 456:	48bd                	li	a7,15
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45e:	48c5                	li	a7,17
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 466:	48c9                	li	a7,18
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46e:	48a1                	li	a7,8
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <link>:
.global link
link:
 li a7, SYS_link
 476:	48cd                	li	a7,19
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47e:	48d1                	li	a7,20
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 486:	48a5                	li	a7,9
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <dup>:
.global dup
dup:
 li a7, SYS_dup
 48e:	48a9                	li	a7,10
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 496:	48ad                	li	a7,11
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 49e:	48b1                	li	a7,12
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a6:	48b5                	li	a7,13
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ae:	48b9                	li	a7,14
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 4b6:	48d9                	li	a7,22
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 4be:	48dd                	li	a7,23
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4c6:	48e1                	li	a7,24
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4ce:	48e5                	li	a7,25
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4d6:	48e9                	li	a7,26
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <bind>:
.global bind
bind:
 li a7, SYS_bind
 4de:	48ed                	li	a7,27
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4e6:	48f5                	li	a7,29
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <listen>:
.global listen
listen:
 li a7, SYS_listen
 4ee:	48f1                	li	a7,28
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4f6:	48f9                	li	a7,30
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <send>:
.global send
send:
 li a7, SYS_send
 4fe:	48fd                	li	a7,31
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <recv>:
.global recv
recv:
 li a7, SYS_recv
 506:	02000893          	li	a7,32
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 510:	02100893          	li	a7,33
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 51a:	02200893          	li	a7,34
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 524:	1101                	addi	sp,sp,-32
 526:	ec06                	sd	ra,24(sp)
 528:	e822                	sd	s0,16(sp)
 52a:	1000                	addi	s0,sp,32
 52c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 530:	4605                	li	a2,1
 532:	fef40593          	addi	a1,s0,-17
 536:	00000097          	auipc	ra,0x0
 53a:	f00080e7          	jalr	-256(ra) # 436 <write>
}
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	6105                	addi	sp,sp,32
 544:	8082                	ret

0000000000000546 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 546:	7139                	addi	sp,sp,-64
 548:	fc06                	sd	ra,56(sp)
 54a:	f822                	sd	s0,48(sp)
 54c:	f426                	sd	s1,40(sp)
 54e:	0080                	addi	s0,sp,64
 550:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 552:	c299                	beqz	a3,558 <printint+0x12>
 554:	0805cb63          	bltz	a1,5ea <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 558:	2581                	sext.w	a1,a1
  neg = 0;
 55a:	4881                	li	a7,0
 55c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 560:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 562:	2601                	sext.w	a2,a2
 564:	00000517          	auipc	a0,0x0
 568:	76c50513          	addi	a0,a0,1900 # cd0 <digits>
 56c:	883a                	mv	a6,a4
 56e:	2705                	addiw	a4,a4,1
 570:	02c5f7bb          	remuw	a5,a1,a2
 574:	1782                	slli	a5,a5,0x20
 576:	9381                	srli	a5,a5,0x20
 578:	97aa                	add	a5,a5,a0
 57a:	0007c783          	lbu	a5,0(a5)
 57e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 582:	0005879b          	sext.w	a5,a1
 586:	02c5d5bb          	divuw	a1,a1,a2
 58a:	0685                	addi	a3,a3,1
 58c:	fec7f0e3          	bgeu	a5,a2,56c <printint+0x26>
  if(neg)
 590:	00088c63          	beqz	a7,5a8 <printint+0x62>
    buf[i++] = '-';
 594:	fd070793          	addi	a5,a4,-48
 598:	00878733          	add	a4,a5,s0
 59c:	02d00793          	li	a5,45
 5a0:	fef70823          	sb	a5,-16(a4)
 5a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a8:	02e05c63          	blez	a4,5e0 <printint+0x9a>
 5ac:	f04a                	sd	s2,32(sp)
 5ae:	ec4e                	sd	s3,24(sp)
 5b0:	fc040793          	addi	a5,s0,-64
 5b4:	00e78933          	add	s2,a5,a4
 5b8:	fff78993          	addi	s3,a5,-1
 5bc:	99ba                	add	s3,s3,a4
 5be:	377d                	addiw	a4,a4,-1
 5c0:	1702                	slli	a4,a4,0x20
 5c2:	9301                	srli	a4,a4,0x20
 5c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c8:	fff94583          	lbu	a1,-1(s2)
 5cc:	8526                	mv	a0,s1
 5ce:	00000097          	auipc	ra,0x0
 5d2:	f56080e7          	jalr	-170(ra) # 524 <putc>
  while(--i >= 0)
 5d6:	197d                	addi	s2,s2,-1
 5d8:	ff3918e3          	bne	s2,s3,5c8 <printint+0x82>
 5dc:	7902                	ld	s2,32(sp)
 5de:	69e2                	ld	s3,24(sp)
}
 5e0:	70e2                	ld	ra,56(sp)
 5e2:	7442                	ld	s0,48(sp)
 5e4:	74a2                	ld	s1,40(sp)
 5e6:	6121                	addi	sp,sp,64
 5e8:	8082                	ret
    x = -xx;
 5ea:	40b005bb          	negw	a1,a1
    neg = 1;
 5ee:	4885                	li	a7,1
    x = -xx;
 5f0:	b7b5                	j	55c <printint+0x16>

00000000000005f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f2:	715d                	addi	sp,sp,-80
 5f4:	e486                	sd	ra,72(sp)
 5f6:	e0a2                	sd	s0,64(sp)
 5f8:	f84a                	sd	s2,48(sp)
 5fa:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5fc:	0005c903          	lbu	s2,0(a1)
 600:	1a090a63          	beqz	s2,7b4 <vprintf+0x1c2>
 604:	fc26                	sd	s1,56(sp)
 606:	f44e                	sd	s3,40(sp)
 608:	f052                	sd	s4,32(sp)
 60a:	ec56                	sd	s5,24(sp)
 60c:	e85a                	sd	s6,16(sp)
 60e:	e45e                	sd	s7,8(sp)
 610:	8aaa                	mv	s5,a0
 612:	8bb2                	mv	s7,a2
 614:	00158493          	addi	s1,a1,1
  state = 0;
 618:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 61a:	02500a13          	li	s4,37
 61e:	4b55                	li	s6,21
 620:	a839                	j	63e <vprintf+0x4c>
        putc(fd, c);
 622:	85ca                	mv	a1,s2
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	efe080e7          	jalr	-258(ra) # 524 <putc>
 62e:	a019                	j	634 <vprintf+0x42>
    } else if(state == '%'){
 630:	01498d63          	beq	s3,s4,64a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 634:	0485                	addi	s1,s1,1
 636:	fff4c903          	lbu	s2,-1(s1)
 63a:	16090763          	beqz	s2,7a8 <vprintf+0x1b6>
    if(state == 0){
 63e:	fe0999e3          	bnez	s3,630 <vprintf+0x3e>
      if(c == '%'){
 642:	ff4910e3          	bne	s2,s4,622 <vprintf+0x30>
        state = '%';
 646:	89d2                	mv	s3,s4
 648:	b7f5                	j	634 <vprintf+0x42>
      if(c == 'd'){
 64a:	13490463          	beq	s2,s4,772 <vprintf+0x180>
 64e:	f9d9079b          	addiw	a5,s2,-99
 652:	0ff7f793          	zext.b	a5,a5
 656:	12fb6763          	bltu	s6,a5,784 <vprintf+0x192>
 65a:	f9d9079b          	addiw	a5,s2,-99
 65e:	0ff7f713          	zext.b	a4,a5
 662:	12eb6163          	bltu	s6,a4,784 <vprintf+0x192>
 666:	00271793          	slli	a5,a4,0x2
 66a:	00000717          	auipc	a4,0x0
 66e:	60e70713          	addi	a4,a4,1550 # c78 <ithread_join+0xce>
 672:	97ba                	add	a5,a5,a4
 674:	439c                	lw	a5,0(a5)
 676:	97ba                	add	a5,a5,a4
 678:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 67a:	008b8913          	addi	s2,s7,8
 67e:	4685                	li	a3,1
 680:	4629                	li	a2,10
 682:	000ba583          	lw	a1,0(s7)
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	ebe080e7          	jalr	-322(ra) # 546 <printint>
 690:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 692:	4981                	li	s3,0
 694:	b745                	j	634 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	ea2080e7          	jalr	-350(ra) # 546 <printint>
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b751                	j	634 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4641                	li	a2,16
 6ba:	000ba583          	lw	a1,0(s7)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e86080e7          	jalr	-378(ra) # 546 <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b7a5                	j	634 <vprintf+0x42>
 6ce:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d0:	008b8c13          	addi	s8,s7,8
 6d4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d8:	03000593          	li	a1,48
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e46080e7          	jalr	-442(ra) # 524 <putc>
  putc(fd, 'x');
 6e6:	07800593          	li	a1,120
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e38080e7          	jalr	-456(ra) # 524 <putc>
 6f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f6:	00000b97          	auipc	s7,0x0
 6fa:	5dab8b93          	addi	s7,s7,1498 # cd0 <digits>
 6fe:	03c9d793          	srli	a5,s3,0x3c
 702:	97de                	add	a5,a5,s7
 704:	0007c583          	lbu	a1,0(a5)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e1a080e7          	jalr	-486(ra) # 524 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 712:	0992                	slli	s3,s3,0x4
 714:	397d                	addiw	s2,s2,-1
 716:	fe0914e3          	bnez	s2,6fe <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 71a:	8be2                	mv	s7,s8
      state = 0;
 71c:	4981                	li	s3,0
 71e:	6c02                	ld	s8,0(sp)
 720:	bf11                	j	634 <vprintf+0x42>
        s = va_arg(ap, char*);
 722:	008b8993          	addi	s3,s7,8
 726:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 72a:	02090163          	beqz	s2,74c <vprintf+0x15a>
        while(*s != 0){
 72e:	00094583          	lbu	a1,0(s2)
 732:	c9a5                	beqz	a1,7a2 <vprintf+0x1b0>
          putc(fd, *s);
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	dee080e7          	jalr	-530(ra) # 524 <putc>
          s++;
 73e:	0905                	addi	s2,s2,1
        while(*s != 0){
 740:	00094583          	lbu	a1,0(s2)
 744:	f9e5                	bnez	a1,734 <vprintf+0x142>
        s = va_arg(ap, char*);
 746:	8bce                	mv	s7,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	b5ed                	j	634 <vprintf+0x42>
          s = "(null)";
 74c:	00000917          	auipc	s2,0x0
 750:	4f490913          	addi	s2,s2,1268 # c40 <ithread_join+0x96>
        while(*s != 0){
 754:	02800593          	li	a1,40
 758:	bff1                	j	734 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 75a:	008b8913          	addi	s2,s7,8
 75e:	000bc583          	lbu	a1,0(s7)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	dc0080e7          	jalr	-576(ra) # 524 <putc>
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	b5d1                	j	634 <vprintf+0x42>
        putc(fd, c);
 772:	02500593          	li	a1,37
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	dac080e7          	jalr	-596(ra) # 524 <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	bd4d                	j	634 <vprintf+0x42>
        putc(fd, '%');
 784:	02500593          	li	a1,37
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	d9a080e7          	jalr	-614(ra) # 524 <putc>
        putc(fd, c);
 792:	85ca                	mv	a1,s2
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	d8e080e7          	jalr	-626(ra) # 524 <putc>
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bd51                	j	634 <vprintf+0x42>
        s = va_arg(ap, char*);
 7a2:	8bce                	mv	s7,s3
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b579                	j	634 <vprintf+0x42>
 7a8:	74e2                	ld	s1,56(sp)
 7aa:	79a2                	ld	s3,40(sp)
 7ac:	7a02                	ld	s4,32(sp)
 7ae:	6ae2                	ld	s5,24(sp)
 7b0:	6b42                	ld	s6,16(sp)
 7b2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7b4:	60a6                	ld	ra,72(sp)
 7b6:	6406                	ld	s0,64(sp)
 7b8:	7942                	ld	s2,48(sp)
 7ba:	6161                	addi	sp,sp,80
 7bc:	8082                	ret

00000000000007be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7be:	715d                	addi	sp,sp,-80
 7c0:	ec06                	sd	ra,24(sp)
 7c2:	e822                	sd	s0,16(sp)
 7c4:	1000                	addi	s0,sp,32
 7c6:	e010                	sd	a2,0(s0)
 7c8:	e414                	sd	a3,8(s0)
 7ca:	e818                	sd	a4,16(s0)
 7cc:	ec1c                	sd	a5,24(s0)
 7ce:	03043023          	sd	a6,32(s0)
 7d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7da:	8622                	mv	a2,s0
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e16080e7          	jalr	-490(ra) # 5f2 <vprintf>
}
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6161                	addi	sp,sp,80
 7ea:	8082                	ret

00000000000007ec <printf>:

void
printf(const char *fmt, ...)
{
 7ec:	711d                	addi	sp,sp,-96
 7ee:	ec06                	sd	ra,24(sp)
 7f0:	e822                	sd	s0,16(sp)
 7f2:	1000                	addi	s0,sp,32
 7f4:	e40c                	sd	a1,8(s0)
 7f6:	e810                	sd	a2,16(s0)
 7f8:	ec14                	sd	a3,24(s0)
 7fa:	f018                	sd	a4,32(s0)
 7fc:	f41c                	sd	a5,40(s0)
 7fe:	03043823          	sd	a6,48(s0)
 802:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	00840613          	addi	a2,s0,8
 80a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80e:	85aa                	mv	a1,a0
 810:	4505                	li	a0,1
 812:	00000097          	auipc	ra,0x0
 816:	de0080e7          	jalr	-544(ra) # 5f2 <vprintf>
}
 81a:	60e2                	ld	ra,24(sp)
 81c:	6442                	ld	s0,16(sp)
 81e:	6125                	addi	sp,sp,96
 820:	8082                	ret

0000000000000822 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 822:	1141                	addi	sp,sp,-16
 824:	e422                	sd	s0,8(sp)
 826:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 828:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	00000797          	auipc	a5,0x0
 830:	7e47b783          	ld	a5,2020(a5) # 1010 <freep>
 834:	a02d                	j	85e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 836:	4618                	lw	a4,8(a2)
 838:	9f2d                	addw	a4,a4,a1
 83a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	6310                	ld	a2,0(a4)
 842:	a83d                	j	880 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 844:	ff852703          	lw	a4,-8(a0)
 848:	9f31                	addw	a4,a4,a2
 84a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84c:	ff053683          	ld	a3,-16(a0)
 850:	a091                	j	894 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	6398                	ld	a4,0(a5)
 854:	00e7e463          	bltu	a5,a4,85c <free+0x3a>
 858:	00e6ea63          	bltu	a3,a4,86c <free+0x4a>
{
 85c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	fed7fae3          	bgeu	a5,a3,852 <free+0x30>
 862:	6398                	ld	a4,0(a5)
 864:	00e6e463          	bltu	a3,a4,86c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	fee7eae3          	bltu	a5,a4,85c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 86c:	ff852583          	lw	a1,-8(a0)
 870:	6390                	ld	a2,0(a5)
 872:	02059813          	slli	a6,a1,0x20
 876:	01c85713          	srli	a4,a6,0x1c
 87a:	9736                	add	a4,a4,a3
 87c:	fae60de3          	beq	a2,a4,836 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 884:	4790                	lw	a2,8(a5)
 886:	02061593          	slli	a1,a2,0x20
 88a:	01c5d713          	srli	a4,a1,0x1c
 88e:	973e                	add	a4,a4,a5
 890:	fae68ae3          	beq	a3,a4,844 <free+0x22>
    p->s.ptr = bp->s.ptr;
 894:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 896:	00000717          	auipc	a4,0x0
 89a:	76f73d23          	sd	a5,1914(a4) # 1010 <freep>
}
 89e:	6422                	ld	s0,8(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret

00000000000008a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a4:	7139                	addi	sp,sp,-64
 8a6:	fc06                	sd	ra,56(sp)
 8a8:	f822                	sd	s0,48(sp)
 8aa:	f426                	sd	s1,40(sp)
 8ac:	ec4e                	sd	s3,24(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	02051493          	slli	s1,a0,0x20
 8b4:	9081                	srli	s1,s1,0x20
 8b6:	04bd                	addi	s1,s1,15
 8b8:	8091                	srli	s1,s1,0x4
 8ba:	0014899b          	addiw	s3,s1,1
 8be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c0:	00000517          	auipc	a0,0x0
 8c4:	75053503          	ld	a0,1872(a0) # 1010 <freep>
 8c8:	c915                	beqz	a0,8fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8cc:	4798                	lw	a4,8(a5)
 8ce:	08977e63          	bgeu	a4,s1,96a <malloc+0xc6>
 8d2:	f04a                	sd	s2,32(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8da:	8a4e                	mv	s4,s3
 8dc:	0009871b          	sext.w	a4,s3
 8e0:	6685                	lui	a3,0x1
 8e2:	00d77363          	bgeu	a4,a3,8e8 <malloc+0x44>
 8e6:	6a05                	lui	s4,0x1
 8e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f0:	00000917          	auipc	s2,0x0
 8f4:	72090913          	addi	s2,s2,1824 # 1010 <freep>
  if(p == (char*)-1)
 8f8:	5afd                	li	s5,-1
 8fa:	a091                	j	93e <malloc+0x9a>
 8fc:	f04a                	sd	s2,32(sp)
 8fe:	e852                	sd	s4,16(sp)
 900:	e456                	sd	s5,8(sp)
 902:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 904:	00001797          	auipc	a5,0x1
 908:	92c78793          	addi	a5,a5,-1748 # 1230 <base>
 90c:	00000717          	auipc	a4,0x0
 910:	70f73223          	sd	a5,1796(a4) # 1010 <freep>
 914:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 916:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91a:	b7c1                	j	8da <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 91c:	6398                	ld	a4,0(a5)
 91e:	e118                	sd	a4,0(a0)
 920:	a08d                	j	982 <malloc+0xde>
  hp->s.size = nu;
 922:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 926:	0541                	addi	a0,a0,16
 928:	00000097          	auipc	ra,0x0
 92c:	efa080e7          	jalr	-262(ra) # 822 <free>
  return freep;
 930:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 934:	c13d                	beqz	a0,99a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 938:	4798                	lw	a4,8(a5)
 93a:	02977463          	bgeu	a4,s1,962 <malloc+0xbe>
    if(p == freep)
 93e:	00093703          	ld	a4,0(s2)
 942:	853e                	mv	a0,a5
 944:	fef719e3          	bne	a4,a5,936 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 948:	8552                	mv	a0,s4
 94a:	00000097          	auipc	ra,0x0
 94e:	b54080e7          	jalr	-1196(ra) # 49e <sbrk>
  if(p == (char*)-1)
 952:	fd5518e3          	bne	a0,s5,922 <malloc+0x7e>
        return 0;
 956:	4501                	li	a0,0
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	a03d                	j	98e <malloc+0xea>
 962:	7902                	ld	s2,32(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 96a:	fae489e3          	beq	s1,a4,91c <malloc+0x78>
        p->s.size -= nunits;
 96e:	4137073b          	subw	a4,a4,s3
 972:	c798                	sw	a4,8(a5)
        p += p->s.size;
 974:	02071693          	slli	a3,a4,0x20
 978:	01c6d713          	srli	a4,a3,0x1c
 97c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 982:	00000717          	auipc	a4,0x0
 986:	68a73723          	sd	a0,1678(a4) # 1010 <freep>
      return (void*)(p + 1);
 98a:	01078513          	addi	a0,a5,16
  }
}
 98e:	70e2                	ld	ra,56(sp)
 990:	7442                	ld	s0,48(sp)
 992:	74a2                	ld	s1,40(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6121                	addi	sp,sp,64
 998:	8082                	ret
 99a:	7902                	ld	s2,32(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
 9a2:	b7f5                	j	98e <malloc+0xea>

00000000000009a4 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 9a4:	1141                	addi	sp,sp,-16
 9a6:	e406                	sd	ra,8(sp)
 9a8:	e022                	sd	s0,0(sp)
 9aa:	0800                	addi	s0,sp,16
  thread_exit(status);
 9ac:	2501                	sext.w	a0,a0
 9ae:	00000097          	auipc	ra,0x0
 9b2:	b20080e7          	jalr	-1248(ra) # 4ce <thread_exit>
}
 9b6:	60a2                	ld	ra,8(sp)
 9b8:	6402                	ld	s0,0(sp)
 9ba:	0141                	addi	sp,sp,16
 9bc:	8082                	ret

00000000000009be <free_stacks>:
int free_stacks() {
 9be:	7179                	addi	sp,sp,-48
 9c0:	f406                	sd	ra,40(sp)
 9c2:	f022                	sd	s0,32(sp)
 9c4:	ec26                	sd	s1,24(sp)
 9c6:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9c8:	00000797          	auipc	a5,0x0
 9cc:	6587a783          	lw	a5,1624(a5) # 1020 <num_threads>
 9d0:	04f05063          	blez	a5,a10 <free_stacks+0x52>
 9d4:	e84a                	sd	s2,16(sp)
 9d6:	e44e                	sd	s3,8(sp)
 9d8:	4481                	li	s1,0
    free(stacks[i]);
 9da:	00000997          	auipc	s3,0x0
 9de:	63e98993          	addi	s3,s3,1598 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9e2:	00000917          	auipc	s2,0x0
 9e6:	63e90913          	addi	s2,s2,1598 # 1020 <num_threads>
    free(stacks[i]);
 9ea:	0009b783          	ld	a5,0(s3)
 9ee:	00349713          	slli	a4,s1,0x3
 9f2:	97ba                	add	a5,a5,a4
 9f4:	6388                	ld	a0,0(a5)
 9f6:	00000097          	auipc	ra,0x0
 9fa:	e2c080e7          	jalr	-468(ra) # 822 <free>
  for (int i = 0; i < num_threads; i++) {
 9fe:	0485                	addi	s1,s1,1
 a00:	00092703          	lw	a4,0(s2)
 a04:	0004879b          	sext.w	a5,s1
 a08:	fee7c1e3          	blt	a5,a4,9ea <free_stacks+0x2c>
 a0c:	6942                	ld	s2,16(sp)
 a0e:	69a2                	ld	s3,8(sp)
  free(stacks);
 a10:	00000497          	auipc	s1,0x0
 a14:	60848493          	addi	s1,s1,1544 # 1018 <stacks>
 a18:	6088                	ld	a0,0(s1)
 a1a:	00000097          	auipc	ra,0x0
 a1e:	e08080e7          	jalr	-504(ra) # 822 <free>
  stacks = 0;
 a22:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a26:	00000797          	auipc	a5,0x0
 a2a:	5e07ad23          	sw	zero,1530(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a2e:	47a1                	li	a5,8
 a30:	00000717          	auipc	a4,0x0
 a34:	5cf72823          	sw	a5,1488(a4) # 1000 <max_stacks>
  threads_done = 0;
 a38:	00000797          	auipc	a5,0x0
 a3c:	5e07a623          	sw	zero,1516(a5) # 1024 <threads_done>
}
 a40:	4501                	li	a0,0
 a42:	70a2                	ld	ra,40(sp)
 a44:	7402                	ld	s0,32(sp)
 a46:	64e2                	ld	s1,24(sp)
 a48:	6145                	addi	sp,sp,48
 a4a:	8082                	ret

0000000000000a4c <expand_num_threads>:
int expand_num_threads() {
 a4c:	1101                	addi	sp,sp,-32
 a4e:	ec06                	sd	ra,24(sp)
 a50:	e822                	sd	s0,16(sp)
 a52:	e426                	sd	s1,8(sp)
 a54:	e04a                	sd	s2,0(sp)
 a56:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a58:	00000797          	auipc	a5,0x0
 a5c:	5a878793          	addi	a5,a5,1448 # 1000 <max_stacks>
 a60:	4388                	lw	a0,0(a5)
 a62:	0015151b          	slliw	a0,a0,0x1
 a66:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a68:	0035151b          	slliw	a0,a0,0x3
 a6c:	00000097          	auipc	ra,0x0
 a70:	e38080e7          	jalr	-456(ra) # 8a4 <malloc>
 a74:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a76:	00000617          	auipc	a2,0x0
 a7a:	5aa62603          	lw	a2,1450(a2) # 1020 <num_threads>
 a7e:	00000497          	auipc	s1,0x0
 a82:	59a48493          	addi	s1,s1,1434 # 1018 <stacks>
 a86:	0036161b          	slliw	a2,a2,0x3
 a8a:	608c                	ld	a1,0(s1)
 a8c:	00000097          	auipc	ra,0x0
 a90:	8d8080e7          	jalr	-1832(ra) # 364 <memmove>
  free(stacks);
 a94:	6088                	ld	a0,0(s1)
 a96:	00000097          	auipc	ra,0x0
 a9a:	d8c080e7          	jalr	-628(ra) # 822 <free>
  stacks = new_stacks;
 a9e:	0124b023          	sd	s2,0(s1)
}
 aa2:	4501                	li	a0,0
 aa4:	60e2                	ld	ra,24(sp)
 aa6:	6442                	ld	s0,16(sp)
 aa8:	64a2                	ld	s1,8(sp)
 aaa:	6902                	ld	s2,0(sp)
 aac:	6105                	addi	sp,sp,32
 aae:	8082                	ret

0000000000000ab0 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 ab0:	7179                	addi	sp,sp,-48
 ab2:	f406                	sd	ra,40(sp)
 ab4:	f022                	sd	s0,32(sp)
 ab6:	e84a                	sd	s2,16(sp)
 ab8:	e44e                	sd	s3,8(sp)
 aba:	1800                	addi	s0,sp,48
 abc:	892a                	mv	s2,a0
 abe:	89ae                	mv	s3,a1
  if (stacks == 0) {
 ac0:	00000797          	auipc	a5,0x0
 ac4:	5587b783          	ld	a5,1368(a5) # 1018 <stacks>
 ac8:	c3d9                	beqz	a5,b4e <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 aca:	00000797          	auipc	a5,0x0
 ace:	5367a783          	lw	a5,1334(a5) # 1000 <max_stacks>
 ad2:	00000717          	auipc	a4,0x0
 ad6:	54e72703          	lw	a4,1358(a4) # 1020 <num_threads>
 ada:	0af71363          	bne	a4,a5,b80 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 ade:	04000713          	li	a4,64
 ae2:	08e78563          	beq	a5,a4,b6c <ithread_create+0xbc>
 ae6:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 ae8:	00000097          	auipc	ra,0x0
 aec:	f64080e7          	jalr	-156(ra) # a4c <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 af0:	6505                	lui	a0,0x1
 af2:	00000097          	auipc	ra,0x0
 af6:	db2080e7          	jalr	-590(ra) # 8a4 <malloc>
 afa:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 afc:	00000717          	auipc	a4,0x0
 b00:	52472703          	lw	a4,1316(a4) # 1020 <num_threads>
 b04:	070e                	slli	a4,a4,0x3
 b06:	00000797          	auipc	a5,0x0
 b0a:	5127b783          	ld	a5,1298(a5) # 1018 <stacks>
 b0e:	97ba                	add	a5,a5,a4
 b10:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b12:	00000697          	auipc	a3,0x0
 b16:	e9268693          	addi	a3,a3,-366 # 9a4 <ithread_exit>
 b1a:	862a                	mv	a2,a0
 b1c:	85ce                	mv	a1,s3
 b1e:	854a                	mv	a0,s2
 b20:	00000097          	auipc	ra,0x0
 b24:	99e080e7          	jalr	-1634(ra) # 4be <create_thread>
 b28:	892a                	mv	s2,a0
  if (res != -1) {
 b2a:	57fd                	li	a5,-1
 b2c:	04f50c63          	beq	a0,a5,b84 <ithread_create+0xd4>
    num_threads++;
 b30:	00000717          	auipc	a4,0x0
 b34:	4f070713          	addi	a4,a4,1264 # 1020 <num_threads>
 b38:	431c                	lw	a5,0(a4)
 b3a:	2785                	addiw	a5,a5,1
 b3c:	c31c                	sw	a5,0(a4)
 b3e:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b40:	854a                	mv	a0,s2
 b42:	70a2                	ld	ra,40(sp)
 b44:	7402                	ld	s0,32(sp)
 b46:	6942                	ld	s2,16(sp)
 b48:	69a2                	ld	s3,8(sp)
 b4a:	6145                	addi	sp,sp,48
 b4c:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b4e:	00000517          	auipc	a0,0x0
 b52:	4b252503          	lw	a0,1202(a0) # 1000 <max_stacks>
 b56:	0035151b          	slliw	a0,a0,0x3
 b5a:	00000097          	auipc	ra,0x0
 b5e:	d4a080e7          	jalr	-694(ra) # 8a4 <malloc>
 b62:	00000797          	auipc	a5,0x0
 b66:	4aa7bb23          	sd	a0,1206(a5) # 1018 <stacks>
 b6a:	b785                	j	aca <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b6c:	00000517          	auipc	a0,0x0
 b70:	0dc50513          	addi	a0,a0,220 # c48 <ithread_join+0x9e>
 b74:	00000097          	auipc	ra,0x0
 b78:	c78080e7          	jalr	-904(ra) # 7ec <printf>
      return -1;
 b7c:	597d                	li	s2,-1
 b7e:	b7c9                	j	b40 <ithread_create+0x90>
 b80:	ec26                	sd	s1,24(sp)
 b82:	b7bd                	j	af0 <ithread_create+0x40>
    free(stack_ptr);
 b84:	8526                	mv	a0,s1
 b86:	00000097          	auipc	ra,0x0
 b8a:	c9c080e7          	jalr	-868(ra) # 822 <free>
    stacks[num_threads] = 0;
 b8e:	00000717          	auipc	a4,0x0
 b92:	49272703          	lw	a4,1170(a4) # 1020 <num_threads>
 b96:	070e                	slli	a4,a4,0x3
 b98:	00000797          	auipc	a5,0x0
 b9c:	4807b783          	ld	a5,1152(a5) # 1018 <stacks>
 ba0:	97ba                	add	a5,a5,a4
 ba2:	0007b023          	sd	zero,0(a5)
 ba6:	64e2                	ld	s1,24(sp)
 ba8:	bf61                	j	b40 <ithread_create+0x90>

0000000000000baa <ithread_join>:

int ithread_join(int thread_id) {
 baa:	1101                	addi	sp,sp,-32
 bac:	ec06                	sd	ra,24(sp)
 bae:	e822                	sd	s0,16(sp)
 bb0:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 bb2:	ff040793          	addi	a5,s0,-16
 bb6:	ffc7859b          	addiw	a1,a5,-4
 bba:	00000097          	auipc	ra,0x0
 bbe:	90c080e7          	jalr	-1780(ra) # 4c6 <join_thread>
  threads_done++;
 bc2:	00000717          	auipc	a4,0x0
 bc6:	46270713          	addi	a4,a4,1122 # 1024 <threads_done>
 bca:	431c                	lw	a5,0(a4)
 bcc:	2785                	addiw	a5,a5,1
 bce:	0007869b          	sext.w	a3,a5
 bd2:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bd4:	00000797          	auipc	a5,0x0
 bd8:	44c7a783          	lw	a5,1100(a5) # 1020 <num_threads>
 bdc:	00d78863          	beq	a5,a3,bec <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 be0:	fec42503          	lw	a0,-20(s0)
 be4:	60e2                	ld	ra,24(sp)
 be6:	6442                	ld	s0,16(sp)
 be8:	6105                	addi	sp,sp,32
 bea:	8082                	ret
    free_stacks();
 bec:	00000097          	auipc	ra,0x0
 bf0:	dd2080e7          	jalr	-558(ra) # 9be <free_stacks>
 bf4:	b7f5                	j	be0 <ithread_join+0x36>
