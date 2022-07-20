import { Prisma, PrismaClient, UserPlan } from "@prisma/client";
import { hashPassword } from "../lib/auth";
import { DEFAULT_SCHEDULE, getAvailabilityFromSchedule } from "../lib/availability";

const prisma = new PrismaClient();

async function createUser(opts: {
  user: {
    email: string;
    password: string;
    username: string;
    plan: UserPlan;
    name: string;
    completedOnboarding?: boolean;
    timeZone?: string;
  };
}) {
  const userData: Prisma.UserCreateArgs["data"] = {
    ...opts.user,
    password: await hashPassword(opts.user.password),
    emailVerified: new Date(),
    completedOnboarding: opts.user.completedOnboarding ?? true,
    locale: "en",
    availability: {
      createMany: {
        data: getAvailabilityFromSchedule(DEFAULT_SCHEDULE),
      },
    },
  };
  const user = await prisma.user.upsert({
    where: { email: opts.user.email },
    update: userData,
    create: userData,
  });

  console.log(
    `👤 Upserted '${opts.user.username}' with email "${opts.user.email}" & password "${opts.user.password}". Booking page 👉 ${process.env.BASE_URL}/${opts.user.username}`
  );

  return user;
}

async function main() {
  await createUser({
    user: {
      email: process.env.USER_EMAIL!,
      password: process.env.USER_PASSWORD!,
      username: process.env.USER_HANDLE!,
      name: process.env.USER_NAME!,
      plan: "FREE",
    }
  });

  await prisma.$disconnect();
}

main()
  .then(() => {
    console.log("🌱 Seeded db");
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });