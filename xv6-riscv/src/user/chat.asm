
src/user/_chat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <recv_loop>:
// Must be < MAX_PORT_BINDINGS (512).
#define CHAT_PORT 400
#define BUF_SIZE  256

void *recv_loop(void *arg)
{
   0:	7129                	addi	sp,sp,-320
   2:	fe06                	sd	ra,312(sp)
   4:	fa22                	sd	s0,304(sp)
   6:	f626                	sd	s1,296(sp)
   8:	f24a                	sd	s2,288(sp)
   a:	0280                	addi	s0,sp,320
  int sockfd = *(int *)arg;
   c:	4104                	lw	s1,0(a0)
  char buf[BUF_SIZE];
  struct sockaddr_in from;
  int fromlen = sizeof(from);
   e:	47c1                	li	a5,16
  10:	ecf42623          	sw	a5,-308(s0)
  while (1) {
    int n = recvfrom(sockfd, buf, BUF_SIZE - 1, 0,
                     (struct sockaddr *)&from, (socklen_t *)&fromlen);
    if (n > 0) {
      buf[n] = '\0';
      printf("peer> %s\n", buf);
  14:	00001917          	auipc	s2,0x1
  18:	d7c90913          	addi	s2,s2,-644 # d90 <ithread_join+0x56>
  1c:	a03d                	j	4a <recv_loop+0x4a>
      buf[n] = '\0';
  1e:	fe050793          	addi	a5,a0,-32
  22:	00878533          	add	a0,a5,s0
  26:	f0050023          	sb	zero,-256(a0)
      printf("peer> %s\n", buf);
  2a:	ee040593          	addi	a1,s0,-288
  2e:	854a                	mv	a0,s2
  30:	00001097          	auipc	ra,0x1
  34:	94c080e7          	jalr	-1716(ra) # 97c <printf>
    }
    memset(buf, 0, BUF_SIZE);
  38:	10000613          	li	a2,256
  3c:	4581                	li	a1,0
  3e:	ee040513          	addi	a0,s0,-288
  42:	00000097          	auipc	ra,0x0
  46:	25e080e7          	jalr	606(ra) # 2a0 <memset>
    int n = recvfrom(sockfd, buf, BUF_SIZE - 1, 0,
  4a:	ecc40793          	addi	a5,s0,-308
  4e:	ed040713          	addi	a4,s0,-304
  52:	4681                	li	a3,0
  54:	0ff00613          	li	a2,255
  58:	ee040593          	addi	a1,s0,-288
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	64c080e7          	jalr	1612(ra) # 6aa <recvfrom>
    if (n > 0) {
  66:	faa04ce3          	bgtz	a0,1e <recv_loop+0x1e>
  6a:	b7f9                	j	38 <recv_loop+0x38>

000000000000006c <main>:
  }
  return 0;
}

int main(int argc, char **argv)
{
  6c:	714d                	addi	sp,sp,-336
  6e:	e686                	sd	ra,328(sp)
  70:	e2a2                	sd	s0,320(sp)
  72:	0a80                	addi	s0,sp,336
  if (argc != 2) {
  74:	4789                	li	a5,2
  76:	02f50163          	beq	a0,a5,98 <main+0x2c>
  7a:	fe26                	sd	s1,312(sp)
  7c:	fa4a                	sd	s2,304(sp)
    printf("usage: chat <peer_ip>\n");
  7e:	00001517          	auipc	a0,0x1
  82:	d2250513          	addi	a0,a0,-734 # da0 <ithread_join+0x66>
  86:	00001097          	auipc	ra,0x1
  8a:	8f6080e7          	jalr	-1802(ra) # 97c <printf>
    exit(1);
  8e:	4505                	li	a0,1
  90:	00000097          	auipc	ra,0x0
  94:	516080e7          	jalr	1302(ra) # 5a6 <exit>
  98:	fe26                	sd	s1,312(sp)
  9a:	fa4a                	sd	s2,304(sp)
  9c:	84ae                	mv	s1,a1
  }

  uint peer_ip = inet_addr(argv[1]);
  9e:	6588                	ld	a0,8(a1)
  a0:	00000097          	auipc	ra,0x0
  a4:	466080e7          	jalr	1126(ra) # 506 <inet_addr>
  a8:	0005091b          	sext.w	s2,a0
  if (peer_ip == 0) {
  ac:	02091063          	bnez	s2,cc <main+0x60>
    printf("invalid ip: %s\n", argv[1]);
  b0:	648c                	ld	a1,8(s1)
  b2:	00001517          	auipc	a0,0x1
  b6:	d0650513          	addi	a0,a0,-762 # db8 <ithread_join+0x7e>
  ba:	00001097          	auipc	ra,0x1
  be:	8c2080e7          	jalr	-1854(ra) # 97c <printf>
    exit(1);
  c2:	4505                	li	a0,1
  c4:	00000097          	auipc	ra,0x0
  c8:	4e2080e7          	jalr	1250(ra) # 5a6 <exit>
  }

  int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  cc:	4601                	li	a2,0
  ce:	4589                	li	a1,2
  d0:	4509                	li	a0,2
  d2:	00000097          	auipc	ra,0x0
  d6:	594080e7          	jalr	1428(ra) # 666 <socket>
  da:	fca42e23          	sw	a0,-36(s0)
  if (sockfd < 0) {
  de:	04054c63          	bltz	a0,136 <main+0xca>
    exit(1);
  }

  // Bind to CHAT_PORT on all local interfaces.
  struct sockaddr_in local;
  memset(&local, 0, sizeof(local));
  e2:	4641                	li	a2,16
  e4:	4581                	li	a1,0
  e6:	fc840513          	addi	a0,s0,-56
  ea:	00000097          	auipc	ra,0x0
  ee:	1b6080e7          	jalr	438(ra) # 2a0 <memset>
  local.sin_family = AF_INET;
  f2:	4789                	li	a5,2
  f4:	fcf41423          	sh	a5,-56(s0)
  local.sin_port = htons(CHAT_PORT);
  f8:	77e5                	lui	a5,0xffff9
  fa:	0785                	addi	a5,a5,1 # ffffffffffff9001 <base+0xffffffffffff7fd1>
  fc:	fcf41523          	sh	a5,-54(s0)
  local.sin_addr.s_addr = INADDR_ANY;
 100:	4785                	li	a5,1
 102:	fcf42623          	sw	a5,-52(s0)

  if (bind(sockfd, (struct sockaddr *)&local, sizeof(local)) < 0) {
 106:	4641                	li	a2,16
 108:	fc840593          	addi	a1,s0,-56
 10c:	fdc42503          	lw	a0,-36(s0)
 110:	00000097          	auipc	ra,0x0
 114:	55e080e7          	jalr	1374(ra) # 66e <bind>
 118:	02055c63          	bgez	a0,150 <main+0xe4>
    printf("bind failed\n");
 11c:	00001517          	auipc	a0,0x1
 120:	cbc50513          	addi	a0,a0,-836 # dd8 <ithread_join+0x9e>
 124:	00001097          	auipc	ra,0x1
 128:	858080e7          	jalr	-1960(ra) # 97c <printf>
    exit(1);
 12c:	4505                	li	a0,1
 12e:	00000097          	auipc	ra,0x0
 132:	478080e7          	jalr	1144(ra) # 5a6 <exit>
    printf("socket failed\n");
 136:	00001517          	auipc	a0,0x1
 13a:	c9250513          	addi	a0,a0,-878 # dc8 <ithread_join+0x8e>
 13e:	00001097          	auipc	ra,0x1
 142:	83e080e7          	jalr	-1986(ra) # 97c <printf>
    exit(1);
 146:	4505                	li	a0,1
 148:	00000097          	auipc	ra,0x0
 14c:	45e080e7          	jalr	1118(ra) # 5a6 <exit>
  }

  // Spawn receiver thread.
  ithread_create(recv_loop, &sockfd);
 150:	fdc40593          	addi	a1,s0,-36
 154:	00000517          	auipc	a0,0x0
 158:	eac50513          	addi	a0,a0,-340 # 0 <recv_loop>
 15c:	00001097          	auipc	ra,0x1
 160:	ae4080e7          	jalr	-1308(ra) # c40 <ithread_create>

  // Peer address — inet_addr returns host byte order, htonl converts to
  // the network byte order that sin_addr.s_addr expects.
  struct sockaddr_in peer;
  memset(&peer, 0, sizeof(peer));
 164:	4641                	li	a2,16
 166:	4581                	li	a1,0
 168:	fb840513          	addi	a0,s0,-72
 16c:	00000097          	auipc	ra,0x0
 170:	134080e7          	jalr	308(ra) # 2a0 <memset>
  peer.sin_family = AF_INET;
 174:	4789                	li	a5,2
 176:	faf41c23          	sh	a5,-72(s0)
  peer.sin_port = htons(CHAT_PORT);
 17a:	77e5                	lui	a5,0xffff9
 17c:	0785                	addi	a5,a5,1 # ffffffffffff9001 <base+0xffffffffffff7fd1>
 17e:	faf41d23          	sh	a5,-70(s0)
    ((netlong & 0xFF000000U) >> 24);
}

static inline uint32 
htonl(uint32 hostlong) {
    return ((hostlong & 0x000000FFU) << 24) |
 182:	0189179b          	slliw	a5,s2,0x18
           ((hostlong & 0x0000FF00U) << 8)  |
           ((hostlong & 0x00FF0000U) >> 8)  |
           ((hostlong & 0xFF000000U) >> 24);
 186:	0189571b          	srliw	a4,s2,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
 18a:	8fd9                	or	a5,a5,a4
           ((hostlong & 0x0000FF00U) << 8)  |
 18c:	0089171b          	slliw	a4,s2,0x8
 190:	00ff06b7          	lui	a3,0xff0
 194:	8f75                	and	a4,a4,a3
           ((hostlong & 0x00FF0000U) >> 8)  |
 196:	8f5d                	or	a4,a4,a5
 198:	0089579b          	srliw	a5,s2,0x8
 19c:	66c1                	lui	a3,0x10
 19e:	f0068693          	addi	a3,a3,-256 # ff00 <base+0xeed0>
 1a2:	8ff5                	and	a5,a5,a3
 1a4:	8fd9                	or	a5,a5,a4
  peer.sin_addr.s_addr = htonl(peer_ip);
 1a6:	faf42e23          	sw	a5,-68(s0)

  printf("chat ready — type a message and press enter\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	c3e50513          	addi	a0,a0,-962 # de8 <ithread_join+0xae>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	7ca080e7          	jalr	1994(ra) # 97c <printf>
  printf("(peer: %s, port %d)\n", argv[1], CHAT_PORT);
 1ba:	19000613          	li	a2,400
 1be:	648c                	ld	a1,8(s1)
 1c0:	00001517          	auipc	a0,0x1
 1c4:	c5850513          	addi	a0,a0,-936 # e18 <ithread_join+0xde>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	7b4080e7          	jalr	1972(ra) # 97c <printf>
    int len = fgetstdin(buf, BUF_SIZE);
    if (len == 0)
      continue;
    if (sendto(sockfd, buf, len, 0,
               (struct sockaddr *)&peer, sizeof(peer)) < 0) {
      printf("sendto failed\n");
 1d0:	00001497          	auipc	s1,0x1
 1d4:	c6048493          	addi	s1,s1,-928 # e30 <ithread_join+0xf6>
    int len = fgetstdin(buf, BUF_SIZE);
 1d8:	10000593          	li	a1,256
 1dc:	eb840513          	addi	a0,s0,-328
 1e0:	00000097          	auipc	ra,0x0
 1e4:	17a080e7          	jalr	378(ra) # 35a <fgetstdin>
    if (len == 0)
 1e8:	d965                	beqz	a0,1d8 <main+0x16c>
    if (sendto(sockfd, buf, len, 0,
 1ea:	47c1                	li	a5,16
 1ec:	fb840713          	addi	a4,s0,-72
 1f0:	4681                	li	a3,0
 1f2:	862a                	mv	a2,a0
 1f4:	eb840593          	addi	a1,s0,-328
 1f8:	fdc42503          	lw	a0,-36(s0)
 1fc:	00000097          	auipc	ra,0x0
 200:	4a4080e7          	jalr	1188(ra) # 6a0 <sendto>
 204:	fc055ae3          	bgez	a0,1d8 <main+0x16c>
      printf("sendto failed\n");
 208:	8526                	mv	a0,s1
 20a:	00000097          	auipc	ra,0x0
 20e:	772080e7          	jalr	1906(ra) # 97c <printf>
 212:	b7d9                	j	1d8 <main+0x16c>

0000000000000214 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 214:	1141                	addi	sp,sp,-16
 216:	e406                	sd	ra,8(sp)
 218:	e022                	sd	s0,0(sp)
 21a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 21c:	00000097          	auipc	ra,0x0
 220:	e50080e7          	jalr	-432(ra) # 6c <main>
  exit(0);
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	380080e7          	jalr	896(ra) # 5a6 <exit>

000000000000022e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 234:	87aa                	mv	a5,a0
 236:	0585                	addi	a1,a1,1
 238:	0785                	addi	a5,a5,1
 23a:	fff5c703          	lbu	a4,-1(a1)
 23e:	fee78fa3          	sb	a4,-1(a5)
 242:	fb75                	bnez	a4,236 <strcpy+0x8>
    ;
  return os;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 250:	00054783          	lbu	a5,0(a0)
 254:	cb91                	beqz	a5,268 <strcmp+0x1e>
 256:	0005c703          	lbu	a4,0(a1)
 25a:	00f71763          	bne	a4,a5,268 <strcmp+0x1e>
    p++, q++;
 25e:	0505                	addi	a0,a0,1
 260:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 262:	00054783          	lbu	a5,0(a0)
 266:	fbe5                	bnez	a5,256 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 268:	0005c503          	lbu	a0,0(a1)
}
 26c:	40a7853b          	subw	a0,a5,a0
 270:	6422                	ld	s0,8(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret

0000000000000276 <strlen>:

uint
strlen(const char *s)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 27c:	00054783          	lbu	a5,0(a0)
 280:	cf91                	beqz	a5,29c <strlen+0x26>
 282:	0505                	addi	a0,a0,1
 284:	87aa                	mv	a5,a0
 286:	86be                	mv	a3,a5
 288:	0785                	addi	a5,a5,1
 28a:	fff7c703          	lbu	a4,-1(a5)
 28e:	ff65                	bnez	a4,286 <strlen+0x10>
 290:	40a6853b          	subw	a0,a3,a0
 294:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  for(n = 0; s[n]; n++)
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <strlen+0x20>

00000000000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2a6:	ca19                	beqz	a2,2bc <memset+0x1c>
 2a8:	87aa                	mv	a5,a0
 2aa:	1602                	slli	a2,a2,0x20
 2ac:	9201                	srli	a2,a2,0x20
 2ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2b6:	0785                	addi	a5,a5,1
 2b8:	fee79de3          	bne	a5,a4,2b2 <memset+0x12>
  }
  return dst;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strchr>:

char*
strchr(const char *s, char c)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cb99                	beqz	a5,2e2 <strchr+0x20>
    if(*s == c)
 2ce:	00f58763          	beq	a1,a5,2dc <strchr+0x1a>
  for(; *s; s++)
 2d2:	0505                	addi	a0,a0,1
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	fbfd                	bnez	a5,2ce <strchr+0xc>
      return (char*)s;
  return 0;
 2da:	4501                	li	a0,0
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	bfe5                	j	2dc <strchr+0x1a>

00000000000002e6 <gets>:

char*
gets(char *buf, int max)
{
 2e6:	711d                	addi	sp,sp,-96
 2e8:	ec86                	sd	ra,88(sp)
 2ea:	e8a2                	sd	s0,80(sp)
 2ec:	e4a6                	sd	s1,72(sp)
 2ee:	e0ca                	sd	s2,64(sp)
 2f0:	fc4e                	sd	s3,56(sp)
 2f2:	f852                	sd	s4,48(sp)
 2f4:	f456                	sd	s5,40(sp)
 2f6:	f05a                	sd	s6,32(sp)
 2f8:	ec5e                	sd	s7,24(sp)
 2fa:	1080                	addi	s0,sp,96
 2fc:	8baa                	mv	s7,a0
 2fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 300:	892a                	mv	s2,a0
 302:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 304:	4aa9                	li	s5,10
 306:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 308:	89a6                	mv	s3,s1
 30a:	2485                	addiw	s1,s1,1
 30c:	0344d863          	bge	s1,s4,33c <gets+0x56>
    cc = read(0, &c, 1);
 310:	4605                	li	a2,1
 312:	faf40593          	addi	a1,s0,-81
 316:	4501                	li	a0,0
 318:	00000097          	auipc	ra,0x0
 31c:	2a6080e7          	jalr	678(ra) # 5be <read>
    if(cc < 1)
 320:	00a05e63          	blez	a0,33c <gets+0x56>
    buf[i++] = c;
 324:	faf44783          	lbu	a5,-81(s0)
 328:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 32c:	01578763          	beq	a5,s5,33a <gets+0x54>
 330:	0905                	addi	s2,s2,1
 332:	fd679be3          	bne	a5,s6,308 <gets+0x22>
    buf[i++] = c;
 336:	89a6                	mv	s3,s1
 338:	a011                	j	33c <gets+0x56>
 33a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 33c:	99de                	add	s3,s3,s7
 33e:	00098023          	sb	zero,0(s3)
  return buf;
}
 342:	855e                	mv	a0,s7
 344:	60e6                	ld	ra,88(sp)
 346:	6446                	ld	s0,80(sp)
 348:	64a6                	ld	s1,72(sp)
 34a:	6906                	ld	s2,64(sp)
 34c:	79e2                	ld	s3,56(sp)
 34e:	7a42                	ld	s4,48(sp)
 350:	7aa2                	ld	s5,40(sp)
 352:	7b02                	ld	s6,32(sp)
 354:	6be2                	ld	s7,24(sp)
 356:	6125                	addi	sp,sp,96
 358:	8082                	ret

000000000000035a <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 35a:	711d                	addi	sp,sp,-96
 35c:	ec86                	sd	ra,88(sp)
 35e:	e8a2                	sd	s0,80(sp)
 360:	e4a6                	sd	s1,72(sp)
 362:	e0ca                	sd	s2,64(sp)
 364:	fc4e                	sd	s3,56(sp)
 366:	f852                	sd	s4,48(sp)
 368:	f456                	sd	s5,40(sp)
 36a:	f05a                	sd	s6,32(sp)
 36c:	ec5e                	sd	s7,24(sp)
 36e:	1080                	addi	s0,sp,96
 370:	8baa                	mv	s7,a0
 372:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 374:	892a                	mv	s2,a0
 376:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 378:	4aa9                	li	s5,10
 37a:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 37c:	8a26                	mv	s4,s1
 37e:	2485                	addiw	s1,s1,1
 380:	0334d863          	bge	s1,s3,3b0 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 384:	4605                	li	a2,1
 386:	faf40593          	addi	a1,s0,-81
 38a:	4501                	li	a0,0
 38c:	00000097          	auipc	ra,0x0
 390:	232080e7          	jalr	562(ra) # 5be <read>
    if(cc < 1)
 394:	00a05e63          	blez	a0,3b0 <fgetstdin+0x56>
    buf[i++] = c;
 398:	faf44783          	lbu	a5,-81(s0)
 39c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a0:	01578763          	beq	a5,s5,3ae <fgetstdin+0x54>
 3a4:	0905                	addi	s2,s2,1
 3a6:	fd679be3          	bne	a5,s6,37c <fgetstdin+0x22>
    buf[i++] = c;
 3aa:	8a26                	mv	s4,s1
 3ac:	a011                	j	3b0 <fgetstdin+0x56>
 3ae:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 3b0:	9bd2                	add	s7,s7,s4
 3b2:	000b8023          	sb	zero,0(s7)
  return i;
}
 3b6:	8552                	mv	a0,s4
 3b8:	60e6                	ld	ra,88(sp)
 3ba:	6446                	ld	s0,80(sp)
 3bc:	64a6                	ld	s1,72(sp)
 3be:	6906                	ld	s2,64(sp)
 3c0:	79e2                	ld	s3,56(sp)
 3c2:	7a42                	ld	s4,48(sp)
 3c4:	7aa2                	ld	s5,40(sp)
 3c6:	7b02                	ld	s6,32(sp)
 3c8:	6be2                	ld	s7,24(sp)
 3ca:	6125                	addi	sp,sp,96
 3cc:	8082                	ret

00000000000003ce <stat>:

int
stat(const char *n, struct stat *st)
{
 3ce:	1101                	addi	sp,sp,-32
 3d0:	ec06                	sd	ra,24(sp)
 3d2:	e822                	sd	s0,16(sp)
 3d4:	e04a                	sd	s2,0(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3da:	4581                	li	a1,0
 3dc:	00000097          	auipc	ra,0x0
 3e0:	20a080e7          	jalr	522(ra) # 5e6 <open>
  if(fd < 0)
 3e4:	02054663          	bltz	a0,410 <stat+0x42>
 3e8:	e426                	sd	s1,8(sp)
 3ea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ec:	85ca                	mv	a1,s2
 3ee:	00000097          	auipc	ra,0x0
 3f2:	210080e7          	jalr	528(ra) # 5fe <fstat>
 3f6:	892a                	mv	s2,a0
  close(fd);
 3f8:	8526                	mv	a0,s1
 3fa:	00000097          	auipc	ra,0x0
 3fe:	1d4080e7          	jalr	468(ra) # 5ce <close>
  return r;
 402:	64a2                	ld	s1,8(sp)
}
 404:	854a                	mv	a0,s2
 406:	60e2                	ld	ra,24(sp)
 408:	6442                	ld	s0,16(sp)
 40a:	6902                	ld	s2,0(sp)
 40c:	6105                	addi	sp,sp,32
 40e:	8082                	ret
    return -1;
 410:	597d                	li	s2,-1
 412:	bfcd                	j	404 <stat+0x36>

0000000000000414 <atoi>:

int
atoi(const char *s)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41a:	00054683          	lbu	a3,0(a0)
 41e:	fd06879b          	addiw	a5,a3,-48
 422:	0ff7f793          	zext.b	a5,a5
 426:	4625                	li	a2,9
 428:	02f66863          	bltu	a2,a5,458 <atoi+0x44>
 42c:	872a                	mv	a4,a0
  n = 0;
 42e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 430:	0705                	addi	a4,a4,1
 432:	0025179b          	slliw	a5,a0,0x2
 436:	9fa9                	addw	a5,a5,a0
 438:	0017979b          	slliw	a5,a5,0x1
 43c:	9fb5                	addw	a5,a5,a3
 43e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 442:	00074683          	lbu	a3,0(a4)
 446:	fd06879b          	addiw	a5,a3,-48
 44a:	0ff7f793          	zext.b	a5,a5
 44e:	fef671e3          	bgeu	a2,a5,430 <atoi+0x1c>
  return n;
}
 452:	6422                	ld	s0,8(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret
  n = 0;
 458:	4501                	li	a0,0
 45a:	bfe5                	j	452 <atoi+0x3e>

000000000000045c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e422                	sd	s0,8(sp)
 460:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 462:	02b57463          	bgeu	a0,a1,48a <memmove+0x2e>
    while(n-- > 0)
 466:	00c05f63          	blez	a2,484 <memmove+0x28>
 46a:	1602                	slli	a2,a2,0x20
 46c:	9201                	srli	a2,a2,0x20
 46e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 472:	872a                	mv	a4,a0
      *dst++ = *src++;
 474:	0585                	addi	a1,a1,1
 476:	0705                	addi	a4,a4,1
 478:	fff5c683          	lbu	a3,-1(a1)
 47c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 480:	fef71ae3          	bne	a4,a5,474 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
    dst += n;
 48a:	00c50733          	add	a4,a0,a2
    src += n;
 48e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 490:	fec05ae3          	blez	a2,484 <memmove+0x28>
 494:	fff6079b          	addiw	a5,a2,-1
 498:	1782                	slli	a5,a5,0x20
 49a:	9381                	srli	a5,a5,0x20
 49c:	fff7c793          	not	a5,a5
 4a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a2:	15fd                	addi	a1,a1,-1
 4a4:	177d                	addi	a4,a4,-1
 4a6:	0005c683          	lbu	a3,0(a1)
 4aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ae:	fee79ae3          	bne	a5,a4,4a2 <memmove+0x46>
 4b2:	bfc9                	j	484 <memmove+0x28>

00000000000004b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e422                	sd	s0,8(sp)
 4b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ba:	ca05                	beqz	a2,4ea <memcmp+0x36>
 4bc:	fff6069b          	addiw	a3,a2,-1
 4c0:	1682                	slli	a3,a3,0x20
 4c2:	9281                	srli	a3,a3,0x20
 4c4:	0685                	addi	a3,a3,1
 4c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	0005c703          	lbu	a4,0(a1)
 4d0:	00e79863          	bne	a5,a4,4e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d4:	0505                	addi	a0,a0,1
    p2++;
 4d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d8:	fed518e3          	bne	a0,a3,4c8 <memcmp+0x14>
  }
  return 0;
 4dc:	4501                	li	a0,0
 4de:	a019                	j	4e4 <memcmp+0x30>
      return *p1 - *p2;
 4e0:	40e7853b          	subw	a0,a5,a4
}
 4e4:	6422                	ld	s0,8(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret
  return 0;
 4ea:	4501                	li	a0,0
 4ec:	bfe5                	j	4e4 <memcmp+0x30>

00000000000004ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e406                	sd	ra,8(sp)
 4f2:	e022                	sd	s0,0(sp)
 4f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f66080e7          	jalr	-154(ra) # 45c <memmove>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 50c:	00054783          	lbu	a5,0(a0)
 510:	cfbd                	beqz	a5,58e <inet_addr+0x88>
  int dots = 0;
 512:	4801                	li	a6,0
  int digits = 0;
 514:	4601                	li	a2,0
  int octet = 0;
 516:	4681                	li	a3,0
  uint result = 0;
 518:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 51a:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 51c:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 520:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 522:	4301                	li	t1,0
      if (octet > 255)
 524:	0ff00e13          	li	t3,255
 528:	a015                	j	54c <inet_addr+0x46>
    } else if (*s == '.') {
 52a:	07d79463          	bne	a5,t4,592 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 52e:	c625                	beqz	a2,596 <inet_addr+0x90>
 530:	07e80563          	beq	a6,t5,59a <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 534:	0085959b          	slliw	a1,a1,0x8
 538:	8ecd                	or	a3,a3,a1
 53a:	0006859b          	sext.w	a1,a3
      dots++;
 53e:	2805                	addiw	a6,a6,1
      digits = 0;
 540:	861a                	mv	a2,t1
      octet = 0;
 542:	869a                	mv	a3,t1
  for (; *s; s++) {
 544:	0505                	addi	a0,a0,1
 546:	00054783          	lbu	a5,0(a0)
 54a:	c79d                	beqz	a5,578 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 54c:	fd07871b          	addiw	a4,a5,-48
 550:	0ff77713          	zext.b	a4,a4
 554:	fce8ebe3          	bltu	a7,a4,52a <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 558:	0026971b          	slliw	a4,a3,0x2
 55c:	9f35                	addw	a4,a4,a3
 55e:	0017171b          	slliw	a4,a4,0x1
 562:	fd07879b          	addiw	a5,a5,-48
 566:	00e786bb          	addw	a3,a5,a4
      digits++;
 56a:	2605                	addiw	a2,a2,1
      if (octet > 255)
 56c:	fcde5ce3          	bge	t3,a3,544 <inet_addr+0x3e>
        return 0;
 570:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 572:	6422                	ld	s0,8(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret
    return 0;
 578:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 57a:	de65                	beqz	a2,572 <inet_addr+0x6c>
 57c:	478d                	li	a5,3
 57e:	fef81ae3          	bne	a6,a5,572 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 582:	0085959b          	slliw	a1,a1,0x8
 586:	8ecd                	or	a3,a3,a1
 588:	0006851b          	sext.w	a0,a3
  return result;
 58c:	b7dd                	j	572 <inet_addr+0x6c>
    return 0;
 58e:	4501                	li	a0,0
 590:	b7cd                	j	572 <inet_addr+0x6c>
      return 0;
 592:	4501                	li	a0,0
 594:	bff9                	j	572 <inet_addr+0x6c>
        return 0;
 596:	4501                	li	a0,0
 598:	bfe9                	j	572 <inet_addr+0x6c>
 59a:	4501                	li	a0,0
 59c:	bfd9                	j	572 <inet_addr+0x6c>

000000000000059e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 59e:	4885                	li	a7,1
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5a6:	4889                	li	a7,2
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ae:	488d                	li	a7,3
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5b6:	4891                	li	a7,4
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <read>:
.global read
read:
 li a7, SYS_read
 5be:	4895                	li	a7,5
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <write>:
.global write
write:
 li a7, SYS_write
 5c6:	48c1                	li	a7,16
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <close>:
.global close
close:
 li a7, SYS_close
 5ce:	48d5                	li	a7,21
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5d6:	4899                	li	a7,6
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <exec>:
.global exec
exec:
 li a7, SYS_exec
 5de:	489d                	li	a7,7
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <open>:
.global open
open:
 li a7, SYS_open
 5e6:	48bd                	li	a7,15
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ee:	48c5                	li	a7,17
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5f6:	48c9                	li	a7,18
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5fe:	48a1                	li	a7,8
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <link>:
.global link
link:
 li a7, SYS_link
 606:	48cd                	li	a7,19
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 60e:	48d1                	li	a7,20
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 616:	48a5                	li	a7,9
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <dup>:
.global dup
dup:
 li a7, SYS_dup
 61e:	48a9                	li	a7,10
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 626:	48ad                	li	a7,11
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 62e:	48b1                	li	a7,12
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 636:	48b5                	li	a7,13
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 63e:	48b9                	li	a7,14
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 646:	48d9                	li	a7,22
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 64e:	48dd                	li	a7,23
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 656:	48e1                	li	a7,24
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 65e:	48e5                	li	a7,25
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <socket>:
.global socket
socket:
 li a7, SYS_socket
 666:	48e9                	li	a7,26
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <bind>:
.global bind
bind:
 li a7, SYS_bind
 66e:	48ed                	li	a7,27
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <accept>:
.global accept
accept:
 li a7, SYS_accept
 676:	48f5                	li	a7,29
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <listen>:
.global listen
listen:
 li a7, SYS_listen
 67e:	48f1                	li	a7,28
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <connect>:
.global connect
connect:
 li a7, SYS_connect
 686:	48f9                	li	a7,30
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <send>:
.global send
send:
 li a7, SYS_send
 68e:	48fd                	li	a7,31
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <recv>:
.global recv
recv:
 li a7, SYS_recv
 696:	02000893          	li	a7,32
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 6a0:	02100893          	li	a7,33
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 6aa:	02200893          	li	a7,34
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6b4:	1101                	addi	sp,sp,-32
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6c0:	4605                	li	a2,1
 6c2:	fef40593          	addi	a1,s0,-17
 6c6:	00000097          	auipc	ra,0x0
 6ca:	f00080e7          	jalr	-256(ra) # 5c6 <write>
}
 6ce:	60e2                	ld	ra,24(sp)
 6d0:	6442                	ld	s0,16(sp)
 6d2:	6105                	addi	sp,sp,32
 6d4:	8082                	ret

00000000000006d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d6:	7139                	addi	sp,sp,-64
 6d8:	fc06                	sd	ra,56(sp)
 6da:	f822                	sd	s0,48(sp)
 6dc:	f426                	sd	s1,40(sp)
 6de:	0080                	addi	s0,sp,64
 6e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6e2:	c299                	beqz	a3,6e8 <printint+0x12>
 6e4:	0805cb63          	bltz	a1,77a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6e8:	2581                	sext.w	a1,a1
  neg = 0;
 6ea:	4881                	li	a7,0
 6ec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6f2:	2601                	sext.w	a2,a2
 6f4:	00000517          	auipc	a0,0x0
 6f8:	7dc50513          	addi	a0,a0,2012 # ed0 <digits>
 6fc:	883a                	mv	a6,a4
 6fe:	2705                	addiw	a4,a4,1
 700:	02c5f7bb          	remuw	a5,a1,a2
 704:	1782                	slli	a5,a5,0x20
 706:	9381                	srli	a5,a5,0x20
 708:	97aa                	add	a5,a5,a0
 70a:	0007c783          	lbu	a5,0(a5)
 70e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 712:	0005879b          	sext.w	a5,a1
 716:	02c5d5bb          	divuw	a1,a1,a2
 71a:	0685                	addi	a3,a3,1
 71c:	fec7f0e3          	bgeu	a5,a2,6fc <printint+0x26>
  if(neg)
 720:	00088c63          	beqz	a7,738 <printint+0x62>
    buf[i++] = '-';
 724:	fd070793          	addi	a5,a4,-48
 728:	00878733          	add	a4,a5,s0
 72c:	02d00793          	li	a5,45
 730:	fef70823          	sb	a5,-16(a4)
 734:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 738:	02e05c63          	blez	a4,770 <printint+0x9a>
 73c:	f04a                	sd	s2,32(sp)
 73e:	ec4e                	sd	s3,24(sp)
 740:	fc040793          	addi	a5,s0,-64
 744:	00e78933          	add	s2,a5,a4
 748:	fff78993          	addi	s3,a5,-1
 74c:	99ba                	add	s3,s3,a4
 74e:	377d                	addiw	a4,a4,-1
 750:	1702                	slli	a4,a4,0x20
 752:	9301                	srli	a4,a4,0x20
 754:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 758:	fff94583          	lbu	a1,-1(s2)
 75c:	8526                	mv	a0,s1
 75e:	00000097          	auipc	ra,0x0
 762:	f56080e7          	jalr	-170(ra) # 6b4 <putc>
  while(--i >= 0)
 766:	197d                	addi	s2,s2,-1
 768:	ff3918e3          	bne	s2,s3,758 <printint+0x82>
 76c:	7902                	ld	s2,32(sp)
 76e:	69e2                	ld	s3,24(sp)
}
 770:	70e2                	ld	ra,56(sp)
 772:	7442                	ld	s0,48(sp)
 774:	74a2                	ld	s1,40(sp)
 776:	6121                	addi	sp,sp,64
 778:	8082                	ret
    x = -xx;
 77a:	40b005bb          	negw	a1,a1
    neg = 1;
 77e:	4885                	li	a7,1
    x = -xx;
 780:	b7b5                	j	6ec <printint+0x16>

0000000000000782 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 782:	715d                	addi	sp,sp,-80
 784:	e486                	sd	ra,72(sp)
 786:	e0a2                	sd	s0,64(sp)
 788:	f84a                	sd	s2,48(sp)
 78a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 78c:	0005c903          	lbu	s2,0(a1)
 790:	1a090a63          	beqz	s2,944 <vprintf+0x1c2>
 794:	fc26                	sd	s1,56(sp)
 796:	f44e                	sd	s3,40(sp)
 798:	f052                	sd	s4,32(sp)
 79a:	ec56                	sd	s5,24(sp)
 79c:	e85a                	sd	s6,16(sp)
 79e:	e45e                	sd	s7,8(sp)
 7a0:	8aaa                	mv	s5,a0
 7a2:	8bb2                	mv	s7,a2
 7a4:	00158493          	addi	s1,a1,1
  state = 0;
 7a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7aa:	02500a13          	li	s4,37
 7ae:	4b55                	li	s6,21
 7b0:	a839                	j	7ce <vprintf+0x4c>
        putc(fd, c);
 7b2:	85ca                	mv	a1,s2
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	efe080e7          	jalr	-258(ra) # 6b4 <putc>
 7be:	a019                	j	7c4 <vprintf+0x42>
    } else if(state == '%'){
 7c0:	01498d63          	beq	s3,s4,7da <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 7c4:	0485                	addi	s1,s1,1
 7c6:	fff4c903          	lbu	s2,-1(s1)
 7ca:	16090763          	beqz	s2,938 <vprintf+0x1b6>
    if(state == 0){
 7ce:	fe0999e3          	bnez	s3,7c0 <vprintf+0x3e>
      if(c == '%'){
 7d2:	ff4910e3          	bne	s2,s4,7b2 <vprintf+0x30>
        state = '%';
 7d6:	89d2                	mv	s3,s4
 7d8:	b7f5                	j	7c4 <vprintf+0x42>
      if(c == 'd'){
 7da:	13490463          	beq	s2,s4,902 <vprintf+0x180>
 7de:	f9d9079b          	addiw	a5,s2,-99
 7e2:	0ff7f793          	zext.b	a5,a5
 7e6:	12fb6763          	bltu	s6,a5,914 <vprintf+0x192>
 7ea:	f9d9079b          	addiw	a5,s2,-99
 7ee:	0ff7f713          	zext.b	a4,a5
 7f2:	12eb6163          	bltu	s6,a4,914 <vprintf+0x192>
 7f6:	00271793          	slli	a5,a4,0x2
 7fa:	00000717          	auipc	a4,0x0
 7fe:	67e70713          	addi	a4,a4,1662 # e78 <ithread_join+0x13e>
 802:	97ba                	add	a5,a5,a4
 804:	439c                	lw	a5,0(a5)
 806:	97ba                	add	a5,a5,a4
 808:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4685                	li	a3,1
 810:	4629                	li	a2,10
 812:	000ba583          	lw	a1,0(s7)
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	ebe080e7          	jalr	-322(ra) # 6d6 <printint>
 820:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 822:	4981                	li	s3,0
 824:	b745                	j	7c4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 826:	008b8913          	addi	s2,s7,8
 82a:	4681                	li	a3,0
 82c:	4629                	li	a2,10
 82e:	000ba583          	lw	a1,0(s7)
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	ea2080e7          	jalr	-350(ra) # 6d6 <printint>
 83c:	8bca                	mv	s7,s2
      state = 0;
 83e:	4981                	li	s3,0
 840:	b751                	j	7c4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 842:	008b8913          	addi	s2,s7,8
 846:	4681                	li	a3,0
 848:	4641                	li	a2,16
 84a:	000ba583          	lw	a1,0(s7)
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	e86080e7          	jalr	-378(ra) # 6d6 <printint>
 858:	8bca                	mv	s7,s2
      state = 0;
 85a:	4981                	li	s3,0
 85c:	b7a5                	j	7c4 <vprintf+0x42>
 85e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 860:	008b8c13          	addi	s8,s7,8
 864:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 868:	03000593          	li	a1,48
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	e46080e7          	jalr	-442(ra) # 6b4 <putc>
  putc(fd, 'x');
 876:	07800593          	li	a1,120
 87a:	8556                	mv	a0,s5
 87c:	00000097          	auipc	ra,0x0
 880:	e38080e7          	jalr	-456(ra) # 6b4 <putc>
 884:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 886:	00000b97          	auipc	s7,0x0
 88a:	64ab8b93          	addi	s7,s7,1610 # ed0 <digits>
 88e:	03c9d793          	srli	a5,s3,0x3c
 892:	97de                	add	a5,a5,s7
 894:	0007c583          	lbu	a1,0(a5)
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	e1a080e7          	jalr	-486(ra) # 6b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8a2:	0992                	slli	s3,s3,0x4
 8a4:	397d                	addiw	s2,s2,-1
 8a6:	fe0914e3          	bnez	s2,88e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 8aa:	8be2                	mv	s7,s8
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	6c02                	ld	s8,0(sp)
 8b0:	bf11                	j	7c4 <vprintf+0x42>
        s = va_arg(ap, char*);
 8b2:	008b8993          	addi	s3,s7,8
 8b6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8ba:	02090163          	beqz	s2,8dc <vprintf+0x15a>
        while(*s != 0){
 8be:	00094583          	lbu	a1,0(s2)
 8c2:	c9a5                	beqz	a1,932 <vprintf+0x1b0>
          putc(fd, *s);
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	dee080e7          	jalr	-530(ra) # 6b4 <putc>
          s++;
 8ce:	0905                	addi	s2,s2,1
        while(*s != 0){
 8d0:	00094583          	lbu	a1,0(s2)
 8d4:	f9e5                	bnez	a1,8c4 <vprintf+0x142>
        s = va_arg(ap, char*);
 8d6:	8bce                	mv	s7,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b5ed                	j	7c4 <vprintf+0x42>
          s = "(null)";
 8dc:	00000917          	auipc	s2,0x0
 8e0:	56490913          	addi	s2,s2,1380 # e40 <ithread_join+0x106>
        while(*s != 0){
 8e4:	02800593          	li	a1,40
 8e8:	bff1                	j	8c4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 8ea:	008b8913          	addi	s2,s7,8
 8ee:	000bc583          	lbu	a1,0(s7)
 8f2:	8556                	mv	a0,s5
 8f4:	00000097          	auipc	ra,0x0
 8f8:	dc0080e7          	jalr	-576(ra) # 6b4 <putc>
 8fc:	8bca                	mv	s7,s2
      state = 0;
 8fe:	4981                	li	s3,0
 900:	b5d1                	j	7c4 <vprintf+0x42>
        putc(fd, c);
 902:	02500593          	li	a1,37
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	dac080e7          	jalr	-596(ra) # 6b4 <putc>
      state = 0;
 910:	4981                	li	s3,0
 912:	bd4d                	j	7c4 <vprintf+0x42>
        putc(fd, '%');
 914:	02500593          	li	a1,37
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	d9a080e7          	jalr	-614(ra) # 6b4 <putc>
        putc(fd, c);
 922:	85ca                	mv	a1,s2
 924:	8556                	mv	a0,s5
 926:	00000097          	auipc	ra,0x0
 92a:	d8e080e7          	jalr	-626(ra) # 6b4 <putc>
      state = 0;
 92e:	4981                	li	s3,0
 930:	bd51                	j	7c4 <vprintf+0x42>
        s = va_arg(ap, char*);
 932:	8bce                	mv	s7,s3
      state = 0;
 934:	4981                	li	s3,0
 936:	b579                	j	7c4 <vprintf+0x42>
 938:	74e2                	ld	s1,56(sp)
 93a:	79a2                	ld	s3,40(sp)
 93c:	7a02                	ld	s4,32(sp)
 93e:	6ae2                	ld	s5,24(sp)
 940:	6b42                	ld	s6,16(sp)
 942:	6ba2                	ld	s7,8(sp)
    }
  }
}
 944:	60a6                	ld	ra,72(sp)
 946:	6406                	ld	s0,64(sp)
 948:	7942                	ld	s2,48(sp)
 94a:	6161                	addi	sp,sp,80
 94c:	8082                	ret

000000000000094e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 94e:	715d                	addi	sp,sp,-80
 950:	ec06                	sd	ra,24(sp)
 952:	e822                	sd	s0,16(sp)
 954:	1000                	addi	s0,sp,32
 956:	e010                	sd	a2,0(s0)
 958:	e414                	sd	a3,8(s0)
 95a:	e818                	sd	a4,16(s0)
 95c:	ec1c                	sd	a5,24(s0)
 95e:	03043023          	sd	a6,32(s0)
 962:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 966:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 96a:	8622                	mv	a2,s0
 96c:	00000097          	auipc	ra,0x0
 970:	e16080e7          	jalr	-490(ra) # 782 <vprintf>
}
 974:	60e2                	ld	ra,24(sp)
 976:	6442                	ld	s0,16(sp)
 978:	6161                	addi	sp,sp,80
 97a:	8082                	ret

000000000000097c <printf>:

void
printf(const char *fmt, ...)
{
 97c:	711d                	addi	sp,sp,-96
 97e:	ec06                	sd	ra,24(sp)
 980:	e822                	sd	s0,16(sp)
 982:	1000                	addi	s0,sp,32
 984:	e40c                	sd	a1,8(s0)
 986:	e810                	sd	a2,16(s0)
 988:	ec14                	sd	a3,24(s0)
 98a:	f018                	sd	a4,32(s0)
 98c:	f41c                	sd	a5,40(s0)
 98e:	03043823          	sd	a6,48(s0)
 992:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 996:	00840613          	addi	a2,s0,8
 99a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 99e:	85aa                	mv	a1,a0
 9a0:	4505                	li	a0,1
 9a2:	00000097          	auipc	ra,0x0
 9a6:	de0080e7          	jalr	-544(ra) # 782 <vprintf>
}
 9aa:	60e2                	ld	ra,24(sp)
 9ac:	6442                	ld	s0,16(sp)
 9ae:	6125                	addi	sp,sp,96
 9b0:	8082                	ret

00000000000009b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9b2:	1141                	addi	sp,sp,-16
 9b4:	e422                	sd	s0,8(sp)
 9b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9bc:	00000797          	auipc	a5,0x0
 9c0:	6547b783          	ld	a5,1620(a5) # 1010 <freep>
 9c4:	a02d                	j	9ee <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9c6:	4618                	lw	a4,8(a2)
 9c8:	9f2d                	addw	a4,a4,a1
 9ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ce:	6398                	ld	a4,0(a5)
 9d0:	6310                	ld	a2,0(a4)
 9d2:	a83d                	j	a10 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9d4:	ff852703          	lw	a4,-8(a0)
 9d8:	9f31                	addw	a4,a4,a2
 9da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9dc:	ff053683          	ld	a3,-16(a0)
 9e0:	a091                	j	a24 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e2:	6398                	ld	a4,0(a5)
 9e4:	00e7e463          	bltu	a5,a4,9ec <free+0x3a>
 9e8:	00e6ea63          	bltu	a3,a4,9fc <free+0x4a>
{
 9ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ee:	fed7fae3          	bgeu	a5,a3,9e2 <free+0x30>
 9f2:	6398                	ld	a4,0(a5)
 9f4:	00e6e463          	bltu	a3,a4,9fc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f8:	fee7eae3          	bltu	a5,a4,9ec <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9fc:	ff852583          	lw	a1,-8(a0)
 a00:	6390                	ld	a2,0(a5)
 a02:	02059813          	slli	a6,a1,0x20
 a06:	01c85713          	srli	a4,a6,0x1c
 a0a:	9736                	add	a4,a4,a3
 a0c:	fae60de3          	beq	a2,a4,9c6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a10:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a14:	4790                	lw	a2,8(a5)
 a16:	02061593          	slli	a1,a2,0x20
 a1a:	01c5d713          	srli	a4,a1,0x1c
 a1e:	973e                	add	a4,a4,a5
 a20:	fae68ae3          	beq	a3,a4,9d4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a24:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a26:	00000717          	auipc	a4,0x0
 a2a:	5ef73523          	sd	a5,1514(a4) # 1010 <freep>
}
 a2e:	6422                	ld	s0,8(sp)
 a30:	0141                	addi	sp,sp,16
 a32:	8082                	ret

0000000000000a34 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a34:	7139                	addi	sp,sp,-64
 a36:	fc06                	sd	ra,56(sp)
 a38:	f822                	sd	s0,48(sp)
 a3a:	f426                	sd	s1,40(sp)
 a3c:	ec4e                	sd	s3,24(sp)
 a3e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a40:	02051493          	slli	s1,a0,0x20
 a44:	9081                	srli	s1,s1,0x20
 a46:	04bd                	addi	s1,s1,15
 a48:	8091                	srli	s1,s1,0x4
 a4a:	0014899b          	addiw	s3,s1,1
 a4e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a50:	00000517          	auipc	a0,0x0
 a54:	5c053503          	ld	a0,1472(a0) # 1010 <freep>
 a58:	c915                	beqz	a0,a8c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5c:	4798                	lw	a4,8(a5)
 a5e:	08977e63          	bgeu	a4,s1,afa <malloc+0xc6>
 a62:	f04a                	sd	s2,32(sp)
 a64:	e852                	sd	s4,16(sp)
 a66:	e456                	sd	s5,8(sp)
 a68:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a6a:	8a4e                	mv	s4,s3
 a6c:	0009871b          	sext.w	a4,s3
 a70:	6685                	lui	a3,0x1
 a72:	00d77363          	bgeu	a4,a3,a78 <malloc+0x44>
 a76:	6a05                	lui	s4,0x1
 a78:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a7c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a80:	00000917          	auipc	s2,0x0
 a84:	59090913          	addi	s2,s2,1424 # 1010 <freep>
  if(p == (char*)-1)
 a88:	5afd                	li	s5,-1
 a8a:	a091                	j	ace <malloc+0x9a>
 a8c:	f04a                	sd	s2,32(sp)
 a8e:	e852                	sd	s4,16(sp)
 a90:	e456                	sd	s5,8(sp)
 a92:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a94:	00000797          	auipc	a5,0x0
 a98:	59c78793          	addi	a5,a5,1436 # 1030 <base>
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56f73a23          	sd	a5,1396(a4) # 1010 <freep>
 aa4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aaa:	b7c1                	j	a6a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 aac:	6398                	ld	a4,0(a5)
 aae:	e118                	sd	a4,0(a0)
 ab0:	a08d                	j	b12 <malloc+0xde>
  hp->s.size = nu;
 ab2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ab6:	0541                	addi	a0,a0,16
 ab8:	00000097          	auipc	ra,0x0
 abc:	efa080e7          	jalr	-262(ra) # 9b2 <free>
  return freep;
 ac0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ac4:	c13d                	beqz	a0,b2a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ac8:	4798                	lw	a4,8(a5)
 aca:	02977463          	bgeu	a4,s1,af2 <malloc+0xbe>
    if(p == freep)
 ace:	00093703          	ld	a4,0(s2)
 ad2:	853e                	mv	a0,a5
 ad4:	fef719e3          	bne	a4,a5,ac6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 ad8:	8552                	mv	a0,s4
 ada:	00000097          	auipc	ra,0x0
 ade:	b54080e7          	jalr	-1196(ra) # 62e <sbrk>
  if(p == (char*)-1)
 ae2:	fd5518e3          	bne	a0,s5,ab2 <malloc+0x7e>
        return 0;
 ae6:	4501                	li	a0,0
 ae8:	7902                	ld	s2,32(sp)
 aea:	6a42                	ld	s4,16(sp)
 aec:	6aa2                	ld	s5,8(sp)
 aee:	6b02                	ld	s6,0(sp)
 af0:	a03d                	j	b1e <malloc+0xea>
 af2:	7902                	ld	s2,32(sp)
 af4:	6a42                	ld	s4,16(sp)
 af6:	6aa2                	ld	s5,8(sp)
 af8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 afa:	fae489e3          	beq	s1,a4,aac <malloc+0x78>
        p->s.size -= nunits;
 afe:	4137073b          	subw	a4,a4,s3
 b02:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b04:	02071693          	slli	a3,a4,0x20
 b08:	01c6d713          	srli	a4,a3,0x1c
 b0c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b0e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b12:	00000717          	auipc	a4,0x0
 b16:	4ea73f23          	sd	a0,1278(a4) # 1010 <freep>
      return (void*)(p + 1);
 b1a:	01078513          	addi	a0,a5,16
  }
}
 b1e:	70e2                	ld	ra,56(sp)
 b20:	7442                	ld	s0,48(sp)
 b22:	74a2                	ld	s1,40(sp)
 b24:	69e2                	ld	s3,24(sp)
 b26:	6121                	addi	sp,sp,64
 b28:	8082                	ret
 b2a:	7902                	ld	s2,32(sp)
 b2c:	6a42                	ld	s4,16(sp)
 b2e:	6aa2                	ld	s5,8(sp)
 b30:	6b02                	ld	s6,0(sp)
 b32:	b7f5                	j	b1e <malloc+0xea>

0000000000000b34 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 b34:	1141                	addi	sp,sp,-16
 b36:	e406                	sd	ra,8(sp)
 b38:	e022                	sd	s0,0(sp)
 b3a:	0800                	addi	s0,sp,16
  thread_exit(status);
 b3c:	2501                	sext.w	a0,a0
 b3e:	00000097          	auipc	ra,0x0
 b42:	b20080e7          	jalr	-1248(ra) # 65e <thread_exit>
}
 b46:	60a2                	ld	ra,8(sp)
 b48:	6402                	ld	s0,0(sp)
 b4a:	0141                	addi	sp,sp,16
 b4c:	8082                	ret

0000000000000b4e <free_stacks>:
int free_stacks() {
 b4e:	7179                	addi	sp,sp,-48
 b50:	f406                	sd	ra,40(sp)
 b52:	f022                	sd	s0,32(sp)
 b54:	ec26                	sd	s1,24(sp)
 b56:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 b58:	00000797          	auipc	a5,0x0
 b5c:	4c87a783          	lw	a5,1224(a5) # 1020 <num_threads>
 b60:	04f05063          	blez	a5,ba0 <free_stacks+0x52>
 b64:	e84a                	sd	s2,16(sp)
 b66:	e44e                	sd	s3,8(sp)
 b68:	4481                	li	s1,0
    free(stacks[i]);
 b6a:	00000997          	auipc	s3,0x0
 b6e:	4ae98993          	addi	s3,s3,1198 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 b72:	00000917          	auipc	s2,0x0
 b76:	4ae90913          	addi	s2,s2,1198 # 1020 <num_threads>
    free(stacks[i]);
 b7a:	0009b783          	ld	a5,0(s3)
 b7e:	00349713          	slli	a4,s1,0x3
 b82:	97ba                	add	a5,a5,a4
 b84:	6388                	ld	a0,0(a5)
 b86:	00000097          	auipc	ra,0x0
 b8a:	e2c080e7          	jalr	-468(ra) # 9b2 <free>
  for (int i = 0; i < num_threads; i++) {
 b8e:	0485                	addi	s1,s1,1
 b90:	00092703          	lw	a4,0(s2)
 b94:	0004879b          	sext.w	a5,s1
 b98:	fee7c1e3          	blt	a5,a4,b7a <free_stacks+0x2c>
 b9c:	6942                	ld	s2,16(sp)
 b9e:	69a2                	ld	s3,8(sp)
  free(stacks);
 ba0:	00000497          	auipc	s1,0x0
 ba4:	47848493          	addi	s1,s1,1144 # 1018 <stacks>
 ba8:	6088                	ld	a0,0(s1)
 baa:	00000097          	auipc	ra,0x0
 bae:	e08080e7          	jalr	-504(ra) # 9b2 <free>
  stacks = 0;
 bb2:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 bb6:	00000797          	auipc	a5,0x0
 bba:	4607a523          	sw	zero,1130(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 bbe:	47a1                	li	a5,8
 bc0:	00000717          	auipc	a4,0x0
 bc4:	44f72023          	sw	a5,1088(a4) # 1000 <max_stacks>
  threads_done = 0;
 bc8:	00000797          	auipc	a5,0x0
 bcc:	4407ae23          	sw	zero,1116(a5) # 1024 <threads_done>
}
 bd0:	4501                	li	a0,0
 bd2:	70a2                	ld	ra,40(sp)
 bd4:	7402                	ld	s0,32(sp)
 bd6:	64e2                	ld	s1,24(sp)
 bd8:	6145                	addi	sp,sp,48
 bda:	8082                	ret

0000000000000bdc <expand_num_threads>:
int expand_num_threads() {
 bdc:	1101                	addi	sp,sp,-32
 bde:	ec06                	sd	ra,24(sp)
 be0:	e822                	sd	s0,16(sp)
 be2:	e426                	sd	s1,8(sp)
 be4:	e04a                	sd	s2,0(sp)
 be6:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 be8:	00000797          	auipc	a5,0x0
 bec:	41878793          	addi	a5,a5,1048 # 1000 <max_stacks>
 bf0:	4388                	lw	a0,0(a5)
 bf2:	0015151b          	slliw	a0,a0,0x1
 bf6:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 bf8:	0035151b          	slliw	a0,a0,0x3
 bfc:	00000097          	auipc	ra,0x0
 c00:	e38080e7          	jalr	-456(ra) # a34 <malloc>
 c04:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 c06:	00000617          	auipc	a2,0x0
 c0a:	41a62603          	lw	a2,1050(a2) # 1020 <num_threads>
 c0e:	00000497          	auipc	s1,0x0
 c12:	40a48493          	addi	s1,s1,1034 # 1018 <stacks>
 c16:	0036161b          	slliw	a2,a2,0x3
 c1a:	608c                	ld	a1,0(s1)
 c1c:	00000097          	auipc	ra,0x0
 c20:	840080e7          	jalr	-1984(ra) # 45c <memmove>
  free(stacks);
 c24:	6088                	ld	a0,0(s1)
 c26:	00000097          	auipc	ra,0x0
 c2a:	d8c080e7          	jalr	-628(ra) # 9b2 <free>
  stacks = new_stacks;
 c2e:	0124b023          	sd	s2,0(s1)
}
 c32:	4501                	li	a0,0
 c34:	60e2                	ld	ra,24(sp)
 c36:	6442                	ld	s0,16(sp)
 c38:	64a2                	ld	s1,8(sp)
 c3a:	6902                	ld	s2,0(sp)
 c3c:	6105                	addi	sp,sp,32
 c3e:	8082                	ret

0000000000000c40 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 c40:	7179                	addi	sp,sp,-48
 c42:	f406                	sd	ra,40(sp)
 c44:	f022                	sd	s0,32(sp)
 c46:	e84a                	sd	s2,16(sp)
 c48:	e44e                	sd	s3,8(sp)
 c4a:	1800                	addi	s0,sp,48
 c4c:	892a                	mv	s2,a0
 c4e:	89ae                	mv	s3,a1
  if (stacks == 0) {
 c50:	00000797          	auipc	a5,0x0
 c54:	3c87b783          	ld	a5,968(a5) # 1018 <stacks>
 c58:	c3d9                	beqz	a5,cde <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 c5a:	00000797          	auipc	a5,0x0
 c5e:	3a67a783          	lw	a5,934(a5) # 1000 <max_stacks>
 c62:	00000717          	auipc	a4,0x0
 c66:	3be72703          	lw	a4,958(a4) # 1020 <num_threads>
 c6a:	0af71363          	bne	a4,a5,d10 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 c6e:	04000713          	li	a4,64
 c72:	08e78563          	beq	a5,a4,cfc <ithread_create+0xbc>
 c76:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 c78:	00000097          	auipc	ra,0x0
 c7c:	f64080e7          	jalr	-156(ra) # bdc <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 c80:	6505                	lui	a0,0x1
 c82:	00000097          	auipc	ra,0x0
 c86:	db2080e7          	jalr	-590(ra) # a34 <malloc>
 c8a:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c8c:	00000717          	auipc	a4,0x0
 c90:	39472703          	lw	a4,916(a4) # 1020 <num_threads>
 c94:	070e                	slli	a4,a4,0x3
 c96:	00000797          	auipc	a5,0x0
 c9a:	3827b783          	ld	a5,898(a5) # 1018 <stacks>
 c9e:	97ba                	add	a5,a5,a4
 ca0:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 ca2:	00000697          	auipc	a3,0x0
 ca6:	e9268693          	addi	a3,a3,-366 # b34 <ithread_exit>
 caa:	862a                	mv	a2,a0
 cac:	85ce                	mv	a1,s3
 cae:	854a                	mv	a0,s2
 cb0:	00000097          	auipc	ra,0x0
 cb4:	99e080e7          	jalr	-1634(ra) # 64e <create_thread>
 cb8:	892a                	mv	s2,a0
  if (res != -1) {
 cba:	57fd                	li	a5,-1
 cbc:	04f50c63          	beq	a0,a5,d14 <ithread_create+0xd4>
    num_threads++;
 cc0:	00000717          	auipc	a4,0x0
 cc4:	36070713          	addi	a4,a4,864 # 1020 <num_threads>
 cc8:	431c                	lw	a5,0(a4)
 cca:	2785                	addiw	a5,a5,1
 ccc:	c31c                	sw	a5,0(a4)
 cce:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 cd0:	854a                	mv	a0,s2
 cd2:	70a2                	ld	ra,40(sp)
 cd4:	7402                	ld	s0,32(sp)
 cd6:	6942                	ld	s2,16(sp)
 cd8:	69a2                	ld	s3,8(sp)
 cda:	6145                	addi	sp,sp,48
 cdc:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 cde:	00000517          	auipc	a0,0x0
 ce2:	32252503          	lw	a0,802(a0) # 1000 <max_stacks>
 ce6:	0035151b          	slliw	a0,a0,0x3
 cea:	00000097          	auipc	ra,0x0
 cee:	d4a080e7          	jalr	-694(ra) # a34 <malloc>
 cf2:	00000797          	auipc	a5,0x0
 cf6:	32a7b323          	sd	a0,806(a5) # 1018 <stacks>
 cfa:	b785                	j	c5a <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 cfc:	00000517          	auipc	a0,0x0
 d00:	14c50513          	addi	a0,a0,332 # e48 <ithread_join+0x10e>
 d04:	00000097          	auipc	ra,0x0
 d08:	c78080e7          	jalr	-904(ra) # 97c <printf>
      return -1;
 d0c:	597d                	li	s2,-1
 d0e:	b7c9                	j	cd0 <ithread_create+0x90>
 d10:	ec26                	sd	s1,24(sp)
 d12:	b7bd                	j	c80 <ithread_create+0x40>
    free(stack_ptr);
 d14:	8526                	mv	a0,s1
 d16:	00000097          	auipc	ra,0x0
 d1a:	c9c080e7          	jalr	-868(ra) # 9b2 <free>
    stacks[num_threads] = 0;
 d1e:	00000717          	auipc	a4,0x0
 d22:	30272703          	lw	a4,770(a4) # 1020 <num_threads>
 d26:	070e                	slli	a4,a4,0x3
 d28:	00000797          	auipc	a5,0x0
 d2c:	2f07b783          	ld	a5,752(a5) # 1018 <stacks>
 d30:	97ba                	add	a5,a5,a4
 d32:	0007b023          	sd	zero,0(a5)
 d36:	64e2                	ld	s1,24(sp)
 d38:	bf61                	j	cd0 <ithread_create+0x90>

0000000000000d3a <ithread_join>:

int ithread_join(int thread_id) {
 d3a:	1101                	addi	sp,sp,-32
 d3c:	ec06                	sd	ra,24(sp)
 d3e:	e822                	sd	s0,16(sp)
 d40:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 d42:	ff040793          	addi	a5,s0,-16
 d46:	ffc7859b          	addiw	a1,a5,-4
 d4a:	00000097          	auipc	ra,0x0
 d4e:	90c080e7          	jalr	-1780(ra) # 656 <join_thread>
  threads_done++;
 d52:	00000717          	auipc	a4,0x0
 d56:	2d270713          	addi	a4,a4,722 # 1024 <threads_done>
 d5a:	431c                	lw	a5,0(a4)
 d5c:	2785                	addiw	a5,a5,1
 d5e:	0007869b          	sext.w	a3,a5
 d62:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 d64:	00000797          	auipc	a5,0x0
 d68:	2bc7a783          	lw	a5,700(a5) # 1020 <num_threads>
 d6c:	00d78863          	beq	a5,a3,d7c <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 d70:	fec42503          	lw	a0,-20(s0)
 d74:	60e2                	ld	ra,24(sp)
 d76:	6442                	ld	s0,16(sp)
 d78:	6105                	addi	sp,sp,32
 d7a:	8082                	ret
    free_stacks();
 d7c:	00000097          	auipc	ra,0x0
 d80:	dd2080e7          	jalr	-558(ra) # b4e <free_stacks>
 d84:	b7f5                	j	d70 <ithread_join+0x36>
