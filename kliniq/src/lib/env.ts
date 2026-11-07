import "server-only"
import {z} from "zod"


const envSchema = z.object({
    NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
    DATABASE_URL: z.string().url(),
    SESSION_SECRET: z.string().min(32),
    APP_URL: z.string().url(),
})

const parsed = envSchema.safeParse(process.env);
if (!parsed.success) {
    console.log("Invalid environment", parsed.error.flatten().fieldErrors)
    throw new Error("Invalid environment variables")
}

export const env = parsed.data

