# Redit Lite
![alt text](https://github.com/kloudysky/kloudysky/blob/main/assets/reddit_lite_demo.gif?raw=true)

On the frontend is a very lite clone of Reddit  
I decided to take on this project to learn how to create a boilerplate using technologies I wanted to use for future projects  
The app is hosted on Digital Ocean using a Docker container + Dokku and Dokku-letsencrypt

## Tech Stack
#### Backend
- TypeScript
- TypeORM
- GraphQL
- Redis

#### Frontend
- React
- Next.JS
- Chakra-UI
- URQL

![alt text](https://github.com/kloudysky/kloudysky/blob/main/assets/reddit_clone_graphql.gif?raw=true)
###### Created a GraphQL server using TypeScript with Type-GraphQL as the GraphQL schema

###### Used URQL to make query/mutation requests, cache data, and perform server side rendering [URQL Docs](https://formidable.com/open-source/urql/docs/basics/react-preact/)
```javascript
import { createClient } from 'urql';

const client = createClient({
  url: 'http://localhost:3000/graphql',
});
```
###### Implemented limit & cursor based pagination in the Posts Resolver
```javascript
@Query(() => PaginatedPosts)
  async posts(
    @Arg("limit", () => Int) limit: number,
    @Arg("cursor", () => String, { nullable: true }) cursor: string | null
  ): Promise<PaginatedPosts> {
    const realLimit = Math.min(50, limit);
    const realLimitPlusOne = realLimit + 1;

    const replacements: any[] = [realLimitPlusOne];

    if (cursor) {
      replacements.push(new Date(parseInt(cursor)));
    }

    const posts = await getConnection().query(
      `
    select p.*
    from post p
    ${cursor ? `where p."createdAt" < $2` : ""}
    order by p."createdAt" DESC
    limit $1
    `,
      replacements
    );

    return {
      posts: posts.slice(0, realLimit),
      hasMore: posts.length === realLimitPlusOne,
    };
  }
  ```