import { MembershipRole, Prisma, PrismaClient, UserPlan } from "@prisma/client";
import dayjs from "dayjs";
import { uuid } from "short-uuid";

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

async function createTeamAndAddUsers(
  teamInput: Prisma.TeamCreateInput,
  users: { id: number; username: string; role?: MembershipRole }[]
) {
  const createTeam = async (team: Prisma.TeamCreateInput) => {
    try {
      return await prisma.team.create({
        data: {
          ...team,
        },
      });
    } catch (_err) {
      if (_err instanceof Error && _err.message.indexOf("Unique constraint failed on the fields") !== -1) {
        console.log(`Team '${team.name}' already exists, skipping.`);
        return;
      }
      throw _err;
    }
  };

  const team = await createTeam(teamInput);
  if (!team) {
    return;
  }

  console.log(`🏢 Created team '${teamInput.name}' - ${process.env.BASE_URL}/team/${team.slug}`);

  for (const user of users) {
    const { role = MembershipRole.OWNER, id, username } = user;
    await prisma.membership.create({
      data: {
        teamId: team.id,
        userId: id,
        role: role,
        accepted: true,
      },
    });
    console.log(`\t👤 Added '${teamInput.name}' membership for '${username}' with role '${role}'`);
  }
}

async function main() {
  await createUser({
    user: {
      email: process.env.USER_EMAIL,
      password: process.env.USER_PASSWORD,
      username: process.env.USER_HANDLE,
      name: process.env.USER_NAME,
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